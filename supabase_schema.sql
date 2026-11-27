create table if not exists public.phd_scholars (
  id uuid primary key default gen_random_uuid(),
  category text not null default 'active', -- 'active' or 'passed'
  enrollment_no text default 'Pending Allotment',
  passing_year text default '',
  "current_role" text default '',
  name text not null,
  department text not null,
  email text unique not null,
  phone text not null,
  topic text not null,
  scopus_status text not null default 'Not Started',
  scopus_title text default '',
  scopus_journal text default '',
  coursework_status text not null default 'Ongoing', -- 'Completed' or 'Ongoing'
  rdc_attempt text not null default '0', -- '0' to '6'
  progress_till_date text not null default '',
  current_issues text default '',
  approval_status text not null default 'pending', -- 'pending', 'approved', 'rejected'
  vc_remark text default '',
  logs jsonb not null default '[]'::jsonb,
  created_at timestamptz not null default now()
);

-- Safely add the new columns if your table already exists
alter table public.phd_scholars
  add column if not exists coursework_status text not null default 'Ongoing',
  add column if not exists rdc_attempt text not null default '0';

-- Enable Row Level Security and grant public API permissions for the portal
alter table public.phd_scholars enable row level security;

grant usage on schema public to anon, authenticated;
grant select, insert, update, delete on table public.phd_scholars to anon, authenticated;

drop policy if exists "Allow portal read access" on public.phd_scholars;
create policy "Allow portal read access"
  on public.phd_scholars for select
  to anon, authenticated
  using (true);

drop policy if exists "Allow portal insert access" on public.phd_scholars;
create policy "Allow portal insert access"
  on public.phd_scholars for insert
  to anon, authenticated
  with check (true);

drop policy if exists "Allow portal update access" on public.phd_scholars;
create policy "Allow portal update access"
  on public.phd_scholars for update
  to anon, authenticated
  using (true)
  with check (true);

-- Refresh PostgREST schema cache
NOTIFY pgrst, 'reload schema';