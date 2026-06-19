# Grovely — Copy Revision (UX Writing)

Humanizar o copy do app. Hoje várias strings soam de IA: descritivas demais,
genéricas, explicativas, com tom de manual. O app é calmo, vivo e encorajador —
a voz precisa soar como **uma pessoa gentil ao seu lado**, não como um sistema.

Fonte da verdade: `app/lib/l10n/app_en.arb` e `app/lib/l10n/app_pt.arb`.
**Este doc não edita os .arb** — propõe revisões chave→atual→revisado (en + pt).
Mantém i18n (mesmas chaves, mesmos placeholders), sem inventar preços/claims.

---

## 1. Voz Grovely — 5 princípios

1. **Calma, não animada demais.** Sem hype, sem exclamação em excesso. Um tom que respira. (Exclamação só no momento de colher: "Tree planted!")
2. **Humana e na 2ª pessoa.** Fala "você"/"you", curto, como um amigo. Nunca jargão de produto ("opt-in", "sessão de foco" repetido, "feature").
3. **Encorajadora, nunca culpando.** No fracasso (murcha/erro) o tom acolhe e abre o próximo passo. Zero vergonha, zero "você falhou".
4. **Viva e concreta (linguagem de jardim).** Plantar, crescer, brotar, bosque, regar — não "iniciar atividade", "registro", "item".
5. **Honesta e leve.** Diz a verdade sem peso (paywall, privacidade): claro, gentil, sem pressão nem letrinha miúda assustadora.

**Soa como:** um amigo tranquilo que cuida de plantas.
**Não soa como:** um app de produtividade corporativo, nem um coach motivacional gritando.

**Regras rápidas**
- Frases curtas. Uma ideia por linha.
- Verbo + objeto nos botões ("Plant a tree", não "Submit"/"OK").
- Evitar reticências decorativas e "•" descritivos.
- **PT: eliminar os "(a)/(s)" de gênero** — reescrever para neutro natural. É o tique mais "robótico" do copy atual.
- Sem "etc.", sem "para que você possa…", sem explicar o óbvio.

---

## 2. Auditoria — strings que soam robóticas/IA (piores offenders)

Os **5 piores offenders** de copy-IA (por soarem a manual/genérico/sistema):

1. **`focusWitheredBody`** — "You left before the session ended. Try again." / "Você saiu antes do fim da sessão. Tente de novo." → seco e culpando; ironicamente já existe a versão gentil (`witheredBodyKind`) não usada como principal.
2. **PT inteiro com `(a)/(s)`** — `profileGuest` "Convidado(a)", `onbSoloTitle` "Focar sozinho(a)", `noThanks` "Não, obrigado(a)" → grito de texto auto-gerado; humano nenhum escreve assim.
3. **`focusSubtitle` / `gardenEmpty` / `gardenWaitingSub`** — "Plant a tree by staying focused." / "Finish a focus session to plant your first." → instrução de manual ("Finish a focus session…"), repete "focus session" como termo de sistema.
4. **`circleEmptySub`** — "A circle is 6–12 people focusing toward a shared garden and a weekly league." → definição de glossário ("A circle is…"), enumerativa, fria.
5. **`pwSub`** — "Everything you love, plus more ways to grow." → frase de marketing genérica (poderia estar em qualquer SaaS); dentro do app deve guiar, não vender com clichê.

Outros sinais de IA detectados: uso repetido de "focus session" como rótulo; "Something went wrong." (erro genérico padrão); títulos puramente descritivos ("Weekly recap", "Weekly league", "Focus session") sem nenhuma voz; bullets de notificação em tom de feature-list.

---

## 3. Revisões — chave → atual → revisado (EN + PT)

> Mantém placeholders `{…}` e plurais. "—" = manter como está (já está bom).
> Mudanças marcadas **negrito** quando o ganho é grande.

### 3.1 Onboarding
| Chave | EN atual | EN revisado | PT atual | PT revisado |
|------|----------|-------------|----------|-------------|
| `onboardingWelcome` | Grow focus, together. | Grow your focus. Together. | Cresça no foco, em conjunto. | **Cultive seu foco. Junto.** |
| `onbWelcomeSub` | Plant a tree with every focused session. Watch your grove grow. | Every focused minute plants a tree. Watch your grove grow. | Plante uma árvore a cada sessão de foco. Veja seu bosque crescer. | **Cada minuto de foco planta uma árvore. Veja seu bosque crescer.** |
| `onbGetStarted` | Get started | Plant my first tree | Começar | **Plantar minha primeira árvore** |
| `onbHaveAccount` | I already have an account | I already have an account | Já tenho conta | — |
| `onbNotifTitle` | Gentle nudges, never noise. | A nudge when it helps. Never noise. | Lembretes gentis, nunca barulho. | **Um toque quando ajuda. Nunca barulho.** |
| `onbNotifBullet1` | A daily reminder to plant one tree | A daily nudge to plant one tree | Um lembrete diário pra plantar uma árvore | Um lembrete diário pra plantar uma árvore |
| `onbNotifBullet2` | We'll help you save a streak before it breaks | A heads-up before your streak slips | Avisamos antes da sua sequência quebrar | **Um aviso antes da sua sequência escapar** |
| `onbNotifBullet3` | Know when your circle is focusing | A ping when your circle starts focusing | Saiba quando seu círculo está focando | **Um sinal quando seu círculo começa a focar** |
| `onbNotifCta` | Turn on reminders | Turn on reminders | Ativar lembretes | — |
| `onbNotNow` | Not now | Maybe later | Agora não | **Talvez depois** |
| `onbSocialTitle` | Focus your way. | Focus your way. | Foque do seu jeito. | — |
| `onbSocialSub` | You can always change this later. | Change this anytime. | Você pode mudar isso depois. | **Dá pra mudar quando quiser.** |
| `onbSoloTitle` | Focus solo | On my own | Focar sozinho(a) | **Por conta própria** |
| `onbSoloDesc` | Just you and your grove. | Just you and your grove. | Só você e seu bosque. | — |
| `onbCircleTitle` | Focus with a circle | With a circle | Focar com um círculo | **Com um círculo** |
| `onbCircleDesc` | Grow a shared garden with 6–12 people. | Grow one garden with 6–12 people. | Cultive um jardim com 6–12 pessoas. | **Cultivem um jardim, de 6 a 12 pessoas.** |
| `onbPrivacy` | We only ever share your first name and tree count. | Only your first name and tree count are ever shared. | Só compartilhamos seu primeiro nome e número de árvores. | **Só seu primeiro nome e quantas árvores você tem.** |
| `onbGuidedCoach` | Let's plant your first tree. Stay here for 30 seconds — that's it. | Let's plant your first one. Just stay here 30 seconds. | Vamos plantar sua primeira árvore. Fique aqui por 30 segundos — só isso. | **Vamos plantar a primeira. É só ficar aqui 30 segundos.** |
| `onbBegin` | Begin | Plant it | Começar | **Plantar** |
| `onbGuidedDone` | Your first tree! 🌱 This one's on us. | Your first tree. 🌱 On us. | Sua primeira árvore! 🌱 Essa é por nossa conta. | Sua primeira árvore. 🌱 Essa é por nossa conta. |

### 3.2 Focus (core loop)
| Chave | EN atual | EN revisado | PT atual | PT revisado |
|------|----------|-------------|----------|-------------|
| `focusTitle` | Focus session | Focus | Sessão de foco | **Foco** |
| `focusSubtitle` | Plant a tree by staying focused. | Stay focused and watch it grow. | Plante uma árvore mantendo o foco. | **Fique no foco e veja ela crescer.** |
| `focusPreview` | A young {species} in {minutes} min. | A {species}, grown in {minutes} min. | Um(a) {species} jovem em {minutes} min. | **{species} pronto em {minutes} min.** *(ver nota gênero)* |
| `focusPlant` | Plant & focus | Plant & focus | Plantar e focar | — |
| `focusKeepGrowing` | Stay in the app to keep your tree growing. | Stay here. Your tree's growing. | Fique no app para sua árvore continuar crescendo. | **Fica por aqui. Ela está crescendo.** |
| `focusGiveUp` | Give up | Stop | Desistir | **Parar** |
| `focusGiveUpConfirmTitle` | Leave now? Your tree will wither. | Leave now? Your tree won't make it. | Sair agora? Sua árvore vai murchar. | **Sair agora? Ela não vai resistir.** |
| `focusKeepFocusing` | Keep focusing | Keep growing | Continuar focando | **Continuar** |
| `focusCompletedTitle` | Tree planted! | Tree planted! | Árvore plantada! | — |
| `focusCompletedBody` | You focused for {minutes} minutes. | {minutes} minutes of focus, well spent. | Você focou por {minutes} minutos. | **{minutes} minutos de foco bem gastos.** |
| `addedToGarden` | Added to your garden | Added to your garden | Adicionada ao seu jardim | — |
| `plantAnother` | Plant another | Plant another | Plantar outra | — |
| `viewGarden` | View garden | See my garden | Ver jardim | **Ver meu jardim** |
| `focusWitheredTitle` | Your tree withered | Your tree didn't make it | Sua árvore murchou | **Ela não resistiu** |
| `focusWitheredBody` | You left before the session ended. Try again. | You stepped away before it finished. It happens. | Você saiu antes do fim da sessão. Tente de novo. | **Você saiu antes do fim. Acontece.** |
| `witheredBodyKind` | You left before the session finished — it happens. Want to bring it back? | You stepped away before it finished — it happens. Want it back? | Você saiu antes do fim — acontece. Quer trazê-la de volta? | **Saiu antes do fim — acontece. Quer trazer de volta?** |
| `focusNewSession` | New session | Start again | Nova sessão | **Recomeçar** |
| `reviveWithVideo` | Revive with a short video | Bring it back with a short video | Reviver com um vídeo curto | **Trazer de volta com um vídeo curto** |
| `reviveSheetBody` | Watch a 30-second video to revive this tree. | A 30-second video brings this tree back. | Assista a um vídeo de 30s para reviver esta árvore. | **Um vídeo de 30s traz essa árvore de volta.** |
| `watchAndRevive` | Watch & revive | Watch & bring it back | Assistir e reviver | **Assistir e trazer de volta** |
| `startFresh` | Start fresh | Start fresh | Começar de novo | — |
| `reviveUnavailable` | Couldn't load the video — your tree's still here to replant. | No video right now — but you can replant it. | Não deu pra carregar o vídeo — sua árvore segue aqui pra replantar. | **Sem vídeo agora — mas dá pra replantar.** |
| `noThanks` | No thanks | No thanks | Não, obrigado(a) | **Agora não** |

### 3.3 Garden
| Chave | EN atual | EN revisado | PT atual | PT revisado |
|------|----------|-------------|----------|-------------|
| `gardenTitle` | Your garden | Your garden | Seu jardim | — |
| `gardenWaiting` | Your garden is waiting. | Your garden starts here. | Seu jardim está esperando. | **Seu jardim começa aqui.** |
| `gardenWaitingSub` | Finish a focus session to plant your first tree. | One focused session plants your first tree. | Conclua uma sessão de foco para plantar sua primeira árvore. | **Uma sessão de foco e nasce sua primeira árvore.** |
| `gardenEmpty` | No trees yet. Finish a focus session to plant your first. | No trees yet — your first focus plants one. | Nenhuma árvore ainda. Conclua uma sessão de foco para plantar a primeira. | **Nenhuma árvore ainda — seu primeiro foco planta uma.** |
| `plantFirst` | Plant your first tree | Plant my first tree | Plantar minha primeira árvore | — |
| `plantAnother` | Plant another | — | Plantar outra | — |

### 3.4 Circle
| Chave | EN atual | EN revisado | PT atual | PT revisado |
|------|----------|-------------|----------|-------------|
| `circleTitle` | Circles | Circles | Círculos | — |
| `circleEmptyTitle` | Grow together. | Grow together. | Cresçam juntos. | — |
| `circleEmptySub` | A circle is 6–12 people focusing toward a shared garden and a weekly league. | 6–12 friends, one shared garden, a friendly weekly league. | Um círculo são 6–12 pessoas focando por um jardim comum e uma liga semanal. | **6 a 12 pessoas, um jardim em comum e uma liga toda semana.** |
| `circleCreate` | Create a circle | Start a circle | Criar um círculo | **Criar um círculo** |
| `circleJoin` | Join with a code | Join with a code | Entrar com código | — |
| `circlePrivacy` | Only your first name and tree count are visible to members. | Members only see your first name and tree count. | Só seu primeiro nome e número de árvores ficam visíveis. | **Os membros só veem seu nome e suas árvores.** |
| `circleNameHint` | e.g. Deep Work Club | e.g. Deep Work Club | ex.: Clube do Foco | — |
| `circleInvalidCode` | That code didn't match a circle. | We couldn't find a circle for that code. | Esse código não corresponde a nenhum círculo. | **Não achamos um círculo com esse código.** |
| `circleFull` | This circle is full. | This circle's full for now. | Este círculo está cheio. | **Esse círculo está cheio por enquanto.** |
| `circleGoal` | {planted}/{goal} trees this week | {planted} of {goal} trees this week | {planted}/{goal} árvores esta semana | **{planted} de {goal} árvores esta semana** |
| `circleLeaveBody` | You can rejoin with the code. | You can come back anytime with the code. | Você pode voltar com o código. | **Dá pra voltar quando quiser, é só o código.** |
| `circleStay` | Stay | Stay | Ficar | — |
| `memberWeekly` | {count} this week | {count} this week | {count} esta semana | — |

### 3.5 League
| Chave | EN atual | EN revisado | PT atual | PT revisado |
|------|----------|-------------|----------|-------------|
| `leagueTitle` | Weekly league | League | Liga semanal | **Liga** |
| `leagueTitleWeek` | This week's standings | This week | Ranking da semana | **Esta semana** |
| `leagueSolo` | Join a circle to enter the weekly league. | Join a circle and the league opens up. | Entre num círculo para participar da liga semanal. | **Entre num círculo e a liga abre.** |
| `leagueYou` | You | You | Você | — |

### 3.6 Recap
| Chave | EN atual | EN revisado | PT atual | PT revisado |
|------|----------|-------------|----------|-------------|
| `recapTitle` | Weekly recap | Your week | Recap semanal | **Sua semana** |
| `recapHero` | {count} trees this week | {count, plural, =1{1 tree this week} other{{count} trees this week}} | {count} árvores esta semana | {count, plural, =1{1 árvore esta semana} other{{count} árvores esta semana}} |
| `recapHeroLabel` *(nova chave sugerida)* | — | {count, plural, =1{tree this week} other{trees this week}} | — | {count, plural, =1{árvore esta semana} other{árvores esta semana}} |
| `recapSub` | {hours}h {minutes}m focused | {hours}h {minutes}m in focus | {hours}h {minutes}m de foco | **{hours}h {minutes}m focado** |
| `recapShare` | Share my week | Share my week | Compartilhar minha semana | — |
| `recapFooter` | Made with Grovely | Grown with Grovely | Feito com Grovely | **Plantado com o Grovely** |
| `recapEmpty` | A fresh week to grow. | A fresh week to grow. | Uma semana nova pra crescer. | — |
| `recapEmptySub` | Plant a tree to start this week's recap. | Plant your first tree to start the week. | Plante uma árvore pra começar o recap da semana. | **Plante uma árvore pra começar a semana.** |

> **Nota técnica (Recap):** hoje o hero é montado com `recapHero(count).replaceFirst('$count ', '')` para separar número e rótulo — frágil e quebra em PT. Sugestão: criar `recapHeroLabel` (só o rótulo pluralizado) e exibir o número grande separado. Resolve o item do APP_REVIEW §1.6.

### 3.7 Paywall (honesto, sem pressão)
| Chave | EN atual | EN revisado | PT atual | PT revisado |
|------|----------|-------------|----------|-------------|
| `paywallTitle` | Go Premium | Grovely Premium | Seja Premium | **Grovely Premium** |
| `pwTitle` | Go deeper with Grovely Premium. | More room to grow. | Vá além com o Grovely Premium. | **Mais espaço pra crescer.** |
| `pwSub` | Everything you love, plus more ways to grow. | Keep everything free, unlock a little more. | Tudo o que você ama, e mais formas de crescer. | **Tudo que já é grátis, e um pouco mais.** |
| `pwTrialCta` | Start 21-day free trial | Try free for 21 days | Iniciar teste grátis de 21 dias | **Testar grátis por 21 dias** |
| `pwTrialSub` | Free for 21 days, then {price}. Cancel anytime in two taps. | Free for 21 days, then {price}. Cancel anytime, two taps. | Grátis por 21 dias, depois {price}. Cancele quando quiser em dois toques. | **Grátis por 21 dias, depois {price}. Cancela quando quiser, em dois toques.** |
| `pwSave` | Save 40% | Save 40% | Economize 40% | **Economize 40%** |
| `pwContinueFree` | Continue with Free | Stay on Free | Continuar no plano grátis | **Seguir no grátis** |
| `pwRestore` | Restore purchases | Restore purchases | Restaurar compras | — |
| `pwRowSoloFocus` | Unlimited solo focus | Unlimited solo focus | Foco solo ilimitado | — |
| `pwRowSpecies` | All species & seasonal trees | All species & seasonal trees | Todas as espécies e árvores sazonais | — |
| `pwRowRecap` | Recap themes | Recap themes | Temas de recap | **Temas de recap** |
| `pwPriceTbd` | price TBD | price TBD | preço a definir | — |

> Manter a postura honesta: nada de "última chance", contagem regressiva ou esconder o "seguir no grátis". As revisões só deixam o tom mais leve e menos "vendedor".

### 3.8 Profile + comuns
| Chave | EN atual | EN revisado | PT atual | PT revisado |
|------|----------|-------------|----------|-------------|
| `profileGuest` | Guest | Guest | Convidado(a) | **Visitante** |
| `profileSaveProgress` | Save your progress | Save my progress | Salvar seu progresso | **Salvar meu progresso** |
| `profileLifetime` | Lifetime | All time | Total | **Desde o começo** |
| `profileFreePlan` | Free plan | Free | Plano grátis | **Grátis** |
| `rowSignOut` | Sign out | Sign out | Sair | — |
| `commonError` | Something went wrong. | That didn't work — let's try again. | Algo deu errado. | **Não rolou — vamos tentar de novo.** |
| `commonRetry` | Retry | Try again | Tentar de novo | — |
| `commonLoading` | Loading… | Growing… *(contextual, opcional)* | Carregando… | **Carregando…** |
| `streakStart` | Start a streak | Start a streak | Comece uma sequência | **Começar uma sequência** |
| `statLongest` | Longest: {count} days | Best: {count} days | Recorde: {count} dias | — |

---

## 4. Nota crítica: PT inclusivo sem "(a)/(s)"

O maior tique de "texto automático" no PT são os parênteses de gênero. Em UX
writing humano, **reescreve-se para neutro natural** em vez de empilhar sufixos:

| Em vez de | Use |
|-----------|-----|
| Convidado(a) | **Visitante** |
| Focar sozinho(a) | **Por conta própria** / **Sozinho no seu ritmo** |
| Não, obrigado(a) | **Agora não** |
| Recomendado(a) | **Recomendado** (rótulo de opção — concorda com "círculo", masc.: ok) |

Regra geral: preferir substantivo neutro ("visitante", "pessoa", "você"),
verbo no infinitivo ("entrar", "focar"), ou reescrever a frase. Nunca "(a)".

---

## 5. Itens que já estão bons (manter)
- `focusCompletedTitle` "Tree planted!" — a única exclamação merecida; mantém.
- `onbGuidedDone` "This one's on us." — caloroso e humano.
- Toda a postura do paywall (transparência, "continue free", sem preço falso).
- `circleEmptyTitle` / `recapEmpty` — já curtos e com voz.
- Nota de privacidade existir em onboarding **e** circle — confiança.

---

## 6. Resumo das mudanças de tom
- **Títulos de aba/tela**: tirar "session"/"weekly" repetidos → "Focus", "League", "Your week". Menos rótulo de sistema.
- **Fracasso**: de "withered / Try again" (culpa) → "didn't make it / it happens" (acolhe + oferece volta).
- **Instruções**: de "Finish a focus session to…" (manual) → "One focused session plants…" (concreto, vivo).
- **Definições**: de "A circle is 6–12 people…" (glossário) → "6–12 friends, one shared garden…" (humano).
- **PT**: fim dos "(a)/(s)"; contrações naturais ("dá pra", "fica por aqui").
