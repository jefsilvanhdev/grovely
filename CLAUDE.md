# Plantio Coletivo — Contexto do Projeto

## TL;DR
App novo (Flutter + Supabase). Fase 0 concluída. Segue briefing. Layout espelha O Meu Salmo. Supabase ref `rkpqpghtuacjxcomisle`.

## Mapa de arquivos
```
plantio-coletivo/
├── app/                    ← Flutter (Riverpod v2 + go_router + l10n pt/en)
│   └── env.json            ← config (gitignored; env.example.json = modelo)
├── plantio-coletivo-design/ ← design system do projeto
├── DESIGN_SYSTEM.md
├── ROADMAP.md
├── HANDOFF.md              ← handoff de design/dev
├── strategy/              ← estratégia/briefing
├── qa/                    ← QA
└── play-store/            ← assets Play Store
```

## Regras
- Padrão de app = O Meu Salmo (Riverpod v2 + go_router).
- Após mudança: `flutter analyze` → git push. QA: `/flutter-review-request`.
