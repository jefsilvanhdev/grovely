# QA de Cenários — Grovely (pré-beta)

**Data:** 2026-07-04 · **Base:** commit `deb52fb` · **Método:** auditoria de caminho de código por cenário (só leitura) + verificações no emulador feitas ao longo da implementação.
**Ferramentas:** `flutter analyze` → **No issues found**. `flutter test` → **23/23 passed**.

Legenda: ✅ ok · ⚠️ gap (funciona mas incompleto/placeholder) · 🔴 bug.
Não repete `QA_REPORT_02.md`, `APP_REVIEW_V6.md` nem `APP_REVIEW_V6_POPULATED.md` — só o que é novo ou o estado atual dos cenários.

---

## A. Assinatura (entitlement)

| Cenário | Esperado | Código | Veredito | Nota |
|---|---|---|---|---|
| A1 free | Row de upsell "Conheça o Grovely Plus / Grátis" → `/paywall` de venda | `profile_screen.dart:170-175` | ✅ | Só o estado free navega ao paywall |
| A2 trial | Card badge âmbar, "N dias restantes", sem preço | `_PlanCard` `profile_screen.dart` (else) | ✅ | Preço só volta com RevenueCat |
| A3 plus | Card verde, membro desde/renova, benefícios em 2 colunas, anel accent no avatar | `_PlanCard` + `_BenefitGrid` | ✅ | Benefícios agora lista alinhada, não chips |
| A3b guard | Assinante no `/paywall` vê "Você já é Plus" + Gerenciar, nunca a venda | `paywall_screen.dart:_buildAlreadyPlus` | ✅ | Verificado no emulador (funil caiu no guard) |
| A4 manage | Abre gestão nativa do Play (externalApplication); fallback snackbar; `<queries>` https | `profile_screen.dart` + `AndroidManifest.xml:67-71` | ⚠️ | URL sem `sku` (Play mostra lista); adicionar sku quando RevenueCat plugar. iOS: falta `showManageSubscriptions` (build iOS desligado hoje) |

**Origem do estado:** hoje `entitlementProvider` é stub `free`; só o `demo_seed` força Plus. Em produção, RevenueCat substitui o provider — **nenhuma tela muda**.

---

## B. Círculo

| Cenário | Esperado | Código | Veredito | Nota |
|---|---|---|---|---|
| B1 sem círculo | Empty + Criar/Entrar + nota de privacidade | `circle_screen.dart:_Empty` | ✅ | |
| B2 criar | Sheet, nome vazio ignora, botão trava no await, sucesso invalida provider | `_CircleFormSheet` | ✅ | Busy-lock impede double-create |
| B2b criar offline/sem-Supabase | Erro "sem conexão", não trava | `circle_repository.dart:_requireReady` → `CircleError.offline` | ✅ | |
| B3 entrar válido | RPC join → detalhe | `joinByCode` | ✅ | Depende da migration 0003 (bloqueio Jeff) |
| B3b inválido | "código inválido" | `CircleError.notFound` | ✅ | |
| B3c cheio | "círculo cheio" | `CircleError.full` | ✅ | |
| B3d rede | **offline ≠ inválido** | `_mapError` mapeia Socket/Auth → offline | ✅ | Corrigido (I5) |
| B4 em círculo | Bosque cap 12 + "+N" + barra; meta batida 🎉; "quem plantou" ícones ×N; avatares por cor | `_Detail` + `_MemberRow` + `avatarColor` | ✅ | Fase A do review aplicada |
| B5 convite | Sheet: código grande + copiar (clipboard+snackbar) + compartilhar; código NÃO na tela principal | `_inviteSheet` `circle_screen.dart:460-490` | ✅ | Ícone `person_add_alt` (≠ share do recap) |
| B6 sair | Confirmação → sucesso; erro → snackbar | `_confirmLeave` com try/catch | ✅ | |

---

## C. Liga

| Cenário | Esperado | Código | Veredito | Nota |
|---|---|---|---|---|
| C1 solo | Empty "entre num círculo" | `_Solo` | ✅ | |
| C2 em círculo | Countdown até segunda, pódio top-3, card "Você" + delta, "N trees", ranking 4+ | `league_screen.dart` (reescrito) | ✅ | Verificado no emulador |
| C3 fora do top-3 | Card "Você" aparece com delta "faltam N pra passar {acima}" | `_YouCard` `youIndex>0` | ✅ | Sempre mostra se está na lista |
| C4 lista 1-2 membros | Pódio degrada (spots vazios = SizedBox.shrink) | `_PodiumSpot` null-guard | ⚠️ | Layout fica levemente torto com 2 (3º slot vazio); aceitável no MVP |
| C4b empate | Mesmo score → ordem estável; delta pode dar "0 trees behind" | `_YouCard` gap>=0 | ⚠️ | Copy "0 árvores atrás" é esquisito no empate; P2 |

**Fase B (liga entre CÍRCULOS, divisões botânicas)** documentada em `APP_REVIEW_V6_POPULATED.md §2` — precisa de RPC `league_standings` + coortes. Não implementada (bloqueio de backend).

---

## D. Jardim

| Cenário | Esperado | Código | Veredito | Nota |
|---|---|---|---|---|
| D1 vazio | Empty + "plantar primeira" | `_GardenEmpty` | ✅ | |
| D2 poucas (<9) | Grid + "+" no fim (mockup) | `garden_screen.dart` `plusFirst=false` | ✅ | |
| D3 cheio (23) | "+" PRIMEIRO; stagger com teto (clamp 10); recap no AppBar só com árvores | `garden_screen.dart` + `staggerIn` | ✅ | Verificado |
| D4 detalhe | Bottom sheet espécie+data+min; tile com Semantics | `_TreeDetailSheet` + `PressableScale(semanticLabel)` | ✅ | |
| D5 offline sync | add falha→pending; load mescla local+nuvem dedupe; não some ao reconectar | `session_repository.dart` fila (I3) | ✅ | Chave de dedupe = slug·min·epoch-segundo |
| D5b flush | Pendências reenviam no próximo load autenticado | `_flushPending` | ⚠️ | Só dispara no `load()`; se o usuário nunca reabre o jardim, não sincroniza até lá (aceitável — jardim é a home de retorno) |

---

## E. Sessão de foco

| Cenário | Esperado | Código | Veredito | Nota |
|---|---|---|---|---|
| E1 selecionar | Dial 15/25/45/60, regra do wither visível, Semantics no dial | `_Selecting` + `DurationDial` | ✅ | |
| E2 rodando | Dark imersivo, wakelock, timer por relógio, liveRegion/min | `focus_session_controller` + `_Running` | ✅ | Wakelock confirmado (dumpsys) |
| E3 completar | Planta no jardim + confete + haptic | `_complete` → `gardenProvider.plant` | ✅ | |
| E4 background | <45s volta ok; >45s murcha; decisão por relógio no resume | `onAppPaused`/`onAppResumed` | ✅ | Imune à race de suspensão (teste cobre) |
| E5 processo morto | Boot: tempo fechou=planta, não=murcha | `_resolvePendingSession` | ✅ | Verificado no emulador (força-stop → murcha) |
| E6 reviver | Após murcha, revive→planta | `revive()` | ⚠️ | Rewarded ad é **placeholder** (`TODO Agente D`), revive direto sem ad |
| E7 sheet desistir | Fecha quando sessão completa por baixo | `ref.listen` phase | ✅ | M8 |

---

## F. Perfil

| Cenário | Esperado | Código | Veredito | Nota |
|---|---|---|---|---|
| F1 nome | Sheet edita, persiste (prefs), sobe pro profiles | `display_name_provider` + `_NameSheet` | ✅ | |
| F2 foto | Picker do sistema, copia/reduz 512px, persiste, render; trocar/remover | `profile_photo_provider` | ✅ | Verificado ponta a ponta no emulador |
| F3 tema | system/light/dark persiste (M10) | `theme_mode_provider` | ✅ | |
| F3b notif | Toggle; permissão negada → snackbar | `_notifSheet` | ✅ | |
| F4 rows mortas | Privacy/Terms/SignOut escondidas no beta | `profile_screen.dart` (removidas) | ✅ | Confirmado: não existem no código |

---

## G. Onboarding + boot

| Cenário | Esperado | Código | Veredito | Nota |
|---|---|---|---|---|
| G1 1º run | Splash animada → onboarding 5p → paywall → app | `splash` + `onboarding` + router | ✅ | |
| G2 run seguinte | Pula onboarding → `/focus` | `splash` lê `onboarding_done`; paywall grava | ✅ | Verificado |
| G3 reduce-motion | Splash curta, sem animação perpétua | `GrovelyMark`/`splash` reduced | ✅ | Testes cobrem |
| G4 offline boot | Supabase falha → app abre | `main.dart` bootstrap `unawaited`+try/catch | ✅ | |

---

## H. Transversais

- **i18n:** paridade pt/en, plurais ICU (streak/best/leagueScore/planTrialDaysLeft). Novas chaves de plano/liga/círculo/foto adicionadas nos dois. ✅
- **reduce-motion:** honrado em splash, stagger, confete, shimmer (M9). ✅
- **loading/erro/vazio:** `GrovelyEmpty`/`GrovelyError`/skeleton consistentes. ✅
- **strings hardcoded:** varredura anterior limpa; novas telas usam .arb. ✅
- **leaks:** controllers/timers/listeners dispostos (sheets do círculo/nome com dispose, GrovelyMark, focus controller). ✅

---

## Achados NOVOS (priorizados)

**P1-1 · Sua própria foto/nome não aparece na Liga nem no Círculo. ✅ CORRIGIDO (`c...`)**
Antes, `_RankRow`/`_PodiumSpot`/`_MemberRow` usavam só `avatarColor` + inicial. Novo widget `MemberAvatar` renderiza a `profilePhotoProvider` quando `member.userId == currentUserId`; parent passa `youPhoto` só na linha do usuário. Membros remotos seguem inicial até o upload com auth real. *Verificado por código; FileImage já confirmado no avatar do Perfil.*

**P2-1 · IO síncrono no provider de foto. ✅ CORRIGIDO** — `existsSync()` → `await File(path).exists()` num `_restore()` async, fora do build.

**P2-2 · Delta de liga no empate. ✅ CORRIGIDO** — delta escondido quando gap == 0 (`gap > 0`).

**P2-3 · `_flushPending` só dispara no `load()` do jardim** — pendências offline não sobem em background nem ao reconectar rede, só quando o usuário reabre o jardim. Aceitável (jardim é a tela de retorno natural); um retry no `resumed` do app fecharia o gap. *Mantido como registro, não bloqueia.*

**P2-4 · Manage subscription sem `sku`** — a URL do Play abre a lista geral de assinaturas, não a do Grovely. Adicionar `&sku=<product_id>` quando o RevenueCat trouxer o id. iOS não tem caminho de gestão (build iOS desligado). *Depende do Agente D.*

---

## Veredito de prontidão

**Pronto para beta fechado no que é lógica de app.** Analyze limpo, 23 testes, todos os fluxos-núcleo (sessão, jardim, perfil, assinatura, círculo/liga com dados) verificados por código e — os de maior risco — no emulador. Os achados acima são P1/P2 de polish, nenhum bloqueia distribuir para testadores.

**Bloqueios que continuam sendo do Jeff (não são bugs):** migration 0003 (círculo/liga com dados reais), RevenueCat (assinatura real + sku), keystore (upload), OAuth (auth real), Firebase (telemetria do beta). Sem a 0003, as abas Círculo/Liga funcionam de UI mas não têm backend — decidir se entram no beta ou ficam ocultas.

## Não verificável sem device físico
- Comportamento real de wakelock/Doze/fabricantes (screen-off → paused; agressividade de battery saver).
- Photo picker em Android < 13 (usa galeria com permissão; testado só no emulador Android 13+).
- `periodicallyShow` do lembrete após reboot em Android 14+.
- Emenda visual splash nativa → Flutter sem "pulo" (só em device).
- RLS/RPCs do Supabase (fora do repo do app).
