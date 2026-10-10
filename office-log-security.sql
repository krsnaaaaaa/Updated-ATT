-- Office Log: real login (Supabase Auth) + payments table + locked-down access
-- BEFORE running this:
--   1) Supabase > Authentication > Users > Add user (your email + password, tick "Auto Confirm User")
--   2) Supabase > Authentication > Sign In / Providers > turn OFF "Allow new users to sign up"
-- After running, only signed-in users can read or write. The old anonymous access stops.

create table if not exists public.payments (
  id bigint generated always as identity primary key,
  paid_on date not null,
  amount numeric not null,
  note text,
  created_at timestamptz default now()
);

alter table public.attendance   enable row level security;
alter table public.app_settings enable row level security;
alter table public.payments     enable row level security;

drop policy if exists "anon read"          on public.attendance;
drop policy if exists "anon write"         on public.attendance;
drop policy if exists "anon all settings"  on public.app_settings;
drop policy if exists "auth all"           on public.attendance;
drop policy if exists "auth all"           on public.app_settings;
drop policy if exists "auth all"           on public.payments;

create policy "auth all" on public.attendance   for all to authenticated using (true) with check (true);
create policy "auth all" on public.app_settings for all to authenticated using (true) with check (true);
create policy "auth all" on public.payments     for all to authenticated using (true) with check (true);

select 'ok' as status, (select count(*) from public.attendance) as attendance_rows;
