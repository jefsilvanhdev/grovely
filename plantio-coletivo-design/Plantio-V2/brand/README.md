# Grovely — Brand assets

Identidade v6 · "Foco que cresce — juntos."

```
brand/
├── brand-book.html                 # Brand book v6 completo, autocontido (abre offline)
├── logo/
│   ├── grovely-symbol-v6.svg        # Marca v6 — bosque orgânico com profundidade + sol
│   ├── grovely-wordmark.svg         # Palavra "Grovely" (Bricolage Grotesque 700, em curvas)
│   ├── grovely-symbol.svg           # Marca v4 (geométrica, legado)
│   └── grovely-logo-mono.svg        # Lockup v4 1 cor (legado)
├── icon/
│   ├── grovely-icon-v6-1024.png     # App icon v6, opaco, quadrado, sem cantos arredondados
│   ├── grovely-adaptive-foreground-v6-1024.png  # Foreground transparente · bg #2E7D52
│   └── grovely-icon-1024.png        # v4 (legado)
├── trees/                           # Illustration 2.0 — 6 tipos × estágios
│   └── <tipo>-<estagio>.svg         # seed · sprout · sapling · young · mature · elder · withered
│                                    # oak e pine também têm -centenarian
├── trees-v1/                        # Biblioteca anterior, arquivada
├── tokens.json                      # cores light/dark + fontes + radius
└── mockups/                         # PNGs de referência (não embarcam)
```

## Illustration 2.0
Mesma construção "organic soft" + 3 movimentos novos: copa de fundo mais escura
(profundidade), cluster de highlight no topo-esquerdo (luz) e 1 acento quente por
espécie (bolotas, pinhas, pétalas — família âmbar/blossom, máx. 3 por árvore).
Troncos sempre encostam na copa. Bétula tem tronco branco característico.

## SVG → Flutter (`flutter_svg`)
Todos os SVGs são limpos: sem `<use>`, filtros, máscaras ou CSS embutido; `fill`/`stroke` diretos; texto convertido em curvas; `viewBox` sem `width/height` fixos.

## Tipos de árvore
`oak`, `pine`, `round-bush`, `willow`, `birch`, `cherry-blossom` (sazonal).
Nível **centenarian** existe só para espécies de grandes exemplares: `oak` e `pine`.

## Fontes (Google Fonts, licença livre)
- Display/títulos/timer: **Bricolage Grotesque**
- UI/corpo: **Hanken Grotesque**
