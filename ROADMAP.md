# Grovely — Roadmap

Baseado no briefing §5. Atualizado a cada bloco entregue.
Legenda: ✅ feito · 🟡 parcial · ❌ não começou · 🔒 bloqueado por ação do Jeff

## Fase 0 — Fundação ✅
- ✅ Scaffold Flutter (Riverpod v3, go_router, Material 3)
- ✅ i18n pt+en (.arb + gerado)
- ✅ Navegação: onboarding + shell 5 abas + paywall/recap/auth
- ✅ Supabase: projeto `rkpqpghtuacjxcomisle`, 6 tabelas + RLS
- ✅ Firebase init tolerante a falha

## Fase 1 — Core (paralelo)
- **Agente A — Design System** ✅
  - Nome Grovely validado · tokens light/dark · Bricolage Grotesque + Hanken Grotesk
  - Ícone adaptive + splash · brand book · 6 árvores × estágios
- **Agente B — Core Loop** ✅ (roda no emulador)
  - Timer foco · árvore cresce por estágio · murcha ao sair · jardim · persistência local
- **Agente D — Monetização** ❌ 🔒 (precisa RevenueCat + AdMob do Jeff)
- **QA Checkpoint 1** 🟡 (analyze limpo + roda no device; auditoria formal em andamento — `qa/QA_REPORT_01.md`)

## Fase 2 — Social (paralelo)
- **Agente C — Social** 🟡
  - ✅ Base: auth anônimo + sync nuvem (focus_sessions, streaks)
  - ❌ Círculos (invite) · jardim coletivo realtime/presence · liga semanal
- **Agente E — Onboarding + Recap** 🟡
  - 🟡 Onboarding (1 tela placeholder — redesign pelo designer)
  - ✅ **Notificações locais**: `NotificationService` (lembrete diário de streak via `periodicallyShow`), prompt OS no onboarding, toggle no profile (persiste), manifest perms + boot receiver. VERIFICADO no emulador.
  - ❌ Recap semanal compartilhável · notificações de círculo/fim-de-trial (dependem de social/monetização)
- **QA Checkpoint 2** ❌

## Fase 3 — Lançamento
- **Agente F — Marketing/Landing** 🟡
  - ✅ Nome + seeds de ASO + brand assets
  - ❌ Landing page · screenshots loja · política privacidade/termos
- ✅ **Splash screen animada** (`features/splash/splash_screen.dart` + `shared/widgets/grovely_mark.dart`): bosque cresce (gv-grow do DS: pinheiros brotam da base em sequência + sol + sway), wordmark sobe, emenda sem pulo com o native, honra reduce-motion. Cold start corrigido (init em background pós-runApp)
- ❌ Polish + beta fechado (Internal Testing ~20 testadores)
- ❌ QA final + build release assinado (keystore Grovely)
- ❌ Publicação Play Store

## Polish UI — 2º passe ✅ (essencial concluído)
Lista do designer em `plantio-coletivo-design/APP_REVIEW.md`. Feito: motion P0 (sweep/árvore/confete/haptics), P1 (stagger/press/elevation), copy humanizado, GrovelyEmpty unificado, árvore maior na home/timer + bg neutro, **pódio da liga (ouro/prata/bronze)**, **jardim coletivo visual (mini-árvores)**, **transição slide do onboarding**, **shimmer no skeleton** (extraído `GrovelySkeletonBox`) + **`GrovelyError` unificado**, **árvore da home corrigida** (colapsava no AnimatedSwitcher), **círculo: copy de meta batida**. Pulados (baixo ROI): Hero da árvore entre telas, count-up de stats (quebra plural i18n).

## Em andamento (squad)
- 🎨 Designer: revisão + design de todas as telas → `plantio-coletivo-design/screens/`
- 🔍 QA: auditoria do build atual → `qa/QA_REPORT_01.md`

## Bloqueios / ações do Jeff
- 🔒 AdMob (ad units) + RevenueCat (produtos/entitlements) — Agente D
- 🔒 `flutterfire configure` → analytics/push reais
- 🔒 Grovely: domínio (grovely.app), INPI, handles sociais
- 🔒 CAPTCHA no anônimo + fluxo vincular conta (antes do público)
- 🔒 Play Console: ficha do Grovely · política de privacidade + termos · Data Safety

## Infra
- Repo: github.com/jefsilvanhdev/grovely (alias SSH `github-jefdev`)
- Supabase: projeto Plantio isolado · auth anônimo ON
- Rodar: `cd app && flutter run --dart-define-from-file=env.json`

## Caminho crítico p/ MVP
Agente C (social) → completar E (onboarding/recap) → D (monetização) → QA final → beta fechado → publicação.
