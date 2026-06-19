-- ─────────────────────────────────────────────────────────────────────────
-- Funções do Circle (Agente C). Aplicar no SQL Editor do Grovely.
-- RLS bloqueia não-membros de ver círculos (join por código) e bloqueia ver
-- profiles de co-membros — estas funções SECURITY DEFINER expõem o mínimo
-- (nome + contagem de árvores), respeitando a privacidade do briefing.
-- ─────────────────────────────────────────────────────────────────────────

-- Capacidade do círculo (6–12). 0001 não tinha; adiciona aqui.
alter table public.circles
  add column if not exists max_members int not null default 12;

-- Entrar num círculo por código (case-insensitive). Retorna o id ou erro.
create or replace function public.join_circle_by_code(p_code text)
returns uuid
language plpgsql
security definer
set search_path = public
as $$
declare
  v_circle uuid;
  v_cap    int;
  v_count  int;
begin
  select id, max_members into v_circle, v_cap
    from public.circles where lower(invite_code) = lower(trim(p_code));
  if v_circle is null then
    raise exception 'circle_not_found';
  end if;
  select count(*) into v_count from public.circle_members where circle_id = v_circle;
  if v_count >= v_cap then
    raise exception 'circle_full';
  end if;
  insert into public.circle_members (circle_id, user_id)
    values (v_circle, auth.uid())
    on conflict (circle_id, user_id) do nothing;
  return v_circle;
end;
$$;

-- Membros do círculo + árvores na semana (só nome + contagem, nada sensível).
-- Só retorna se o chamador for membro.
create or replace function public.circle_member_stats(p_circle_id uuid)
returns table (user_id uuid, display_name text, weekly_trees int)
language plpgsql
security definer
set search_path = public
as $$
begin
  if not public.is_circle_member(p_circle_id) then
    return;
  end if;
  return query
    select p.id,
           coalesce(p.display_name, 'Member'),
           (select count(*)::int from public.focus_sessions fs
              where fs.user_id = p.id
                and fs.completed
                and fs.ended_at >= date_trunc('week', now()))
    from public.circle_members cm
    join public.profiles p on p.id = cm.user_id
    where cm.circle_id = p_circle_id
    order by 3 desc;
end;
$$;
