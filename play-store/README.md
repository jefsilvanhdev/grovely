# Play Store — Assets do Grovely

Tudo que a ficha do app precisa. Espelha a estrutura do "O Meu Salmo".

> **Bundle de upload:** `export/` — subir tudo daqui no Play Console. O resto é fonte/trabalho.

```
play-store/
├── README.md
├── export/                        ★ BUNDLE (subir no Console)
│   ├── icon-512.png               ← ícone 512×512, sem alpha (compartilhado)
│   ├── en/                        ← ficha em INGLÊS (padrão, global-first)
│   │   ├── feature-graphic.png    ← 1024×500 (EN)
│   │   └── s1-foco … s5-recap.png ← 5 screenshots 1080×1920 (app EN + legenda EN)
│   ├── pt/                        ← ficha em PORTUGUÊS (pt-BR)
│   │   ├── feature-graphic.png
│   │   └── s1-foco … s5-recap.png ← app PT + legenda PT
│   └── es/                        ← ficha em ESPANHOL
│       ├── feature-graphic.png
│       └── s1-foco … s5-recap.png ← app ES + legenda ES
├── listing/
│   ├── aso-copy.md                ★ título/descrições/keywords (pt/en/es)
│   └── estrategia-screenshots.md  ← narrativa + copy por tela
├── feature-graphic/
│   ├── feature-graphic-en.html    ← fonte EN
│   ├── feature-graphic-pt.html    ← fonte PT
│   └── feature-graphic-es.html    ← fonte ES
└── screenshots/
    ├── raw/ raw-pt/ raw-es/       ← capturas 1080×2400 por idioma (demo mode)
    └── final/ final-pt/ final-es/ ← s1…s5.html (frames) → PNGs de export/
```

## Três fichas (en · pt · es)
A Play permite **uma ficha por idioma** — cada uma com título, descrições, screenshots e feature graphic próprios. Os três sets estão prontos e são **consistentes** (app capturado no idioma + legenda no mesmo idioma):
- **en-US (padrão):** `export/en/` — estratégia en-first do brand-brief
- **pt-BR:** `export/pt/`
- **es:** `export/es/`

Textos da ficha (título/descrição/keywords) nos três idiomas: `listing/aso-copy.md`.

O idioma das capturas vem do app: **Perfil → Idioma**. O app está 100% traduzido nos três (`lib/l10n/app_{en,pt,es}.arb`).

## Como regenerar

**Feature graphic:**
```
chrome --headless=new --window-size=1024,500 \
  --screenshot=export/feature-graphic.png feature-graphic/feature-graphic.html
```

**Screenshots (a partir de raw/ + final/*.html):**
```
# 1. capturar telas do app (demo populado + demo mode do SystemUI p/ status bar limpa)
adb shell am broadcast -a com.android.systemui.demo -e command enter
adb shell am broadcast -a com.android.systemui.demo -e command clock -e hhmm 0941
adb exec-out screencap -p > screenshots/raw/<tela>.png
# 2. render de cada slide 1080×1920
chrome --headless=new --window-size=1080,1920 \
  --screenshot=export/s1-foco.png screenshots/final/s1-foco.html
```

## Checklist do Console (Ficha da loja)
- [ ] **Nome do app:** `Grovely: Focus & Grow` (en) — ver aso-copy por idioma
- [ ] **Descrição curta / completa:** aso-copy.md
- [ ] **Ícone:** `export/icon-512.png`
- [ ] **Feature graphic:** `export/feature-graphic.png`
- [ ] **Screenshots (telefone):** `export/s1…s5.png` (mín. 2, temos 5)
- [ ] **Categoria:** Produtividade · **Classificação:** Livre (13+)
- [ ] **Política de privacidade:** `https://jefsilvanhdev.github.io/grovely/privacy_policy.html` (via GitHub Pages — não precisa do domínio; ver GUIA)
- [ ] **E-mail de contato**
- [ ] **Contém anúncios:** **SIM** (rewarded opt-in pra reviver árvore). Marcar no Console.
- [ ] **Data Safety:** conta anônima (User ID), sessões de foco (App activity), nome de exibição/círculo (App info) **+ Advertising ID (AD_ID)** — o AdMob usa pro vídeo opcional de revive.
- [ ] **App ID do AdMob real** em `app/android/admob.properties` (o build de release falha com o de teste — de propósito) e o **rewarded unit id** em `env.json` (`ADMOB_REWARDED_UNIT_ID`).
- [ ] **MVP é grátis** — sem assinatura. Nada de produtos in-app no Console.
