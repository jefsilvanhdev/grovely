# Plantio Coletivo — Brand Brief & Validação de Nome

> Deliverable do **Agente A / designer de identidade visual** (skills:
> `brand-identity`, `branding`, `aso`, `logo-creator`, `image`).
> Fundamenta o `DESIGN_SYSTEM.md` e o prompt para o `claude design`.
> Mercado-alvo: **global (en) primeiro**, Brasil (pt) como teste.

---

## 1. Estratégia de marca

**Brand Purpose** — Existimos para ajudar pessoas a recuperar o foco e cultivar
hábitos saudáveis **juntas**, transformando atenção em algo que cresce e se vê.

**Positioning** — Para quem quer focar mas se distrai sozinho, [NOME] é o app de
foco que faz o tempo concentrado virar um jardim — e, focando em grupo em tempo
real, o jardim coletivo floresce. Diferente do **Forest** (foco solo), o coração
aqui é o **coletivo** (círculos, jardim em grupo, liga semanal).

**Personality** — calmo, encorajador, vivo. Não gamificado-agressivo, não
corporativo. Natureza + leveza. Sem dark patterns (princípios §1: paywall
honesto, social opt-in, anúncio nunca interrompe foco).

**Valores visuais** → orgânico, respirável, acolhedor, otimista.

---

## 2. Validação de nome (3 opções — briefing §Agente A)

⚠️ **"Plantio Coletivo" é só nome de trabalho (pt).** Para mercado global o nome
público deve funcionar em inglês, ser curto, pronunciável e **NÃO colidir com o
"Forest"** (líder absoluto de ASO no nicho — evitar "forest/tree/woods" genérico).

Critérios usados: distintividade · significado (foco+crescer+junto) ·
pronunciável em en/pt · raiz disponível p/ ASO · marca/dominio plausível.

| # | Nome | Por quê | ASO seeds | Risco |
|---|---|---|---|---|
| **1 ⭐** | **Grovely** | "grove" = bosque pequeno = jardim **coletivo** literal; sufixo *-ly* amigável e brandável; foge do "Forest" | grove focus, focus grove, study grove | médio — checar trademark/Play |
| **2** | **Bloomwork** | "bloom" (florescer/crescer) + "work" (foco/produtividade); promete trabalho focado que floresce | bloom focus, focus bloom, deep work | baixo-médio |
| **3** | **Tendwell** | "tend" (cuidar do jardim) + "well"; tom de cuidado e bem-estar, coletivo por extensão | tend focus, mindful focus, focus garden | médio — som menos óbvio |

**Recomendação:** **Grovely** (#1) — único que carrega o conceito coletivo no
próprio significado e se distancia do Forest. Fallback: Bloomwork.

### Resultado da validação (WebSearch, jun/2026)

| Nome | Play Store | Marca / empresa | Veredito |
|---|---|---|---|
| **Grovely ⭐** | sem app homônimo | sem trademark "Grovely"; só "Grove" (Grove Collaborative, Grovemade) e o lugar *Grovely Wood/UK* | ✅ **mais livre** — seguir |
| Bloomwork | espaço "Bloom" lotado (Focus Bloom, Bloom) | **colisão**: Bloomwork UK (2020), Bloom Works (gov-tech US), Bloomworks | ⚠️ fraco |
| Tendwell | sem app homônimo | **colisão forte**: trademarks USPTO registradas — TENDWELL (saúde, *com folha no "t"*), TENDWELL HEALTH, TENDWELL FARM, TENDWELL (ferramentas de jardim) | ❌ evitar (marca + folha + jardim = conflito direto) |

**Conclusão:** **Grovely** é o caminho. Bloomwork e Tendwell têm conflito real
de marca/empresa (Tendwell pior — já tem marca registrada com folha + jardim).

**Pendente (não checado daqui):**
- [ ] Domínio `grovely.com` (provável ocupado — pegar `grovely.app` / `getgrovely.com`)
- [ ] INPI Brasil (marca nacional)
- [ ] Handles @grovely em Instagram/TikTok
- [ ] Pronúncia testada com 3–5 pessoas (en e pt)

---

## 3. Direção visual (input para o `claude design`)

**Paleta (proposta — claro + escuro):**

| Token | Claro | Escuro | Uso |
|---|---|---|---|
| `primary` (verde folha) | `#2E7D52` | `#5FC58A` | marca, CTA |
| `accent` (sol/conquista) | `#E0A458` | `#F0BE78` | streak, destaque |
| `surface` | `#F4F7F2` | `#0F1A14` | fundo |
| `onSurface` | `#1B2620` | `#E7F0E9` | texto |
| `treeHealthy` | `#3FA56B` | `#5FC58A` | árvore concluída |
| `treeWithered` | `#9A8C7A` | `#7A6F60` | árvore murcha |

(Placeholder atual no app: `app/lib/core/theme/app_colors.dart`. claude design
refina e devolve os hex finais.)

**Tipografia:** par humanista + arredondado (ex: títulos *Fraunces*/*Recoleta*,
corpo *Inter*/*Plus Jakarta Sans*) — calor sem perder legibilidade de UI.

**Símbolo:** broto/folha que sugere crescimento + união (várias folhas formando
um círculo = "coletivo"). Tem que funcionar como **ícone 512px** e **adaptive
icon Android** (foreground folha + background verde sólido).

**Biblioteca de árvores (mín. 5 + 1 sazonal, briefing Agente A):** mesmo estilo
de ilustração, 3–4 estágios de crescimento cada (semente → broto → jovem →
adulta), versão **murcha** para sessão falha.

---

## 4. Próximos passos

1. Validar nome (checklist §2) → fixar nome público.
2. Rodar o `claude design` com `prompt-claude-design.md` → logo, ícone, paleta
   final, type, biblioteca de árvores, mockups de telas.
3. Designer/Agente A traduz os tokens finais para `DESIGN_SYSTEM.md` +
   `app/lib/core/theme/`.
