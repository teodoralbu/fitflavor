-- =============================================================================
-- 004_comment_threading.sql
-- Run this migration after 003_rating_system_v2.sql
--
-- Adds comment threading (parent_comment_id), soft delete (is_deleted),
-- and edit tracking (edited_at) to review_comments. Also adds the missing
-- RLS UPDATE policy required for both editing and soft-deleting comments.
-- =============================================================================


-- 1. Add parent_comment_id for threaded replies (null = top-level comment)
ALTER TABLE public.review_comments
  ADD COLUMN IF NOT EXISTS parent_comment_id UUID REFERENCES review_comments(id) ON DELETE CASCADE;


-- 2. Add soft-delete flag
ALTER TABLE public.review_comments
  ADD COLUMN IF NOT EXISTS is_deleted BOOLEAN NOT NULL DEFAULT false;


-- 3. Add edit timestamp (null = never edited)
ALTER TABLE public.review_comments
  ADD COLUMN IF NOT EXISTS edited_at TIMESTAMPTZ;


-- 4. Allow text to be nullable for soft-deleted comments
--    (CHECK constraint char_length(text) <= 280 already passes for NULL)
ALTER TABLE public.review_comments
  ALTER COLUMN text DROP NOT NULL;


-- 5. Partial index for efficient reply fetching
CREATE INDEX IF NOT EXISTS idx_review_comments_parent_id
  ON public.review_comments(parent_comment_id)
  WHERE parent_comment_id IS NOT NULL;


-- 6. RLS UPDATE policy — required for both edit and soft-delete operations
CREATE POLICY "review_comments: owner update"
  ON public.review_comments FOR UPDATE
  USING (auth.uid() = user_id);


-- =============================================================================
-- END OF MIGRATION 004_comment_threading.sql
-- =============================================================================
