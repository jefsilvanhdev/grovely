# Grovely — App Review & Improvement List

Auditoria de produto/UX do app Flutter **já implementado**. Foco: deixar o app
**mais visual, satisfatório e prazeroso**, com **motion intencional** e um
**Design System** completo. Este documento **planeja**; a implementação vem
depois (não há edição de código aqui).

Fonte lida: `app/lib/features/*`, `app/lib/shared/widgets/*`,
`app/lib/core/theme/*`, `brand/tokens.json`, e screenshots em `/tmp`.

**Legenda de prioridade**
- **P0** — bloqueia "satisfatório/prazeroso"; o app parece estático ou inacabado sem isso.
- **P1** — eleva visivelmente o craft e a consistência.
- **P2** — refinamento; faz num segundo passe.

**Veredito rápido:** a base está sólida (tokens coerentes, M3, dark mode real,
empty/loading/error já existem no Garden, copy já começou a ser humanizada em
alguns pontos). O que falta é **vida**: quase não há motion proprietário, o
momento-herói (árvore crescendo + anel + conclusão) é estático, e há
inconsistências de profundidade, espaçamento e estados entre telas. Hoje o app
"funciona"; ainda não "encanta".

---

## 0. Resumo executivo — Top 10 melhorias (priorizadas)

| # | Melhoria | Prioridade | Onde |
|---|----------|-----------|------|
| 1 | **TimerRing com sweep animado** (tween por frame, não saltos de 1s) + cap arredondado que viaja | P0 | `grovely_components.dart`, `focus_session_screen.dart` |
| 2 | **Crescimento da árvore com spring** (não fade-scale genérico) + honra reduce-motion | P0 | `tree_view.dart` |
| 3 | **Momento "Tree planted!"**: confete de folhas + escala/bounce da árvore + haptic de sucesso | P0 | `focus_session_screen.dart` (_Completed) |
| 4 | **Hero da árvore** entre selecting → running → completed → garden tile | P0 | `tree_view.dart`, `focus_session_screen.dart`, `garden_screen.dart` |
| 5 | **Tokens de motion** (duração/easing/spring) no `tokens.json` + `app_theme.dart` (`GrovelyMotion`) | P0 | `tokens.json`, `app_theme.dart` (novo) |
| 6 | **Elevação/sombra em superfícies** (cards hoje são só border 1px → chapados) | P1 | `app_theme.dart`, todos os cards |
| 7 | **Staggered reveal** em listas (garden grid, league rows, members) | P1 | `garden_screen.dart`, `league_screen.dart`, `circle_screen.dart` |
| 8 | **Withered humanizado + sem castigo visual**: usar `witheredBodyKind` em todo lugar, motion de murcha suave, sheet de revive primário | P1 | `focus_session_screen.dart`, copy |
| 9 | **Press states** consistentes (scale-down + haptic leve) em todo card/botão tappável custom | P1 | `grovely_components.dart`, choice cards, tree tiles |
| 10 | **Watermark com regras** (nunca atrás de nav/listas; só em momentos-herói, com escala/posição padronizada) | P2 | `grovely_components.dart` + telas que usam |

**Recomendação `flutter_animate`:** **SIM, adicionar.** Justificativa no §4.

---

## 1. Avaliação por tela

### 1.1 Onboarding — `features/onboarding/onboarding_screen.dart`
**Bom**
- Fluxo correto e honesto: welcome → notif → social (opt-in, default solo) → sessão guiada de 30s → paywall.
- `_Dots` já anima a largura do dot ativo (bom detalhe).
- Sessão guiada "essa é por nossa conta" é um ótimo primeiro-valor.

**Melhorar**
- **Transição entre passos é só `AnimatedSwitcher` (fade 250ms)** — sem direção. Onboarding pede slide horizontal + fade (sensação de avançar). **[P1]**
- **Welcome estático:** logo + texto aparecem secos. Falta entrada encadeada (logo → título → sub → botões) com leve translateY. **[P1]**
- **Sessão guiada não tem o payoff visual** que o app inteiro promete: ao bater 30s, a árvore deveria explodir em folhas/escala + haptic (é o "momento aha"). Hoje só troca o texto e libera o botão. **[P0]**
- O dot inativo usa `outline` — contraste baixo no claro. Usar `onSurfaceVariant @ 30%` ou um track dedicado. **[P2]**
- Watermark de 320 no welcome fica atrás do texto e dos botões inferiores; cabe definir uma faixa segura (ver §3 watermark). **[P2]**

### 1.2 Focus — `features/focus_session/focus_session_screen.dart` (+ `widgets/tree_view.dart`, `focus_session_controller.dart`)
É **o coração do app** e onde está o maior gap entre "ok" e "encantador".

**Bom**
- Máquina de estados limpa (selecting/running/completed/withered) com grace period perdoador (5s em background) — UX humana e correta.
- Modo imersivo (nav some no running) — decisão certa.
- Fundo do running já faz `Color.lerp` "esquentando" rumo ao fim — gesto bonito e subutilizado.
- DurationDial é um bom componente (já anima seleção).

**Melhorar (núcleo dos P0)**
- **Anel não anima de fato.** `TimerRing` recebe `progress` do estado, que muda 1×/s — o arco **salta** a cada segundo em vez de varrer continuamente. Precisa de um `AnimationController` interpolando entre ticks. **[P0]**
- **Anel sem "ponta viva".** Hoje é só um arco com `StrokeCap.round`. Um ponto/glow na cabeça do arco dá leitura de progresso e vida. **[P0]**
- **Proporção árvore↔anel ruim no running:** anel 280, árvore 170 dentro de uma caixa `0.62*size ≈ 173` → a muda fica minúscula no centro de um círculo enorme e vazio (confirmado no screenshot `g-running`). A árvore deve **crescer e preencher mais** o anel conforme o progresso. **[P0]**
- **Crescimento sem peso.** `tree_view.dart` usa `AnimatedSwitcher` fade+scale 0.85→1, `easeOutBack`, 600ms — genérico e não honra reduce-motion. Trocar por crescimento com **spring** + cross-fade dos estágios. **[P0]**
- **Completed é estático.** Árvore aparece, pills aparecem, fim. Falta: bounce/settle da árvore (Hero da run), **confete de folhas**, haptic de sucesso, e entrada encadeada dos pills + "Added to your garden". É o pico emocional do loop — tem que ser memorável. **[P0]**
- **Withered pune visualmente e na cópia.** O título usa `focusWitheredTitle` + body `focusWitheredBody` ("Try again.") — seco, culpando. Já existe `witheredBodyKind` ("it happens…") **mas a tela _Withered não o usa no body principal** (usa no `_Withered`, sim — confira: usa `witheredBodyKind`, ok; o offender é o estado fora do core que mostra `focusWitheredBody`). Padronizar no tom gentil em todos os lugares. Murcha deve ter motion suave (folhas caindo devagar), não um corte. **[P1]**
- **"Give up" é verde** (cor primária = parece ação positiva/primária). Confuso. Deveria ser `onSurfaceVariant`/neutro discreto. **[P1]** *(confirmado no screenshot `g-running`.)*
- **Sem haptics** em nenhum ponto (start, complete, wither, tick final). **[P1]**
- Timer `displayLarge` com `tabularFigures` — ótimo; manter. **[—]**

### 1.3 Garden — `features/garden/garden_screen.dart`
**Bom**
- **Melhor tela do app em completude:** tem `data`/`loading` (skeleton)/`error` (retry) + empty dedicado. É o padrão a replicar.
- Header card com count + streak + stat pills é limpo.
- Grid 3-col com detail sheet por árvore — bom.

**Melhorar**
- **Grid aparece de uma vez** — pede staggered fade/scale ao entrar (jardim "brotando"). **[P1]**
- **Tiles sem profundidade e sem press state.** São `surfaceContainerHighest` chapado, radius 14; tocar não dá feedback. Adicionar sombra sutil + scale-on-press + Hero pro sheet. **[P1]**
- **Skeleton não pulsa** (shimmer). Hoje é cinza estático. **[P2]**
- Detail sheet é informativo mas seco — a árvore poderia ter entrada com Hero vindo do tile. **[P2]**
- Stats no header poderiam ter **contador animado** (count-up) quando muda. **[P2]**

### 1.4 Circle — `features/circle/circle_screen.dart`
**Bom**
- Empty state forte ("Grow together.") com 2 CTAs + nota de privacidade — honesto e claro.
- Detail com meta coletiva (progress bar), lista de membros, invite/leave. Realtime "focando agora" corretamente adiado.

**Melhorar**
- **Loading é `CircularProgressIndicator` cru** (diverge do skeleton do Garden). Padronizar skeleton. **[P1]**
- **Error cai pro empty** (`error: (_, _) => _Empty()`) — esconde falha como "sem círculo". Deve ter estado de erro com retry. **[P1]**
- **`LinearProgressIndicator` da meta** anima nativamente, mas a cor de progresso usa default do tema (não o verde "saúde"); e não há celebração ao bater a meta. **[P1]**
- **Lista de membros sem stagger nem avatar com cor/identidade** (todos `primaryContainer`). Dar variação sutil por inicial/seed. **[P2]**
- A barra de progresso da meta poderia virar um **jardim coletivo** visual (mini-árvores enchendo) — diferencial do produto. Hoje é uma barra genérica. **[P2 / oportunidade de produto]**

### 1.5 League — `features/league/league_screen.dart`
**Bom**
- Circle-gated com `_Solo` empty claro.
- `_RankRow` destaca "Você" com `primaryContainer`.

**Melhorar**
- **Sem hierarquia de pódio:** rank 1/2/3 deveriam ter medalha/cor (ouro/prata/bronze) e/ou tamanho. Hoje todos iguais, só número. **[P1]**
- **Rows entram secas** — staggered slide-in. **[P1]**
- **Loading dobrado** (`CircularProgressIndicator` no circle e de novo nos members) — skeleton de ranking. **[P1]**
- "Você" poderia ter leve glow/borda accent além do fundo. **[P2]**
- Sem animação de mudança de posição (se reordenar) — `AnimatedList`/`flutter_animate` futuro. **[P2]**

### 1.6 Recap — `features/recap/recap_screen.dart`
**Bom**
- Card 9:16 com gradiente cobalt-verde, número gigante, fileira de espécies, streak + footer — **ótimo para share**. Render via `RepaintBoundary` @3x: correto.
- Empty dedicado.

**Melhorar**
- **Card não tem entrada/reveal** quando abre (poderia montar com número fazendo count-up + árvores brotando em stagger). **[P1]**
- **Gradiente hardcoded** (`0xFF34855A`/`0xFF1C4A33`) fora dos tokens — extrair pra `tokens.json` (`gradient.recap`). **[P1]**
- Texto do hero é montado com `replaceFirst('$count ', '')` — frágil em i18n (quebra se a string não começar com o número, ex.: pt "X árvores"). Refatorar com chave dedicada (ver COPY_REVISION). **[P1]**
- Estados de share (sucesso/falha) são silenciosos — um toast/haptic leve confirmaria. **[P2]**

### 1.7 Paywall — `features/paywall/paywall_screen.dart`
**Bom**
- **Honesto:** comparativo Free vs Premium real, trial claro, "Continue with Free" visível, nunca mostra preço falso (`pwPriceTbd`). Sem dark patterns. Excelente postura.
- Toggle anual/mensal com badge "Save 40%".

**Melhorar**
- **Sem hierarquia visual no plano premium:** a coluna Premium poderia ter um leve realce (fundo/sombra) pra ancorar. **[P1]**
- **Linhas do comparativo entram secas;** um stagger curto ajuda a ler. **[P2]**
- Watermark `Align.topCenter` 320 atrás do título — ok, mas garantir que não reduza contraste do headline. **[P2]**
- CTA poderia ter leve shimmer/respiração (sem ser agressivo) pra diferenciar do tonal. **[P2]**

### 1.8 Profile — `features/profile/profile_screen.dart`
**Bom**
- Identidade + stats vitalícios + linhas de ajuste organizadas. Dark mode lê bem (screenshot `p-dark`).
- Theme sheet funcional.

**Melhorar**
- **Avatar "G" genérico** — pode ser a árvore-favorita do usuário ou um seed-avatar. **[P2]**
- **Linhas sem ícone-cor / divisores** ficam um pouco monótonas; agrupar em cards/seções daria ritmo. **[P2]**
- Stats poderiam ter o mesmo count-up do Garden (consistência). **[P2]**
- Versão "v1.0.0" hardcoded na tela (string montada) — ok, mas idealmente do package_info. **[P2 / técnico]**

### 1.9 Shared / Sistema — `shared/widgets/*`, `core/theme/*`
**Bom**
- `grovely_components.dart` centraliza StreakBadge/StatPill/DurationDial/TimerRing/SymbolWatermark — boa base de DS.
- `main_shell.dart` esconde nav no running — correto.
- Tema M3 com fontes corretas (Bricolage display + Hanken body).

**Melhorar**
- **`feature_scaffold.dart` é placeholder morto** (Fase 0) — confirmar se ainda referenciado; se não, remover pra não confundir. **[P2]**
- **Tema não define motion, elevação, nem spacing scale** — tudo é número solto nas telas (24/18/16/12/8 repetidos à mão). Centralizar (ver §3). **[P0 p/ motion, P1 p/ spacing/elevação]**
- **`shared/widgets/grovely_logo.dart`** não revisado em detalhe aqui, mas garantir que entre no inventário do DS.

---

## 2. Melhorias visuais (transversais)

| Item | Detalhe | Prioridade | Escopo (replicar em) |
|------|---------|-----------|----------------------|
| Elevação real | Cards hoje = `border: outline 1px`, sem sombra → chapados. Definir 2–3 níveis de sombra suave (verde-acinzentada, baixa opacidade) e aplicar a todo "card de superfície". | P1 | garden, circle, league, profile, paywall |
| Spacing scale | Padronizar 4/8/12/16/20/24/32 como tokens (`GrovelySpacing`) e parar de hardcodar. | P1 | todas |
| Hierarquia de cor | `accent` (âmbar) é "sol/streak/conquista" — usar com parcimônia e consistência (hoje aparece em botão tonal do circle como CTA secundário cheio, o que rouba atenção). Definir papel: accent = celebração, nunca CTA neutro. | P1 | circle (botão Join), league, badges |
| Empty states | Garden é o padrão-ouro (ícone/heró + título + sub + CTA). Circle/League/Recap variam de forma. Unificar template `GrovelyEmpty(symbol, title, body, cta?)`. | P1 | circle, league, recap, garden |
| Loading states | Garden tem skeleton; Circle/League usam spinner cru. Unificar skeleton shimmer. | P1 | circle, league |
| Error states | Garden tem retry; Circle engole erro no empty; League mostra texto cru. Unificar `GrovelyError(onRetry)`. | P1 | circle, league |
| Watermark disciplinado | Definir: opacidade (claro 0.05 / escuro 0.07), tamanho relativo, e **nunca** sobrepor nav/listas/CTA. Hoje vaza atrás da bottom nav (welcome, league) e atrás de botões. | P2 | grovely_components + todas que usam |
| Tree↔container ratio | Padronizar tamanhos de árvore por contexto (hero 220, running cresce 120→200, tile 80, recap 44) como constantes. | P1 | tree_view, focus, garden, recap |
| Contraste de dots/track | Dots inativos e tracks usam `outline` (baixo no claro). Definir token de "track". | P2 | onboarding, timer ring |

---

## 3. Design System — gaps a preencher

O DS atual (`tokens.json` + `app_colors.dart` + `app_theme.dart`) cobre **cor,
tipo e radius**. Faltam **motion, elevação, spacing e componentes**. Proposta:

### 3.1 `tokens.json` — adicionar
```jsonc
"motion": {
  "duration": { "instant": 0, "fast": 120, "base": 220, "slow": 360, "grand": 600 },
  "easing": {
    "standard":  [0.2, 0, 0, 1],     // entradas/saídas padrão (M3 emphasized-ish)
    "decelerate":[0, 0, 0, 1],       // algo entrando e parando
    "accelerate":[0.3, 0, 1, 1],     // algo saindo
    "emphasized":[0.2, 0, 0, 1]
  },
  "spring": {
    "tree":   { "mass": 1, "stiffness": 180, "damping": 16 }, // crescimento
    "press":  { "mass": 1, "stiffness": 500, "damping": 28 }, // tap feedback
    "settle": { "mass": 1, "stiffness": 120, "damping": 14 }  // bounce de chegada
  }
},
"elevation": {
  "level0": { "y": 0, "blur": 0,  "alpha": 0 },
  "level1": { "y": 1, "blur": 3,  "alpha": 0.06 },
  "level2": { "y": 4, "blur": 12, "alpha": 0.10 },
  "level3": { "y": 8, "blur": 24, "alpha": 0.14 }
},
"space": { "xs": 4, "sm": 8, "md": 12, "lg": 16, "xl": 20, "2xl": 24, "3xl": 32 },
"gradient": {
  "recap": ["#34855A", "#1C4A33"],
  "focusWarmLight": ["#FFFFFF", "#F6ECD9"],
  "focusWarmDark":  ["#16221C", "#3A2F1C"]
}
```

### 3.2 `app_theme.dart` — adicionar classes (espelhando AppRadius)
- `GrovelyMotion` — `Duration` + `Curve` + helpers de `SpringDescription` (consumidos pelas animações; ver §4).
- `GrovelySpacing` — `xs…xxxl` (encerra os números soltos).
- `GrovelyElevation` — `List<BoxShadow>` por nível (claro/escuro).
- Reduzir-motion: um `bool reduceMotion = MediaQuery.disableAnimationsOf(context)` lido num único helper `GrovelyMotion.effective(context, …)` que zera durações/desativa springs quando true.

### 3.3 `brand-book.html` — documentar
- Página "Motion": durações, curvas, springs, princípios (calmo, orgânico, nunca brusco), exemplos do crescimento/anel/confete.
- Página "Elevation" e "Spacing".
- Atualizar inventário de componentes (abaixo).

### 3.4 Componentes do DS — faltando / a formalizar
| Componente | Estado | Ação |
|-----------|--------|------|
| `GrovelyEmpty` | ad-hoc por tela | criar componente único |
| `GrovelyError` | só no garden | promover a componente |
| `GrovelySkeleton` (shimmer) | só garden, sem shimmer | criar com shimmer |
| `GrovelyCard` (superfície + elevação + press) | inline em 4 telas | criar |
| `PressableScale` (wrapper tap-feedback) | inexistente | criar (usa spring.press + haptic) |
| `LeafConfetti` | inexistente | criar (completed/recap/goal) |
| `AnimatedCounter` (count-up) | inexistente | criar (stats) |
| `PodiumRow` | inline | formalizar com tiers |

---

## 4. Motion & micro-interações (Flutter)

### Recomendação sobre `flutter_animate`: **SIM, adicionar.**
**Por quê:** o app precisa de muitas entradas encadeadas/staggered, fades e
escalas declarativas (listas, empty states, reveals de card, pills). Fazer isso
à mão com `AnimationController` repetido em ~8 telas é caro e inconsistente.
`flutter_animate` cobre 80% (entradas, stagger, shimmer, fade/scale/slide) em
1 linha e mantém o estilo uniforme.

**Onde NÃO usá-lo (manter explícito/custom):**
- **TimerRing sweep** — precisa de `AnimationController` próprio interpolando o progresso entre ticks (lógica de timer, não decorativa).
- **Crescimento da árvore com spring** — usar `AnimationController` + `SpringSimulation` (ou `flutter_animate` só pro cross-fade dos estágios; a escala física fica melhor explícita).
- **Hero** — API nativa do Flutter (`Hero`/`PageRoute`), não é do pacote.
- **Confete de folhas** — custom painter / partículas (pode-se usar `flutter_animate` pra orquestrar opacidade/translate dos sprites, mas a coreografia é custom).

**Reduce-motion (obrigatório, transversal):** todo efeito deve checar
`MediaQuery.disableAnimationsOf(context)` (ou `MediaQuery.of(context).disableAnimations`).
Quando `true`: sem confete, sem spring/bounce, durações → 0/`instant`,
trocas viram corte/cross-fade instantâneo. Centralizar no helper `GrovelyMotion`.

### Lista concreta de animações a adicionar

| # | Animação | Abordagem Flutter | Duração / Easing | Reduce-motion | Prio | Arquivos |
|---|----------|-------------------|------------------|---------------|------|----------|
| M1 | **Sweep contínuo do anel** | `AnimationController` (1 ciclo = totalSeconds) OU tween entre `progress` a cada tick com `TweenAnimationBuilder(duration: 1s, curve: linear)` envolvendo o `CustomPaint` | linear, contínuo | sem tween → set direto | **P0** | `grovely_components.dart` (TimerRing), `focus_session_screen.dart` |
| M2 | **Ponta viva do anel** (dot + leve glow na cabeça do arco) | desenhar no `_RingPainter` na posição do ângulo atual; pulsar opacidade com controller | respiração 1200ms ease-in-out | sem pulso (dot estático) | P0 | `grovely_components.dart` |
| M3 | **Árvore cresce com a sessão** (escala 0.6→1.0 ligada a `progress`, não só troca de estágio) | `AnimatedBuilder` mapeando `progress`→`scale`; cross-fade de estágio via `AnimatedSwitcher` | spring `tree` p/ trocas de estágio | escala segue progress sem spring; trocas = corte | **P0** | `tree_view.dart`, `focus_session_screen.dart` |
| M4 | **Bounce/settle na conclusão** | `AnimationController` one-shot com `SpringSimulation(spring.settle)` na árvore ao entrar em `completed` (Hero chega e "assenta") | ~600ms spring | sem bounce | **P0** | `focus_session_screen.dart` (_Completed) |
| M5 | **Confete de folhas** no completed (e goal do circle, e recap) | `LeafConfetti` custom (partículas SVG de folha caindo/espalhando); orquestra com `flutter_animate` ou controller | 900–1400ms, decelerate | **não renderiza** | **P0** | novo `shared/widgets/leaf_confetti.dart`, usado em focus/circle/recap |
| M6 | **Haptics** | `HapticFeedback` (`flutter/services`): `selectionClick` no DurationDial/toggle/tab; `mediumImpact` no start; `heavyImpact`+sucesso no completed; `lightImpact` no wither | — | respeitar config de sistema (já é) | P1 | focus, paywall, garden, components |
| M7 | **Hero da árvore** selecting → running → completed → garden tile | `Hero(tag: 'tree-<sessionId>')` no `TreeView`; tags estáveis por sessão/árvore | transição de rota padrão (300ms) | Hero é ok com reduce-motion (sem bounce extra) | **P0** | `tree_view.dart`, `focus_session_screen.dart`, `garden_screen.dart` |
| M8 | **Transição de passos do onboarding** (slide+fade direcional) | `PageView` OU `AnimatedSwitcher` com `SlideTransition` + `FadeTransition`, direção pelo sentido | base (220ms) standard | fade simples instantâneo | P1 | `onboarding_screen.dart` |
| M9 | **Entrada encadeada de tela** (título→sub→conteúdo→CTA) | `flutter_animate` `.animate().fadeIn().slideY()` com `.interval`/delay incremental | fast→base, decelerate | sem efeito (aparece pronto) | P1 | welcome, empty states, completed, paywall, recap |
| M10 | **Staggered list reveal** (garden grid, league rows, members) | `flutter_animate` em itens com `delay: (i * 40ms).ms` | 40ms/item, fade+slideY 8px | sem stagger | P1 | garden, league, circle |
| M11 | **Press state** (scale 0.97 + haptic leve) em cards/tiles/choice custom | `PressableScale` (GestureDetector + `AnimatedScale`/spring.press) | 120ms, spring press | sem scale (só ripple/none) | P1 | garden tiles, onboarding choice, circle CTAs |
| M12 | **Fundo "amanhecer" do running** (já existe lerp; suavizar + opcional partículas leves) | manter `Color.lerp`; opcional sol subindo/raios bem sutis com controller lento | muito lento (toda a sessão) | manter cor estática final | P2 | `focus_session_screen.dart` |
| M13 | **Shimmer no skeleton** | `flutter_animate` `.shimmer()` nos boxes | 1200ms loop | sem shimmer (cinza estático) | P2 | garden, circle, league skeletons |
| M14 | **Count-up de stats** | `AnimatedCounter` (`TweenAnimationBuilder<int>`) | base, decelerate | set direto | P2 | garden, profile, recap |
| M15 | **Murcha suave** (folhas caindo devagar + dessaturar) | `AnimatedSwitcher`/controller no `TreeView` quando vira `withered` | slow (360–600ms), decelerate | corte para o estágio withered | P1 | `tree_view.dart`, focus _Withered |
| M16 | **Meta do círculo "enche e celebra"** | `LinearProgressIndicator` animado (já anima) + ao chegar 100%, M5 confete + haptic | progress anima 600ms | sem confete | P2 | `circle_screen.dart` |
| M17 | **Nav bar: ícone selecionado com leve pop** | `AnimatedScale`/`flutter_animate` no selectedIcon | fast | sem pop | P2 | `main_shell.dart` |

**Princípios de motion (do motion-dev / craft):**
- **Orgânico, nunca mecânico:** árvore/folhas com spring e leve overshoot; UI com easing standard.
- **Rápido pra confirmar, lento pra encantar:** feedback de toque ≤120ms; momentos-herói (crescer/colher) 400–1000ms.
- **Coreografia, não simultaneidade:** elementos entram em sequência (stagger 40–60ms), não todos juntos.
- **Calmo:** nada pisca/treme; respiração e fades preferidos a bounces agressivos (exceto o "colher", que pode celebrar).

---

## 5. Checklist de replicação (transversal — aplicar em TODOS os arquivos)

Ao implementar, cada tela/PR deve cumprir:

- [ ] **Sem números soltos de spacing** — usar `GrovelySpacing.*`.
- [ ] **Sem `Duration`/`Curve` literais em animação** — usar `GrovelyMotion.*`.
- [ ] **Sem cor/gradiente hardcoded** — tudo via `AppColors`/tokens (`gradient.recap`, `focusWarm*`).
- [ ] **Toda animação checa reduce-motion** via `GrovelyMotion.effective(context, …)`.
- [ ] **Todo card de superfície** usa `GrovelyCard` (elevação + radius + press quando tappável), não `Container+border` ad-hoc.
- [ ] **Todo estado assíncrono** expõe os três: data / **skeleton shimmer** / **erro com retry** (padrão do Garden).
- [ ] **Todo empty** usa `GrovelyEmpty(symbol/icon, title, body, cta?)`.
- [ ] **Todo elemento tappável custom** tem press state (`PressableScale`) + haptic leve.
- [ ] **Toda lista** ≥3 itens entra com staggered reveal (40–60ms/item).
- [ ] **Watermark** só em momento-herói; nunca atrás de nav/lista/CTA; opacidade e tamanho dos tokens.
- [ ] **Árvore** sempre via `TreeView` com tamanho-token por contexto e Hero tag estável quando transita entre telas.
- [ ] **Cópia gentil no fracasso** (withered/erro) — nunca culpar; sempre oferecer próximo passo (ver COPY_REVISION).
- [ ] **`accent` (âmbar)** só para celebração/streak/conquista — nunca CTA neutro.
- [ ] **i18n intacto** — sem texto hardcoded, sem montar string com `replaceFirst`.

---

## 6. Notas de implementação / pendências cruzadas
- `feature_scaffold.dart` parece resíduo da Fase 0 — verificar uso e remover.
- Recap monta hero com `replaceFirst` → criar chave i18n dedicada (COPY_REVISION).
- Gradiente do Recap e do running → tokens.
- `package_info` para versão no Profile (hoje hardcoded).
- Revive depende de rewarded ad real (Agente D) — manter o sheet honesto enquanto isso.
