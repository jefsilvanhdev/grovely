# App Review V6 — Modo populado (Plus · círculo 8 membros · 23 árvores)

**Data:** 2026-07-03 · **Base:** `screens-demo-v6/` (build com `demoSeedOverrides`) vs mockups `Plantio-V2/brand/mockups/` + código de `lib/features/`.
**Escopo:** os dois pedidos do Jeff (estado de assinante + Liga × Círculo) e achados que só aparecem com dados reais. Não repete o APP_REVIEW_V6.md.

**Nota de captura:** `circle.png` capturou a página 3 do onboarding ("Focus your way"), não a aba Círculo. A análise do Círculo abaixo foi feita por código (`circle_screen.dart`) + demo seed. Recapturar antes de usar o pacote em loja/pitch.

---

## 1. Subscription / estado Plus

### Diagnóstico

Hoje o Profile trata assinatura como uma linha de ajustes (`_Row` → `context.go('/paywall')`, `profile_screen.dart:107-111`). Isso produz dois erros com usuário Plus:

1. **Assinante cai em paywall de venda.** Toca em "Subscription: Grovely Plus ›" e recebe "Try free for 21 days" + toggle de plano — a tela oferece comprar o que ele já tem. Quebra confiança e viola política do Play (fluxo de gestão de assinatura precisa existir).
2. **O plano não é celebrado nem gerenciável.** Plus é o produto inteiro do negócio e no Profile tem o mesmo peso visual de "Appearance". Não há: desde quando é membro, o que está desbloqueado, quando renova, como cancela.

Agravante: o assinante se chama **"Guest"** (avatar "G"). Pagante anônimo é dissonância forte — ver achado P0-2 na seção 3.

### Proposta — modelo de estados

Um provider único de entitlement alimenta Profile e o guard do paywall. Sketch (Riverpod, mesmo padrão de `circle_provider.dart`):

```dart
enum PlanStatus { free, trial, plus }

class Entitlement {
  const Entitlement(this.status, {this.trialDaysLeft, this.renewsAt, this.isAnnual});
  final PlanStatus status;
  final int? trialDaysLeft;   // trial
  final DateTime? renewsAt;   // plus
  final bool? isAnnual;       // plus
  static const free = Entitlement(PlanStatus.free);
}

/// Hoje: stub (free) + override no demo_seed. Depois: RevenueCat CustomerInfo.
final entitlementProvider = Provider<Entitlement>((ref) => Entitlement.free);
```

Adicionar ao `demo_seed.dart`: `entitlementProvider.overrideWithValue(Entitlement(PlanStatus.plus, renewsAt: ..., isAnnual: true))` — assim o modo populado exercita o estado que o screenshot fingiu ter.

### Proposta — Profile por estado

A `_Row` de Subscription morre. No lugar, um **card de plano** entre o card "All time" e as rows de ajustes — mesma `grovelyCard(context)`, sem componente novo além de conteúdo.

**Estado `plus` (o pedido do Jeff):**

```
┌─────────────────────────────────────────────┐
│ [marca 28px]  GROVELY PLUS        ● Ativo   │  ← overline caps primary,
│                                              │    como circleGroveOverline
│ Membro desde jun 2026 · Renova 12 jul       │  bodySmall onSurfaceVariant
│                                              │
│ (✓ Todos os círculos) (✓ Todas as espécies) │  StatPills existentes,
│ (✓ Temas) (✓ Stats avançadas)               │  icon check, Wrap 8/8
│                                              │
│ Gerenciar assinatura                      ›  │  TextButton → Play Store
└─────────────────────────────────────────────┘
```

- **Fundo:** o mesmo gradiente do card do bosque (`primaryContainer` α0.45 → `surface`, `circle_screen.dart:290-299`). É o tratamento "momento especial" que o app já tem; reusar cria linguagem: gradiente mint = coisa viva/conquistada.
- **Badge "Ativo":** dot 6px `treeHealthy` + label — não inventar cor nova.
- **Benefícios:** `StatPill` com `Icons.check` — lista literalmente o que a coluna Premium do paywall promete, agora no pretérito ("desbloqueado"). Fecha o loop da venda.
- **"Gerenciar assinatura":** abre a gestão nativa via `url_launcher`:
  `https://play.google.com/store/account/subscriptions?sku=<sku>&package=<pkg>` (Android; no iOS, `showManageSubscriptions` do StoreKit quando existir build iOS). **Nunca** o `/paywall`. Cancelamento é do sistema — não construir fluxo próprio de cancelamento no MVP.
- **Badge no avatar (opcional, barato):** anel de 2px `accent` no `CircleAvatar` da identidade + mini selo "PLUS" pill (accent α0.18, como o `StreakBadge`). Celebração discreta, on-brand — sem coroas/dourados genéricos.

**Estado `trial`:**

```
┌─────────────────────────────────────────────┐
│ [marca 28px]  GROVELY PLUS      ◔ Teste     │
│                                              │
│ 5 dias restantes do teste grátis            │  titleMedium
│ Depois, R$ X/ano — cancele quando quiser    │  bodySmall (preço só com
│                                              │   RevenueCat; sem preço,
│ Gerenciar assinatura                      ›  │   omitir a linha)
└─────────────────────────────────────────────┘
```

Mesmo card, badge âmbar (`accent`) em vez de verde. Sem contagem alarmista — o paywall já promete lembrete 2 dias antes; o card só informa.

**Estado `free`:** mantém uma row, mas como **upsell honesto**, não ajuste:

```
│ ✦ Conheça o Grovely Plus         Grátis  ›  │  → /paywall (aí sim)
```

Row com ícone `workspace_premium_outlined` tingido `accent` para diferenciar de Notifications/Appearance. Só o estado free navega para o paywall.

**Guard de rota:** em `/paywall` (GoRouter `redirect` ou no `build`): se `entitlement.status != free`, redirecionar ao Profile (ou mostrar variante "você já é Plus" com botão Gerenciar). Isso cobre deep links, notificações antigas e o funil de onboarding de quem restaurou compra.

### Copy (chaves .arb novas)

| chave | pt | en |
|---|---|---|
| `planPlusOverline` | GROVELY PLUS | GROVELY PLUS |
| `planActiveBadge` | Ativo | Active |
| `planTrialBadge` | Teste | Trial |
| `planMemberSince` | Membro desde {date} | Member since {date} |
| `planRenews` | Renova em {date} | Renews {date} |
| `planTrialDaysLeft` | {n, plural, one{1 dia restante do teste} other{{n} dias restantes do teste}} | {n, plural, one{1 day left in your trial} other{{n} days left in your trial}} |
| `planManage` | Gerenciar assinatura | Manage subscription |
| `planBenefitCircles` | Todos os círculos | All circles |
| `planBenefitSpecies` | Todas as espécies | Every species |
| `planBenefitThemes` | Temas de jardim | Garden themes |
| `planBenefitStats` | Stats avançadas | Deep-focus stats |
| `planFreeUpsell` | Conheça o Grovely Plus | Meet Grovely Plus |
| `pwAlreadyPlus` | Você já é Plus — tudo desbloqueado. | You're already Plus — everything's unlocked. |

Tom: mesmo do resto do app — calmo, sem exclamação, sem "parabéns!!". A celebração é visual (gradiente, selo), não verbal.

---

## 2. Liga × Círculo

### Diagnóstico da redundância

Com o círculo populado, as duas abas são a mesma consulta com roupa diferente — ambas leem `circleMembersProvider` e listam os mesmos 8 nomes com o mesmo `weeklyTrees`:

- **Círculo** (`circle_screen.dart:349-372`): lista de membros ordenada como veio, trailing "N this week".
- **Liga** (`league_screen.dart:50-58`): a mesma lista com medalha nas posições 1–3 e highlight no "You".

Ou seja: a Liga hoje é o Círculo ordenado. O usuário abre duas abas e aprende uma informação. Pior: o Círculo, que deveria ser cooperativo, já exibe contagem individual por membro — ranking implícito — então a Liga não adiciona nem a competição. E o mockup 03 mostra a intenção original correta: **liga = círculos competindo entre si** ("Morning Sprinters 412 min · Library Owls 389 · Deep Divers 351").

### Separação conceitual

| | **Círculo — "nós"** | **Liga — "nós contra eles"** |
|---|---|---|
| Unidade | pessoas dentro do meu círculo | círculos entre si |
| Emoção | pertencimento, meta comum | competição, orgulho de time |
| Métrica | bosque coletivo da semana (soma) | posição no ranking semanal |
| Pergunta que responde | "como estamos indo juntos?" | "estamos ganhando?" |
| Números individuais | contribuição (sem ranking) | só o agregado do círculo |

Regra dura que resolve a redundância: **número individual comparativo aparece em no máximo um lugar.** Decisão: a comparação individual sai da aba Círculo (vira contribuição visual) e a Liga passa a comparar times. No intervalo em que a liga entre círculos não existe (Fase A), a Liga mantém o ranking individual — mas vestido de competição de verdade, e o Círculo já se despe dele.

### Fase A — só com dados atuais (`MemberStat` + relógio do cliente). Implementável já.

**Círculo (Fase A)** — remove o ranking implícito, reforça cooperação:

```
┌ Sprint da Manhã ─────────────────── ⤴ ⋮ ┐
│ Código: GRV4TA                            │
│                                           │
│ ┌ BOSQUE COMPARTILHADO · ESTA SEMANA ───┐ │
│ │ Meta batida! 40 árvores 🎉            │ │  ← ver P1-3: linha de
│ │ [🌳🌸🌲🌳🌿🌲 ...até 12] +28          │ │    árvores legível, não 36
│ │ ▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓▓ 40/40           │ │    brotos de 22px
│ └───────────────────────────────────────┘ │
│                                           │
│ Quem plantou esta semana                  │
│ (J) Jeff      🌳🌳🌳🌳🌳🌳🌳🌳🌳🌳        │  ← contribuição como
│ (N) Nicole    🌳🌳🌳🌳🌳🌳🌳🌳            │    ícones (park 14px),
│ (M) Marina    🌳🌳🌳🌳🌳🌳🌳              │    NÃO "7 this week";
│ (R) Rafael    🌳🌳🌳🌳🌳                  │    >12 vira "🌳 ×15"
│ ...ordem: quem plantou mais recente*      │
└───────────────────────────────────────────┘
```

Mudanças concretas em `circle_screen.dart`:
1. `ListTile.trailing` deixa de ser `memberWeekly(m.weeklyTrees)` texto e vira `Row` de `Icon(Icons.park, size: 14, color: treeHealthy)` × `weeklyTrees` (cap 12; acima disso, um ícone + "×N"). O número não some — a **moldura de ranking** some. Ícones somam ao bosque visualmente; números convidam a comparar.
2. Barra de progresso da meta (`LinearProgressIndicator` minHeight 6, `borderRadius` 999) sob o bosque — a meta hoje é só texto.
3. *Ordenação: `weeklyTrees` continua sendo o único dado; ordenar por ele é reintroduzir ranking. Enquanto não houver `lastPlantedAt` no RPC, ordem estável de entrada no círculo (como vem) está ok — é neutra.
4. Botões Criar/Entrar em outro círculo não entram aqui; multi-círculo é Plus e é outra conversa.

**Liga (Fase A)** — mesmos dados, tela de competição de verdade:

```
┌ Liga ─────────────────────────────────────┐
│ LIGA DA SEMANA          ⏳ termina em 2d 5h│  ← countdown p/ dom 23:59
│                                            │    local, computado no client
│        ┌──────┐                            │
│  ┌─────┤ 🥇 J ├─────┐                      │  Pódio: 3 avatares em
│  │ 🥈 N │ Jeff │ 🥉 M│                      │  alturas 64/80/56, nome +
│  │Nicole│  10  │Marina                     │  score. Bricolage no número.
│  │  8   │      │  7  │                      │
│  └──────┴──────┴─────┘                      │
│                                            │
│ ┌ VOCÊ ─────────────────────────────────┐  │
│ │ 1º lugar · 10 árvores                 │  │  ← card "isYou" destacado
│ │ Nicole está a 2 árvores de você 🔥    │  │    (primaryContainer);
│ └───────────────────────────────────────┘  │    delta p/ vizinho de cima
│                                            │    ou de baixo
│ 4  (R) Rafael                    5 árvores │
│ 5  (T) Théo                      4 árvores │
│ ...                                        │
└────────────────────────────────────────────┘
```

Tudo derivável do que já existe:
1. **Countdown**: `nextMonday00 = ...; remaining = nextMonday00.difference(now)` — texto "termina em Xd Yh". Dá urgência e explica que a liga zera (hoje nada diz que é semanal além do título).
2. **Pódio top-3**: substitui as 3 primeiras `_RankRow` por um bloco hero. As cores de medalha já existem (`_RankMedal`). Avatar 40/48/36px conforme posição.
3. **Card "Você"**: sticky mental — posição + score + **delta**: se não é 1º, "Faltam N para passar {nome}"; se é 1º, "{nome} está a N de você". Uma linha, computada da lista ordenada. É o que transforma leitura passiva em meta acionável.
4. **Unidade no score**: "10 this week" não diz 10 de quê (achado P2-3). Trocar `memberWeekly` na Liga por `leagueScore(n)` = "{n} árvores / trees".
5. Ranking individual continua aqui **até a Fase B existir** — aí ele morre de vez, porque o Círculo já cobre "quem plantou".

Sem RPC nova, sem tabela nova. Estimativa: 1 tela refeita + 3 strings.

**Empate:** desempate estável por ordem de chegada ao score (não temos timestamp — aceitar empate visual: mesmo rank, "1º" duplicado é ok no MVP).

### Fase B — liga entre círculos (mockup 03). Precisa de backend.

**Conceito:** o círculo é o time; a liga é a divisão onde o time joga. Coopero dentro, competimos fora — o loop social do Duolingo, mas por equipes, que é mais defensável (pressão social positiva: "não deixa o círculo cair").

**B1 — ranking simples de círculos (1 RPC):**

```sql
-- league_standings(): soma weekly_trees por círculo, retorna a janela
-- do meu círculo (ex.: 10 vizinhos) + minha posição global.
select c.id, c.name, count(t.*) as weekly_trees,
       count(distinct t.user_id) as active_members
from circles c join trees t on ... where t.week = current_week
group by c.id order by weekly_trees desc;
```

Normalização a decidir com dados reais: círculo de 12 vence círculo de 6 por tamanho; opções: (a) média por membro ativo, (b) buckets por tamanho, (c) aceitar no B1 e resolver no B2. Recomendo (a) exibindo as duas colunas — soma dá orgulho, média dá justiça.

```
┌ Liga ──────────────────────────────────────┐
│ DIVISÃO BOSQUE 🌳        ⏳ termina em 2d 5h│
│                                             │
│ 1  Morning Sprinters              412 🌳    │
│ 2  Library Owls                   389 🌳    │
│ ┌───────────────────────────────────────┐   │
│ │3  Sprint da Manhã (seu círculo) 351 🌳│   │  ← primaryContainer
│ │   Faltam 38 árvores p/ alcançar Owls  │   │
│ └───────────────────────────────────────┘   │
│ 4  Deep Divers                    340 🌳    │
│ ...10 círculos por divisão                  │
│                                             │
│ Sua contribuição: 10 de 351 · [ver círculo]│  ← link p/ aba Círculo:
└─────────────────────────────────────────────┘    é lá que se "joga"
```

**B2 — divisões + promoção/rebaixamento (Duolingo por times):**
- Tiers com nomes botânicos da marca (já temos a escada de estágios!): **Broto → Muda → Bosque → Floresta → Sequoia** (Sprout → Sapling → Grove → Forest → Sequoia). Reusa a iconografia dos estágios de árvore — zero asset novo.
- Coortes de ~10 círculos por divisão, sorteadas na segunda-feira; top-2 sobe, bottom-2 desce. Job semanal (cron Supabase) + tabelas `league_cohorts`, `league_results`.
- Recap semanal ganha a linha "Seu círculo terminou em 3º na Divisão Bosque" — combustível de share.
- Liga entre círculos é feature Plus-adjacente ("weekly leagues" já está na tabela do paywall) — decidir se free vê a divisão e Plus vê histórico/stats, ou liga toda gated. Recomendo liga visível a todos (é o motor de retenção/virada social) e **histórico** de temporadas como Plus.

**Sequência:** Fase A agora (destrava screenshots de loja e diferencia as abas) → B1 quando houver ≥ ~20 círculos reais (com menos, o ranking global fica vazio e desmoraliza) → B2 quando houver massa para coortes.

---

## 3. Achados do modo populado (P0/P1/P2)

Coisas que só apareceram com 23 árvores / 8 membros / Plus. Não repete o review anterior.

**P0-1 · Assinante → paywall de venda** (Profile). Coberto na seção 1. É bug de produto, não polish.

**P0-2 · "Guest" pagante** (Profile). Usuário Plus com streak de 6 dias chamado "Guest" com avatar "G". Enquanto o auth real não vem, permitir **nome local** (TextField no Profile, salvo em prefs, alimenta `display_name` do círculo). O nome já é público no círculo — o app já tem o conceito; só falta o dono editá-lo. Sem isso, o círculo demo mostra "Jeff" para os outros e "Guest" para si.

**P1-1 · Stagger do jardim escala com o acervo** (`garden_screen.dart:117-119`). `staggerIn(context, i)` com delay `i*45ms`: com 24 tiles, o último entra ~1.1s depois, e a onda roda **a cada visita** à aba. Com 100 árvores, 4.5s de tiles pipocando. Fix: `staggerIn(context, i.clamp(0, 10))` (onda máx ~450ms) e idealmente animar só na primeira build da sessão. Mesmo fix vale para a lista de membros do círculo.

**P1-2 · Tile "+" invisível no jardim cheio** (garden). Com 23 árvores o slot "plant more" é o 24º item — abaixo da dobra. Com jardim populado, o CTA de plantar não existe visualmente. Fix: com `trees.length >= 9` (3 fileiras), mover o "+" para **primeiro** slot e ordenar árvores da mais recente para a mais antiga (a recente é a que o usuário quer rever; hoje a ordem enterra a árvore nova no fundo). Com < 9, manter como está (match do mockup 02).

**P1-3 · Card do bosque vira mingau com meta 40** (`circle_screen.dart:322-344`). 8 membros ⇒ meta 40 ⇒ `goal.clamp(0,36)` renderiza **36 TreeViews de 22px** num Wrap. A Illustration 2.0 (copa dupla, highlight, acento) vira ruído nessa escala — e o clamp silencioso mente: mostra 36 células para meta 40. Fix (wireframe na seção 2): máx **12** árvores de 28–32px (tamanho onde a ilustração ainda respira) + chip "+28" + `LinearProgressIndicator` como portador real do número. Bônus: a espécie é `TreeType.values[i % 6]` — sequência repetida (oak, pine, bush, willow, birch, cherry, oak…) que parece papel de parede; usar as espécies **realmente plantadas** na semana quando o dado existir, ou ao menos hash pseudo-aleatório estável (`(i * 7 + 3) % 6`).

**P1-4 · Oito avatares idênticos** (circle + league). Todos os `CircleAvatar` usam a mesma cor (`primaryContainer` no círculo, `surfaceContainerHighest` na liga — nem entre si batem). Com 8 membros, a lista é uma coluna de bolinhas mint iguais; J/N/M/R não criam identidade. Fix: cor determinística por pessoa — `palette[userId.hashCode % 6]` sobre 6 tons derivados da marca (mint, sage, âmbar α0.25, blossom α0.25, primaryContainer, secondaryContainer), texto no par `on*` correspondente. Um helper `avatarColor(context, userId)` em `grovely_components.dart`, usado nas duas telas (consistência: a mesma pessoa tem a mesma cor em toda parte).

**P1-5 · Demo seed não exercita o "You"** (league). `_RankRow.isYou` compara com `SupabaseService.currentUserId`, que no demo não é `u1`…`u8` — o highlight e o label "You" nunca renderizam (confirmado no league.png: nenhuma linha destacada). O modo populado existe para ver estados; está escondendo um. Fix no `demo_seed.dart`: usar o uid real da sessão no primeiro `MemberStat`, ou expor um `demoCurrentUserId` que a tela consulte via provider (não tocar no serviço real).

**P2-1 · Recap: número × ilustração divergem** (recap.png). "8 trees this week" com 6 mini-árvores desenhadas. Se a fileira é amostra de espécies, tudo bem — mas 8 vs 6 lê como bug. Fix barato: renderizar `min(n, 6)` árvores + "+2"; ou legenda "6 espécies".

**P2-2 · Profile mostra "Best: 6 days" com streak atual de 6** (profile.png). O jardim já tem a regra "esconder recorde quando `longest == current`" (`garden_screen.dart:92`); o Profile não a aplica — mesma informação duas vezes a 40px de distância (badge streak + pill Best). Aplicar a mesma regra no bloco All time.

**P2-3 · "10 this week" sem unidade** (league.png). Dez o quê? O mockup 03 usa minutos, o app usa árvores. Com dados populados a ambiguidade fica visível (Jeff: 10 árvores mas 15h focadas — qual número manda?). Fix: unidade explícita na Liga (`leagueScore`: "{n} árvores/trees") — coberto na Fase A.

**P2-4 · Ícone de share duplicado com significados diferentes.** No jardim, `ios_share` no AppBar = recap semanal; no círculo, o mesmo ícone = convidar membro. Com as duas abas cheias, o mesmo glifo faz duas coisas. Trocar o convite do círculo por `person_add_alt` (mantém `SharePlus` por trás).

**P2-5 · Código de convite sempre exposto** (circle). "Código: GRV4TA" em texto plano permanente sob o título. Com o círculo cheio (8/12), o código é informação de baixa frequência. Mover para dentro do fluxo de convite (sheet: código grande + botão copiar + share) e tirar da tela principal — reduz uma linha de ruído e protege contra screenshot vazando o código.

---

## 4. O que está forte — não mexer

1. **A sensação de acervo no jardim.** 23 árvores em grid 3col com a Illustration 2.0 é exatamente o "quero encher isso" do Forest — as espécies variadas + cherry blossom rosa quebram a monotonia. Só corrigir ordem/stagger (P1-1/P1-2); a densidade em si está certa.
2. **Header card do jardim** (23 trees + streak + pills condicionais). Com dados reais, as regras de esconder pill vazia (review anterior) provaram valor: nada parece debug.
3. **Recap escuro 9:16.** Com semana populada, é screenshot de loja pronto: número gigante Bricolage, fileira de árvores, streak. É o melhor artefato de share do app.
4. **Card do bosque como conceito** (gradiente mint + overline caps). A execução precisa do P1-3, mas o conceito — meta coletiva visual no topo do Círculo — é a alma da diferenciação vs Forest; a Fase A constrói em cima, não substitui.
5. **Consistência dos componentes** (`grovelyCard`, `StatPill`, `StreakBadge`, `GrovelyEmpty`, stagger). O modo populado não revelou nenhuma quebra de linguagem entre telas — o DS está segurando. As propostas deste doc usam só esses primitivos + tokens; nenhum componente novo além do card de plano.
6. **Sheets de criar/entrar no círculo** (estados de erro, busy-lock, offline ≠ código inválido). Não tocar.

---

## Prioridades consolidadas

| P | Item | Tela | Seção |
|---|---|---|---|
| P0 | Assinante cai em paywall de venda → card de plano + guard | Profile/Paywall | §1 |
| P0 | "Guest" pagante → nome local editável | Profile | §3 |
| P1 | Liga = Círculo → Fase A (círculo cooperativo + liga competitiva) | Circle/League | §2 |
| P1 | Stagger escala com acervo (clamp 10) | Garden/Circle | §3 |
| P1 | Tile "+" abaixo da dobra + ordem antigo-primeiro | Garden | §3 |
| P1 | Bosque com 36 mini-árvores ilegível (cap 12 + barra) | Circle | §3 |
| P1 | Avatares todos da mesma cor (hash por userId) | Circle/League | §3 |
| P1 | Demo seed sem "You" na liga | dev | §3 |
| P2 | Recap 8 vs 6 · Best duplicado no Profile · unidade do score · share duplicado · código exposto | várias | §3 |
| Fase B | Liga entre círculos (B1 RPC standings → B2 divisões botânicas) | League | §2 |
