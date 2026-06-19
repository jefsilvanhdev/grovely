# Grovely — Navigation & Flow Map

Companion to `SCREENS_SPEC.md`. Shows which screen leads to which, where the **paywall** gates,
and where the **social opt-in** lives. Section numbers (§) refer to the spec.

Legend: `──▶` navigates · `⤵ sheet` opens a bottom sheet · `🔒 gate` conditional/blocking ·
`★ opt-in` social opt-in point · `$ paywall` monetization point.

---

## 1. First-run flow (cold install → planted → trial decision)

```
                                   ┌──────────────────────────────────────────────┐
   INSTALL                          │   ★ opt-in lives at step 1.3 (default: Solo)  │
     │                              └──────────────────────────────────────────────┘
     ▼
 [1.1 Welcome] ──"Get started"──▶ [1.2 Notifications pre-prompt] ──▶ [1.3 Social opt-in ★]
     │                                   │  (OS dialog; deferrable)        │ (Solo | Circle)
     │ "I already have an account"       │                                 │
     ▼                                   ▼                                 ▼
 [9.1 Auth · sign in] ───────────▶ (advance regardless of grant)  [1.4 Guided first session]
     │                                                                     │  (5-min, forgiving,
     │ success                                                             │   no wither, no skip)
     ▼                                                                     ▼  completes → tree!
 (into shell · §2 Focus) ◀───────────────────── $ ───────── [1.5 / §7 Paywall (rigid, honest)]
                                                                  │            │
                                            "Start 21-day trial" $│            │"Continue with Free"
                                                                  └────────────┴────▶ (into shell)
```

**Notes**
- The **only forced stops** are Welcome → … → Guided session → Paywall. Every permission/social
  screen is **skippable**; the paywall always exposes **Continue with Free** (≤1 tap).
- Account is **not** required to enter the app (anonymous/guest). Auth is offered up front only via
  the "already have an account" link, and later via Profile (§8.4).
- After onboarding, the app lands on the **Focus** tab inside `MainShell`.

---

## 2. Persistent shell (5-tab bottom nav, `MainShell`)

```
┌───────────────────────────── MainShell (StatefulShellRoute) ─────────────────────────────┐
│   [ Focus ]      [ Garden ]      [ Circle ]      [ League ]      [ Profile ]              │
│      §2             §3              §4              §5              §8                      │
└───────────────────────────────────────────────────────────────────────────────────────────┘
        ▲ nav HIDES while a focus session is RUNNING (§2.2 / review 12.2.3)
```

Each tab keeps its own navigation state. Deep links cross tabs (e.g. a Focus "live" chip → Circle).

---

## 3. Focus tab (core loop) — internal state machine

```
 [2.1 Selecting] ──"Plant & focus"──▶ [2.2 Running] ──(timer hits 0)──▶ [2.3 Completed ✓]
      │  ▲                                  │                                  │
      │  │ "Plant another"                  │ background app / "Give up"✔      │ "View garden" ──▶ §3
      │  └──────────────────────────────────┼────────────────┐                │ milestone "Share" ─▶ §6
      │                                       ▼                │                ▼
      │  live chip ──▶ §4.4                [2.4 Withered ✗]    │           [2.1 Selecting]
      │  Custom dur. ⤵ sheet ($ premium)      │ ⤵ Revive sheet │
      │                                        │  ($ rewarded ad, capped, opt-in)
      │                                        │   success → tree revives → §2.3-like plant
      └──"Give up" ⤵ confirm sheet ───────────┘   "Start fresh" ──▶ [2.1 Selecting]
```

- **$ monetization (non-blocking):** "Custom duration" is premium-gated (opens paywall if free);
  **Revive** uses a **rewarded ad by explicit choice only** (never auto, never required, capped).
- Backgrounding during a *real* session is the canonical fail → Withered. The guided onboarding
  session (§1.4) is exempt (forgiving).

---

## 4. Garden tab

```
 [3.1 Garden grid] ──tap tile──▶ [3.2 Tree detail] ──"Share"──▶ system share sheet
      │  (header: streak + stats)        │
      │                                   └──"Set as favorite" (inline)
      │ empty → "Plant your first tree" ──▶ Focus (§2.1)
      └ loading = skeleton tiles · error = inline + Retry
```

---

## 5. Circle tab (the differentiator) — ★ social, opt-in throughout

```
                          ┌─ in a circle? ─┐
 [4.1 Circle home] ──NO──▶│  (empty state) │──"Create a circle" ⤵ [4.2 Create sheet] ─success─┐
        │                  └────────────────┘──"Join with a code" ⤵ [4.3 Join sheet] ─success─┤
        │ YES                                                                                  ▼
        └──────────────────────────────────────────────────────────────────▶ [4.4 Circle detail]
                                                                                    │  • collective garden
   [4.4 Circle detail] ──"This week" card──▶ §5 League                              │  • LiveDot "N focusing now"
        │  ⤵ invite sheet (share code)                                              │  • members list
        │  ⤵ leave-circle confirm (≤2 taps) ──▶ back to [4.1]                        │
        └─ member focusing → LiveDot · offline → "Reconnecting…" bar                │
```

- **★ opt-in:** joining/creating a circle is always a user action; presence is **ambient only**
  (no taps inside Running that could break focus). **Leaving is ≤2 taps**, no guilt.
- A free user gets **1 circle**; additional circles are a **$ premium** unlock (honest, shown in §7).

---

## 6. League tab (circle-gated)

```
 [5.1 League standings] ── 🔒 not in a circle ──▶ explainer ──"Join a circle"──▶ §4 Circle
        │  • tier badge + countdown + your sticky row + ranked list
        │  • week rollover → results overlay ("promoted!/held") ──"Share"──▶ §6 Recap
        └  loading = skeletons · offline = last-synced + "Reconnecting…"
```

- League is honestly **a circle benefit**: solo users see why and a path in, not a locked tease.

---

## 7. Recap (entered from multiple places)

```
 entry points:  §2.3 milestone "Share"   §5 league-result "Share"   (and a Profile/Recap surface)
                         └──────────────┬───────────────┬─────────┘
                                        ▼
                              [6.1 Weekly recap card]
                                  │  "Share my week" ──▶ system share (Stories/Reels 9:16)
                                  │  "Save image" ──▶ saved to device
                                  └  empty week → "A fresh week to grow" ──▶ Focus (§2.1)
```

---

## 8. Profile / Settings + Auth + Paywall (entered from many surfaces)

```
 [8.1 Profile home]
     ├─ "Account" ─────────▶ [8.4 Link/upgrade account] ──provider──▶ [9.1 Auth (upgrade variant)]
     ├─ "Subscription" ────▶  if FREE  ── $ ──▶ [§7 Paywall]
     │                        if PREMIUM ─────▶ [8.3 Manage/Cancel] ⤵ confirm (≤2 taps)
     ├─ "Notifications" ───▶ [8.2 Notification settings] (OS-denied → "Open Settings")
     ├─ "Appearance" ─────▶  theme: System / Light / Dark
     ├─ "Privacy" ────────▶  privacy policy · export/delete data (LGPD)
     ├─ "Terms" · "About/version" · "Restore purchases"
     └─ "Sign out"

 GUEST users: identity header shows "Guest" + "Save your progress" ──▶ [8.4] ──▶ [9.1]
```

### Where the Paywall (§7) can be reached
1. **Onboarding** step 1.5 (rigid, after first tree) — the primary funnel.
2. **Profile → Subscription** when on Free.
3. **Soft gates** when a free user taps a premium affordance: Custom duration (§2.1), extra circles
   (§4), recap themes (§6), advanced stats (§3/§8). Each gate is honest ("This is a Premium feature")
   and offers a clear path to §7 **and** a way back — never a blocking wall mid-task.

> The paywall **never** appears to someone already on trial/Premium — that entry resolves to the
> **Manage** view (§8.3) instead.

---

## 9. Global state routing (applies on every screen)
- **Loading** → skeletons (content) / button spinners (actions). Never a bare full-screen spinner on content.
- **Empty** → symbol watermark + headline + one helper + one primary action.
- **Error** → inline card + `Retry`; cached content stays; never a dead end.
- **Offline** → Focus/Garden/Streak fully usable (local-first); Circle/League/Recap show
  "Reconnecting…" + last-synced data.
- **Reduce-motion** → crossfades replace spring/scale growth + pulses.

---

## 10. One-glance summary of gates
| Gate | Type | Where | Rule |
|---|---|---|---|
| Social opt-in | ★ opt-in | Onboarding §1.3; Circle tab §4 | Default Solo; always user-initiated; leave ≤2 taps |
| Trial / Premium | $ paywall | Onboarding §1.5; Profile §8.1; soft feature gates | Honest free column; **Continue with Free** always ≤1 tap |
| Rewarded ad | $ opt-in ad | Withered → Revive §2.4 only | Explicit choice, never interrupts focus, capped, honest |
| League | 🔒 circle-gated | League tab §5 | Solo users get explainer + path in, not a locked tease |
| Cancel subscription | — (anti-gate) | Profile §8.3 | As easy as subscribing: **≤2 taps**, no retention maze |
| Account | (deferred) | Profile §8.4 / Auth §9 | Anonymous-first; link later; data migrates |
```
