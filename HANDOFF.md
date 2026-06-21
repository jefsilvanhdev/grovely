# Grovely — Handoff (para iniciar um novo chat)

> App Flutter de foco + jardim coletivo. Cole este arquivo como contexto inicial.
> Trabalhe em **caveman mode full** (economia de tokens) e siga o workflow
> `flutter analyze → git push` no alias SSH `github-jefdev`.

---

## 1. O que é

**Grovely** (ex- "Plantio Coletivo"): timer de foco onde você planta uma árvore
que cresce enquanto mantém o foco; sair do app antes do fim faz murchar; sessões
viram um jardim pessoal. Diferencial = **coletivo**: focar em tempo real com um
círculo (6–12 pessoas) faz um jardim de grupo florescer + liga semanal.
Mercado: global (inglês primeiro) + Brasil (pt). Plataforma: Android primeiro.

Segue o briefing `briefing-plantio-coletivo-claude-code.md` (padrão "O Meu Salmo").

## 2. Stack & convenções

- **Flutter** (Dart 3.12), **Riverpod v3**, **go_router**, Material 3.
- **Supabase** (auth anônimo + Postgres + RLS), **RevenueCat** (futuro), **AdMob**
  (futuro), **Firebase** (futuro), **flutter_svg**, **flutter_animate**, **share_plus**,
  **google_fonts**, **intl**.
- i18n **pt + en** obrigatório (nada hardcoded) — `app/lib/l10n/app_*.arb` (en é o
  template). Regenerar: `cd app && flutter gen-l10n`.
- Pastas: `app/lib/{core,data,features,shared,l10n}`. Lints estritos (`avoid_print`).
- Rodar: `cd app && flutter run -d emulator-5554 --dart-define-from-file=env.json`.

## 3. Infra / contas (NÃO commitar segredos)

- **Repo:** github.com/jefsilvanhdev/grovely — push **só** via alias SSH
  `git@github-jefdev:jefsilvanhdev/grovely.git` (a conta jefsilvanhdev não está no
  `gh` CLI; só jefsilvanh88 + omeusalmo).
- **Supabase:** projeto isolado `rkpqpghtuacjxcomisle` (NUNCA reusar Salmos/treinos).
  Creds em `app/env.json` (gitignored). Auth anônimo **ligado**. Tabelas+RLS aplicadas.
- Estrutura git: raiz `plantio-coletivo/` (a pasta mantém esse nome) com `app/` dentro.
- applicationId / bundle: `com.grovely.app`. Label: Grovely.

## 4. O que está PRONTO (telas MVP + polish, ~23 commits, roda no emulador)

- **Fase 0**: scaffold, i18n, nav (shell 5 abas), tema claro/escuro, Supabase schema+RLS.
- **Identidade (Grovely)**: tokens, fontes Bricolage Grotesque + Hanken Grotesk,
  ícone adaptive + splash, brand book, 44 SVGs de árvore (6 tipos × estágios) em
  `app/assets/brand/trees/`. Símbolo = bosque de pinheiros + sol.
- **Core loop** (`features/focus_session/`): timer, árvore cresce por estágio,
  murcha ao sair (carência 5s), jardim. **Motion**: TimerRing com sweep contínuo +
  ponta viva, árvore escala, **confete de folhas** + **haptics** no completed.
- **Onboarding** 5 passos (welcome→notif→social→guiada 30s→paywall).
- **Garden** (header stats, skeleton com shimmer, empty, detalhe).
- **Paywall** honesto (Free×Premium, toggle anual/mensal, preço placeholder).
- **Profile/Settings** + troca de tema ao vivo (dark mode verificado).
- **Recap** (card 9:16 + share via captura).
- **Circle** (home/criar/join/detalhe) + **League** (ranking + pódio ouro/prata/bronze).
- **Design System** em `app/lib/core/theme/`: `GrovelyMotion` (durações/curvas/springs
  + reduce-motion), `GrovelySpacing`, `GrovelyElevation`, `AppRadius`, `AppColors`.
  Componentes em `app/lib/shared/widgets/grovely_components.dart`:
  `StreakBadge, StatPill, DurationDial, TimerRing, SymbolWatermark, LeafConfetti`
  (em `leaf_confetti.dart`), `PressableScale`, `GrovelyEmpty`, `grovelyCard()`,
  extensão `.staggerIn(context, i)`.
- **Copy humanizado** (UX writing): voz Grovely, sem "(a)/(s)" no PT, fracasso sem culpa.
- Docs do designer: `plantio-coletivo-design/{APP_REVIEW.md, COPY_REVISION.md, brand/, screens/}`.

## 5. PRÓXIMOS PASSOS (começar por aqui)

### 5.1 ✅ RESOLVIDO — árvore adulta na home agora grande (verificado no emulador)
Causa raiz do "tamanho pequeno" NÃO era o `Expanded`/`FittedBox`: era o `TreeView`.
`AnimatedSwitcher` usa um Stack interno com constraints **loose**, então o
`SvgPicture.asset` (sem width/height) colapsava pro tamanho intrínseco do viewBox
(~100×120 lógico) → árvore minúscula, independente do tamanho do box pai.
**Fix:** `SvgPicture.asset` agora recebe `width: size, height: size` explícitos
(`app/lib/features/focus_session/widgets/tree_view.dart`). Beneficia home, running
(240) e todos os usos do TreeView.
Home (`_Selecting`): `FittedBox` trocado por `LayoutBuilder` → size explícito =
`min(maxWidth, maxHeight) * 0.95`.
**Status: VERIFICADO no emulador-5554** — árvore ocupa ~65% da largura, elemento
dominante da tela. Screenshot confere.

### 5.2 Resto do 2º passe de polish (designer — `plantio-coletivo-design/APP_REVIEW.md`)
- ✅ **Jardim coletivo visual** (Circle): barra → mini-árvores enchendo + brotos
  esmaecidos nas vagas. FEITO (commit `4f62ee4`).
- ✅ **Transição slide** do onboarding (slide+fade direcional). FEITO (`4f62ee4`).
- ✅ **Splash screen animada** (`features/splash/splash_screen.dart` +
  `shared/widgets/grovely_mark.dart`): o bosque **CRESCE** replicando o motion do
  design system (`gv-grow`: escala da base + fade; `gv-sway`: balanço leve). O
  mark é pintado em Flutter (`GrovelyMark`, CustomPaint, geometria 1:1 com o
  símbolo da marca) — cada pinheiro brota da base em sequência (baixo→médio→alto,
  clímax no central, `Curves.easeOutBack` por `Interval`), o sol surge no fim e o
  bosque balança ±1.2° depois de assentar. Wordmark "Grovely" sobe após o grow.
  Emenda sem pulo com o native (mesma arte/verde). ~2.4s → `/onboarding`. Honra
  reduce-motion (pinta estado final, 600ms). `GrovelyMark` é reutilizável
  (`animate:false` = ícone estático). VERIFICADO no emulador.
- ✅ **Extrair `GrovelyError`/`GrovelySkeleton`**: feito em
  `shared/widgets/grovely_components.dart` (`GrovelyError{onRetry,message}` +
  `GrovelySkeletonBox{height,radius}`). Garden/Circle/League agora usam o padrão
  único (removidos `_GardenError` e o skeleton ad-hoc).
- ✅ **Cold start corrigido**: `main()` agora chama `runApp` ANTES dos inits;
  Supabase/Firebase sobem em background via `unawaited(_bootstrapServices())`.
  São best-effort e ninguém no boot (splash→onboarding) depende deles, então o
  primeiro frame (splash animada) aparece na hora — sem os ~8-10s de splash
  nativa travada. Telas autenticadas só são alcançadas depois do onboarding,
  quando o init já terminou.
- ⏳ Extrair `GrovelyError`/`GrovelySkeleton` como componentes (hoje só garden tem padrão).
- ❌ **Hero da árvore** entre selecting→running→completed→tile: PULADO (complexidade de
  rota/Hero entre telas do shell — baixo ROI agora).
- ❌ **Count-up** de stats (`AnimatedCounter`): PULADO (quebra plural i18n — baixo ROI).

### 5.3 Roadmap maior (ver `ROADMAP.md`)
- **Agente C (social)** runtime: aplicar `app/supabase/migrations/0003_circle_functions.sql`
  no SQL Editor pra join-by-code + stats de membros funcionarem. Presence "X focando
  agora" ao vivo (realtime + 2 devices) ainda falta.
- **Agente D (monetização)**: RevenueCat (produtos/entitlements) + AdMob (ad units) +
  preço real do paywall + wiring do rewarded "reviver árvore".
- **Agente E**: prompt OS de notificação + notificações (streak/círculo/fim de trial).
- **Agente F**: landing page, screenshots da loja, política de privacidade + termos.
- **Auth real**: tela de auth ainda é placeholder (OAuth Apple/Google + email).
- Beta fechado → QA final → build release assinado (keystore Grovely) → Play Store.

## 6. AÇÕES DO JEFF (blockers — fazer quando puder)

1. **Supabase SQL Editor**: aplicar `app/supabase/migrations/0002_streak_trigger.sql`
   (streak atômico) e `0003_circle_functions.sql` (Circle). Sem elas, streak não
   incrementa no servidor e Circle join/membros não funcionam.
2. **AdMob** App ID real (o manifest usa o TEST id `ca-app-pub-3940256099942544~3347511713`).
3. **RevenueCat** produtos + **preço** do paywall (hoje placeholder honesto).
4. **flutterfire configure** (analytics/push) + projeto Firebase novo isolado.
5. **Grovely**: domínio (grovely.com provável ocupado → grovely.app), INPI, handles.
6. **CAPTCHA** no anônimo do Supabase antes do público (anti-abuso).
7. Trocar a senha do Postgres do Supabase (foi colada num chat antigo).

## 7. Regras de trabalho

- **Caveman mode full** (economia de tokens): prosa curta, fragmentos ok; código/commits
  normais. Reduzir rebuilds/screenshots/re-reads — economia real está no volume de
  tool calls, não na prosa.
- Após mudança no app: `flutter analyze` (zero erro/warning) → `git push` no alias
  `github-jefdev`. Não commitar `env.json` nem chaves.
- Verificar no emulador `emulator-5554` antes de fechar features visuais.
- Para telas atrás do onboarding (que tem sessão guiada de 30s), pra testar rápido dá
  pra flipar `initialLocation` em `app/lib/core/router/app_router.dart` pra `/focus`
  temporariamente e reverter depois (ou navegar pelo fluxo).
