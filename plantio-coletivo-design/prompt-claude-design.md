# Prompt para o Claude Design

> Cole o bloco abaixo no **claude design** (Claude com Figma/geração de imagem).
> É autocontido. Se ele tiver Figma, peça entrega em Figma; senão, SVG + PNG.

---

Você é diretor de identidade visual. Crie a identidade completa de um **app
mobile de foco e produtividade**.

## O produto
Timer de foco em que o usuário planta uma árvore que cresce enquanto mantém o
foco; se sair do app antes do fim, a árvore murcha. Sessões concluídas viram um
**jardim pessoal**. O diferencial é o **coletivo**: focar em tempo real com um
"círculo" de 6–12 pessoas faz um **jardim de grupo** florescer, com liga semanal.

- **Público:** global (inglês primeiro), 18–35, estudantes e knowledge workers
  que querem foco e se motivam em grupo.
- **Tom:** calmo, encorajador, vivo. Natureza + leveza. NÃO gamificado-agressivo,
  NÃO corporativo, sem dark patterns.
- **Concorrente a evitar parecer:** "Forest" (foco solo). Nosso coração é o
  **coletivo/jardim em grupo** — a identidade deve sentir mais comunidade e
  crescimento compartilhado.

## Nome
Nome de trabalho: "Plantio Coletivo". Para o mercado global avalio 3 nomes —
**valide/critique** e desenhe o wordmark do recomendado, mostrando os 3:
1. **Grovely** (recomendado) — "grove" = bosque pequeno = jardim coletivo.
2. **Bloomwork** — florescer + foco/trabalho.
3. **Tendwell** — cuidar (do jardim) + bem-estar.

## Entregáveis
1. **Logo / wordmark** (do nome recomendado) + versão monocromática.
2. **Símbolo / app icon**: broto/folhas formando um círculo (ideia de
   "coletivo"). Precisa funcionar como **ícone 512×512** e como **adaptive icon
   Android** (camada *foreground* = símbolo, *background* = cor sólida).
3. **Paleta** clara e escura, com tokens nomeados e HEX
   (`primary`, `accent`, `surface`, `onSurface`, `treeHealthy`, `treeWithered`).
   Ponto de partida (refine à vontade): primary verde-folha `#2E7D52`, accent
   sol `#E0A458`. Garanta contraste AA.
4. **Tipografia**: par de fontes (Google Fonts, licença livre) — uma humanista
   de título com calor, uma sans limpa de UI. Mostre hierarquia (H1, H2, corpo,
   label).
5. **Biblioteca de árvores/plantas**: 5 tipos + 1 sazonal, mesmo estilo de
   ilustração, cada um em 4 estágios (semente → broto → jovem → adulta) + 1
   estado **murcho** (sessão falha).
6. **Mockups de 4 telas** (mobile, Material 3): (a) sessão de foco com árvore
   crescendo + timer, (b) jardim pessoal em grid, (c) jardim coletivo do círculo
   com "X pessoas focando agora", (d) paywall premium honesto.

## Restrições técnicas
- App em **Flutter / Material 3**, claro e escuro obrigatórios.
- Ícone legível em 48px; símbolo simples, sem detalhe fino.
- Ilustrações exportáveis (SVG preferível; PNG @1x/@2x/@3x).
- Entregue **tokens de cor e tipografia em formato copiável** (lista HEX +
  nomes de fonte) para eu codar direto no tema do Flutter.

## Formato de saída
Se tiver Figma: um arquivo com páginas Logo · Cores · Tipografia · Árvores ·
Telas. Senão: SVGs do logo/ícone/árvores + PNG dos mockups + um resumo de tokens
em markdown.
