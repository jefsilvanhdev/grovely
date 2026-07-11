# Play Store — Assets do Grovely

Tudo que a ficha do app precisa. Espelha a estrutura do "O Meu Salmo".

> **Bundle de upload:** `export/` — subir tudo daqui no Play Console. O resto é fonte/trabalho.

```
play-store/
├── README.md
├── export/                        ★ BUNDLE (subir no Console)
│   ├── icon-512.png               ← ícone 512×512, sem alpha
│   ├── feature-graphic.png        ← 1024×500
│   ├── s1-foco.png                ← screenshots 1080×1920 (EN, primário)
│   ├── s2-jardim.png
│   ├── s3-circulo.png
│   ├── s4-liga.png
│   └── s5-recap.png
├── listing/
│   ├── aso-copy.md                ★ título/descrições/keywords (pt/en/es)
│   └── estrategia-screenshots.md  ← narrativa + copy por tela
├── feature-graphic/
│   └── feature-graphic.html       ← fonte do feature graphic
└── screenshots/
    ├── raw/                       ← capturas 1080×2400 do app (demo mode, status bar limpa)
    └── final/                     ← s1…s5.html (frames) → geram os PNG de export/
```

## Idiomas
- **Screenshots (export/) = inglês** — estratégia en-first do brand-brief. App capturado em EN + legendas EN (consistente).
- **aso-copy.md** tem título/descrições em **pt/en/es**.
- Para localizar os screenshots (pt/es): trocar o idioma no app (Perfil → Idioma), recapturar `raw/`, e trocar as legendas em `screenshots/final/gen` (as strings EN/PT/ES estão na estratégia).

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
- [ ] **Política de privacidade:** `https://grovely.com.br/privacy_policy.html` (após DNS)
- [ ] **E-mail de contato**
- [ ] **Data Safety:** conta anônima (User ID), sessões de foco (App activity), nome de exibição/círculo (App info). **Sem Advertising ID** (AdMob removido).
