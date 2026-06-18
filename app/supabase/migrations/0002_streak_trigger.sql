-- ─────────────────────────────────────────────────────────────────────────
-- Streak atômico no servidor (corrige race read-modify-write do cliente).
-- Aplicar no SQL Editor do projeto Grovely. Após aplicar, o cliente NÃO
-- calcula streak — o trigger faz, de forma atômica, a cada sessão concluída.
-- ─────────────────────────────────────────────────────────────────────────

create or replace function public.handle_focus_session_streak()
returns trigger
language plpgsql
security definer
set search_path = public
as $$
declare
  v_today date := (coalesce(new.ended_at, now()) at time zone 'utc')::date;
  v_last  date;
  v_cur   int;
  v_lng   int;
  v_new   int;
begin
  if not coalesce(new.completed, false) then
    return new;
  end if;

  select last_session_date, current_streak, longest_streak
    into v_last, v_cur, v_lng
    from public.streaks
    where user_id = new.user_id;

  if v_last is null then
    insert into public.streaks (user_id, current_streak, longest_streak, last_session_date)
      values (new.user_id, 1, 1, v_today)
      on conflict (user_id) do update
        set current_streak    = 1,
            longest_streak     = greatest(public.streaks.longest_streak, 1),
            last_session_date  = v_today;
    return new;
  end if;

  v_new := case
    when v_today = v_last then greatest(v_cur, 1) -- mesma data
    when v_today = v_last + 1 then v_cur + 1       -- dia seguinte
    else 1                                          -- quebrou
  end;

  update public.streaks
    set current_streak   = v_new,
        longest_streak    = greatest(v_lng, v_new),
        last_session_date = v_today
    where user_id = new.user_id;

  return new;
end;
$$;

drop trigger if exists trg_focus_session_streak on public.focus_sessions;
create trigger trg_focus_session_streak
  after insert on public.focus_sessions
  for each row execute function public.handle_focus_session_streak();
