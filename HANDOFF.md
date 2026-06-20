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

## 4. O que está PRONTO (telas MVP + polish, ~20 commits, roda no emulador)

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

### 5.1 PRIMEIRO — árvore adulta na home com o DOBRO do tamanho
Na home (`_Selecting` em `app/lib/features/focus_session/focus_session_screen.dart`)
a árvore já mostra `TreeStage.mature` a `size: 300`. **Pedido do Jeff: dobrar o
tamanho visual da árvore adulta na home.** Ações sugeridas:
- Aumentar `size` (ex.: ~480–560) e garantir que o `Expanded`/`Center` comporte sem
  estourar o layout (talvez reduzir paddings, dar mais espaço vertical à ilustração).
- Conferir que o SVG da árvore madura preenche bem (o `viewBox` tem margem; pode
  valer um leve `Transform.scale`/`FittedBox` pra encher).
- Validar no emulador (home/Foco) que ficou **claramente maior** (Jeff já reclamou
  2× que estava menor — confirmar com screenshot antes de fechar).
- Rever também o tamanho no timer (running) se necessário pra manter proporção.

### 5.2 Resto do 2º passe de polish (designer — `plantio-coletivo-design/APP_REVIEW.md`)
- **Hero da árvore** entre selecting → running → completed → tile do garden.
- **Count-up** de stats (garden/profile/recap) — `AnimatedCounter`.
- **Jardim coletivo visual**: no Circle, trocar a barra de progresso por mini-árvores
  enchendo (diferencial do produto).
- **Transição slide** do onboarding (hoje é fade).
- **Splash screen animada** (broto/bosque crescendo + wordmark) — está no ROADMAP.
- Extrair `GrovelyError`/`GrovelySkeleton` como componentes (hoje só garden tem padrão).

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
