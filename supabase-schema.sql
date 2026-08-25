-- Psychrometric Hatcher Calc — Supabase schema
-- Run this once in your Supabase project's SQL Editor (Project > SQL Editor > New query).
-- Creates two tables the app syncs to: batches and readings.

create table if not exists public.batches (
  id text primary key,
  name text not null,
  "setDate" date not null,
  "createdAt" timestamptz not null,
  "updatedAt" timestamptz not null
);

create table if not exists public.readings (
  id text primary key,
  "batchId" text not null references public.batches(id) on delete cascade,
  ts timestamptz not null,
  "stageLabel" text,
  "tdbF" numeric,
  "twbF" numeric,
  "rhPct" numeric,
  "dpF" numeric,
  "hiC" numeric,
  "updatedAt" timestamptz not null
);

create index if not exists readings_batch_idx on public.readings ("batchId");

-- Row Level Security: enabled, with a permissive policy for the anon key.
-- This is a small private-team tool, not a multi-tenant app — knowing the
-- project URL + anon key is effectively the "password" for this data.
-- Don't publish those two values anywhere public.
alter table public.batches enable row level security;
alter table public.readings enable row level security;

drop policy if exists "anon full access" on public.batches;
create policy "anon full access" on public.batches
  for all using (true) with check (true);

drop policy if exists "anon full access" on public.readings;
create policy "anon full access" on public.readings
  for all using (true) with check (true);
