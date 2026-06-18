# QA Report 01 — Grovely (plantio-coletivo)

- Data: 2026-06-18
- Escopo: auditoria estática + verificações automatizadas da fase atual (Fase 0 + core loop). Sem alteração de comportamento.
- Raiz Flutter: `/Users/jeffsilva/Dropbox/Claude/plantio-coletivo/app`
- Auditor: QA (Claude)

---

## 1. Resumo executivo

**Veredito geral: REPROVADO no portão de QA por 1 item objetivo (formatação) + 1 bug de dados (major) no core loop.** O restante está sólido para a fase. `flutter analyze` limpo, testes passam, nenhum segredo vazado, permissões mínimas, dark mode e offline-first corretos.

Bloqueio do gate de QA do briefing §4:
- `dart format` NÃO aplicado — 14 arquivos em `lib/` fora do padrão (o checklist exige "dart format aplicado"). Item objetivo, fix trivial.

Bug de produto a corrigir antes de confiar no streak:
- `_bumpStreak` (session_repository) tem race read-modify-write + sem try/catch → pode lançar exceção não tratada e corromper a contagem de streak sob concorrência.

Pendência pré-produção já sinalizada no próprio código:
- AdMob App ID de TESTE no AndroidManifest (esperado nesta fase; trocar antes de release).

### Contagem por severidade

| Severidade | Qtd |
|---|---|
| Blocker | 0 |
| Major | 3 |
| Minor | 4 |
| Nit | 3 |
| **Total findings** | **10** |

Itens do checklist marcados N/A (feature ainda não implementada): 8 — ver seção 5.

---

## 2. Saída real das ferramentas

### 2.1 `flutter analyze`
```
Analyzing app...
No issues found! (ran in 2.1s)
```
PASS — sem erros nem warnings. `analysis_options.yaml` inclui `flutter_lints` + regras extras (`avoid_print`, `prefer_const_constructors`, etc.) e exclui apenas os gerados de l10n.

### 2.2 `flutter test`
```
00:00 +0: loading .../test/widget_test.dart
00:00 +0: App monta e mostra o onboarding
00:00 +1: All tests passed!
```
PASS na execução — 1 teste (smoke test que monta `PlantioApp`). Cobertura de componentes críticos (timer/paywall) ainda inexistente (ver finding #6).

### 2.3 `dart format --output=none --set-exit-if-changed lib/`
```
Changed lib/core/constants/env.dart
Changed lib/core/router/app_router.dart
Changed lib/core/theme/app_theme.dart
Changed lib/core/theme/theme_mode_provider.dart
Changed lib/data/models/completed_tree.dart
Changed lib/data/models/tree.dart
Changed lib/data/providers/garden_provider.dart
Changed lib/data/repositories/session_repository.dart
Changed lib/data/services/supabase_service.dart
Changed lib/features/focus_session/focus_session_controller.dart
Changed lib/features/focus_session/focus_session_screen.dart
Changed lib/features/garden/garden_screen.dart
Changed lib/features/paywall/paywall_screen.dart
Changed lib/features/profile/profile_screen.dart
Formatted 29 files (14 changed) in 0.04 seconds.
EXIT_CODE=1
```
FAIL — 14 arquivos não formatados (ver finding #1). Não foram alterados (apenas `--output=none`).

---

## 3. Tabela de findings

| # | Severidade | Categoria | Arquivo:linha | Problema | Recomendação |
|---|---|---|---|---|---|
| 1 | major | Código / gate §4 | 14 arquivos em `lib/` (env.dart, app_router.dart, app_theme.dart, theme_mode_provider.dart, completed_tree.dart, tree.dart, garden_provider.dart, session_repository.dart, supabase_service.dart, focus_session_controller.dart, focus_session_screen.dart, garden_screen.dart, paywall_screen.dart, profile_screen.dart) | `dart format` não aplicado; gate de QA exige formatação. Bloqueia o critério objetivo do §4. | Rodar `dart format lib/` e commitar. Idealmente adicionar `dart format --set-exit-if-changed` ao CI/pre-push (já existe workflow flutter analyze→push no MEMORY). |
| 2 | major | Core loop / dados | `lib/data/repositories/session_repository.dart:84-118` (`_bumpStreak`) | Race read-modify-write: faz `select` em `streaks`, calcula em Dart e dá `upsert`. Duas conclusões simultâneas/rápidas leem o mesmo valor e gravam o mesmo `current_streak`. Além disso o método NÃO está em try/catch (só o `insert` em `add` está, linhas 69-81) — exceção aqui (rede/RLS) escapa silenciosamente apenas porque o caller engole? Não: `_bumpStreak` é `await`-ado dentro do `try` de `add`, então a exceção é capturada, mas isso descarta o erro sem log e o streak fica inconsistente. | Mover a lógica de streak para o servidor: função SQL/RPC `bump_streak(user_id, date)` atômica (ou trigger em `focus_sessions`). Enquanto isso, envolver explicitamente em try/catch próprio e logar. Não confiar no valor de streak calculado no cliente. |
| 3 | major | Pré-produção / compliance | `app/android/app/src/main/AndroidManifest.xml:39-41` | AdMob `APPLICATION_ID` usa o App ID de TESTE oficial `ca-app-pub-3940256099942544~3347511713`. Subir assim em produção serve anúncios de teste / pode violar políticas AdMob. | Trocar pelo App ID real do AdMob antes do release (idealmente injetado por build flavor / `manifestPlaceholders`, não hardcoded). Já está comentado no código como pendência do "Agente D" — manter como blocker de release, não de fase. |
| 4 | minor | Tratamento de erro | `lib/main.dart:21-28` | `try { ... } catch (_) {}` engole silenciosamente falhas de init do Supabase e do Firebase (vazio, sem log). Tolerância a falha é correta (offline-first), mas a ausência total de log dificulta diagnosticar boot quebrado em produção. | Logar o erro (logger/Crashlytics quando entrar) dentro do catch em vez de `catch (_) {}`. |
| 5 | minor | Tratamento de erro | `lib/data/repositories/session_repository.dart:58-60, 81` | `catch (_)` silencioso em `load()` (cai pro local) e em `add()` (fica só local). Comportamento de fallback correto, mas sem qualquer telemetria de quantas syncs falham. | Adicionar log/contador de falha de sync (best-effort) para observabilidade; manter o fallback. |
| 6 | minor | Testes | `app/test/widget_test.dart` (único teste) | Não há testes de widget/unidade para os componentes críticos exigidos pelo §4: timer (`FocusSessionController` — start/tick/complete/wither/reset) e paywall. O paywall ainda é placeholder, mas o controller do timer já é lógica testável e crítica. | Adicionar testes unitários do `FocusSessionController` (usar `Timer`/`fakeAsync` para tick e transições de fase) e do `SessionRepository` (local). Paywall fica para quando sair do placeholder. |
| 7 | minor | i18n | `lib/core/router/app_router.dart:79` | String hardcoded `'Rota não encontrada: ${state.uri}'` no `errorBuilder`. É tela de erro de rota (raramente vista pelo usuário, dev-facing), mas tecnicamente viola "nada hardcoded". | Mover para `.arb` (ex.: `routeNotFound`) ou aceitar formalmente como string de diagnóstico fora do escopo de tradução. |
| 8 | nit | Core loop / UX | `lib/features/focus_session/focus_session_controller.dart:90-97` (`_tick`) + `focus_session_screen.dart:33-38` | Timer é cronometrado por `Timer.periodic` de 1s sem ancorar em relógio de parede (`DateTime`). Se o app for suspenso e o `Timer` for pausado/atrasado pelo OS, o tempo decorrido fica impreciso. Hoje o efeito é mascarado porque sair do app já faz `wither()` (zera a sessão), então é cosmético. Se no futuro a regra mudar (continuar contando em background), vira bug de contagem. | Quando/se a sessão puder sobreviver ao background, calcular `secondsRemaining` a partir de `endTime = start + duração` e do relógio, não por decremento de tick. |
| 9 | nit | Core loop / consistência | `lib/data/models/tree.dart:32-40` (`fromProgress`) | `if (p <= 0)` e `if (p < 0.20)` ambos retornam `seed` — a primeira condição é redundante (linha morta). Sem impacto funcional. | Remover o `if (p <= 0) return seed;` redundante. |
| 10 | nit | Persistência | `lib/core/theme/theme_mode_provider.dart:8-13` | `ThemeMode` vive só em memória (documentado no próprio arquivo). Trocar tema não persiste entre sessões. Esperado para a fase (seletor ainda não existe), registrado para não esquecer. | Persistir via `shared_preferences` quando o seletor de tema (perfil) for implementado. |

---

## 4. Auditoria do checklist (PASS / FAIL / N/A)

### QA de código (briefing §4)
| Item | Status | Evidência | Nota |
|---|---|---|---|
| flutter analyze sem erros/warnings | PASS | saída §2.1 ("No issues found!"); `analysis_options.yaml` com flutter_lints + extras | — |
| dart format aplicado | FAIL | §2.3, 14 arquivos `Changed` | Finding #1 |
| Sem strings hardcoded (tudo em .arb) | PASS (com 1 exceção) | varredura: nenhum `Text('...')` literal em telas; único literal é `app_router.dart:79` (errorBuilder dev-facing) e `grovely_logo.dart:16` (`semanticsLabel: 'Grovely'`, nome de marca — aceitável) | Finding #7 |
| Sem chaves de API no código | PASS | `env.json` está em `.gitignore` (linha confirmada) e `git ls-files` não o rastreia; segredos lidos via `String.fromEnvironment` em `core/constants/env.dart`; `git grep` por `sb_publishable_`/`service_role` em arquivos rastreados → só comentário de exemplo em `env.dart:7` e `env.example.json` (placeholders). Nenhum segredo real commitado. | env.json local contém a publishable key real (chave pública/anon — OK ser publishable, mas confirme RLS) |
| Tratamento de erro em toda chamada de rede | PASS (parcial) | `supabase_service.init/ensureSignedIn` best-effort; `session_repository.load/add` em try/catch com fallback local | Catches silenciosos (#4, #5) e streak sem proteção própria (#2) |
| Loading e empty states (garden) | PASS | `garden_screen.dart:22-37` — `garden.when(loading: CircularProgressIndicator, error: commonError, data: empty→gardenEmpty)`. Loading + erro + empty cobertos. | Exemplar |
| Testes de widget p/ componentes críticos (timer, paywall) | FAIL | só `widget_test.dart` smoke; sem teste de timer/paywall | Finding #6 |
| Sem print() em produção | PASS | `grep` por `print(`/`debugPrint(` em `lib/` → nenhum; lint `avoid_print: true` ativo | — |

### QA de produto
| Item | Status | Evidência | Nota |
|---|---|---|---|
| Dark mode funcional | PASS | `main.dart:43-45` define `theme`+`darkTheme`+`themeMode`; `app_theme.dart:17-53` constrói ColorScheme dark real com tokens dedicados; telas usam `Theme.of(context).colorScheme` (garden, focus, feature_scaffold) | Não persiste (#10) |
| Offline para sessão solo (sync depois) | PASS | `session_repository.dart` offline-first: `addLocal` sempre grava em `shared_preferences`; nuvem é best-effort com fallback em catch; `SupabaseService.init` só inicializa se `Env.hasSupabase` | Sólido |
| Mecânica social opt-in | N/A | auth anônimo (`ensureSignedIn` comenta "pressão social é opt-in depois"); circle/league são placeholders (`FeatureScaffold`) | Não implementado |
| Cancelamento de assinatura ≤2 toques | N/A | paywall é placeholder (`paywall_screen.dart` → FeatureScaffold); `purchases_flutter` declarado mas não wired (grep: nenhum uso de `Purchases` em lib) | Não implementado |
| Anúncios nunca interrompem foco | N/A | `google_mobile_ads` declarado mas não wired (grep: nenhum `MobileAds`/`RewardedAd` em lib); intenção documentada (rewarded p/ reviver árvore) | Não implementado |

### QA de compliance
| Item | Status | Evidência | Nota |
|---|---|---|---|
| Permissões mínimas (AndroidManifest) | PASS | `AndroidManifest.xml`: única permissão = `android.permission.INTERNET`. Bloco `<queries>` PROCESS_TEXT é padrão do engine Flutter. Nenhuma permissão sensível (localização/contatos/câmera/storage). | Mínimo correto. Nota: `firebase_messaging`/`flutter_local_notifications` estão no pubspec mas ainda não wired — quando entrarem, exigirão `POST_NOTIFICATIONS` (Android 13+); reavaliar então. |
| Consentimento LGPD no 1º uso | N/A / GAP futuro | `onboarding_screen.dart` é tela única (logo + welcome + Continuar → /focus); sem tela de consentimento; nenhuma string de privacidade/LGPD nos `.arb` | Não implementado. Necessário antes de produção dado uso de Analytics/Ads/Supabase. |
| Política de privacidade/termos linkados | N/A / GAP futuro | grep nos `.arb` por privac/termo/terms/consent/lgpd → nenhum; sem link em onboarding/profile | Não implementado |
| Data Safety / aviso pré-cobrança | N/A | paywall/billing não implementados | Não implementado |

---

## 5. N/A — ainda não implementado (cobertura do checklist sem código correspondente)

Estes itens do checklist não puderam ser testados porque a feature não existe nesta fase. Registrados para rastreio:

1. **Paywall / billing** — `paywall_screen.dart` é `FeatureScaffold` placeholder; `purchases_flutter` (RevenueCat) declarado no pubspec mas sem nenhuma chamada em `lib/`. Implica N/A em: testes de paywall, cancelamento ≤2 toques, Data Safety/aviso pré-cobrança.
2. **Anúncios (AdMob rewarded)** — `google_mobile_ads` declarado, sem `MobileAds.instance.initialize()` nem `RewardedAd` em `lib/`. (Mas o App ID já está no manifest — ver #3.) Implica N/A em "anúncios nunca interrompem foco".
3. **Mecânica social / círculos / liga** — `circle_screen.dart`, `league_screen.dart`, `profile_screen.dart`, `recap_screen.dart`, `auth_screen.dart` são placeholders. Opt-in social não verificável.
4. **Consentimento LGPD + política de privacidade/termos** — onboarding é tela única sem etapa de consentimento; sem strings de privacidade nos `.arb`. GAP de compliance a fechar antes de release público.
5. **Push / notificações locais** — `firebase_messaging`, `flutter_local_notifications`, `timezone` declarados; sem wiring em `lib/`. Quando entrarem, exigem permissão `POST_NOTIFICATIONS` + reavaliação de compliance.
6. **Persistência de tema** — seletor de tema/persistência ainda não existe (#10).
7. **Redirect de auth/onboarding** — `app_router.dart:initialLocation` fixo em `/onboarding`; redirect baseado em estado (onboarding concluído / sessão) ainda não ligado (comentado no router).
8. **Sync reverso / fila offline** — quando offline, a sessão grava local mas NÃO há fila de reenvio: `add()` só tenta a nuvem no momento da conclusão; ao reconectar, sessões antigas não são re-sincronizadas automaticamente (apenas `load()` lê da nuvem se autenticado). Ver risco R5.

---

## 6. Riscos do core loop

Leitura de `focus_session_controller.dart`, `focus_session_screen.dart`, `garden_provider.dart`, `session_repository.dart`:

- **R1 — Streak: race + cálculo no cliente (major, finding #2).** `_bumpStreak` lê-modifica-grava `streaks` sem atomicidade. Conclusões rápidas/concorrentes (ex.: retry, multi-device) produzem streak incorreto. Mover para RPC/trigger no Postgres.

- **R2 — Timer não ancorado em relógio de parede (nit, finding #8).** `Timer.periodic(1s)` decrementa um contador; se o OS atrasar o timer, a duração real diverge. Hoje mascarado porque `paused` → `wither()` encerra a sessão. Vira bug se a regra de background mudar.

- **R3 — `wither()` dispara em qualquer `paused`, inclusive interrupções involuntárias (major de produto).** `didChangeAppLifecycleState` mata a árvore em `AppLifecycleState.paused` — o que inclui chamada recebida, troca rápida de app, notificação do sistema, ou abrir as configurações. Apps concorrentes (Forest) toleram uma janela de graça curta. Punir interrupções legítimas é risco real de frustração/avaliação 1 estrela. **Recomendação:** janela de tolerância (ex.: 5-15s) ou só murchar em `detached`/retorno após X segundos; decisão de produto, mas sinalizo como risco alto de UX.
  - Subitem: `inactive` (transição no iOS ao puxar a central de controle) não dispara hoje (só `paused`), o que é bom; manter.

- **R4 — Sem proteção contra dupla conclusão.** `_complete()` cancela o timer e chama `gardenProvider.plant`. Não há guarda de idempotência se `_complete` for chamado mais de uma vez (ex.: tick em `remaining == 0` coincidindo com algo). Hoje o fluxo é linear e `_timer?.cancel()` mitiga, mas `plant` não é idempotente — uma chamada dupla planta duas árvores e conta a sessão duas vezes na nuvem. Baixa probabilidade, sem assert/guarda. **Recomendação:** checar `state.phase != completed` no início de `_complete()`.

- **R5 — Sem fila de sync offline (gap, item 8 da seção 5).** Sessão concluída offline grava local e tenta a nuvem na hora; falhando, fica só local para sempre (nenhum reenvio ao reconectar). O jardim na nuvem diverge do local permanentemente. **Recomendação:** fila de pendências (flag `synced` por árvore) drenada no próximo boot autenticado.

- **R6 — `plant` e estado da árvore concluída persistem entre voltas (menor).** Após `completed`/`withered`, o estado fica até `reset()`. `reset()` chama `build()` que sorteia nova árvore — correto. Sem bug observado, mas o `FocusState` não é persistido: se o app for morto durante uma sessão `running`, ao reabrir volta para `selecting` (a árvore "em progresso" some). Coerente com a mecânica (sair = murchar), apenas registrar.

- **R7 — `garden_provider` otimista sem rollback (menor).** `plant()` faz `await add()` e então seta `state = AsyncData([tree, ...])`. Se `add()` lançar (o `addLocal` pode lançar em I/O), a exceção sobe e o estado não atualiza — aceitável. Mas o estado é montado a partir de `state.value` em memória, não recarregado do repo; em cenário multi-device a lista local pode divergir até o próximo `load()`. Registrar.

- **Sem race no provider em si:** `FocusSessionController` é `Notifier` single-threaded (event loop), `_timer` é cancelado em `onDispose`, `setDuration`/`start` têm guarda de fase. Não há race interno aparente no controller — os riscos são de dados (R1/R5) e de regra de produto (R3).

---

## 7. Observações positivas (não-findings)

- Offline-first bem desenhado: local sempre grava, nuvem é best-effort, init tolerante a falha. Atende ao princípio de §QA "funciona offline".
- Empty/loading/error states completos no garden via `AsyncValue.when`.
- Segredos corretamente externalizados (`String.fromEnvironment` + `env.json` gitignored + `env.example.json` com placeholders). Nenhum segredo real rastreado pelo git.
- Permissão Android mínima (só INTERNET).
- i18n: paridade pt/en OK — as 5 chaves "só em EN" são metadados ICU (`@placeholders`/`type`/`description`/`count`/`minutes`), não traduções faltando (template é `app_en.arb`).
- Dark mode com tokens dedicados (não derivado automático).
- Lints rígidos ativos (`avoid_print`, const-preferences).

---

## 8. Recomendações priorizadas (sem aplicar — apenas reporte)

1. (gate) `dart format lib/` + adicionar `--set-exit-if-changed` ao pre-push/CI. [#1]
2. (dados) Tornar o streak atômico no servidor (RPC/trigger) e logar falhas. [#2, R1]
3. (UX, decisão de produto) Janela de tolerância antes de `wither()` em `paused`. [R3]
4. (robustez) Guarda de idempotência em `_complete()` e fila de sync offline. [R4, R5]
5. (testes) Cobertura unitária do `FocusSessionController` e `SessionRepository`. [#6]
6. (release, não bloqueia fase) Trocar AdMob test App ID pelo real antes de produção. [#3]
7. (compliance, antes de release público) Consentimento LGPD + link de política/termos. [seção 5.4]
