-- ─────────────────────────────────────────────────────────────────────────
-- Plantio Coletivo — schema inicial (briefing §2)
-- Aplicar SOMENTE no projeto Supabase NOVO do Plantio (NUNCA em Salmos/treinos).
-- RLS ativo em todas as tabelas. Privacidade por design (LGPD §1.6).
-- ─────────────────────────────────────────────────────────────────────────

-- ── Tabelas ────────────────────────────────────────────────────────────────

-- Perfis — estende auth.users. Sem upload de foto (avatar gerado por seed).
create table public.profiles (
  id          uuid primary key references auth.users (id) on delete cascade,
  display_name text,
  avatar_seed text,
  locale      text not null default 'pt',
  created_at  timestamptz not null default now()
);

-- Círculos (grupos de 6–12 pessoas).
create table public.circles (
  id                  uuid primary key default gen_random_uuid(),
  name                text not null,
  invite_code         text unique not null,
  created_by          uuid not null references public.profiles (id) on delete cascade,
  weekly_goal_minutes int  not null default 600,
  created_at          timestamptz not null default now()
);

-- Membros de cada círculo.
create table public.circle_members (
  circle_id uuid not null references public.circles (id) on delete cascade,
  user_id   uuid not null references public.profiles (id) on delete cascade,
  joined_at timestamptz not null default now(),
  primary key (circle_id, user_id)
);

-- Sessões de foco concluídas (ou murchas).
create table public.focus_sessions (
  id               uuid primary key default gen_random_uuid(),
  user_id          uuid not null references public.profiles (id) on delete cascade,
  duration_minutes int  not null,
  completed        boolean not null default false, -- true = árvore cresceu
  tree_type        text,
  circle_id        uuid references public.circles (id) on delete set null, -- null = solo
  started_at       timestamptz not null default now(),
  ended_at         timestamptz
);

-- Streaks diários.
create table public.streaks (
  user_id           uuid primary key references public.profiles (id) on delete cascade,
  current_streak    int not null default 0,
  longest_streak    int not null default 0,
  last_session_date date,
  freezes_available int not null default 0 -- "congelamentos" (benefício premium)
);

-- Liga semanal.
create table public.league_entries (
  id                  uuid primary key default gen_random_uuid(),
  user_id             uuid not null references public.profiles (id) on delete cascade,
  week_start          date not null,
  total_focus_minutes int  not null default 0,
  league_tier         text not null default 'bronze',
  unique (user_id, week_start)
);

-- Índices de apoio.
create index focus_sessions_user_idx   on public.focus_sessions (user_id);
create index focus_sessions_circle_idx on public.focus_sessions (circle_id);
create index circle_members_user_idx   on public.circle_members (user_id);
create index league_entries_week_idx   on public.league_entries (week_start);

-- ── Helper anti-recursão de RLS ──────────────────────────────────────────────
-- SECURITY DEFINER evita recursão de policy ao consultar circle_members.
create or replace function public.is_circle_member(p_circle_id uuid)
returns boolean
language sql
security definer
set search_path = public
stable
as $$
  select exists (
    select 1 from public.circle_members
    where circle_id = p_circle_id and user_id = auth.uid()
  );
$$;

-- ── RLS ──────────────────────────────────────────────────────────────────────
alter table public.profiles       enable row level security;
alter table public.circles        enable row level security;
alter table public.circle_members enable row level security;
alter table public.focus_sessions enable row level security;
alter table public.streaks        enable row level security;
alter table public.league_entries enable row level security;

-- profiles: dono lê/escreve o próprio. (Visibilidade de nome entre membros de
-- círculo será refinada pelo Agente C via view agregada.)
create policy profiles_select_own on public.profiles
  for select using (id = auth.uid());
create policy profiles_insert_own on public.profiles
  for insert with check (id = auth.uid());
create policy profiles_update_own on public.profiles
  for update using (id = auth.uid()) with check (id = auth.uid());

-- circles: membros leem; qualquer autenticado cria (vira o created_by).
create policy circles_select_member on public.circles
  for select using (is_circle_member(id) or created_by = auth.uid());
create policy circles_insert_own on public.circles
  for insert with check (created_by = auth.uid());
create policy circles_update_owner on public.circles
  for update using (created_by = auth.uid()) with check (created_by = auth.uid());

-- circle_members: membro vê a lista do(s) círculo(s) ao qual pertence;
-- entra/sai a si mesmo.
create policy circle_members_select on public.circle_members
  for select using (is_circle_member(circle_id));
create policy circle_members_insert_self on public.circle_members
  for insert with check (user_id = auth.uid());
create policy circle_members_delete_self on public.circle_members
  for delete using (user_id = auth.uid());

-- focus_sessions: dono CRUD o próprio.
create policy focus_sessions_select_own on public.focus_sessions
  for select using (user_id = auth.uid());
create policy focus_sessions_insert_own on public.focus_sessions
  for insert with check (user_id = auth.uid());
create policy focus_sessions_update_own on public.focus_sessions
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());

-- streaks: dono.
create policy streaks_select_own on public.streaks
  for select using (user_id = auth.uid());
create policy streaks_upsert_own on public.streaks
  for insert with check (user_id = auth.uid());
create policy streaks_update_own on public.streaks
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());

-- league_entries: dono lê/escreve o próprio; membros do mesmo círculo leem o
-- ranking entram na fase social (Agente C, via view).
create policy league_entries_select_own on public.league_entries
  for select using (user_id = auth.uid());
create policy league_entries_insert_own on public.league_entries
  for insert with check (user_id = auth.uid());
create policy league_entries_update_own on public.league_entries
  for update using (user_id = auth.uid()) with check (user_id = auth.uid());
