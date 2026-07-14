-- THE DEEP END v2: run this once in the Supabase SQL editor (Dashboard → SQL Editor → New query → paste → Run).

-- each player gets one row holding their whole game state
create table public.player_state (
  user_id uuid primary key references auth.users(id) on delete cascade,
  name text,
  email text,
  data jsonb not null,
  updated_at timestamptz not null default now()
);

alter table public.player_state enable row level security;

-- players can read and write only their own row
create policy "own row select" on public.player_state
  for select using (auth.uid() = user_id);
create policy "own row insert" on public.player_state
  for insert with check (auth.uid() = user_id);
create policy "own row update" on public.player_state
  for update using (auth.uid() = user_id);

-- coaches (Micah) can read every row for the dashboard
create table public.coaches (email text primary key);
insert into public.coaches (email) values ('micah@transformwithmicah.com');

alter table public.coaches enable row level security;
create policy "anyone can check coach list" on public.coaches
  for select using (true);

create policy "coach reads all players" on public.player_state
  for select using (
    exists (select 1 from public.coaches c where c.email = (auth.jwt() ->> 'email'))
  );

-- RECOMMENDED SETTING (not SQL): in Dashboard → Authentication → Sign In / Up → Email,
-- turn OFF "Confirm email" so clients can sign in immediately without an email round-trip.
