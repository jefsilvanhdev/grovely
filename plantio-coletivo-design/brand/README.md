# Grovely — Brand assets

Identidade v4 · "Foco que cresce — juntos."

```
brand/
├── brand-book.html                 # Brand book completo, autocontido (abre offline)
├── logo/
│   ├── grovely-wordmark.svg         # Palavra "Grovely" (Bricolage Grotesque 700, em curvas)
│   ├── grovely-symbol.svg           # Marca — bosque de pinheiros + sol
│   └── grovely-logo-mono.svg        # Lockup marca + palavra, 1 cor (#18241D)
├── icon/
│   ├── grovely-icon-1024.png        # App icon, opaco, quadrado, sem cantos arredondados
│   └── grovely-adaptive-foreground-1024.png  # Foreground transparente · bg #2E7D52
├── trees/                           # 6 tipos × estágios (organic soft)
│   └── <tipo>-<estagio>.svg         # seed · sprout · sapling · young · mature · elder · withered
│                                    # oak e pine também têm -centenarian
├── tokens.json                      # cores light/dark + fontes + radius
└── mockups/                         # PNGs de referência (não embarcam)
    ├── 01-focus-session.png
    ├── 02-personal-garden.png
    ├── 03-collective-garden.png
    └── 04-paywall.png
```

## SVG → Flutter (`flutter_svg`)
Todos os SVGs são limpos: sem `<use>`, filtros, máscaras ou CSS embutido; `fill`/`stroke` diretos; texto convertido em curvas; `viewBox` sem `width/height` fixos.

## Tipos de árvore
`oak`, `pine`, `round-bush`, `willow`, `birch`, `cherry-blossom` (sazonal).
Nível **centenarian** existe só para espécies de grandes exemplares: `oak` e `pine`.

## Fontes (Google Fonts, licença livre)
- Display/títulos/timer: **Bricolage Grotesque**
- UI/corpo: **Hanken Grotesque**
