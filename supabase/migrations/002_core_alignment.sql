-- ─── 002_core_alignment.sql ──────────────────────────────────────────────────
-- Supplement-core alignment pass.
-- Apply in Supabase SQL Editor after 001_initial_schema.sql.

-- 1. Add photo_url to ratings (review photos are already used in app code)
ALTER TABLE public.ratings
  ADD COLUMN IF NOT EXISTS photo_url text;

-- 2. Ensure review_comments exists (should be in 001, but safe to re-declare)
CREATE TABLE IF NOT EXISTS public.review_comments (
  id         uuid PRIMARY KEY DEFAULT gen_random_uuid(),
  rating_id  uuid NOT NULL REFERENCES public.ratings(id) ON DELETE CASCADE,
  user_id    uuid NOT NULL REFERENCES public.users(id)   ON DELETE CASCADE,
  text       text NOT NULL CHECK (char_length(text) BETWEEN 1 AND 280),
  created_at timestamptz NOT NULL DEFAULT now()
);

ALTER TABLE public.review_comments ENABLE ROW LEVEL SECURITY;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'review_comments' AND policyname = 'Anyone can read review comments'
  ) THEN
    CREATE POLICY "Anyone can read review comments"
      ON public.review_comments FOR SELECT USING (true);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'review_comments' AND policyname = 'Authenticated users can insert review comments'
  ) THEN
    CREATE POLICY "Authenticated users can insert review comments"
      ON public.review_comments FOR INSERT
      WITH CHECK (auth.uid() = user_id);
  END IF;
END $$;

DO $$ BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM pg_policies
    WHERE tablename = 'review_comments' AND policyname = 'Users can delete own review comments'
  ) THEN
    CREATE POLICY "Users can delete own review comments"
      ON public.review_comments FOR DELETE
      USING (auth.uid() = user_id);
  END IF;
END $$;

-- 3. Performance indexes
CREATE INDEX IF NOT EXISTS idx_review_comments_rating_id ON public.review_comments(rating_id);
CREATE INDEX IF NOT EXISTS idx_review_comments_user_id   ON public.review_comments(user_id);
CREATE INDEX IF NOT EXISTS idx_ratings_user_id            ON public.ratings(user_id);
CREATE INDEX IF NOT EXISTS idx_ratings_flavor_id          ON public.ratings(flavor_id);
CREATE INDEX IF NOT EXISTS idx_ratings_created_at         ON public.ratings(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_review_likes_rating_id     ON public.review_likes(rating_id);
CREATE INDEX IF NOT EXISTS idx_follows_following_id       ON public.follows(following_id);
CREATE INDEX IF NOT EXISTS idx_follows_follower_id        ON public.follows(follower_id);

-- 4. Storage bucket for review photos (run manually in Supabase dashboard if needed)
-- INSERT INTO storage.buckets (id, name, public) VALUES ('review-photos', 'review-photos', true)
-- ON CONFLICT (id) DO NOTHING;
