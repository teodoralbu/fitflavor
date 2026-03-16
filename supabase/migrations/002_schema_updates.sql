-- ─── 002_schema_updates.sql ──────────────────────────────────────────────────
-- Run this migration in Supabase SQL Editor after 001_initial_schema.sql

-- 1. rep_likes table (for liking rep/gym-check posts)
create table if not exists public.rep_likes (
  id         uuid primary key default gen_random_uuid(),
  rep_id     uuid not null references public.reps(id) on delete cascade,
  user_id    uuid not null references public.users(id) on delete cascade,
  created_at timestamptz not null default now(),
  constraint rep_likes_unique unique (rep_id, user_id)
);

alter table public.rep_likes enable row level security;

create policy "Anyone can read rep likes"
  on public.rep_likes for select using (true);

create policy "Authenticated users can insert rep likes"
  on public.rep_likes for insert
  with check (auth.uid() = user_id);

create policy "Users can delete own rep likes"
  on public.rep_likes for delete
  using (auth.uid() = user_id);

-- 2. comments.rep_id column (for comments on rep posts)
alter table public.comments
  add column if not exists rep_id uuid references public.reps(id) on delete cascade;

-- 3. Prevent duplicate ratings per user per flavor
alter table public.ratings
  drop constraint if exists ratings_user_flavor_unique;

alter table public.ratings
  add constraint ratings_user_flavor_unique unique (user_id, flavor_id);

-- 4. Indexes for performance
create index if not exists idx_rep_likes_rep_id   on public.rep_likes(rep_id);
create index if not exists idx_rep_likes_user_id  on public.rep_likes(user_id);
create index if not exists idx_comments_rep_id    on public.comments(rep_id);
create index if not exists idx_comments_rating_id on public.comments(rating_id);
create index if not exists idx_ratings_flavor_id  on public.ratings(flavor_id);
create index if not exists idx_ratings_user_id    on public.ratings(user_id);
create index if not exists idx_follows_following  on public.follows(following_id);
create index if not exists idx_follows_follower   on public.follows(follower_id);
