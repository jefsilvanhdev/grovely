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
- **Agente C — Social** 🟢 (migrations aplicadas 2026-07-04; social VIVO)
  - ✅ Base: auth anônimo + sync nuvem (focus_sessions, streaks)
  - ✅ **Círculos com dados reais**: migrations 0001/0002/0003 aplicadas no Supabase. VERIFICADO no emulador ponta a ponta: criar círculo → código de convite (`_genCode`) → RPC `circle_member_stats` retorna membros+árvores da semana → sair (`leave`) → entrar por código (RPC `join_circle_by_code`) → de volta no círculo. Liga lê os mesmos dados.
  - 🟡 Nome de membro: fallback SQL `'Member'` (0003) até o usuário setar nome no Perfil (edição já existe); não-localizado no servidor (aceitável)
  - ❌ Jardim coletivo realtime/presence ("X focando agora") — precisa Supabase Realtime + 2 devices
  - ❌ Liga entre CÍRCULOS (Fase B do design review) — RPC `league_standings` + divisões
- **Agente E — Onboarding + Recap** 🟡
  - 🟡 Onboarding (1 tela placeholder — redesign pelo designer)
  - ✅ **Notificações locais**: `NotificationService` (lembrete diário de streak via `periodicallyShow`), prompt OS no onboarding, toggle no profile (persiste), manifest perms + boot receiver. VERIFICADO no emulador.
  - ✅ **Recap semanal compartilhável**: card 9:16 (árvores/min/streak/espécies da semana) + share via captura (`RepaintBoundary` → PNG → share_plus). Entrada wireada no AppBar do Garden (ícone share, só com árvores). VERIFICADO no emulador.
  - ❌ Notificações de círculo/fim-de-trial (dependem de social/monetização)
- **QA Checkpoint 2** ❌

## Fase 3 — Lançamento
- **Agente F — Marketing/Landing** 🟡
  - ✅ Nome + seeds de ASO + brand assets
  - ❌ Landing page · screenshots loja · política privacidade/termos
- ✅ **Splash screen animada** (`features/splash/splash_screen.dart` + `shared/widgets/grovely_mark.dart`): bosque cresce (gv-grow do DS: pinheiros brotam da base em sequência + sol + sway), wordmark sobe, emenda sem pulo com o native, honra reduce-motion. Cold start corrigido (init em background pós-runApp)
- ❌ Polish + beta fechado (Internal Testing ~20 testadores)
- ❌ QA final + build release assinado (keystore Grovely)
- ❌ Publicação Play Store

## Rebrand v6 ✅ (2026-07-02)
Fonte: `plantio-coletivo-design/Plantio-V2/brand/` (brand book v6, tokens, Illustration 2.0).
- 40/44 árvores atualizadas (copa com profundidade + highlight + acento quente por espécie)
- Símbolo v6 (bosque orgânico + sol) em assets; launcher icon e splash nativa regenerados
- `GrovelyMark` refeito na geometria v6 (cores do foreground da splash)
- **Corrida da splash corrigida**: `FlutterNativeSplash.preserve()/remove()` + navegação via `onSettled` (antes a animação rodava escondida sob a nativa)
- Sessão de foco = ambiente imersivo escuro (header FOCO PROFUNDO, anel mint, timer branco, stop ghost)
- Paywall escuro com a marca no topo · Garden com slot "+" · card do bosque do círculo com gradiente + overline
- VERIFICADO no emulador ponta a ponta (splash, onboarding, foco, completed, garden, paywall)

## QA + Usabilidade + Fixes ✅ (2026-07-03)
Relatórios: `qa/QA_REPORT_02.md` (técnico) · `plantio-coletivo-design/APP_REVIEW_V6.md` (design) · `qa/USABILITY_REPORT_V6.html` (6 synth users — abrir no navegador).
**Resolvido no commit `1b52532`** (verificado no emulador): C1 wakelock+carência 45s · C2 onboarding persiste · C3 círculo com guardas/feedback · C4 assinatura via key.properties · I1 timing por relógio · I2 sessão sobrevive a processo morto · I5/I6/I7/I9 · M2/M4/M8/M9/M10 · plurais ICU · UX P1s (regra do wither na home, paywall sem "TBD", espécie capitalizada, pills, watermark).
**Ficou para depois (não bloqueia beta):** I3 sync offline→nuvem (merge no load) · I4/I8 decisão Firebase (configurar OU remover) · M6 ícone mono de notificação · M11 horário fixo do lembrete (zonedSchedule) · M12 RPC transacional create_circle.

## Landing page ✅ (2026-07-03)
`landing/index.html` — estática, brand v6, autocontida (falta domínio + form real de waitlist = Jeff).

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
