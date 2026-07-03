# QA Report 02 — Grovely (pós-rebrand v6)

**Data:** 2026-07-02 · **Escopo:** auditoria estática pré-release (commits até `2cf09da`)
**Ferramentas:** `flutter analyze`, `flutter test`, revisão manual de 100% dos 37 arquivos Dart em `lib/`, AndroidManifest, Gradle, pubspec, .arb.

---

## Sumário executivo

O app está **bem construído para a fase em que está**: analyze limpo, 20 testes passando, i18n com paridade perfeita pt/en (161 chaves cada), estados de loading/erro/vazio padronizados (`GrovelyEmpty`/`GrovelyError`/skeleton), reduce-motion honrado quase em toda parte, e a splash v6 (preserve/remove + `onSettled`) está correta e sem leaks — o `GrovelyMark` cancela listeners e controllers direito.

Porém, há **4 achados críticos** que quebram o core loop ou bloqueiam release:

1. **A árvore murcha quando a tela apaga.** Não há wakelock e a carência de background é de 5s — deitar o celular na mesa (o gesto que o app pede!) mata a sessão quando o screen timeout dispara.
2. **Onboarding + paywall a cada cold start.** Nada persiste "onboarding concluído"; a splash sempre navega para `/onboarding`.
3. **Criar círculo crasha silenciosamente sem Supabase** (`create()` não tem guarda de inicialização, ao contrário de `myCircle()`).
4. **Release assinado com chave de debug** e AdMob com App ID de teste no manifest.

Além disso, a máquina de estados do foco confia em `Timer` (ticks) em vez de relógio de parede, o que gera comportamento indefinido com app suspenso (iOS/Doze), e árvores plantadas offline **nunca sobem para a nuvem** — somem da UI quando o usuário reconecta.

**Resultados das ferramentas:**

| Comando | Resultado |
|---|---|
| `flutter analyze` | ✅ **No issues found** (2.3s) |
| `flutter test` | ✅ **20/20 passed** (controller, garden stats, GrovelyMark, notification, widget boot) |

---

## 🔴 Crítico

### C1. Sessão murcha com a tela apagada (sem wakelock + carência de 5s)
- **Arquivo:** `app/lib/features/focus_session/focus_session_controller.dart:61` (`witherGraceSeconds = 5`) e `:132-136` (`onAppPaused`); `app/lib/features/focus_session/focus_session_screen.dart:38-45`; `pubspec.yaml` (não há `wakelock_plus`).
- **Problema:** No Android, tela apagando (screen timeout) dispara `AppLifecycleState.paused`. O `_graceTimer` de 5s continua rodando com o processo vivo → `wither()` executa. Não há wakelock mantendo a tela acesa durante a sessão.
- **Cenário de falha:** Usuário inicia sessão de 45 min, deita o celular na mesa. Após ~30s–2min o screen timeout apaga a tela → 5s depois a árvore murcha. O usuário volta e encontra a árvore morta *tendo focado perfeitamente*. O mesmo vale para uma ligação recebida (>5s) ou notificação aberta rapidamente. É o pior tipo de bug para um app estilo Forest: pune o comportamento que o produto quer recompensar.
- **Fix sugerido:** (a) adicionar `wakelock_plus` e segurar a tela acesa enquanto `phase == running`; (b) distinguir "tela apagou" de "usuário saiu" (com wakelock ativo, `paused` só ocorre por saída real); (c) subir a carência para 30–60s como Forest.

### C2. Onboarding + paywall repetem em todo cold start
- **Arquivo:** `app/lib/features/splash/splash_screen.dart:46-48` (`_leave` → sempre `context.go('/onboarding')`); `app/lib/core/router/app_router.dart:22-24` (sem `redirect`); `app/lib/features/onboarding/onboarding_screen.dart:26-33` (nada é gravado ao concluir).
- **Problema:** Não existe flag persistida de "onboarding concluído". O comentário no router admite ("redirect será ligado nas fases seguintes"), mas isso é bloqueador de beta, não de fase futura.
- **Cenário de falha:** Testador abre o app pela 2ª vez → refaz welcome → notificações → social → sessão guiada de 30s → paywall, todo santo dia. Beta testers vão reportar isso no primeiro dia e a retenção D1 fica inutilizável como métrica.
- **Fix sugerido:** gravar `onboarding_done` em `shared_preferences` ao sair do paywall; `redirect` no GoRouter (ou decisão no `_leave` da splash) mandando direto para `/focus`.

### C3. "Criar círculo" lança exceção não tratada sem Supabase / offline
- **Arquivo:** `app/lib/data/repositories/circle_repository.dart:38-50` (`create()` usa `SupabaseService.instance.client` **sem** checar `_ready`, diferente de `myCircle():28`); `app/lib/features/circle/circle_screen.dart:126-133` (botão faz `await create(...)` sem try/catch, sem estado de loading).
- **Problema:** Rodando sem `--dart-define` do Supabase (build padrão!) ou com auth falha, `Supabase.instance.client` lança `StateError`. Como `myCircle()` retorna `null` nesses casos, a UI mostra alegremente o estado vazio com os botões "Criar/Entrar" — que não podem funcionar.
- **Cenário de falha:** Beta tester offline (ou build sem credenciais) toca "Criar círculo", digita o nome, toca o CTA → nada acontece, sheet congela, exceção no console. Sem feedback nenhum. O mesmo `await` sem guarda permite **double-tap = dois círculos criados** quando online.
- **Fix sugerido:** guarda `_ready` no `create()`/`leave()`; try/catch no botão com mensagem (`GrovelyError`/snackbar); desabilitar o botão durante o await; no estado vazio, se `!_ready`, mostrar mensagem de offline/login em vez dos CTAs.

### C4. Build de release assinado com chave de debug + AdMob App ID de teste
- **Arquivo:** `app/android/app/build.gradle.kts:33-38` (`signingConfig = signingConfigs.getByName("debug")` com TODO); `app/android/app/src/main/AndroidManifest.xml:33-36` (`ca-app-pub-3940256099942544~...` — App ID de teste do Google).
- **Problema:** O AAB não pode ser aceito no Play Console assinado com debug key; o AdMob App ID de teste em produção viola política do AdMob (e o real crasharia no boot se trocado errado — o comentário do manifest está certo).
- **Cenário de falha:** `flutter build appbundle --release` gera artefato inutilizável para o Play; se ninguém revisitar o TODO, o upload falha em cima da hora do beta fechado.
- **Fix sugerido:** criar keystore + `key.properties` (mesmo fluxo já usado no "O Meu Salmo"), configurar `signingConfigs.release`; trocar o App ID do AdMob junto com o wiring real do Agente D — e registrar isso como gate de release, não só TODO.

---

## 🟠 Importante

### I1. Máquina de estados do foco conta ticks, não relógio de parede
- **Arquivo:** `app/lib/features/focus_session/focus_session_controller.dart:95-105` (`Timer.periodic` + `secondsRemaining - 1`) e `:132-139` (`onAppPaused`/`onAppResumed`).
- **Problema:** Três consequências: (a) **iOS/Doze**: com o isolate suspenso, nem o tick nem o `_graceTimer` disparam; no resume, o timer de carência vencido e o handler de `resumed` (que o cancela) correm em ordem indefinida → murcha-ou-não vira loteria; (b) usuário ausente 30 min pode voltar com a sessão "congelada" e continuar de onde parou (burla o mecanismo); (c) ticks atrasados esticam a duração real da sessão. Nota: contar ticks é *imune* a mudança de relógio do usuário — isso está certo por acidente; a correção não deve regredir isso.
- **Cenário de falha:** iPhone (ou Android agressivo de battery) — usuário sai do app por 20 min durante sessão, volta, e a árvore está viva com o mesmo tempo restante.
- **Fix sugerido:** gravar `pausedAt = DateTime.now()` em `onAppPaused`; em `onAppResumed`, comparar `now.difference(pausedAt)` com a carência e decidir wither/continuar deterministicamente; manter deadline da sessão por timestamp monotônico (ex.: `Stopwatch`) e recalcular `secondsRemaining` no resume.

### I2. App morto no meio da sessão = sessão evapora
- **Arquivo:** `app/lib/features/focus_session/focus_session_controller.dart` (nenhuma persistência de sessão em andamento).
- **Problema:** Todo o estado vive em memória. Se o SO mata o processo (ou crash, ou usuário arrasta o app), a sessão desaparece — nem murcha, nem planta, nem registro.
- **Cenário de falha:** Sessão de 60 min, Android mata o processo em background aos 50 min → usuário reabre e está na tela de seleção como se nada tivesse acontecido. Incentiva "matar o app pra não murchar" (cheese conhecido do gênero).
- **Fix sugerido:** persistir `{startedAt, durationMinutes, treeType}` em `shared_preferences` no `start()`, limpar no complete/wither/reset; no boot, se existir sessão pendente: completou o tempo → planta; não completou → murcha (ou pergunta).

### I3. Árvores offline nunca sincronizam — e somem da UI ao reconectar
- **Arquivo:** `app/lib/data/repositories/session_repository.dart:39-62` (`load()` prefere nuvem e ignora local) e `:83-85` (catch vazio com comentário "sincroniza depois" — não existe mecanismo de sync).
- **Problema:** `add()` grava local sempre e nuvem best-effort. Se a gravação na nuvem falha (offline), a árvore fica só no local. No próximo `load()` autenticado+online, retorna **só a nuvem** → as árvores offline desaparecem do jardim (e do streak!) sem aviso. Também: usuário anônimo que acumulou árvores locais antes do primeiro sign-in bem-sucedido nunca as vê subir.
- **Cenário de falha:** Usuário completa 3 sessões no avião; pousa, abre o app com rede → jardim mostra só as árvores antigas da nuvem; streak zera. Percepção: "o app apagou meu progresso".
- **Fix sugerido:** ou (a) fazer merge local+nuvem no `load()` deduplicando por timestamp, ou (b) fila de pendências: marcar árvores não-sincronizadas e reenviar no próximo boot/reconexão.

### I4. Firebase nunca inicializa — analytics e FCM mortos em silêncio
- **Arquivo:** `app/lib/main.dart:42-44` (`Firebase.initializeApp()` sem options, com catch vazio); não existe `android/app/google-services.json`, nem plugin `com.google.gms.google-services` no Gradle, nem `lib/firebase_options.dart`. `AnalyticsService` (`app/lib/data/services/analytics_service.dart`) não é referenciado por nenhum arquivo.
- **Problema:** `initializeApp()` lança sempre e o catch engole. Todo o funil de analytics do beta (a razão de ter beta!) não coleta nada, e ninguém percebe porque não há log.
- **Cenário de falha:** Beta roda 2 semanas; na hora de olhar retenção/conversão do paywall, o Firebase está vazio.
- **Fix sugerido:** rodar `flutterfire configure` (gera `firebase_options.dart` + google-services.json) e passar `options:` no init; logar o erro do bootstrap (mesmo que só `debugPrint`); wire do `navObserver` e eventos-chave (session_start, session_complete, wither, paywall_view). Ou, se analytics ficou para o Agente D, **remover** `firebase_*` do pubspec por ora (ver I8).

### I5. Erro de rede no "Entrar com código" vira "código inválido"
- **Arquivo:** `app/lib/data/repositories/circle_repository.dart:66-75` (tudo que não é `circle_not_found`/`circle_full` vira `CircleError.unknown`); `app/lib/features/circle/circle_screen.dart:188-194` (`unknown` renderiza como `circleInvalidCode`).
- **Problema:** Timeout/DNS/RLS error é mostrado como "código inválido" — o usuário confere o código 5 vezes achando que digitou errado.
- **Fix sugerido:** mapear `SocketException`/`AuthException` para `CircleError.offline` e mostrar `l10n.commonError` + retry nesse caso.

### I6. Acessibilidade: controles centrais invisíveis para TalkBack
- **Arquivo:** `app/lib/shared/widgets/grovely_components.dart:300-328` (`DurationDial` — `GestureDetector` puro, sem semântica de botão/seleção); `:161-176` (`PressableScale` idem — afeta os tiles do jardim em `garden_screen.dart:129`); `app/lib/features/paywall/paywall_screen.dart:216-262` (`_PlanToggle`); `app/lib/features/onboarding/onboarding_screen.dart:267` (cards solo/círculo); `focus_session_screen.dart:267-273` (countdown sem `Semantics(liveRegion)` nem label).
- **Problema:** Leitor de tela não anuncia nem ativa: escolha de duração (15/25/45/60), toggle anual/mensal, escolha solo/círculo, tiles de árvore. O contraste geral está bom (tokens ok; `dim #A7B8AD` sobre `#0F1A15` ≈ 8:1) e reduce-motion é honrado — o problema é semântica, não visual. Exceção positiva: `_PlantMoreTile` tem `Semantics(button:)` correto.
- **Fix sugerido:** envolver cada opção com `Semantics(button: true, selected: ..., label: ...)` (ou usar `SegmentedButton`); no timer, `Semantics(label: l10n + tempo restante)` com `liveRegion` a cada minuto.

### I7. Telas obrigatórias mortas + `/auth` é beco sem saída
- **Arquivo:** `app/lib/features/profile/profile_screen.dart:125-135` (Privacidade, Termos e Sair com `onTap: () {}`); `app/lib/features/auth/auth_screen.dart` (placeholder Fase 0); `onboarding_screen.dart:170-171` e `profile_screen.dart:59` navegam com `context.go('/auth')` — rota top-level, sem AppBar back e sem pilha → botão back do sistema **sai do app**.
- **Cenário de falha:** Tester toca "Já tenho uma conta" no onboarding → tela placeholder sem saída. Play exige link de política de privacidade funcional para o beta fechado.
- **Fix sugerido:** esconder as rows/links não implementados no beta; usar `context.push('/auth')` para ter volta; linkar privacy/termos via `url_launcher` para as URLs já exigidas no Play Console.

### I8. Dependências pesadas não usadas no código
- **Arquivo:** `app/pubspec.yaml:49-61` — `purchases_flutter`, `google_mobile_ads`, `firebase_messaging`, `timezone` têm **zero referências** em `lib/` (grep confirmado); `firebase_analytics` só no service órfão.
- **Problema:** AdMob e RevenueCat inicializam código nativo, incham o AAB e o AdMob exige o meta-data do manifest (já é o motivo do App ID de teste estar lá). Tudo isso a bordo sem entregar nada.
- **Fix sugerido:** ou o Agente D pluga de fato, ou removê-las até lá (o meta-data do AdMob sai junto — elimina C4-parte-2).

### I9. `ensureSignedIn` grava `locale: 'pt'` para todo mundo
- **Arquivo:** `app/lib/data/services/supabase_service.dart:36-47`; chamado em `app/lib/main.dart:39` sem argumento.
- **Problema:** O default `locale = 'pt'` sobe pro `profiles` de qualquer usuário, inclusive EN. Se push/copy segmentada usar isso, todo mundo recebe PT.
- **Fix sugerido:** passar `PlatformDispatcher.instance.locale.languageCode` no bootstrap.

---

## 🟡 Menor

### M1. Fontes via rede em runtime (google_fonts sem bundle)
`app/pubspec.yaml:43` + `app/lib/core/theme/app_theme.dart:56-57`, `splash_screen.dart:81`. Primeira execução offline → tipografia inteira (inclusive o wordmark da splash) cai para a fonte default do sistema. Fix: bundlar os .ttf em `assets/fonts` e declarar no pubspec (também remove tráfego para servidores do Google — ponto de privacidade).

### M2. `TextEditingController` sem dispose nas sheets do círculo
`app/lib/features/circle/circle_screen.dart:92` e `:144` — controllers criados em função top-level e nunca descartados. Leak pequeno e recorrente. Fix: converter as sheets em `StatefulWidget` com dispose.

### M3. `reset()` chama `build()` manualmente
`app/lib/features/focus_session/focus_session_controller.dart:149-153` — re-registra `ref.onDispose` a cada reset (callbacks acumulam; inócuo hoje porque são cancels idempotentes, mas é anti-pattern Riverpod v3 e vira leak se alguém adicionar listeners ali). Fix: extrair `_initialState()` e usar em `build()` e `reset()`.

### M4. Strings de UI fora dos .arb
- `app/lib/core/router/app_router.dart:67` — `'Rota não encontrada: ...'` (PT hardcoded).
- `app/lib/data/services/notification_service.dart:65-66` — nome/descrição do canal Android (`'Lembretes de streak'`) em PT fixo; aparece nas configurações do sistema de usuários EN.
- `app/lib/data/models/circle.dart` (`MemberStat.fromJson`) — fallback `'Member'` em EN fixo.
- `app/lib/features/profile/profile_screen.dart:139` — `'v1.0.0'` hardcoded; vai divergir do `pubspec` (`1.0.0+1`) no primeiro bump. Fix: `package_info_plus`.
- Fora isso, a varredura de literais confirmou: o resto está 100% nos .arb, com paridade pt/en completa. 👍

### M5. Copy do lembrete diário congela no idioma do momento do enable
`app/lib/data/services/notification_service.dart:57-81` — título/corpo são passados prontos; se o usuário troca o idioma do sistema depois, a notificação diária continua no idioma antigo até re-toggle. Fix: re-agendar no boot com a copy atual.

### M6. Ícone de notificação = launcher adaptativo
`notification_service.dart:23` usa `@mipmap/launcher_icon` como small icon. O Android renderiza small icons só pelo alpha → vira um quadrado/blob branco na status bar. Fix: gerar um drawable monocromático (silhueta do bosque) e usar ele.

### M7. Streak: aritmética de dias em horário local
`app/lib/data/providers/garden_provider.dart:77-98` — `subtract(Duration(days: 1))` e `difference().inDays == 1` quebram em transições de DST (dia de 23h → `inDays == 0`). Brasil não tem DST hoje, mas usuários EN/outros fusos têm. Fix: normalizar com `DateTime.utc(y,m,d)` para a aritmética de dias.

### M8. Sheet de desistência sobrevive ao fim da sessão
`app/lib/features/focus_session/focus_session_screen.dart:164-199` — se o timer completa com a sheet "desistir?" aberta, a tela por baixo vira `_Completed` mas a sheet fica; "desistir" então no-opa (guard de fase segura). Confuso, não perigoso. Fix: fechar a sheet quando `phase` muda (ref.listen).

### M9. Skeleton shimmer ignora reduce-motion
`app/lib/shared/widgets/grovely_components.dart:110-130` — o `.shimmer(...).repeat()` roda mesmo com `disableAnimations`. Todo o resto do app honra (`GrovelyMotion.dur`, stagger, confetti). Fix: pular o `.animate` quando `GrovelyMotion.reduced(context)`.

### M10. Tema escolhido não persiste
`app/lib/core/theme/theme_mode_provider.dart` — documentado no código; usuário escolhe Escuro no perfil, reinicia, volta pro sistema. Fix: `shared_preferences` (5 linhas).

### M11. Horário do lembrete diário é aleatório na prática
`notification_service.dart:71-79` — `periodicallyShow(daily)` ancora no instante do enable (+ inexact). Quem ativa às 23h50 recebe lembrete ~meia-noite todo dia. Fix: `zonedSchedule` com hora fixa (19h?) usando o pacote `timezone` que já está no pubspec (e hoje não é usado).

### M12. `create()` do círculo não é atômico + código de convite sem retry
`circle_repository.dart:38-50` — se o insert de `circle_members` falha após o de `circles`, fica um círculo órfão do qual o criador não é membro; `_genCode()` sem tratamento de colisão de unique constraint (raro com 31^6, mas o erro sairia como exceção crua). Fix: RPC transacional `create_circle` no Postgres (mesmo padrão do `join_circle_by_code`).

---

## Pontos positivos (registrar para não regredir)

- `GrovelyMark`: lifecycle exemplar — status listener removido, controllers disposed, reduce-motion pinta estado final e ainda chama `onSettled` via post-frame com `mounted` check (`grovely_mark.dart:85-116`). Os testes cobrem exatamente os cenários de leak.
- Splash: `preserve`/`remove` no lugar certo (main → primeiro frame), timer de segurança de 8s, cancelamento correto no dispose.
- `MainShell` esconde a bottom nav durante sessão (anti-saída acidental) e o `StatefulShellRoute.indexedStack` mantém o `FocusSessionScreen` (e seu `WidgetsBindingObserver`) vivo entre abas — o observer não vaza nem duplica.
- Estados de loading/erro/vazio consistentes; RefreshIndicator + retry por `ref.invalidate` no círculo/jardim.
- 42/42 SVGs de árvore presentes (6 espécies × 7 estágios); paridade total dos .arb.
- Manifest enxuto: só INTERNET, POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED + receiver de boot do plugin. Nada de permissão sobrando.

---

## Veredito: pronto para beta fechado?

**Ainda não. Perto, mas não.** Bloqueadores mínimos antes de distribuir para testadores:

1. **C1** (wakelock/carência) — sem isso o core loop falha no primeiro uso real.
2. **C2** (persistir onboarding) — sem isso nenhum tester passa do dia 1 sem irritação.
3. **C3** (guarda + feedback no círculo) — ou esconder a aba Círculo no beta se o Supabase não for junto.
4. **C4** (keystore de release) — pré-requisito mecânico do upload.
5. **I4 ou I8** (decidir: Firebase configurado OU removido) — beta sem telemetria desperdiça o beta.

Com esses 5 resolvidos, os demais Importantes (I1/I2/I3) podem entrar durante o beta — mas I1/I2 devem vir logo, porque os testadores vão esbarrar neles.

### O que NÃO consegui verificar estaticamente
- Comportamento real de lifecycle em device (tela apagando → `paused`? ordem timer-vencido vs `resumed` no retorno da suspensão; agressividade de Doze/fabricantes) — exige QA físico (celular da mãe, conforme fluxo atual).
- A emenda visual splash nativa → splash Flutter (mesmo verde/arte, sem "pulo") — só em device.
- Migrations/RLS/RPCs do Supabase (`join_circle_by_code`, `circle_member_stats`, trigger de streaks da migration 0002/0003) — fora do repo do app; o contrato usado pelo cliente parece consistente, mas não vi o SQL.
- Renderização real dos 42 SVGs pelo flutter_svg (features não suportadas renderizam em branco sem erro).
- Contraste medido em tela (calculei pelos tokens; OK no papel).
- Build iOS (config atual é Android-first: splash/ícones iOS desligados de propósito).
- Comportamento de `periodicallyShow` após reboot em Android 14+ (receiver está declarado; confiança no plugin).
- Tamanho final do AAB com as 5 dependências não usadas a bordo.
