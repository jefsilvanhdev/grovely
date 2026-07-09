-- ─────────────────────────────────────────────────────────────────────────
-- Hardening do Circle (audit SECURITY_AUDIT.md). Aplicar no SQL Editor do
-- Grovely APÓS 0001/0002/0003.
--
-- Corrige:
--  #4 (RLS): a policy de INSERT de circle_members deixava um cliente entrar
--     em QUALQUER círculo com o UUID, burlando join_circle_by_code (código +
--     limite de 12). Aqui: remove o INSERT direto e força a entrada/criação
--     por RPCs SECURITY DEFINER; um trigger barra estouro de capacidade.
--  M12 (QA): create_circle vira atômico (círculo + membro num só request) —
--     não deixa círculo órfão se o insert do membro falhasse.
--  #6 (UGC): nome de círculo e display_name sem limite → CHECK de tamanho.
-- ─────────────────────────────────────────────────────────────────────────

-- ── #6: limites de UGC ─────────────────────────────────────────────────────
alter table public.circles
  add constraint circles_name_len
  check (char_length(btrim(name)) between 1 and 40) not valid;
alter table public.circles validate constraint circles_name_len;

alter table public.profiles
  add constraint profiles_display_name_len
  check (display_name is null or char_length(btrim(display_name)) between 1 and 24) not valid;
alter table public.profiles validate constraint profiles_display_name_len;

-- ── Capacidade (defesa em profundidade) ────────────────────────────────────
create or replace function public.enforce_circle_capacity()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_cap   int;
  v_count int;
begin
  select max_members into v_cap from public.circles where id = new.circle_id;
  if v_cap is null then
    raise exception 'circle_not_found';
  end if;
  select count(*) into v_count from public.circle_members where circle_id = new.circle_id;
  if v_count >= v_cap then
    raise exception 'circle_full';
  end if;
  return new;
end;
$$;

drop trigger if exists trg_circle_capacity on public.circle_members;
create trigger trg_circle_capacity
  before insert on public.circle_members
  for each row execute function public.enforce_circle_capacity();

-- ── Criação atômica (círculo + criador como membro) ────────────────────────
create or replace function public.create_circle(p_name text, p_code text)
returns public.circles
language plpgsql
security definer
set search_path = public
as $$
declare
  v_circle public.circles;
begin
  insert into public.circles (name, invite_code, created_by)
    values (btrim(p_name), upper(btrim(p_code)), auth.uid())
    returning * into v_circle;
  insert into public.circle_members (circle_id, user_id)
    values (v_circle.id, auth.uid());
  return v_circle;
end;
$$;

-- ── #4: remove o INSERT direto de circle_members ───────────────────────────
-- join_circle_by_code e create_circle (SECURITY DEFINER) continuam inserindo;
-- o cliente perde o atalho que burlava código e capacidade.
drop policy if exists circle_members_insert_self on public.circle_members;
