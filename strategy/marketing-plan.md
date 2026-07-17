# Grovely — Plano de Marketing (12 meses)

**Data:** 2026-07-17 · **Estágio:** pré-lançamento (beta fechado pendente) · **Time:** Jeff (solo) + agentes
**Parâmetros definidos pelo Jeff:** mercado **Brasil (pt) primeiro** · orçamento **R$0 (orgânico)** · meta 6 meses **volume de instalações**

---

## 1. Sumário executivo (leia em 60s)

Grovely é um app de foco que planta árvores — mas o que o diferencia do Forest (líder absoluto) **não é a árvore, é o círculo**: 6–12 pessoas focando no mesmo bosque, com liga semanal. Com R$0 e meta de instalações no Brasil, o plano tem **três apostas**:

1. **ASO em português é o canal #1.** É o único canal de aquisição gratuito, permanente e escalável que existe pra app. Forest não otimiza pra long-tail PT ("app de foco em grupo", "foco para estudar juntos"). É onde o Grovely ganha barato.
2. **O convite de círculo é o motor de crescimento, não uma feature.** Cada usuário que cria um círculo traz 5–11 pessoas. Nenhum outro canal com R$0 tem esse multiplicador. **Todo o plano existe pra empurrar usuários até "criar/entrar num círculo".**
3. **Comunidades de estudo brasileiras são o campo de caça.** Concurseiros, vestibulandos e universitários já se organizam em grupos pra estudar juntos — e sofrem exatamente o problema que o círculo resolve. É distribuição gratuita e altamente qualificada.

**90 dias:** destravar os 3 bloqueios (DNS, migration, Data Safety) → beta com 12 testadores (gate da Play) → ficha pt-BR afiada → produção → sementeadura em 8–10 comunidades → TikTok/Reels de estudo.
**12 meses:** ~10–25k instalações orgânicas no BR, 200+ círculos ativos, ASO ranqueando no top-10 de 5 termos long-tail, e os números de retenção que destravam a decisão de paid.

**Tradeoff que eu preciso nomear:** você escolheu *volume de instalações* como meta. Instalação é fácil de comprar atenção e fácil de perder — e a Play **ranqueia por retenção e desinstalação**, não por download bruto. Instalar 10k com D7 de 5% faz o app **cair** no ranking e queima as comunidades (só dá pra pedir uma vez). Então: meta = instalações, **guardrail = D7 ≥ 20% e desinstalação em 7 dias ≤ 40%**. Se o guardrail estourar, a gente para de captar e conserta antes de continuar. Isso não é diluir sua meta — é o que faz a meta durar.

---

## 2. Frame estratégico

**Claim de categoria:** *o app de foco em grupo.* Não "mais um pomodoro", não "o Forest brasileiro". A frase que vende: **"Foco é melhor em bando."**

**ICP primário (BR, 6 meses):**
- **Concurseiro / vestibulando (18–35)** — estuda 4–8h/dia, sofre com celular, já está em grupo de WhatsApp/Discord de estudo, mede o próprio esforço em horas. É o mais desesperado pelo produto e o mais organizado em comunidade. **Prioridade 1.**
- **Universitário (18–26)** — TCC, provas, trabalho em grupo. Alta afinidade com estética e com compartilhar progresso. **Prioridade 2 (motor de viralidade visual).**
- Secundários (não perseguir agora): trabalhador de deep work, pessoa querendo largar o celular.

**Por que o círculo importa pro ICP:** estudar sozinho falha. Esses grupos já existem ("bora estudar às 19h"), mas coordenam por mensagem e ninguém tem prova de quem realmente focou. Grovely dá **presença, prova e placar** — sem feed, sem exposição.

**Lógica de negócio:** grátis pra focar sozinho, pra sempre. Plus (círculos ilimitados, espécies, stats) é receita futura. **Nos próximos 6 meses a receita não é a meta** — o RevenueCat nem está plugado. O ativo que estamos construindo é *círculos ativos*, porque círculo é retenção e viralidade ao mesmo tempo.

**Voz (não negociável):** calma, direta, sem hype, sem exclamação, sem "!!!". O app fala com quem quer silêncio. Nada de "BAIXE AGORA 🔥🔥". Português real, não traduzido.

---

## 3. Estado atual (pontuado a partir do que existe)

| Área | Nota /5 | Realidade |
|---|---|---|
| Produto (core loop) | 4.5 | Sessão, jardim, murcha, streak — sólido e testado. Diferencial social **vivo** (círculo, liga, presence). |
| Identidade / design | 5 | Marca v6, ilustração própria, LP tier-awwwards. Ativo acima da média da categoria. |
| ASO / ficha | 3.5 | Copy pt/en/es escrita, 5 screenshots + feature graphic por idioma prontos. **Não publicada.** |
| Site / LP | 4 | Pronta, SEO/JSON-LD, 3 páginas. **DNS pendente → nada no ar.** |
| Analytics | 0 | **Firebase removido.** Zero telemetria. Não sabemos D1/D7 de nada. |
| Lifecycle (e-mail/push) | 0.5 | Só notificação local de streak. Sem e-mail (não há e-mail de usuário — conta anônima). |
| Comunidade | 0 | Nenhuma presença. Zero seguidores, zero lista. |
| Receita | 0 | RevenueCat não plugado. Paywall é UI. |
| Viralidade | 3 | Convite de círculo + recap compartilhável **existem no produto** — mas nunca foram usados por ninguém real. |

**Fase:** pré-receita, pré-usuário. O gargalo não é marketing — é **publicar**.

**Já feito que o plano respeita:** app completo em 3 idiomas, LP, política/termos, keystore, auditoria de segurança, assets de loja trilíngues, one-pager de parceria com ONG.

---

## 4. Aquisição — como estranhos descobrem

### 4.1 ASO (canal #1, permanente, grátis)
O único canal que trabalha 24/7 sem você. **60% do esforço vai aqui.**

**Realidade competitiva:** "foco", "pomodoro", "produtividade" = Forest e gigantes. Não brigue de frente. Ataque **long-tail que descreve o diferencial**:

| Termo alvo (pt-BR) | Por quê |
|---|---|
| app de foco em grupo | descreve o diferencial; Forest não otimiza |
| foco para estudar | intenção altíssima do ICP |
| estudar junto online | é literalmente o círculo |
| app para concentração nos estudos | long-tail de concurseiro |
| plantar árvore estudando | quem viu o Forest e procura alternativa |
| timer de estudo em grupo | funcional + diferencial |
| sala de estudo online | adjacente (Discord de estudo migra) |

**Movimentos:**
- Título: `Grovely: Foco em Grupo` (testar contra `Grovely: Foco que Cresce`) — "grupo" é o termo que carrega o diferencial e a busca.
- Descrição curta: densidade de "foco · estudar · juntos" nos primeiros 80 chars.
- Descrição longa: já escrita (`play-store/listing/aso-copy.md`), com os termos naturais no corpo.
- **Iterar a cada 4 semanas** com os dados do Play Console (a Play mostra os termos que trouxeram instalação). ASO é loop, não one-shot.
- **Resenhas = ranking.** Pedir avaliação in-app **só depois da 3ª árvore plantada** (nunca antes; nunca no meio da sessão).

**Skill:** `aso` · **Ferramenta:** Play Console (termos de busca)

### 4.2 Comunidades de estudo BR (canal #2 — instalações qualificadas em semanas)
Onde o ICP já está, organizado, e com o problema aberto:

| Onde | Como entrar |
|---|---|
| Reddit r/concursos, r/estudos, r/brasil, r/universitarios | **Não anunciar.** Participar 2 semanas antes. Depois: post honesto de "fiz um app pra estudar junto com meus amigos" (dev indie brasileiro vende bem lá) |
| Discords de estudo (Estudo em Grupo, concurseiros, "study with me") | Falar com o admin **primeiro**. Oferecer o círculo como recurso pro servidor — é feature, não spam |
| Telegram/WhatsApp de concurso | Só via admin. Alta conversão, alto risco de queimar. Um por semana, no máximo |
| Fóruns (Qconcursos, Estratégia — comunidades) | Presença longa, não campanha |

**Regra dura:** você só tem **uma** chance por comunidade. Não entre antes de o app estar bom e da ficha estar pronta. Nunca copie-cole o mesmo texto em 5 lugares.

**Ângulo que funciona:** *"Estudo com um grupo e a gente nunca sabia quem tava realmente focando. Fiz um app onde cada sessão planta uma árvore num bosque compartilhado."* — história pessoal + o problema deles. Não "baixe meu app".

### 4.3 TikTok / Reels de estudo (canal #3 — o único com upside viral em R$0)
Study-tok BR é gigante (#estudos #concurso #rotinadeestudos #studytok). O produto é **visualmente perfeito** pra vídeo curto: a árvore crescendo, o bosque enchendo, a árvore murchando quando você pega o celular.

- **3 posts/semana, 15–30s, sem falar.** Tela do app + música + legenda curta.
- Formatos que performam: (a) *"minha árvore morreu porque peguei o celular"*, (b) *timelapse do jardim enchendo em 30 dias*, (c) *"estudando com meu grupo às 6h"* (círculo + presence), (d) recap semanal.
- **Sem produção.** Gravação de tela + CapCut. O app já é bonito — não precisa de edição.
- Meta realista: 1 em 20 vídeos estoura. É loteria com bilhete grátis — o custo é o tempo.

**Nota:** você não tem Instagram. TikTok primeiro (maior alcance orgânico do BR pra esse nicho). Reels é reaproveitamento do mesmo vídeo, zero custo marginal.

### 4.4 PR / imprensa BR (canal #4 — pico único, alto valor)
Imprensa tech brasileira cobre app indie nacional. **História:** *designer brasileiro (SAP Concur) faz app de foco em grupo pra concorrer com o Forest.*

Alvos: **Tecnoblog, Canaltech, Olhar Digital, MacMagazine (quando iOS), Startups.com.br**.
Timing: **na semana da produção**, com a LP no ar. Um e-mail curto por veículo, personalizado, com 2 screenshots + 1 frase.

### 4.5 Diretórios + Product Hunt
Product Hunt é global/en — mas dá backlink, DR e um pico. Fazer **depois** de o BR validar. Diretórios de app indie: grátis, meia hora, backlink permanente.
**Skill:** `directory-submissions` · `launch`

### 4.6 O que NÃO vamos fazer (e por quê)
- **Paid (Meta/Google Ads):** R$0 e — mais importante — **sem RevenueCat e sem analytics, você não consegue medir CAC nem LTV.** Pagar por instalação sem saber se ela retorna é queimar dinheiro. Volta quando houver telemetria + receita.
- **Influencer pago:** mesmo motivo. Micro-influencer de estudo em permuta (conta Plus grátis) é possível no Q2 — não agora.
- **Instagram orgânico do zero:** custo de tempo alto, alcance orgânico baixo em 2026. TikTok entrega mais por hora investida.
- **Blog/SEO de conteúdo:** demora 6+ meses pra ranquear e compete com sites enormes. ASO entrega antes. Reavaliar no Q3.

---

## 5. Ativação — do install à primeira árvore

Instalar não é nada. **A ativação do Grovely é: plantar a 1ª árvore → e (o que importa) entrar num círculo.**

- **Já está forte:** o ritual guiado de 30s no onboarding é o melhor ativo de ativação do app (6/6 personas do teste plantaram). Não mexer.
- **Gap crítico:** o onboarding **não empurra pro círculo**. Hoje pergunta "sozinho ou com círculo?" e segue. Se o círculo é o motor de crescimento e retenção, o onboarding tem que terminar com **um convite pronto pra compartilhar** ("crie seu círculo e chame 2 amigos" com o botão de share já ali).
- **Gap:** sem analytics, não sabemos onde as pessoas caem. **Instalar analytics é pré-requisito da meta de instalações** — sem isso você não sabe qual canal traz gente que fica.

**Movimentos:** (1) plugar analytics (§11), (2) evento-chave `circle_created` / `circle_joined` como métrica de ativação real, (3) testar terminar o onboarding no fluxo de círculo.
**Skills:** `onboarding`, `analytics`

---

## 6. Retenção — o guardrail da sua meta

Não é a meta declarada, mas **protege** a meta: Play ranqueia por retenção; comunidade queimada não volta.

- **Já existe:** streak + lembrete diário + recap semanal + a liga que zera segunda (motivo semanal pra voltar).
- **A liga é o melhor ativo de retenção do app** e ninguém sabe que ela existe. Ela dá um motivo *social* pra voltar toda semana — muito mais forte que streak solo.
- **Faltando:** notificação de círculo ("seu círculo está focando agora", "a liga vira em 1 dia") — é o gancho que traz de volta. Depende do social estar em produção.
- **Sem e-mail:** conta anônima = zero lifecycle por e-mail. Aceito por ora; é o preço da simplicidade. Não construir agora.

**Guardrail:** D7 ≥ 20%, desinstalação 7d ≤ 40%. Medir a partir do 1º mês de produção.

---

## 7. Referral — o motor real (aqui está o crescimento)

**Isto não é uma seção secundária. É a aposta #2.**

O convite de círculo é um mecanismo de referral **embutido no valor do produto** — o usuário convida porque *ele* quer focar junto, não porque ganha desconto. É o tipo que funciona.

**Matemática simples:** se 20% dos instalados criam um círculo e cada círculo traz em média 3 pessoas de fora → k ≈ 0,6. Não é auto-sustentável (k<1), mas **corta o custo de aquisição pela metade** e é composto com os outros canais.

**Movimentos (todos já quase prontos no produto):**
1. **Convite mais visível** — hoje está atrás de um ícone. O estado vazio do círculo e o fim do onboarding devem empurrar o convite.
2. **Recap semanal = mídia grátis.** Já é bonito e compartilhável. Falta: um empurrão contextual no domingo ("seu recap está pronto") — hoje só quem procura o ícone de share acha.
3. **Link de convite** (não só código) — código exige digitar; link abre a Play e entra no círculo. **Maior alavanca de conversão do convite** (depende de deep link + assetlinks; hoje não existe).
4. **Marca no recap** — "Grown with Grovely" já está lá. ✅

**Skill:** `referrals`

---

## 8. Receita — fora de escopo nos 6 meses

Honestidade: sem RevenueCat, não há receita. E **isso está certo por enquanto** — cobrar antes de saber se as pessoas voltam é otimizar a coisa errada.

- **Q3+:** plugar RevenueCat, medir conversão do trial de 21 dias, aí sim considerar paid.
- **Preço:** o paywall já ancora anual vs mensal (-40%). Definir o número real quando o RevenueCat entrar. Referência: Forest cobra ~US$3,99 uma vez; assinatura precisa justificar recorrência — o social justifica.
- **Árvores reais (ONG):** o one-pager (`strategy/real-trees-partnership.md`) é **munição de marketing** e de conversão. Entra quando houver receita pra custear.

---

## 9. Roadmap 90 dias

### Semanas 1–2 — Destravar (você)
| # | Ação | Dono |
|---|---|---|
| 1 | **DNS grovely.com.br** → LP + política no ar | Jeff |
| 2 | **Aplicar migration 0004** (SQL Editor) | Jeff |
| 3 | **Decidir a conta Play** (ver §13 — muda o cronograma em 2 semanas) | Jeff |
| 4 | **Plugar analytics** (Firebase ou alternativa leve) — sem isso a meta é cega | Claude |
| 5 | Recrutar **12 testadores** (se a conta exigir o gate) | Jeff |

### Semanas 3–4 — Fundação
- Beta fechado rodando (14 dias correndo em paralelo com o resto).
- **Ficha pt-BR no Console** (assets prontos em `play-store/export/pt/`).
- Criar conta TikTok **@grovely** e postar os 3 primeiros vídeos (o app já dá material).
- Entrar (só participar, não divulgar) em 4 comunidades: r/concursos, r/estudos, 2 Discords de estudo.
- Onboarding → círculo (§5) + empurrão do recap (§7).

### Semanas 5–8 — Velocidade
- **Produção na Play.** Ficha pt-BR + en.
- **Semana de PR:** 5 e-mails (Tecnoblog, Canaltech, Olhar Digital, Startups, MacMagazine).
- Primeiro post nas comunidades onde você já é presente (1 por semana, nunca em lote).
- TikTok 3×/semana.
- 1ª iteração de ASO com dados reais do Console.

### Semanas 9–12 — Compor
- Link de convite (deep link) — a maior alavanca de referral.
- Product Hunt (en) + diretórios indie.
- 2ª iteração de ASO.
- **Checagem do guardrail:** D7 e desinstalação. Se estourou → parar captação, consertar.

---

## 10. 12 meses

| Trimestre | Foco | Marco |
|---|---|---|
| **Q1** (m1–3) | Publicar + primeiros usuários | Produção · ficha pt · 500–2.000 instalações · analytics vivo |
| **Q2** (m4–6) | Compor ASO + comunidade + TikTok | 3.000–10.000 instalações · 100+ círculos · D7 medido · 1 vídeo estourado |
| **Q3** (m7–9) | Monetizar + decidir paid | RevenueCat · trial medido · **se CAC < LTV → primeiro teste pago** · ONG fechada |
| **Q4** (m10–12) | Escalar o que provou | 10–25k instalações acumuladas · en/es ativos · árvores reais como gancho de PR |

**Destrava com dinheiro:** nada disso precisa de capital. O que muda com R$500–1.500/mês (Q3+, **só depois do RevenueCat**): teste de CAC no Meta/Google, e a resposta pra "dá pra comprar crescimento?".

---

## 11. Stack de operação (o que executa cada coisa)

| Estágio | Movimento | Skill | Ferramenta |
|---|---|---|---|
| Aquisição | ASO iterativo | `aso` | Play Console |
| Aquisição | Vídeo curto | `social` | CapCut + gravação de tela |
| Aquisição | Comunidade | `community-marketing` | Reddit/Discord |
| Aquisição | PR | `launch` | e-mail |
| Aquisição | Diretórios/PH | `directory-submissions` | — |
| Ativação | Onboarding → círculo | `onboarding` | app |
| Ativação | Telemetria | `analytics` | **decisão pendente** |
| Retenção | Notificação de círculo/liga | — | app |
| Referral | Link de convite, recap | `referrals` | deep link |
| Receita | Preço/paywall | `pricing` | RevenueCat |

**Time:** Jeff = estratégia, decisão, relacionamento em comunidade (isso não terceiriza — comunidade cheira agente). Claude = execução (ASO copy, roteiro de vídeo, código, assets, análise).

---

## 12. Banco de ideias (status)

**Agora:** ASO · comunidades de estudo · TikTok orgânico · PR BR · convite de círculo · recap share · avaliações in-app (pós-3ª árvore) · diretórios indie
**Q2:** Product Hunt · link de convite · notificação de círculo · micro-influencer de estudo (permuta) · parceria com Discord de estudo (círculo oficial do servidor)
**Q3+:** RevenueCat → paid test · ONG árvores reais (PR + conversão) · blog/SEO · en/es ativos · liga entre círculos (Fase B — feature = marketing)
**Skip (com motivo):** paid agora (sem CAC/LTV mensurável) · Instagram orgânico (ROI de tempo ruim) · influencer pago (sem unit economics) · ASO nos termos de cabeça ("pomodoro") — perde pro Forest, gasta esforço

---

## 13. Métricas, decisões abertas

**North star (6 meses):** instalações no BR.
**Guardrails (inegociáveis):** D7 ≥ 20% · desinstalação 7d ≤ 40% · nota da Play ≥ 4,3
**Indicadores antecedentes:** % que planta a 1ª árvore · **% que entra/cria círculo** (o mais preditivo de tudo) · círculos com 3+ membros ativos · termos de busca do Console

### Decisões abertas (bloqueiam)
1. **🔴 Qual conta da Play?** Se for **nova**, o Google exige **12 testadores por 14 dias** antes de liberar produção (o Salmo passou por isso). Se for a **mesma conta do Salmo** (que já tem acesso a produção), publica direto e o cronograma encurta ~2 semanas. **Isso muda o roadmap inteiro — decidir primeiro.**
2. **🔴 Analytics: qual?** Firebase foi removido na auditoria (estava morto). Sem telemetria, "volume de instalações" é uma meta que não dá pra pilotar — você vê o número mas não sabe de onde veio nem se fica. Opções: religar Firebase (`flutterfire configure`) ou algo leve (PostHog/Umami). **Recomendo religar Firebase** — é o que integra com o Play Console.
3. **🟠 E-mail de contato** da política/ficha (grovely.com.br sem DNS).
4. **🟠 Nome na ficha:** `Grovely: Foco em Grupo` vs `Grovely: Foco que Cresce`. Recomendo testar o primeiro — "grupo" é diferencial + termo de busca.
5. **🟡 TikTok:** você topa aparecer/gravar tela? (não precisa mostrar rosto — os melhores vídeos de study-tok são só tela + música).

---

## Apêndice — docs relacionados
- `play-store/listing/aso-copy.md` — textos da ficha (pt/en/es)
- `play-store/export/{pt,en,es}/` — screenshots + feature graphic prontos
- `strategy/real-trees-partnership.md` — parceria com ONG (munição de Q3)
- `qa/SECURITY_AUDIT.md` — bloqueios técnicos de lançamento
- `docs/` — LP (aguardando DNS)
