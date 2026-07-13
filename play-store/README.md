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
│   └── pt/                        ← ficha em PORTUGUÊS (pt-BR)
│       ├── feature-graphic.png    ← 1024×500 (PT)
│       └── s1-foco … s5-recap.png ← 5 screenshots (app PT + legenda PT)
├── listing/
│   ├── aso-copy.md                ★ título/descrições/keywords (pt/en/es)
│   └── estrategia-screenshots.md  ← narrativa + copy por tela
├── feature-graphic/
│   ├── feature-graphic-en.html    ← fonte EN
│   └── feature-graphic-pt.html    ← fonte PT
└── screenshots/
    ├── raw/       ← capturas EN (1080×2400, demo mode)
    ├── raw-pt/    ← capturas PT
    ├── final/     ← s1…s5.html EN (frames)
    └── final-pt/  ← s1…s5.html PT (frames)
```

## Duas fichas (bilíngue)
A Play permite **uma ficha por idioma** — cada uma com título, descrições, screenshots e feature graphic próprios.
- **en-US (padrão):** `export/en/` — app + legendas em inglês (estratégia en-first do brand-brief).
- **pt-BR (tradução):** `export/pt/` — app + legendas em português.
- **aso-copy.md** já traz título/descrição/keywords em **pt/en/es**.
- **es** (opcional, futuro): trocar o idioma no app (Perfil → Idioma → Español), recapturar `raw-es/`, gerar `final-es/` com as legendas ES (estratégia tem as strings).

Como o app captura seguem o idioma do app: trocado em **Perfil → Idioma**.

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
