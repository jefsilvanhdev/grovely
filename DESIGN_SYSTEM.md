# Design System — Grovely

> **Fonte da verdade:** [`plantio-coletivo-design/brand/brand-book.html`](plantio-coletivo-design/brand/brand-book.html)
> (abre offline no navegador) + [`brand/tokens.json`](plantio-coletivo-design/brand/tokens.json).
> Tokens implementados em `app/lib/core/theme/`. Nome validado: **Grovely**
> (ver `plantio-coletivo-design/brand-brief.md`).

## Logo & símbolo

Símbolo: bosque de pinheiros + sol (crescer junto). Assets em `app/assets/brand/`:

| Asset | Arquivo |
|---|---|
| Wordmark | `assets/brand/logo/grovely-wordmark.svg` |
| Símbolo | `assets/brand/logo/grovely-symbol.svg` |
| Mono (lockup) | `assets/brand/logo/grovely-logo-mono.svg` |
| Ícone app (1024) | `assets/icon/grovely-icon-1024.png` |
| Adaptive foreground | `assets/icon/grovely-adaptive-foreground-1024.png` (bg `#2E7D52`) |

No app: `GrovelyLogo` (`shared/widgets/grovely_logo.dart`) renderiza o SVG via
`flutter_svg`. Launcher icon e splash gerados (`flutter_launcher_icons` +
`flutter_native_splash`, fundo `#2E7D52`).

## Cores (brand/tokens.json)

| Token | Claro | Escuro |
|---|---|---|
| primary | `#2E7D52` | `#6FD79B` |
| accent | `#E0A458` | `#F0B978` |
| background | `#F3F6F1` | `#0F1A15` |
| surface | `#FFFFFF` | `#16221C` |
| onSurface | `#18241D` | `#E7F0E9` |
| treeHealthy | `#43A86B` | `#5FD394` |
| treeWithered | `#A89274` | `#B9A488` |

## Tipografia

- **Display / timer / títulos:** Bricolage Grotesque
- **UI / corpo:** Hanken Grotesk
- Ambas Google Fonts (livre). Wiring em `app/lib/core/theme/app_theme.dart`.

Radius: sm 8 · md 14 · lg 20 · xl 28 · pill 999 (`AppRadius`).

## Biblioteca de árvores

6 tipos × estágios em `app/assets/brand/trees/`:
`oak`, `pine`, `round-bush`, `willow`, `birch`, `cherry-blossom` (sazonal).
Estágios: `seed · sprout · sapling · young · mature · elder · withered`
(`oak` e `pine` também têm `centenarian`). Nomes: `<tipo>-<estagio>.svg`.
