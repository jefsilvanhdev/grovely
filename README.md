# Plantio Coletivo

Timer de foco com jardim que cresce e sessões coletivas em tempo real.
Stack: **Flutter · Supabase · RevenueCat · AdMob · Firebase**. Plataforma
inicial: Android. Mercado-alvo: público global (en) + Brasil (pt) como teste.

> Padrão de qualidade e convenções herdados de **"O Meu Salmo"** (Riverpod,
> go_router, mesma estrutura de pastas). Ver `briefing-plantio-coletivo`.

## Estrutura

```
plantio-coletivo/        ← raiz do git
└── app/                 ← Flutter app
    ├── lib/
    │   ├── main.dart
    │   ├── core/        ← theme, router, constants
    │   ├── l10n/        ← .arb (en, pt) + classes geradas
    │   ├── features/    ← onboarding, focus_session, garden, circle,
    │   │                  league, recap, paywall, profile, auth
    │   ├── data/        ← models, repositories, services
    │   └── shared/      ← widgets do design system
    └── test/
```

## Rodar

Segredos entram via `--dart-define` (nunca commitados). Sem eles o app sobe
mesmo assim — a sessão de foco solo funciona offline e a sincronização ativa
quando as credenciais existirem.

```bash
cd app
flutter run \
  --dart-define=SUPABASE_URL=https://xxx.supabase.co \
  --dart-define=SUPABASE_PUBLISHABLE_KEY=sb_publishable_... \
  --dart-define=REVENUECAT_ANDROID_KEY=goog_... \
  --dart-define=ADMOB_APP_ID=ca-app-pub-...
```

Em CI/release use `--dart-define-from-file=env.json` (copie de
`env.example.json` e preencha; o arquivo real é gitignored).

## Verificação

```bash
cd app
flutter analyze      # sem erros nem warnings (regra de QA)
flutter test         # smoke test da Fase 0
flutter gen-l10n     # regenera as traduções após editar .arb
```

## Status — Fase 0 (Fundação) ✅

- [x] Projeto Flutter + estrutura de pastas (briefing §2)
- [x] i18n pt + en com strings placeholder
- [x] Esqueleto de navegação (go_router) — onboarding + 5 abas + paywall/recap/auth
- [x] Tema claro/escuro (placeholder — Agente A finaliza)
- [x] Conexão Supabase tolerante a falha (`--dart-define`)
- [x] Firebase init tolerante a falha (aguarda `flutterfire configure`)
- [x] **Supabase** projeto novo `plantio-coletivo` (`rkpqpghtuacjxcomisle`) — creds em `app/env.json` (gitignored)
- [x] Tabelas + RLS no Supabase (briefing §2) — `app/supabase/migrations/0001_init_plantio.sql`, 6 tabelas verificadas via REST
- [ ] **Firebase** projeto novo + `flutterfire configure` (push/analytics) — pendente
- [ ] Rodar security advisor no Supabase quando o MCP for reapontado pro Plantio

Próximo: **Fase 1** (Agentes A · B · D em paralelo).

## Infra (reaproveitar contas do "O Meu Salmo", projetos novos)

Mesma conta, **projeto novo e isolado** por serviço (Supabase, Firebase,
RevenueCat, AdMob, Play Console). Keystore separado. Ver briefing §6.1.
