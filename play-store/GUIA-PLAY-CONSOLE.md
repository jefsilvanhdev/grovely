# Grovely — Guia de Publicação na Google Play

> **Objetivo:** publicar o Grovely no Google Play sem travar em formulário. Cada passo diz **exatamente** o que marcar. Assets prontos em `play-store/export/`.

## URL da política de privacidade (não precisa comprar o domínio agora)
A Play exige uma **URL viva** com a política. Sem o domínio, use a do GitHub Pages:

```
https://jefsilvanhdev.github.io/grovely/privacy_policy.html
```

**Pra ficar no ar** (uma vez): Repo `grovely` → **Settings → Pages** → Source **main /docs**. Se ainda tiver "custom domain" preenchido, **limpar** (o arquivo CNAME foi removido; o `docs/CNAME.later` guarda o valor `grovely.com.br` pra quando você comprar o domínio — aí é só renomear pra `CNAME` e apontar o DNS).

- [ ] Pages ligado · `https://jefsilvanhdev.github.io/grovely/privacy_policy.html` abrindo.

## Antes de começar (checar)
- [ ] **AAB de release** gerado e assinado: `flutter build appbundle --release --dart-define-from-file=env.json` → `build/app/outputs/bundle/release/app-release.aab`.
- [ ] **Conta Play** decidida (ver "Gate de testadores" no fim).

---

## Passo 1 — Criar o app
Console → **Criar app**.
- Nome: **Grovely**
- Idioma padrão: **Português (Brasil) – pt-BR** *(ou English se for global-first — ver nota no fim)*
- Tipo: **App** · Gratuito ou pago: **Gratuito**
- Aceitar as declarações.

## Passo 2 — Ficha principal (Presença na Play → Ficha da loja)
Textos prontos em `listing/aso-copy.md` (pt/en/es). Por idioma:
- **Nome do app:** `Grovely: Foco em Grupo` (testar contra `Grovely: Foco que Cresce`)
- **Descrição curta** (≤80) e **completa** (≤4000): copiar do aso-copy.
- Adicionar tradução **en-US** (e **es** se quiser) → mesma coisa, na aba de idiomas.

## Passo 3 — Recursos gráficos (mesma tela)
De `play-store/export/`:
- **Ícone (512×512):** `icon-512.png`
- **Feature graphic (1024×500):** `pt/feature-graphic.png` (e `en/`, `es/` nas outras línguas)
- **Screenshots de telefone (2–8):** `pt/s1…s5.png` (e `en/`, `es/` por idioma)
- Categoria: **Produtividade** · Tags: foco, estudo, produtividade
- E-mail de contato: **(definir)** · Site: `https://grovely.com.br`

## Passo 4 — Formulários obrigatórios (Política e programas)

### 4.1 Classificação de conteúdo
Questionário → categoria **Produtividade/Utilitário**. Sem violência, sexo, drogas, apostas, linguagem forte → resultado **Livre / L (todas as idades)** ou 3+.

### 4.2 Anúncios
**SIM, o app contém anúncios.** (Rewarded opt-in pra reviver árvore.)

### 4.3 Segurança dos dados (Data Safety) — **respostas exatas**

**O app coleta ou compartilha dados do usuário?** → **Sim**.
**Os dados são criptografados em trânsito?** → **Sim** (HTTPS).
**O usuário pode pedir exclusão dos dados?** → **Sim** (por e-mail — está na política).

**Tipos de dados coletados:**

| Categoria | Tipo | Coletado? | Compartilhado? | Finalidade | Obrigatório? |
|---|---|---|---|---|---|
| **IDs** | ID do usuário (conta anônima) | Sim | Não | Funcionalidade do app | Sim |
| **IDs** | **Advertising ID (AD_ID)** | Sim | **Sim** (Google AdMob) | **Publicidade/marketing** | Não |
| **Atividade no app** | Ações no app (sessões de foco, streak) | Sim | Não | Funcionalidade do app | Sim |
| **Informações pessoais** | Nome (o "nome de exibição" que o usuário escolhe) | Sim | Não* | Funcionalidade do app | Não |
| **Fotos** | Foto de perfil | **Não coletado** — fica só no dispositivo | — | — | — |

\* O nome de exibição é visível a outros **membros do mesmo círculo** dentro do app; não é "compartilhado" com terceiros/empresas. Se o formulário insistir, tratar como "não compartilhado com terceiros".

**Dados que NÃO coleta:** e-mail, telefone, localização, contatos, mensagens, dados financeiros, saúde, arquivos, histórico de navegação, áudio.

> **Por que AD_ID entra:** o SDK do AdMob acessa o Advertising ID pra exibir o vídeo opcional de reviver árvore. É obrigatório declarar. A política de privacidade (`docs/privacy_policy.html` §7) já descreve isso e como o usuário desativa.

### 4.4 Público-alvo e conteúdo
- Faixa etária: **13+** (não direcionado a crianças).
- Não é "app para famílias/crianças" (tem anúncios + conta) → responder que **não** é destinado a menores de 13.

### 4.5 Outras declarações
- **App de notícias:** Não
- **App de COVID / rastreamento:** Não
- **Acesso ao app:** todo o conteúdo disponível **sem restrição / sem login** (conta é anônima, criada automática) → marcar essa opção. *(Se pedir credenciais de teste: não há — explicar "conta anônima automática".)*
- **Política de privacidade (URL):** `https://jefsilvanhdev.github.io/grovely/privacy_policy.html`

## Passo 5 — Enviar o AAB
Teste interno (ou produção) → **Criar versão** → subir `app-release.aab`.
- Notas da versão: "Primeira versão — foco em grupo, jardim, círculos e liga semanal."
- Confirmar que está **assinado pelo Play App Signing** (deixar o Google gerenciar a chave de app; a nossa é a upload key).

## Passo 6 — Revisar e publicar
Resolver todos os ⚠️ do checklist do Console → **Enviar para revisão**.

---

## Gate de testadores (decisão que muda o cronograma)
- **Conta Play NOVA (criada depois de nov/2023):** o Google exige **12 testadores rodando por 14 dias** no teste fechado antes de liberar produção. (Foi o caso do Salmo.)
- **Conta que já publicou app em produção** (ex.: a mesma do Salmo): publica direto, sem o gate.

**→ Decidir a conta primeiro.** Se for nova, começar já a recrutar os 12 testadores (o relógio de 14 dias corre em paralelo com o resto).

## Pendências conhecidas (não bloqueiam o teste interno)
- **Migration 0004** aplicada no Supabase (círculo/liga com dados reais).
- **AdMob:** o app precisa passar pela revisão do AdMob (dias) pra servir anúncio real; até lá serve anúncio de teste. Não bloqueia publicar.
- **E-mail de contato** real (o mesmo da política).
- **iOS:** fora de escopo (build Android-first).
