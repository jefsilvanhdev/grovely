# Prompt para o Claude Design — Brand Book (HTML) + Export de Assets

> Cole o bloco abaixo no **claude design**. É autocontido. Pede 2 coisas:
> (1) um **brand book visual em HTML** e (2) os **assets exportados** nos
> formatos que o app Flutter precisa. Se ele usar Figma, no fim do prompt há a
> opção de entregar só o link.

---

Você é diretor de identidade visual. A marca já existe — nome, conceito, paleta
e fontes definidos abaixo. **Mantenha a essência**; pode refinar execução, não
reinventar. Entregue um **brand book em HTML** + os **assets exportados**.

## A marca: Grovely

- **App:** timer de foco em que você planta uma árvore que cresce enquanto
  mantém o foco; sair do app antes do fim faz murchar. Sessões viram um jardim
  pessoal. **Diferencial = coletivo:** focar em tempo real com um "círculo"
  (6–12 pessoas) faz um jardim de grupo florescer, com liga semanal.
- **Público:** global (inglês primeiro), 18–35, estudantes e knowledge workers
  que se motivam em grupo.
- **Tom:** calmo, encorajador, vivo. Natureza + leveza. Sem dark patterns,
  sem gamificação agressiva, sem corporativês.
- **Concorrente a NÃO imitar:** "Forest" (foco solo). Nosso coração é o
  **coletivo / jardim em grupo**.
- **Conceito do símbolo:** 3 brotos saindo de uma base comum = "crescer junto".
- **Paleta** (HEX — refine contraste, mantenha a família verde+sol):
  - claro: primary `#2E7D52` · accent `#E0A458` · surface `#F4F7F2` ·
    onSurface `#1B2620` · muted `#4E5E54`
  - escuro: primary `#5FC58A` · accent `#F0BE78` · surface `#0F1A14` ·
    onSurface `#E7F0E9`
  - estados de árvore: saudável `#3FA56B` · murcha `#9A8C7A`
- **Tipografia:** Fraunces (display/timer/títulos) + Plus Jakarta Sans (UI/corpo)
  — Google Fonts, licença livre.

## Entregável 1 — Brand Book (1 arquivo HTML)

`brand-book.html` — **autocontido** (CSS inline, SVG inline; único externo
permitido = Google Fonts via CDN), visual e bem diagramado, responsivo, com
**modo claro e escuro demonstrados**. Seções obrigatórias:

1. **Capa** — wordmark grande, tagline ("Foco que cresce — juntos." / EN: "Focus
   that grows — together."), fundo verde da marca.
2. **Essência** — purpose, positioning, personality (3–5 palavras), o que
   evitar (Forest).
3. **Logo** — wordmark, símbolo, versão monocromática; **clear space**, tamanho
   mínimo, e um grid de **usos proibidos** (esticar, recolorir, sombra, girar).
4. **Cor** — paleta clara e escura com swatches + HEX + papel de cada token;
   nota de **contraste AA**.
5. **Tipografia** — espécimes de Fraunces e Plus Jakarta Sans, escala (H1→label),
   exemplo do timer (ex: "25:00").
6. **Símbolo & ícone** — app icon claro/escuro + adaptive (foreground + bg).
7. **Ilustração** — biblioteca de árvores: estágios (semente → broto → jovem →
   adulta) + estado murcho; regras de traço/estilo.
8. **Voz & tom** — princípios + exemplos "diga assim / não assim".
9. **Em uso** — 3 mockups de tela (sessão de foco com árvore, jardim pessoal,
   jardim coletivo "X focando agora").
10. **Rodapé** — versão, data, lista dos arquivos de asset.

## Entregável 2 — Assets exportados

Salve nesta estrutura de pastas e nomes:

```
brand/
├── brand-book.html
├── logo/
│   ├── grovely-wordmark.svg
│   ├── grovely-symbol.svg
│   └── grovely-logo-mono.svg
├── icon/
│   ├── grovely-icon-1024.png            (opaco, quadrado, SEM cantos arredondados)
│   └── grovely-adaptive-foreground-1024.png  (transparente; bg sólido #2E7D52)
├── trees/
│   └── <tipo>-<estagio>.svg             (5 tipos + 1 sazonal; estágios: seed, sprout, young, adult, withered)
├── tokens.json                          (cores light/dark + fontes + radius)
└── mockups/
    └── *.png
```

### Formatos (regras rígidas — app é Flutter)
- **Vetores** (logo, símbolo, ícone-foreground vetorial, árvores): **SVG
  otimizado** para `flutter_svg`:
  - **texto convertido em curvas** (outline) — nada de fonte referenciada
  - **sem filtros, blur, máscaras, CSS embutido, `<use>` externo**
  - gradiente linear simples = ok; use `fill`/`stroke` diretos
  - viewBox quadrado quando fizer sentido; sem `width/height` fixos em px
- **Ícone do app:** PNG **1024×1024**, opaco, sem cantos arredondados.
- **Adaptive foreground:** PNG 1024 transparente, símbolo dentro da zona segura
  (~66% central); informe a cor de fundo (`#2E7D52`).
- **Árvores se rasterizar:** PNG transparente **@1x/@2x/@3x**.
- **tokens.json**: `{ "color": { "light": {...}, "dark": {...} }, "type": {
  "display": "Fraunces", "body": "Plus Jakarta Sans" }, "radius": {...} }`.
- **Mockups:** PNG (referência, não embarcam).

## Biblioteca de árvores
5 tipos distintos + 1 sazonal, **mesmo traço/estilo**, cada um nos 4 estágios
(semente → broto → jovem → adulta) + 1 versão **murcha** (sessão falha).

## Saída
Devolva os arquivos na estrutura acima. **Se você trabalha em Figma:** pode, em
vez de exportar à mão, me dar o **link do arquivo Figma** organizado em páginas
(Logo · Cor · Tipografia · Árvores · Telas · Brand Book) — eu puxo os assets e
tokens direto pelo Figma MCP.
