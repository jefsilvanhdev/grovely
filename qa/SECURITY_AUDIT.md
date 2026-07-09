# Security + QA Audit — Grovely (plantio-coletivo)

**Data:** 2026-07-06 · **Escopo:** AppSec + QA pré-lançamento. Só código/config verificados (sem commit). Base: HEAD atual.
**Ferramentas:** `git ls-files`, `git grep`, leitura de manifest/gradle/migrations/lib, `flutter analyze`, `flutter pub outdated`, `curl`/`nslookup`.

---

## Resolução (2026-07-06)

**Resolvido no código (sem Jeff):**
- #1 AdMob test ID · #3 AD_ID · #5 Firebase morto · #médio deps não usadas → **removidas as deps** `google_mobile_ads`, `purchases_flutter`, `firebase_core/analytics/messaging`, `timezone`; `analytics_service.dart` deletado; Firebase init tirado do `main.dart`; meta-data AdMob fora do manifest. AAB de release rebuildou **58.3MB** (era 65.5) e o manifest merged de release confirma **AD_ID: 0, AdMob: 0**.
- #médio minify → **R8 ligado** (`isMinifyEnabled`/`isShrinkResources` + `proguard-rules.pro`); build passa.
- #低 allowBackup → **`allowBackup="false"`** (confirmado no merged).
- #4 RLS + #6 UGC + M12 → **migration `0004_circle_hardening.sql` escrita** (RPC `create_circle` atômica, trigger de capacidade, drop do INSERT direto, CHECK de tamanho) + `create()` do app migrado pra RPC com **ponte de fallback** pro caminho legado até a 0004 ser aplicada.

**Pendente do Jeff:**
- #2 hospedar a política (domínio/Pages) + e-mail + data.
- Aplicar `migration 0004` no SQL Editor (fecha o #4/#6 no banco).
- Data Safety no Play Console.

---

## TL;DR — o que bloqueia lançamento

**🔴 Crítico (resolver antes de subir AAB):**
1. **AdMob TEST App ID em produção** — `AndroidManifest.xml:38` (`ca-app-pub-3940256099942544~...`). Viola política do AdMob; não pode ir pra loja assim.
2. **Política de privacidade não está viva** — `grovely.app/privacy_policy.html` → HTTP 307 (redirect de registrar/parking, não serve o arquivo). Play exige URL viva servindo a política. Ainda: e-mail de contato placeholder + "data de vigência a definir" nos dois documentos.

**🟠 Alto:**
3. **Permissão AD_ID injetada por dependência não usada** — `google_mobile_ads` (0 usos em `lib/`) injeta `com.google.android.gms.permission.AD_ID` no manifest de release. Data Safety terá que declarar coleta de Advertising ID — pra nada. Rejeição provável no Play.
4. **Gap de RLS: entrar em qualquer círculo direto** — `0001_init_plantio.sql:117`. A policy de INSERT de `circle_members` só checa `user_id = auth.uid()`, não valida código nem capacidade. Cliente com o UUID do círculo insere direto, burlando `join_circle_by_code` (código + limite de 12).
5. **Firebase nunca inicializa → beta sem telemetria** — sem `google-services.json`/options; `AnalyticsService` é órfão (ninguém importa). Beta sobe coletando zero. Decidir: `flutterfire configure` OU remover `firebase_*`.

**🟡 Médio:** sem minify/shrink (AAB 65MB, sem ofuscação); 5 deps pesadas não usadas; Data Safety a declarar; UGC de círculo sem validação server-side.

**Limpo (verificado, sem ação):** nenhum segredo commitado · `.gitignore` sólido · segredos via `--dart-define` · só anon/publishable key no client (RLS protege) · sem `service_role` no app · RLS ligado nas 6 tabelas com policies own-user estritas · cross-user só via RPC `SECURITY DEFINER` com guarda `is_circle_member` · permissões mínimas, **sem `SCHEDULE_EXACT_ALARM`** (o que reprovou o Salmo) · `applicationId == namespace == com.grovely.app` consistente · sem deep link/assetlinks (classe do bug do Salmo não se aplica) · `flutter analyze` limpo · sem `print`/`debugPrint` vazando dado.

---

## Achados priorizados

### 🔴 Crítico

**🔴 `android/app/src/main/AndroidManifest.xml:38` — AdMob App ID de teste em produção.**
Evidência: `android:value="ca-app-pub-3940256099942544~3347511713"` (App ID de teste oficial do Google), com comentário "TEST ID por ora; Agente D troca". `google_mobile_ads` tem **0 usos** em `lib/` (o rewarded de reviver árvore é placeholder).
Fix: como o AdMob não é usado, **remover `google_mobile_ads` do pubspec** (o meta-data sai junto — resolve também o AD_ID, achado #3). Quando o Agente D plugar de fato, readicionar com o App ID real.

**🔴 Política de privacidade não servida por URL viva.**
Evidência: `curl https://grovely.app/privacy_policy.html` → **HTTP 307** (não 200; o domínio resolve mas redireciona, sem hospedar o arquivo). `landing/privacy_policy.html` e `terms.html` existem no repo mas não estão publicados. Ambos têm `contato@grovely.app` (placeholder) e "Data de vigência: a definir".
Fix: hospedar a `landing/` (GitHub Pages `/docs` como o Salmo, ou o host do domínio), pôr e-mail monitorado e data real. A URL viva é pré-requisito da ficha da Play.

### 🟠 Alto

**🟠 Manifest de release — permissão `AD_ID` injetada por dep não usada.**
Evidência: `grep AD_ID build/app/intermediates/.../release/.../AndroidManifest.xml` → presente (injetado por `google_mobile_ads`). A dep não é usada. Coletar Advertising ID exige declaração no Data Safety e, se não usado/declarado corretamente, é motivo de rejeição.
Fix: remover `google_mobile_ads` (mesmo do #1). Se um dia for usado, adicionar `<uses-permission android:name="com.google.android.gms.permission.AD_ID" tools:node="remove"/>` caso não queira o ID, e declarar no Data Safety caso queira.

**🟠 `supabase/migrations/0001_init_plantio.sql:117` — INSERT de `circle_members` burla código + limite.**
Evidência: `create policy circle_members_insert_self ... with check (user_id = auth.uid())`. Só valida que o usuário insere a si mesmo — não que ele tem o código de convite nem que o círculo tem vaga. `join_circle_by_code` (RPC `SECURITY DEFINER`) é que aplica o limite de 12 e o código; um cliente com o UUID do círculo faz `insert` direto e pula os dois. UUID não é trivial de obter (a policy de `circles` só deixa membro ler), mas vaza no fluxo de convite/compartilhamento.
Fix: revogar INSERT direto de `circle_members` do papel `authenticated` (forçar o fluxo pela RPC), OU trigger `before insert` que valida capacidade e origem. No mínimo, um trigger que rejeita quando `count(*) >= max_members`.

**🟠 Firebase não inicializa → beta coleta zero telemetria; `AnalyticsService` órfão.**
Evidência: `main.dart` chama `Firebase.initializeApp()` sem `options`, sem `google-services.json` no projeto; `grep analytics_service.dart lib/` → ninguém importa. `firebase_analytics` referenciado só no arquivo órfão. `Firebase.initializeApp()` lança e o catch engole.
Fix: decidir — (a) `flutterfire configure` (gera options + google-services.json), plugar o `navObserver` no router e logar eventos-chave; OU (b) remover `firebase_core/analytics/messaging` do pubspec até o Agente D. Beta sem telemetria desperdiça o beta.

### 🟡 Médio

**🟡 `android/app/build.gradle.kts` — sem minify/shrink/proguard no release.**
Evidência: `grep minifyEnabled|shrinkResources|proguard` → nada. AAB de release saiu com **65.5MB**. Sem R8/ofuscação.
Fix: `buildTypes.release { isMinifyEnabled = true; isShrinkResources = true }` + regras proguard do Flutter. Reduz tamanho e ofusca. Testar que nada quebra (reflection do Supabase/plugins).

**🟡 `pubspec.yaml` — 5 dependências pesadas não usadas.**
Evidência (0 usos em `lib/`): `purchases_flutter`, `google_mobile_ads`, `firebase_messaging`, `timezone`; `firebase_analytics` só no órfão. Incham o AAB e trazem código nativo/permissão (AD_ID) sem entregar nada.
Fix: remover até serem plugadas (Agente D readiciona). Corta ~metade do bundle e elimina #1/#3.

**🟡 Data Safety — declarar coleta real.**
Evidência: o app cria conta anônima (Supabase) e armazena no servidor: id anônimo, sessões de foco, nome de exibição, dados de círculo, idioma. Notificações locais. AD_ID via AdMob (enquanto a dep existir).
Fix: preencher o Data Safety batendo com isso (User ID/App activity/App info; AD_ID se manter AdMob). A política de privacidade já cobre esses itens.

**🟡 UGC de círculo sem validação server-side.**
Evidência: nome do círculo e `display_name` inseridos sem limite de tamanho/conteúdo no DB (só `maxLength:24` no cliente, burlável). Vetor de abuso/spam em nome visível a outros membros.
Fix: `check` de tamanho na coluna (ex.: `char_length(name) between 1 and 40`) e sanitização básica.

### 🔵 Baixo

**🔵 `AndroidManifest.xml` — `android:allowBackup` não definido (default true).**
Evidência: sem `android:allowBackup="false"`. Auto Backup pode incluir `shared_preferences`, onde a sessão do Supabase pode ser persistida → token de sessão anônima em backup na nuvem do usuário.
Fix: `android:allowBackup="false"` no `<application>` (ou `fullBackupContent`/`dataExtractionRules` excluindo o storage do Supabase).

**🔵 Dependências levemente desatualizadas.**
Evidência: `supabase_flutter 2.14.2→2.15.4`, `firebase_* patch`, `purchases_flutter 10.2.3→10.4.0`. Sem CVE conhecida, sem lib abandonada — só freshness.
Fix: `flutter pub upgrade` num ciclo de manutenção; nada urgente.

---

## Checklist do briefing

| Área | Resultado |
|---|---|
| 1. Identidade (applicationId/namespace/deep link/assetlinks) | ✅ consistente (`com.grovely.app`); **sem** deep link/assetlinks → classe do bug do Salmo não se aplica |
| 2. Segredos/credenciais | ✅ nada commitado; `.gitignore` sólido; `--dart-define`; só anon key; sem `service_role` |
| 3. Permissões Android | ✅ mínimas (INTERNET, POST_NOTIFICATIONS, RECEIVE_BOOT_COMPLETED); **sem SCHEDULE_EXACT_ALARM**; ⚠️ AD_ID injetado (#3) |
| 4. Backend/Supabase | ✅ RLS em todas as tabelas, own-user estrito; ⚠️ gap no INSERT de circle_members (#4); migrations 0001/0002/0003 aplicadas |
| 5. Build/qualidade | ✅ analyze limpo; ⚠️ sem minify (#médio); deps não usadas (#médio); ✅ sem debug log vazando |
| 6. Privacidade/Play | 🔴 URL não viva (#2); ⚠️ Data Safety a declarar (#médio) |

**Veredito:** o app está sólido em segurança de dados (RLS, segredos, permissões). **Bloqueiam o lançamento:** #1 (AdMob test ID), #2 (política não viva), #3 (AD_ID/dep não usada). Todos resolvidos com **remover as deps não usadas + hospedar a política** — duas ações, sem tocar em feature.

## Não verificável estaticamente
- RLS/RPCs em runtime no projeto Supabase real (li o SQL das migrations, não o estado aplicado do banco).
- Data Safety atual no Play Console (ainda não há ficha).
- Restrição das chaves Google por package+SHA (não há Firebase/Maps config real ainda).
- Comportamento do R8 se minify for ligado (reflection de plugins).
