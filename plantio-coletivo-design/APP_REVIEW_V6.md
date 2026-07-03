# App Review V6 — Grovely pós-rebrand

**Data:** 2026-07-03 · **Base:** screenshots do build `2cf09da` no emulador (Pixel 8) vs mockups `Plantio-V2/brand/mockups/` + tokens v6.
**Escopo:** aderência visual ao brand v6, hierarquia, tipografia, cor, microcopy, momentos de deleite. Telas sem screenshot (circle com dados, league, profile, recap) avaliadas por código — sinalizadas.

---

## Veredito geral

O rebrand pegou. A Illustration 2.0 transforma o app: as árvores têm profundidade, luz e acento quente, e aparecem consistentes do onboarding ao jardim. A splash animada é o melhor momento de marca do app. A sessão imersiva escura está **no nível do mockup** — é a tela mais importante e está pronta pra screenshot de loja. Restam desvios P1 de composição no jardim e no paywall, e um punhado de P2.

---

## Tela a tela

### Splash (sc_4 vs brand v6) — ✅ fiel
- Bosque orgânico + sol + wordmark, cores do foreground nativo (centro quase-branco, laterais mint, chão escuro). Emenda com a nativa sem pulo de cor.
- **P2:** wordmark entra por fade+rise; o mockup do DS sugere leve overshoot no assentamento — hoje só o bosque tem `easeOutBack`. Opcional.

### Sessão de foco — running (focus_dark vs mockup 01) — ✅ quase 1:1
- Header "DEEP WORK" mint caps + `species · min` ✓, anel mint sobre trilha escura ✓, timer branco tabular ✓, subtitle ✓, stop ghost ✓.
- **P1: capitalizar a espécie no meta do header** — mockup mostra "Oak · session 3", app mostra "bush · 1 min" (minúscula). Fix: capitalizar `speciesName` ali.
- **P2:** mockup tem 2 botões (Give up ghost + Pause mint). Produto decidiu **sem pause** (filosofia Forest) — correto; registrar a decisão pra ninguém "corrigir" depois.
- **Melhor que o mockup:** fundo esquenta gradualmente até verde-amanhecer conforme o progresso — manter.

### Home / selecting (app_home) — ✅ bom
- Árvore madura gigante + dial + CTA. Streak badge no topo.
- **P2:** área da árvore não comunica que a espécie muda por sessão; considerar chip com o nome da espécie tocável (educa a coleção).

### Onboarding (home/ob2/ob3/ritual/ritual_done) — ✅ acima do esperado
- Watermark v6 no hero ✓, ritual de 30s com árvore crescendo dentro do anel é o melhor onboarding do gênero que já vimos — **não redesenhar do zero; iterar**.
- **P1:** página 1 — título "Grovely" + watermark disputam o mesmo centro; a copy passa por cima das árvores com contraste apertado. Dar mais respiro (watermark menor ou deslocada pra baixo).
- **P2:** bell âmbar da página de notificações é o único ícone grande chapado do app; usar a linguagem de ilustração (sino com folha?) quando houver tempo de designer.

### Paywall (ob5 vs mockup 04) — ✅ direção certa, composição P1
- Dark + marca no topo + tabela comparativa honesta (mais informativa que o checklist do mockup — manter a tabela).
- **P1: CTA fora da dobra.** No 1080×2400 o "Try free for 21 days" fica no limite e "Restore purchases" corta. Mockup resolve com menos linhas. Opções: reduzir py das rows, ou CTA sticky no rodapé.
- **P1: "price TBD" visível ao usuário** ("Free for 21 days, then price TBD") — honesto demais; até ter preço real, trocar por "cancele quando quiser" sem mencionar preço.
- **P2:** mockup tem caixa de reassurance ("No ads, ever…") — boa adição quando os termos existirem.

### Jardim (garden_v6 vs mockup 02) — ✅ estrutura igual, densidade P1
- Header card com contagem + pills ✓, grid 3col ✓, slot "+" ✓ (mockup match exato), share no AppBar ✓.
- **P1: pills redundantes** — "1 tree" (título) + "Best: 1 days" + "0h focused" no primeiro uso parecem debug. Regra: esconder "Best:" enquanto `longest == current` e "0h" enquanto < 1h.
- **P1 (código): "1 days"** — plural errado em EN para valor 1; conferir ICU plural nos .arb (`statLongest`).
- **P2:** mockup pinta tile murcho com tint quente — jardim só guarda árvores completas hoje, ok ignorar.

### Círculo (avaliado por código + mockup 03)
- Card do bosque com gradiente mint + overline caps ✓ (mockup). Pódio da liga já existia.
- **P1:** mockup tem linha de presença ("8 of 12 focusing now" + avatares) — depende do realtime (bloqueio Jeff), registrar como pendência de produto, não de design.
- **P2:** CTA grande "Join the circle's session" do mockup não existe; depende de presença. Idem.

### Recap / Profile / League (por código)
- Recap 9:16 ✓ já verificado em sessão anterior. **P2:** entrada única via ícone share no jardim é pouco descobrível (ver usability report).
- Profile: rows Privacidade/Termos/Sair mortas (`onTap: (){}`) — **P0 de confiança**, listado também no QA (I7). Esconder no beta.

---

## Não regredir (está melhor que o mockup)
1. Fundo que esquenta na sessão conforme progresso.
2. Tabela comparativa honesta no paywall (vs checklist só-benefícios).
3. Ritual de 30s no onboarding com árvore real crescendo.
4. Confete de folhas + haptics no completed.
5. Slot "+" do jardim com `Semantics` correto.

## Prioridades do designer
| P | Item | Tela |
|---|---|---|
| P0 | Esconder rows mortas (Privacidade/Termos/Sair) | Profile |
| P1 | CTA do paywall fora da dobra + "price TBD" exposto | Paywall |
| P1 | Espécie minúscula no header da sessão | Foco |
| P1 | Pills redundantes/plural "1 days" no primeiro uso | Jardim |
| P1 | Respiro título × watermark | Onboarding p.1 |
| P2 | Overshoot no wordmark da splash · chip de espécie na home · bell ilustrado · reassurance box | várias |
