-- Run this in Supabase Dashboard → SQL Editor
-- Creates the attendance_logs table with real-time enabled

create table if not exists public.attendance_logs (
  id uuid primary key default gen_random_uuid(),
  full_name text not null check (char_length(full_name) > 0 and char_length(full_name) <= 100),
  section text not null check (char_length(section) > 0 and char_length(section) <= 100),
  action_type text not null check (action_type in ('IN', 'OUT')),
  date_display text not null,
  time_display text not null,
  created_at timestamptz not null default now()
);

-- Enable Row Level Security
alter table public.attendance_logs enable row level security;

-- Allow public read/write (suitable for internal/trusted use)
create policy "Allow public read"
  on public.attendance_logs for select
  using (true);

create policy "Allow public insert"
  on public.attendance_logs for insert
  with check (true);

-- Index for fast ordering
create index if not exists attendance_logs_created_at_idx
  on public.attendance_logs (created_at desc);

-- Enable real-time (run once; skip if already added)
-- If this fails, enable manually: Database → Replication → attendance_logs
do $$
begin
  alter publication supabase_realtime add table public.attendance_logs;
exception
  when duplicate_object then null;
end $$;
