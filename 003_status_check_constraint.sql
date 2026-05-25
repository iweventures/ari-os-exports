-- Migration 003: Add CHECK constraint on todos_backlog.status
-- Locks the status column to the canonical 9-status pipeline.
-- See: ~/ari-os/docs/todo-pipeline.md for the full pipeline reference.
--
-- IMPORTANT: Do NOT execute without Chad's explicit approval.
-- This migration is idempotent — safe to re-run.

BEGIN;

-- ============================================================
-- Step 1: Migrate any non-canonical status values
-- ============================================================

-- waiting → blocked
UPDATE todos_backlog
SET    status = 'blocked',
       notes  = COALESCE(notes || E'\n', '') || '[migration-003] status migrated from ''waiting'' to ''blocked'' on ' || NOW()::text
WHERE  status = 'waiting';

-- pending_review → pending_verification
UPDATE todos_backlog
SET    status = 'pending_verification',
       notes  = COALESCE(notes || E'\n', '') || '[migration-003] status migrated from ''pending_review'' to ''pending_verification'' on ' || NOW()::text
WHERE  status = 'pending_review';

-- rejected → in_progress (returned for rework)
UPDATE todos_backlog
SET    status = 'in_progress',
       notes  = COALESCE(notes || E'\n', '') || '[migration-003] status migrated from ''rejected'' to ''in_progress'' on ' || NOW()::text
WHERE  status = 'rejected';

-- ============================================================
-- Step 2: Add CHECK constraint (idempotent)
-- ============================================================

ALTER TABLE todos_backlog
  DROP CONSTRAINT IF EXISTS todos_backlog_status_check;

ALTER TABLE todos_backlog
  ADD CONSTRAINT todos_backlog_status_check
  CHECK (status IN (
    'backlog',
    'ready',
    'in_progress',
    'blocked',
    'awaiting_approval_gate',
    'pending_verification',
    'pending_approval',
    'done',
    'cancelled'
  ));

COMMENT ON CONSTRAINT todos_backlog_status_check ON todos_backlog IS
  'Enforces the canonical 9-status pipeline. See ~/ari-os/docs/todo-pipeline.md for definitions, transitions, and ownership rules.';

COMMIT;
