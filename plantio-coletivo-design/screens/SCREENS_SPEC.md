# Grovely — MVP Screen Specification

> Product designer spec. Source of truth for the visual mockups in `screens.html` and the
> navigation in `flow-map.md`. Read alongside `brand/tokens.json` and `brand/brand-book.html`.
> This document **specifies design**; it does not prescribe Flutter implementation beyond the
> existing widget vocabulary (`TreeView`, `MainShell`, `FeatureScaffold`).

---

## 0. Design foundations (recap from the DS, so every screen below can reference them)

### 0.1 Tokens used throughout
| Token | Light | Dark | Used for |
|---|---|---|---|
| `primary` | `#2E7D52` | `#6FD79B` | Primary actions, active nav, healthy growth, timer ring |
| `onPrimary` | `#FFFFFF` | `#07120C` | Text/icon on primary fills |
| `primaryContainer` | `#C8E6CF` | `#1E5238` | Soft chips, selected states, "live now" pill |
| `accent` | `#E0A458` | `#F0B978` | The **sun**, streak flame, league gold, premium |
| `background` | `#F3F6F1` | `#0F1A15` | App canvas |
| `surface` | `#FFFFFF` | `#16221C` | Cards, sheets, nav bar |
| `surfaceVariant` | `#E7EEE7` | `#213029` | Tree tiles, inset rows, skeletons |
| `onSurface` | `#18241D` | `#E7F0E9` | Primary text |
| `onSurfaceVariant` | `#4A5A50` | `#A7B8AD` | Secondary text, captions, helper |
| `outline` | `#C2D0C5` | `#3A4D42` | Hairlines, input borders, dividers |
| `treeHealthy` | `#43A86B` | `#5FD394` | Growth accents, progress |
| `treeWithered` | `#A89274` | `#B9A488` | Withered tree, revive flow |

**Type:** `Bricolage Grotesque` (display / timer / titles / numbers) + `Hanken Grotesk` (UI / body).
Display uses **tight tracking** (-.02em headlines, -.035em the wordmark), eyebrows are **uppercase .12–.14em**.
**Radius:** sm `8` (chips, inputs) · md `14` (tiles, list rows) · lg `20` (cards, sheets) · xl `28` (hero cards, paywall) · pill `999` (buttons, status pills, nav highlight).
**Elevation:** brand uses *colored* soft shadows, not gray — cards `0 14px 34px rgba(46,125,82,.12)`; the master icon `0 16px 34px rgba(46,125,82,.28)`. Dark mode drops shadows in favor of `surfaceVariant` borders.

### 0.2 The symbol (reuse it as a motif, not just the logo)
The Grovely symbol = **three pine triangles + a sun dot (accent) top-right**, on ground. It is the
literal mark for "grove." Use a faint, large, low-contrast version as a **watermark** behind hero
moments (focus complete, recap, empty states) — never behind dense content. The **sun dot** is the
single recurring accent gesture across the app (streak flame, league trophy, premium badge all echo
that warm `accent` dot).

### 0.3 Component vocabulary (defined once, referenced by every screen)
- **GrovelyButton (primary):** pill, `primary` fill, `onPrimary` label, height 56, full-width on action screens. Hanken 600. Pressed: scale .98 + shadow collapse.
- **GrovelyButton (tonal):** pill, `primaryContainer` fill, `onPrimaryContainer` label. Secondary actions.
- **GrovelyButton (ghost/text):** no fill, `primary` label. Tertiary ("Maybe later", "Skip").
- **Card:** `surface`, radius lg, padding 20, colored soft shadow (light) / 1px `outline` (dark).
- **Tile (tree):** `surfaceVariant`, radius md, square, holds a `TreeView`. Long-press → context.
- **StatPill:** pill, `surfaceVariant`, leading glyph + number + caption. Used in headers.
- **StreakBadge:** pill, `accent`-tinted, flame glyph + "N", the sun motif as the flame.
- **LiveDot:** 8px `treeHealthy` dot with a soft pulsing halo = "someone focusing now."
- **DurationDial:** the refined focus selector (see 2.1) — a radial/segmented control, not raw chips.
- **TimerRing:** circular progress around the tree, `primary` stroke on `outline` track.
- **SegmentedToggle:** pill track, two segments (e.g. Annual / Monthly), `surface` thumb.
- **BottomSheet:** radius xl on top corners, grabber, `surface`, used for create/join/manage/revive.
- **Toast/Snackbar:** pill, `surface` + shadow, single line, auto-dismiss; errors get an inline retry.

### 0.4 Naming note (must resolve before build)
The product/brand is **Grovely**. The Flutter `app_*.arb` files still ship `appName: "Plantio
Coletivo"` and onboarding copy `"Grow focus, together."` All microcopy below is written for
**Grovely** and should replace the placeholder ARB strings. (Flagged again in §13.)

### 0.5 Cross-cutting state rules (so each screen doesn't re-specify)
- **Loading:** skeletons in `surfaceVariant` with a slow shimmer; **never** a bare centered spinner on content screens (the existing Garden uses one — see review). Spinners only inside buttons mid-action.
- **Empty:** faint symbol watermark + one-line headline + one helper line + a single primary action. Encouraging, never scolding.
- **Error:** inline card, plain-language cause, a `Retry` (`commonRetry`), and a quiet secondary path. Never a dead end. Network errors keep cached content visible.
- **Offline:** focus, garden, streak all work offline (local-first). Circle/League/Recap show a slim "Reconnecting…" bar and last-synced data, never a blocking error.
- **Reduced motion:** tree growth, ring sweep, and pulses honor the OS reduce-motion flag → crossfades replace scale/spring.
- **Touch targets** ≥ 48dp. **Contrast** ≥ 4.5:1 for text (accent-on-surface is for large/icon use, not body).

---

## 1. Onboarding (multi-step flow)

**Purpose:** turn a cold install into a planted first tree and an honest paywall decision — in
under ~90 seconds. Sequence: Welcome → Notifications permission → Social opt-in → **Guided first
session** → Paywall. No account is required to start (anonymous); account is offered later.

Global onboarding chrome: a slim **progress dotline** (5 dots) top-center; a `Skip` ghost top-right
on the permission/opt-in steps (never on the guided session). Back arrow returns one step.

### 1.1 Welcome
- **Layout/hierarchy:** centered. Large symbol watermark behind. `GrovelyLogo` (stacked lockup) ~64h, then a Bricolage headline, one Hanken subline, primary `Get started`, ghost `I already have an account` → Auth (sign in).
- **Components:** logo, headline, subline, primary button, ghost link, progress dotline (dot 1 active).
- **States:** static. No loading.
- **Microcopy**
  - EN — H: "Grow focus, together." · Sub: "Plant a tree with every focused session. Watch your grove grow." · CTA: "Get started" · link: "I already have an account"
  - PT — H: "Cultive seu foco, junto." · Sub: "Plante uma árvore a cada sessão de foco. Veja seu bosque crescer." · CTA: "Começar" · link: "Já tenho conta"
- **Tokens:** `background`, `onSurface` headline, `onSurfaceVariant` subline, `primary` button, symbol watermark at ~6% opacity.
- **Nav:** Get started → Notifications. Link → Auth/sign-in. Replaces the current single-screen placeholder.

### 1.2 Notifications permission (pre-prompt)
- **Purpose:** explain value *before* the OS dialog, so the accept rate is honest and high. Never dark-pattern ("Allow" and "Not now" are visually equal weight).
- **Layout:** illustration (a sprout + a soft bell using the sun-dot motif), Bricolage title, 2–3 benefit bullets (session reminders, streak saves, "your circle is focusing"), primary `Turn on reminders` (triggers OS prompt), ghost `Not now`.
- **States:** after OS prompt resolves (granted/denied) → advance regardless. If denied, a one-line note "You can turn these on later in Settings." No nagging.
- **Microcopy**
  - EN — Title: "Gentle nudges, never noise." · Bullets: "A daily reminder to plant one tree" / "We'll help you save a streak before it breaks" / "Know when your circle is focusing" · CTA: "Turn on reminders" · ghost: "Not now"
  - PT — Title: "Lembretes gentis, nunca barulho." · Bullets: "Um lembrete diário pra plantar uma árvore" / "Avisamos antes da sua sequência quebrar" / "Saiba quando seu círculo está focando" · CTA: "Ativar lembretes" · ghost: "Agora não"
- **Tokens:** `surface` card, `accent` bell dot, `primary` CTA, `onSurfaceVariant` bullets.
- **Principle:** opt-in, equal weight, deferrable. (Briefing: pressão social SEMPRE opt-in; no dark patterns.)

### 1.3 Social opt-in
- **Purpose:** the collective layer is the differentiator — but it's **opt-in**. This screen frames it and lets the user choose **Solo** or **With a circle** with no penalty either way.
- **Layout:** split illustration — left a single tree, right a small cluster (collective garden). Title + subline. Two large selectable cards: **"Focus solo"** and **"Focus with a circle"** (recommended tag, not forced). A privacy reassurance line: only first name + tree count are shared, never session content. Primary `Continue`.
- **Components:** two `Card` choices (radio behavior), reassurance row with a small lock glyph, primary.
- **States:** default selection = Solo (honest: don't pre-opt-in to social). Selecting "with a circle" reveals a sub-choice later (create/join) but **not now** — onboarding stays linear; circle setup happens post-paywall from the Circle tab.
- **Microcopy**
  - EN — Title: "Focus your way." · Sub: "You can always change this later." · Card A: "Focus solo — Just you and your grove." · Card B: "Focus with a circle — Grow a shared garden with 6–12 people." · Privacy: "We only ever share your first name and tree count." · CTA: "Continue"
  - PT — Title: "Foque do seu jeito." · Sub: "Você pode mudar isso depois." · Card A: "Focar sozinho(a) — Só você e seu bosque." · Card B: "Focar com um círculo — Cultive um jardim com 6–12 pessoas." · Privacy: "Só compartilhamos seu primeiro nome e número de árvores." · CTA: "Continuar"
- **Tokens:** `primaryContainer` on the selected card, `outline` on unselected, lock glyph in `onSurfaceVariant`.
- **Principle:** opt-in default solo; LGPD minimal-data reassurance shown at the decision point.

### 1.4 Guided first session
- **Purpose:** deliver the "aha" — a real, short, guaranteed-success session so the user *feels* a tree grow before any ask. **No skip.**
- **Layout:** a stripped focus screen. Pre-set to a friendly **5-minute** "first plant" (shorter than the real minimum 15 to guarantee completion). Coach line above the tree, the tree centered (`TreeView` seed→), TimerRing, a single calm `Begin` then live countdown. On completion → a celebratory micro-moment (tree pops to sapling/young, confetti-of-leaves, "Your first tree!") then auto-advances to paywall.
- **Components:** coach text, `TreeView`, `TimerRing`, primary `Begin` → countdown, completion overlay.
- **States:** *running* (timer + grow); *completed* (celebration → continue). Backgrounding here does **not** wither (it's a tutorial — explicitly forgiving); instead a gentle "Come back to finish planting." (This teaches the rule without punishing during onboarding.)
- **Microcopy**
  - EN — Coach: "Let's plant your first tree. Stay here for 5 minutes — that's it." · CTA: "Begin" · running helper: "Stay in Grovely and watch it grow." · done: "Your first tree! 🌱 This one's on us."
  - PT — Coach: "Vamos plantar sua primeira árvore. Fique aqui por 5 minutos — só isso." · CTA: "Começar" · running: "Fique no Grovely e veja crescer." · done: "Sua primeira árvore! 🌱 Essa é por nossa conta."
- **Tokens:** `primary` ring, `treeHealthy` accents, `accent` confetti highlights, symbol watermark on the done overlay.
- **Principle:** value before payment; forgiving tutorial; honest framing of what's free.

### 1.5 Paywall (rigid) — onboarding variant
See **§7** for the full paywall spec. In onboarding it appears **after** the first tree is planted,
framed as "Start your 21-day trial" with a prominent, honest **"Continue with Free"** escape. It is
"rigid" in that it's a full-screen step, but it is **honest**: Free is always reachable in ≤1 tap.

---

## 2. Focus (core loop)

The home tab. Four phases already exist (`FocusPhase.selecting/running/completed/withered`) — this
section **refines** them and adds the live-circle affordance + revive.

### 2.1 Selecting (duration picker, refined)
- **Purpose:** choose a session and start with one tap; surface streak and (if opted-in) live circle activity.
- **Layout/hierarchy (top→bottom):**
  1. **Header row:** `StreakBadge` (left, "🔥 7") + optional `LiveDot` chip "3 focusing now" (right, only if in a circle and someone is active) — tapping it deep-links to the circle.
  2. **Tree stage:** centered `TreeView` (seed) on a faint symbol watermark — this is the "plot" you're about to plant.
  3. **DurationDial:** replace the raw `ChoiceChip` wrap. A horizontal **segmented pill** 15·25·45·60 with the selected segment as a `primary` thumb, plus a small "Custom" affordance (premium) that opens a wheel sheet. Below the dial: a one-line preview ("A young oak in 25 min", tree species rotates/seasonal).
  4. **Primary** `Plant & focus`.
- **Components:** `StreakBadge`, `LiveDot` chip, `TreeView`, `DurationDial` (SegmentedToggle variant), species-preview caption, primary button.
- **States:** *default* (15 or last-used pre-selected); *empty streak* (badge reads "Start a streak"); *no circle* (no live chip). Loading n/a (local).
- **Microcopy**
  - EN — preview: "A young {species} in {n} min." · CTA: "Plant & focus" · streak0: "Start a streak" · live: "{n} focusing now"
  - PT — preview: "Um(a) {species} jovem em {n} min." · CTA: "Plantar e focar" · streak0: "Comece uma sequência" · live: "{n} focando agora"
- **Tokens:** dial thumb `primary`/`onPrimary`, track `surfaceVariant`, preview caption `onSurfaceVariant`, streak `accent`.
- **Nav:** CTA → Running. Live chip → Circle detail. Custom → duration sheet (premium-gated).

### 2.2 Running (timer + growing tree + ambient)
- **Purpose:** a calm, **immersive, distraction-free** focus environment that makes leaving feel like a small loss.
- **Layout:** full-bleed, no bottom nav (nav bar hides during a running session — a deliberate change; see review). Vertically centered: **TimerRing wrapping the TreeView**, the `mm:ss` in Bricolage tabular figures *inside or below* the ring, a soft growth-progress caption, and a low-emphasis `Give up` text button near the bottom. Background is a calm vertical gradient that **warms slightly** as the session nears completion (dawn→day), echoing the sun.
  - If in a live circle: a tiny stacked-avatar cluster + "you + 3 growing" pinned bottom — ambient presence, **not** interactive (no taps that could break focus). No chat, no notifications surface here.
- **Components:** `TimerRing`, `TreeView` (stage driven by progress), tabular timer, growth caption, `Give up` ghost, optional ambient presence cluster.
- **States:** *running* (default); *near-complete* (last 60s: ring + bg intensify, gentle haptic at finish). Backgrounding → triggers wither (existing lifecycle logic) → 2.4.
- **Microcopy**
  - EN — helper: "Stay in Grovely to keep it growing." · giveup: "Give up" · giveup confirm (sheet): "Leave now? Your tree will wither." / "Keep focusing" / "Give up" · ambient: "you + {n} growing"
  - PT — helper: "Fique no Grovely pra continuar crescendo." · giveup: "Desistir" · confirm: "Sair agora? Sua árvore vai murchar." / "Continuar focando" / "Desistir" · ambient: "você + {n} crescendo"
- **Tokens:** `primary` ring on `outline` track, timer `onSurface`, helper `onSurfaceVariant`, warm-gradient driven by `accent`.
- **Principle:** ads NEVER interrupt focus; no social pressure beyond ambient opt-in presence. Adds a **give-up confirmation** to prevent accidental loss (review item).

### 2.3 Completed (success)
- **Purpose:** reward, reinforce streak, confirm the tree was planted in the garden, invite the next loop.
- **Layout:** celebratory. Mature/elder `TreeView` center on symbol watermark; Bricolage "Tree planted!"; a **stats row** (3 `StatPill`s: minutes focused · streak now · total trees); a "Added to your garden" confirmation chip; primary `Plant another`, tonal `View garden`. If session was in a circle: a line "+1 to {Circle}'s garden" with the collective progress nudged.
- **Components:** `TreeView`, headline, 3× `StatPill`, garden-confirm chip, primary + tonal, optional circle-contribution line, leaf confetti.
- **States:** *default*; *new streak milestone* (e.g. 7/30 days → a one-time celebratory banner + share affordance to Recap); *streak broken-then-restarted* handled gracefully ("Day 1 again — fresh start").
- **Microcopy**
  - EN — H: "Tree planted!" · stats: "{n} min focused" / "{n}-day streak" / "{n} trees" · chip: "Added to your garden" · CTA: "Plant another" · alt: "View garden" · circle: "+1 to {circle}'s garden"
  - PT — H: "Árvore plantada!" · stats: "{n} min de foco" / "sequência de {n} dias" / "{n} árvores" · chip: "Adicionada ao seu jardim" · CTA: "Plantar outra" · alt: "Ver jardim" · circle: "+1 no jardim do {circle}"
- **Tokens:** `treeHealthy`/`primary` accents, `accent` on streak stat, `surface` stat pills.
- **Nav:** Plant another → Selecting. View garden → Garden tab. Milestone share → Recap.

### 2.4 Withered (failure) + Revive
- **Purpose:** acknowledge the loss kindly (no shame), teach, and offer **one** honest recovery path: a **rewarded ad by explicit choice** to revive, OR just move on.
- **Layout:** muted. Withered `TreeView` (the real `*-withered.svg`, in `treeWithered`) on a desaturated bg; Bricolage "Your tree withered" in a gentle tone; a short empathetic line; **two equal paths**: tonal `Revive with a short video` (opens revive sheet) and ghost `Start fresh`. Never auto-plays an ad; never implies the ad is required.
- **Revive sheet:** bottom sheet — "Watch a 30s video to revive this tree?" with `Watch & revive` (rewarded) and `No thanks`. After reward → tree animates back to its pre-wither stage and plants normally. Reviving is **capped** (e.g. once per session, limited per day) and that limit is stated honestly.
- **Components:** withered `TreeView`, headline, empathetic body, tonal revive + ghost, revive `BottomSheet`, rewarded-ad host.
- **States:** *withered* (default); *revive available* vs *revive used/limit reached* (revive button → disabled with reason: "Revive used for this session"); *ad failed to load* → "Couldn't load the video — your tree's still here to replant" + `Start fresh`.
- **Microcopy**
  - EN — H: "Your tree withered." · body: "You left before the session finished — it happens. Want to bring it back?" · revive: "Revive with a short video" · fresh: "Start fresh" · sheet: "Watch a 30-second video to revive this tree." / "Watch & revive" / "No thanks" · limit: "Revive already used this session."
  - PT — H: "Sua árvore murchou." · body: "Você saiu antes do fim — acontece. Quer trazê-la de volta?" · revive: "Reviver com um vídeo curto" · fresh: "Começar de novo" · sheet: "Assista a um vídeo de 30s para reviver esta árvore." / "Assistir e reviver" / "Não, obrigado(a)" · limit: "Revive já usado nesta sessão."
- **Tokens:** `treeWithered` tree, `surfaceVariant` muted bg, tonal revive button (`primaryContainer`), `accent` only on the "revive" affordance to signal it's the warm path.
- **Principle:** rewarded ads only by explicit choice, only here, capped + honest; no shame language.

---

## 3. Garden (personal)

### 3.1 Garden grid (refined)
- **Purpose:** the trophy case — a living record of focus that grows denser and more beautiful over time.
- **Layout:** 
  1. **Header card:** `StreakBadge` + headline count ("23 trees · 14-day streak") + a row of `StatPill`s (total focus time, longest streak, species collected N/6). This replaces the bare `titleMedium` count line.
  2. **Filter/sort chips:** All · By species · Recent (pill chips).
  3. **Grid:** 3-col `Tile`s of elder/mature trees on `surfaceVariant`. Newest first. A subtle "ground line" baseline under each tree unifies the grid into a landscape. Tap → detail; long-press → quick actions (favorite, share).
- **Components:** header `Card`, `StreakBadge`, `StatPill` row, filter chips, `Tile` grid (`TreeView`).
- **States:**
  - **Loading:** 3×N **skeleton tiles** (shimmer), header skeleton. (Replaces the centered spinner.)
  - **Empty:** symbol watermark + "Your garden is waiting." + helper + primary `Plant your first tree` → Focus. (Briefing-friendly, encouraging.)
  - **Error:** inline card + `Retry`, keeps any cached trees visible.
- **Microcopy**
  - EN — header: "{n} trees" / "{n}-day streak" · stats: "{h}h focused" / "Longest: {n} days" / "{n}/6 species" · empty H: "Your garden is waiting." · empty sub: "Finish a focus session to plant your first tree." · empty CTA: "Plant your first tree"
  - PT — header: "{n} árvores" / "sequência de {n} dias" · stats: "{h}h de foco" / "Recorde: {n} dias" / "{n}/6 espécies" · empty H: "Seu jardim está esperando." · empty sub: "Conclua uma sessão de foco para plantar sua primeira árvore." · empty CTA: "Plantar minha primeira árvore"
- **Tokens:** header `surface` card + colored shadow, tiles `surfaceVariant`, chips `primaryContainer` when active.
- **Nav:** tile → 3.2; empty CTA → Focus.

### 3.2 Tree detail
- **Purpose:** celebrate one tree and the session behind it; allow sharing.
- **Layout:** sheet or full screen. Large `TreeView` (elder) on watermark; species name + a poetic one-liner; a metadata row: date planted, duration, "grown solo" or "with {circle}". `Share` (→ generates a small card) and `Set as favorite`. If withered-then-revived, a small "Revived" tag.
- **Components:** large `TreeView`, title, metadata rows, `Share`, favorite toggle, optional tags.
- **States:** static; share → loading spinner in button → share sheet; error → toast + retry.
- **Microcopy**
  - EN — e.g. "Cherry Blossom" · "Planted Jun 14 · 45 min · with Deep Work Club" · "Set as favorite" · "Share"
  - PT — "Cerejeira" · "Plantada em 14 jun · 45 min · com Deep Work Club" · "Definir como favorita" · "Compartilhar"
- **Tokens:** `surface`, species color accents come from the SVG itself; `accent` favorite star.

---

## 4. Circle (collective)

### 4.1 Circle home — empty / not in a circle
- **Purpose:** explain the collective value (opt-in) and offer two clear actions.
- **Layout:** symbol watermark + a small cluster illustration; headline; two primary-weight actions: `Create a circle` and `Join with a code`; a reassurance line about privacy & size (6–12). A "What's a circle?" expandable.
- **States:** empty (default), loading skeleton if checking membership, error inline.
- **Microcopy**
  - EN — H: "Grow together." · sub: "A circle is 6–12 people focusing toward a shared garden and a weekly league." · A: "Create a circle" · B: "Join with a code" · privacy: "Only your first name and tree count are visible to members."
  - PT — H: "Cresçam juntos." · sub: "Um círculo são 6–12 pessoas focando por um jardim comum e uma liga semanal." · A: "Criar um círculo" · B: "Entrar com código" · privacy: "Só seu primeiro nome e número de árvores ficam visíveis."
- **Tokens:** two `primaryContainer`/`primary` action cards; lock glyph `onSurfaceVariant`.
- **Nav:** A → 4.2; B → 4.3.

### 4.2 Create a circle (sheet)
- **Layout:** `BottomSheet` — circle name field, optional emoji/leaf picker, size cap (default 12, slider 6–12), privacy is fixed-minimal (explained), primary `Create circle`. On success → 4.4 with an invite code surfaced + a `Share invite` button.
- **States:** typing (validate name length), submitting (button spinner), error (name taken / network → inline), success (→ detail + share prompt).
- **Microcopy**
  - EN — title: "Create a circle" · field: "Circle name" · hint: "e.g. Deep Work Club" · cap: "Up to {n} members" · CTA: "Create circle" · success: "Your circle is live. Invite up to {n} people." · share: "Share invite"
  - PT — title: "Criar um círculo" · field: "Nome do círculo" · hint: "ex.: Clube do Foco" · cap: "Até {n} membros" · CTA: "Criar círculo" · success: "Seu círculo está no ar. Convide até {n} pessoas." · share: "Compartilhar convite"
- **Tokens:** input `outline` border + `surface`, focus ring `primary`.

### 4.3 Join with a code (sheet)
- **Layout:** `BottomSheet` — a 6-char segmented code input (monospace, Bricolage), paste support, primary `Join`. A note that codes are case-insensitive.
- **States:** empty, typing, validating (spinner), invalid code ("That code didn't match a circle"), full circle ("This circle is full (12/12)"), success → 4.4.
- **Microcopy**
  - EN — title: "Join a circle" · field: "Invite code" · CTA: "Join" · invalid: "That code didn't match a circle." · full: "This circle is full." 
  - PT — title: "Entrar num círculo" · field: "Código de convite" · CTA: "Entrar" · invalid: "Esse código não corresponde a nenhum círculo." · full: "Este círculo está cheio."
- **Tokens:** segmented input cells `surfaceVariant` with `primary` active cell border.

### 4.4 Circle detail (collective garden + live presence)
- **Purpose:** the heart of the differentiator — a shared garden growing in real time, who's focusing now, weekly league snapshot, and members.
- **Layout (top→bottom):**
  1. **Header:** circle name + member avatars (stacked) + a `LiveDot` "**{n} focusing now**" pill (pulsing) — the live signal.
  2. **Collective garden:** a wide, dense illustration zone — everyone's recent trees composed into one **shared landscape** (not a cold grid; trees overlap into a grove). A subtle progress meter toward this week's group goal.
  3. **This week:** a compact league snapshot card (current tier + group rank) → tap to League tab.
  4. **Members list:** rows with avatar, first name, trees-this-week, and a `LiveDot` if currently focusing. The current user is highlighted.
  5. Overflow menu: invite, mute, **leave circle** (with confirm; leaving is easy, no guilt-trip).
- **Components:** avatar stack, `LiveDot` pill, collective garden composite, group-goal meter, league snapshot `Card`, member rows, overflow menu, `BottomSheet` for invite/leave.
- **States:**
  - **Loading:** header skeleton + garden skeleton + 5 member-row skeletons.
  - **Empty-ish (new circle):** "Plant the first tree together" + invite CTA when the garden is bare.
  - **No one live:** the pill reads "Quiet right now — start a session" (gentle, opt-in nudge, not pressure).
  - **Error/offline:** "Reconnecting…" slim bar, show last-synced garden + members; live counts dim.
- **Microcopy**
  - EN — live: "{n} focusing now" · quiet: "Quiet right now" · goal: "{planted}/{goal} trees this week" · member: "{name} · {n} this week" · leave: "Leave circle?" / "You can rejoin with the code." / "Leave" / "Stay"
  - PT — live: "{n} focando agora" · quiet: "Tranquilo por aqui" · goal: "{planted}/{goal} árvores esta semana" · member: "{name} · {n} esta semana" · leave: "Sair do círculo?" / "Você pode voltar com o código." / "Sair" / "Ficar"
- **Tokens:** `LiveDot` = `treeHealthy` with halo; group-goal meter `primary` on `outline`; current-user row tinted `primaryContainer`.
- **Principle:** presence is ambient + opt-in; leaving is ≤2 taps; only minimal data shown.

---

## 5. League (weekly)

### 5.1 League standings
- **Purpose:** light, weekly competitive layer that resets — motivation without permanent ranking anxiety.
- **Layout:**
  1. **Tier header:** current tier badge (Bronze→Silver→Gold→…) using the **sun/leaf motif** in `accent`/metallic tints, "Ends in 2d 14h" countdown, and a promotion/relegation legend (top N promote, bottom N relegate).
  2. **Your position card:** sticky highlighted row — rank, name, tree-minutes this week, and trend arrow.
  3. **Standings list:** ranked rows (rank number, avatar, name, weekly score, a tiny live dot if focusing). Promotion zone gets a faint green top-band; relegation zone a faint amber bottom-band.
- **Components:** tier badge, countdown, legend, sticky "you" row, ranked list, zone bands.
- **States:**
  - **Loading:** tier skeleton + 8 row skeletons.
  - **Not in a league yet:** (solo users) → friendly explainer + "Join a circle to enter the league" → Circle. (League is a circle benefit; honest that solo has no league.)
  - **Week rollover:** a one-time results overlay ("You finished #3 — promoted to Gold!" / "Held in Silver") on first open after reset, with a share-to-Recap option.
  - **Error/offline:** last-synced standings + "Reconnecting…".
- **Microcopy**
  - EN — ends: "Ends in {d}d {h}h" · zones: "Top {n} promote" / "Bottom {n} relegate" · you: "You · #{rank}" · result: "You finished #{rank} — promoted to {tier}!" / "Held in {tier}." · solo: "Join a circle to enter the weekly league."
  - PT — ends: "Termina em {d}d {h}h" · zones: "Top {n} sobem" / "Últimos {n} descem" · you: "Você · #{rank}" · result: "Você terminou em #{rank} — subiu para {tier}!" / "Ficou em {tier}." · solo: "Entre num círculo para participar da liga semanal."
- **Tokens:** tier badges in `accent` family (Bronze warm, Gold bright), promote band `primaryContainer` @ low opacity, relegate band `accent` @ low opacity, "you" row `primaryContainer`.
- **Principle:** opt-in (circle-gated), resets weekly (no permanent hierarchy), no pay-to-win.

---

## 6. Recap (shareable weekly card)

### 6.1 Weekly recap
- **Purpose:** a beautiful, **9:16 share-optimized** summary of the week's focus → organic growth via Stories/Reels.
- **Layout:** a single hero **card** sized for vertical share (1080×1920 export). Composition: Grovely symbol/wordmark top, a Bricolage hero number ("8 trees · 4h 20m"), a mini composed grove of the week's trees, streak + league result, and a tasteful footer ("grovely.app"). A theme switch (light/dark/seasonal). Below the card: `Share` (→ system share sheet, Instagram/TikTok-ready) and `Save image`. The card itself is the export artifact — no UI chrome inside it.
- **Components:** export `Card` (xl radius for the in-app preview; full-bleed on export), hero number, mini grove, streak/league badges, share + save buttons, theme toggle.
- **States:**
  - **Loading:** card skeleton.
  - **Empty (no focus this week):** an encouraging variant — "A fresh week to grow" + CTA to Focus instead of a share card (don't push sharing a blank week).
  - **Generating image:** button spinner; **error** → "Couldn't create your card" + retry.
- **Microcopy**
  - EN — hero: "{n} trees this week" · sub: "{h}h {m}m focused" · streak: "{n}-day streak" · footer: "Made with Grovely" · CTA: "Share my week" · alt: "Save image" · empty: "A fresh week to grow." 
  - PT — hero: "{n} árvores esta semana" · sub: "{h}h {m}m de foco" · streak: "sequência de {n} dias" · footer: "Feito com Grovely" · CTA: "Compartilhar minha semana" · alt: "Salvar imagem" · empty: "Uma semana nova pra crescer."
- **Tokens:** export card uses brand gradient (`primary`→darker) for dark theme, `background`→`surface` for light; `accent` for streak/numbers; symbol watermark.
- **Principle:** never auto-share; sharing is user-initiated; blank weeks don't pressure.

---

## 7. Paywall (rigid, honest)

### 7.1 Paywall
- **Purpose:** convert to a **21-day trial** with an honest value frame and clear annual-vs-monthly anchoring — **without lying about what's free**.
- **Layout (top→bottom):**
  1. **Hero:** symbol watermark + Bricolage title + a single emotional line. Premium badge uses the `accent` sun dot.
  2. **Free vs Premium table (the honesty centerpiece):** two columns. **Free** column is real and generous (unlimited solo focus, full garden, basic streak, 1 circle). **Premium** adds (custom durations, all species/seasonal trees, advanced stats, multiple circles, recap themes, no rewarded-revive cap, etc.). Every Free row shows a real check — never a fake limitation to manufacture urgency.
  3. **Plan toggle (anchoring):** `SegmentedToggle` Annual / Monthly. **Annual is pre-selected** with a "Save 40%" `accent` tag and a per-month equivalent ("$X/mo, billed yearly"); Monthly shows its true price. The price math is shown plainly.
  4. **Primary CTA:** "Start 21-day free trial" + a literal sub-line: "Free for 21 days, then {price}. Cancel anytime in two taps."
  5. **Escape:** an equally legible `Continue with Free` (ghost, not hidden, not tiny).
  6. Footer: restore purchases, terms, privacy.
- **Components:** hero, comparison table, `SegmentedToggle`, price block, primary CTA, free-escape ghost, restore/legal links.
- **States:**
  - **Loading prices:** price block skeleton (never show a fake price).
  - **Purchasing:** button spinner; **success** → confirmation + into the app; **error** ("Purchase didn't go through — you weren't charged") + retry.
  - **Already premium / in trial:** this screen becomes the **Manage** view (see §8.3) — never re-sell someone who already pays.
  - **Store unavailable / offline:** "Plans are unavailable right now" + `Continue with Free` stays.
- **Microcopy**
  - EN — H: "Go deeper with Grovely Premium." · sub: "Everything you love, plus more ways to grow." · trial CTA: "Start 21-day free trial" · trial sub: "Free for 21 days, then {price}/yr. Cancel anytime in two taps." · annual tag: "Save 40%" · escape: "Continue with Free" · restore: "Restore purchases"
  - PT — H: "Vá além com o Grovely Premium." · sub: "Tudo o que você ama, e mais formas de crescer." · trial CTA: "Iniciar teste grátis de 21 dias" · trial sub: "Grátis por 21 dias, depois {price}/ano. Cancele quando quiser em dois toques." · annual tag: "Economize 40%" · escape: "Continuar no plano grátis" · restore: "Restaurar compras"
- **Tokens:** premium accents in `accent`; Premium column header tinted `primaryContainer`; CTA `primary`; comparison checks `treeHealthy`.
- **Principle (all briefing-mandated):** honest paywall (Free shown truthfully), 21-day trial, cancel ≤2 taps stated **on the paywall itself**, no dark patterns, escape always visible.

---

## 8. Profile / Settings

### 8.1 Profile home
- **Purpose:** identity, streak/lifetime stats, and the hub for account, subscription, notifications, privacy, theme.
- **Layout:**
  1. **Identity header:** avatar (or initial), display name, `StreakBadge`, and an **account state** chip — "Guest" (anonymous) with a `Save your progress` CTA, or email/OAuth identity if linked.
  2. **Lifetime stats card:** total trees, total focus hours, longest streak, species collected.
  3. **Settings list (grouped rows):**
     - **Account** → link/manage account (8.4)
     - **Subscription** → manage/cancel (8.3) with current status ("Premium · trial ends Jun 30" / "Free")
     - **Notifications** → toggles (8.2)
     - **Appearance** → theme (System/Light/Dark)
     - **Privacy** → privacy policy, data export/delete (LGPD)
     - **Terms**, **About/version**, **Restore purchases**, **Sign out**
- **Components:** identity header, stats `Card`, grouped list rows (leading glyph, label, value/chevron), `StreakBadge`.
- **States:** loading skeleton rows; guest vs linked; premium vs free reflected inline.
- **Microcopy**
  - EN — guest chip: "Guest" · save CTA: "Save your progress" · sub status: "Premium · trial ends {date}" / "Free plan" · rows: "Account" / "Subscription" / "Notifications" / "Appearance" / "Privacy" / "Terms" / "Sign out"
  - PT — guest: "Convidado(a)" · save: "Salvar seu progresso" · status: "Premium · teste acaba em {date}" / "Plano grátis" · rows: "Conta" / "Assinatura" / "Notificações" / "Aparência" / "Privacidade" / "Termos" / "Sair"
- **Tokens:** rows on `surface`, dividers `outline`, status chip `primaryContainer`/`accent`.

### 8.2 Notifications settings
- **Layout:** toggle list — Daily reminder (+ time picker), Streak-saver alert, Circle activity ("someone in your circle started focusing"), League results, Product news (default OFF). Each with a one-line description.
- **States:** OS-permission-denied banner at top with `Open Settings` if globally off.
- **Microcopy:** EN "Daily reminder", "Streak saver", "Circle activity", "League results", "Product news" / PT "Lembrete diário", "Salvar sequência", "Atividade do círculo", "Resultados da liga", "Novidades".

### 8.3 Manage / cancel subscription (≤2 taps)
- **Purpose:** make canceling **as easy as subscribing** — the briefing's hard rule.
- **Layout:** current plan, renewal date, price; a single **`Cancel subscription`** button (tap 1) → a one-line confirm sheet `Cancel subscription?` with `Keep Premium`/`Cancel` (tap 2). No retention maze, no multi-step survey *required* (an optional one-tap "why?" may appear *after*, skippable). After cancel: "You'll keep Premium until {date}" — no immediate lockout, no guilt.
- **States:** active, trialing (cancel = "trial won't convert"), already-canceled ("ends {date}, Resubscribe"), error.
- **Microcopy**
  - EN — "Cancel subscription" · sheet: "Cancel subscription?" / "You'll keep Premium until {date}." / "Keep Premium" / "Cancel" · done: "Canceled. Premium stays active until {date}."
  - PT — "Cancelar assinatura" · sheet: "Cancelar assinatura?" / "Você mantém o Premium até {date}." / "Manter Premium" / "Cancelar" · done: "Cancelado. Premium ativo até {date}."
- **Tokens:** cancel is a clear (not buried) tonal/destructive-text button; confirm sheet neutral.
- **Principle:** cancel ≤2 taps, no dark patterns, honest about remaining access.

### 8.4 Link / upgrade account (anonymous → email/OAuth)
- **Purpose:** let guests secure their grove without forcing signup upfront.
- **Layout:** "Save your progress so it's never lost." → buttons: Continue with Apple, Continue with Google, Continue with email. Reassurance: "Your trees and streak stay exactly as they are." On success the guest data migrates and the identity chip updates.
- **States:** idle, provider-loading, success (migrated), error/cancelled, "email already in use → sign in instead".
- **Microcopy:** EN H "Save your progress" sub "Link an account so your grove is never lost." / PT H "Salvar seu progresso" sub "Vincule uma conta para nunca perder seu bosque."

---

## 9. Auth

### 9.1 Sign in / Sign up / Upgrade (one adaptive screen)
- **Purpose:** OAuth-first, email fallback; the *same* screen serves new sign-up, returning sign-in, and guest-upgrade (just different headline + the migration note when upgrading).
- **Layout:** symbol watermark, headline (context-dependent), OAuth buttons (Apple/Google) full-width, an "or" divider, email field → continue (magic-link or password per backend), legal line ("By continuing you agree to Terms & Privacy"), and a footer toggle "New here? Create an account" / "Have an account? Sign in".
- **Components:** OAuth buttons, divider, email input, continue button, legal microcopy, mode toggle.
- **States:** idle; per-provider loading; email-sent confirmation (if magic link); errors (wrong password, invalid email, network); upgrade variant shows the "your progress will be saved" note.
- **Microcopy**
  - EN — signin H: "Welcome back." · signup H: "Create your account." · upgrade H: "Save your progress." · legal: "By continuing you agree to our Terms and Privacy Policy." · email: "Email" · cta: "Continue" · sent: "Check your email for a sign-in link."
  - PT — signin: "Bem-vindo(a) de volta." · signup: "Crie sua conta." · upgrade: "Salve seu progresso." · legal: "Ao continuar, você concorda com os Termos e a Política de Privacidade." · email: "E-mail" · cta: "Continuar" · sent: "Verifique seu e-mail para o link de acesso."
- **Tokens:** OAuth buttons on `surface` with `outline` border + brand glyphs; primary email continue `primary`.

---

## 10. Transversal states & dark mode (gallery)

A dedicated section in `screens.html` renders, side by side:
- **Loading** (skeletons): garden grid, circle detail, league list.
- **Empty:** garden, circle, recap (fresh week), league (solo/not-in-league).
- **Error:** generic inline card + retry; purchase error; ad-failed-to-load.
- **Dark mode:** Focus running, Garden, Circle detail, Paywall, Recap rendered in dark tokens to prove the palette holds (and that shadows give way to `outline` borders).

**Dark-mode rules:** swap to `dark` token set; remove colored drop-shadows, add 1px `outline`
borders for separation; `primary` becomes the brighter `#6FD79B`; the timer ring and live dots gain
contrast; tree SVGs already read well on `#0F1A15`. The running-focus gradient shifts to a deep
forest-night warming to ember.

---

## 11. Motion & micro-interactions (brief)
- **Tree growth:** `AnimatedSwitcher` (already present) scale .85→1 + fade, easeOutBack, 600ms — keep, but gate behind reduce-motion.
- **Timer ring:** smooth sweep; final 3s a subtle pulse; completion = a single soft haptic + leaf-confetti burst (no sound by default).
- **Live dot:** 1.6s ease-in-out halo pulse; pauses when offline.
- **Buttons:** press scale .98, shadow collapse; success buttons morph spinner→check before navigating.
- **Sheets:** spring up, grabber, scrim fade.
- **Streak milestone:** one-time confetti + badge stamp on the Completed screen.

---

## 12. Revisão das telas existentes (críticas concretas + melhorias acionáveis)

> Files reviewed: `onboarding_screen.dart`, `focus_session_screen.dart`, `garden_screen.dart`,
> `widgets/tree_view.dart`, `shared/widgets/{feature_scaffold,main_shell,grovely_logo}.dart`,
> `data/models/tree.dart`, `l10n/app_{en,pt}.arb`. (No code changes made — design feedback only.)

### 12.1 Onboarding (`onboarding_screen.dart`)
1. **It's a single static placeholder** (logo + one line + Continue → `/focus`). It skips the entire mandated flow (notif permission, social opt-in, guided first session, paywall). **Action:** implement the 5-step flow in §1; the guided 5-min session is the highest-leverage addition (delivers the aha before any ask).
2. **No progress indication / no back.** Add the 5-dot progress line + back affordance (§1 chrome).
3. **Headline pulled from a single `onboardingWelcome` key** — fine, but it routes straight to Focus, meaning a brand-new user lands on the duration picker with **zero context, no streak, no tree planted, and never sees the paywall**. This breaks the trial funnel. **Action:** route Welcome → Notifications, end the flow at Paywall, then into the shell.
4. **Brand mismatch:** copy is generic; align with the Grovely voice in §1.

### 12.2 Focus session (`focus_session_screen.dart`)
1. **`ChoiceChip` wrap for durations is functional but off-brand and low-commitment.** It reads like a settings form, not a calm "choose your focus." **Action:** replace with the `DurationDial` (§2.1) + species preview; keep the existing duration list source of truth.
2. **`Give up` has no confirmation.** A single tap (or accidental tap) discards the session and withers the tree — punishing and easy to trigger by mistake. **Action:** add the confirm sheet (§2.2). Note the *real* failure path is backgrounding (lifecycle), which is correct; the in-screen button just needs a guard.
3. **Bottom nav stays visible during a running session.** Tapping another tab mid-focus is an easy accidental "leave." **Action:** hide/disable `MainShell`'s nav while `FocusPhase.running` (immersive mode) — this also reinforces "stay here." (Design change to `MainShell` behavior, flagged for Agent B.)
4. **The `running` state lacks a progress ring.** The tree grows in stages but there's no continuous sense of time elapsed besides `mm:ss`. **Action:** wrap `TreeView` in `TimerRing` (§2.2). The growth gradient (dawn→day) is a cheap, high-impact ambient upgrade.
5. **`completed` and `withered` share one `_Result` widget.** Success and failure deserve different emotional treatments. Success needs **stats + streak + "added to garden" confirmation + leaf confetti**; failure needs the **revive (rewarded) path** (§2.3/2.4). Currently neither stats nor revive exist — and the whole rewarded-ad revive (a core monetization + briefing principle) is **missing**. **Action:** split into `_Completed` and `_Withered` with their own layouts.
6. **No live-circle presence anywhere in the loop.** The collective differentiator never touches the core screen. **Action:** add the opt-in `LiveDot` chip (selecting) + ambient presence cluster (running).
7. **`AppBar(title: focusTitle)` on the focus screen** wastes the calmest, most important screen's top space on a redundant title. **Action:** drop the app bar on Focus; lead with the streak/live header instead.

### 12.3 Garden (`garden_screen.dart`)
1. **Loading is a bare `CircularProgressIndicator`.** Per §0.5 this should be **skeleton tiles** — a spinner on a content grid feels broken and off-brand. **Action:** shimmer skeletons.
2. **Error is just `Text(commonError)` centered** — a dead end with no retry and no cached content. **Action:** inline error card + `Retry` (§3.1), keep cached trees.
3. **Empty state is a single gray text line** — accurate but joyless and gives no action. **Action:** symbol watermark + headline + helper + `Plant your first tree` CTA → Focus (§3.1).
4. **Header is a lone `titleMedium` count.** No streak, no stats, no sense of achievement. **Action:** the header `Card` with `StreakBadge` + `StatPill`s (§3.1).
5. **All tiles render `TreeStage.elder` regardless of the actual tree** — so every tree looks identical/maxed and species variety is lost visually. Also tiles aren't tappable (no detail). **Action:** render the tree's *real* final stage + species; add tap → Tree detail (§3.2) and a unifying ground-line baseline.
6. **Fixed 3-col grid** with no sort/filter; will get unwieldy and monotonous as it grows. **Action:** add filter/sort chips (§3.1).

### 12.4 Placeholders (`circle`, `league`, `profile`, `paywall`, `recap`, `auth`)
All are `FeatureScaffold` stubs (eco icon + a one-line empty message). They need full builds per
§§4–9. **Priority order for the differentiator + monetization:** Paywall (§7) and Circle detail
(§4.4) first, then League (§5), Profile/Subscription-cancel (§8.3), Recap (§6), Auth (§9).

### 12.5 Shared widgets
1. **`MainShell` nav** is the standard Material `NavigationBar` — acceptable, but (a) it should **hide during running focus** (12.2.3), and (b) consider the **center Focus tab** as a slightly emphasized primary destination since it's the core loop. Icons are generic Material (`timer`, `grass`, `groups`, `emoji_events`, `person`); fine for MVP but a custom **leaf/grove** glyph set would lift it on-brand later.
2. **`FeatureScaffold`** uses `Icons.eco_outlined` as the universal empty glyph — replace per-screen empties with the **Grovely symbol watermark** for brand consistency (§0.2).
3. **`TreeView`** is solid and reusable — good. One note: `easeOutBack` overshoot is delightful for growth but must be **disabled under reduce-motion** (§0.5/§11).

### 12.6 Localization
1. `app_en.arb` `appName` = **"Plantio Coletivo"** — the public brand is **Grovely**; update (and resolve the V2/working-title ambiguity).
2. Several screens I specced need new ARB keys (durations preview, streak, circle live counts, paywall comparison rows, cancel-confirm, auth states). These are enumerated implicitly by the microcopy above; both `pt` and `en` must ship (briefing: i18n pt+en).
3. Existing copy is serviceable but generic — adopt the warmer, calmer Grovely voice (encouraging, never scolding; note "withered" copy must avoid shame — current "Try again." is okay but the §2.4 version is kinder).

---

## 13. Open questions / dependencies (flag to PM + engineering)
1. **Brand name in code** ("Plantio Coletivo") vs **Grovely** — resolve before any string ships.
2. **Pricing numbers** for the paywall (annual/monthly, the "Save 40%" claim must be true) — needed to finalize §7 copy. Placeholder `{price}` used throughout.
3. **Rewarded-ad provider + revive caps** (per session/day) — affects §2.4 honesty copy.
4. **League mechanics** (promote/relegate counts, tiers list) — affects §5 legend + result copy.
5. **Circle privacy spec** — confirm exactly what's shared (first name + tree count assumed) for the LGPD-minimal reassurance lines.
6. **Reduce-motion + haptics** confirmation across §11.
