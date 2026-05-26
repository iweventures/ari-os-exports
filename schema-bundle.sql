===== FILE: sql/001_schema.sql =====
-- Ari Agent OS — Supabase Schema v1.2
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

CREATE TABLE IF NOT EXISTS agents (
  id TEXT PRIMARY KEY,
  name TEXT NOT NULL,
  role_summary TEXT,
  domain TEXT CHECK (domain IN ('executive', 'business', 'personal')),
  soul_version TEXT DEFAULT 'v0.1-draft',
  default_model TEXT,
  runtime_state TEXT DEFAULT 'sleeping' CHECK (runtime_state IN ('active', 'sleeping', 'paused', 'disabled', 'retired')),
  always_on BOOLEAN DEFAULT false,
  can_initiate_work BOOLEAN DEFAULT false,
  escalation_to_agent TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS tasks (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  category TEXT CHECK (category IN ('business', 'personal', 'system')),
  priority TEXT CHECK (priority IN ('critical', 'high', 'medium', 'low')),
  status TEXT DEFAULT 'not_started' CHECK (status IN ('not_started', 'in_progress', 'blocked', 'in_review', 'complete', 'cancelled')),
  owner_agent TEXT REFERENCES agents(id),
  parent_task_id UUID REFERENCES tasks(id),
  requires_approval BOOLEAN DEFAULT false,
  approval_type TEXT,
  success_criteria TEXT,
  definition_of_done TEXT,
  due_at TIMESTAMPTZ,
  created_by TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS task_steps (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
  step_order INTEGER NOT NULL,
  step_text TEXT NOT NULL,
  status TEXT DEFAULT 'not_started' CHECK (status IN ('not_started', 'in_progress', 'complete', 'skipped')),
  assigned_agent TEXT REFERENCES agents(id)
);

CREATE TABLE IF NOT EXISTS agent_runs (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  agent_id TEXT REFERENCES agents(id),
  started_at TIMESTAMPTZ DEFAULT NOW(),
  ended_at TIMESTAMPTZ,
  trigger_type TEXT CHECK (trigger_type IN ('cron', 'direct_message', 'routed', 'manual')),
  task_id UUID REFERENCES tasks(id),
  objective TEXT,
  outcome_summary TEXT,
  artifacts_produced TEXT[],
  confidence TEXT CHECK (confidence IN ('high', 'medium', 'low')),
  model_used TEXT,
  input_tokens INTEGER,
  output_tokens INTEGER,
  estimated_cost_usd DECIMAL(10,4)
);

CREATE TABLE IF NOT EXISTS memory_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  scope TEXT CHECK (scope IN ('global', 'agent', 'task', 'personal')),
  agent_id TEXT REFERENCES agents(id),
  subject TEXT NOT NULL,
  content TEXT NOT NULL,
  source TEXT,
  confidence TEXT CHECK (confidence IN ('high', 'medium', 'low')),
  active BOOLEAN DEFAULT true,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS artifacts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  task_id UUID REFERENCES tasks(id),
  title TEXT NOT NULL,
  type TEXT CHECK (type IN ('research', 'plan', 'report', 'code', 'config', 'legal', 'financial', 'content', 'other')),
  storage_path TEXT,
  summary TEXT,
  created_by_agent TEXT REFERENCES agents(id),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS approvals (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  task_id UUID REFERENCES tasks(id),
  requested_by_agent TEXT REFERENCES agents(id),
  reason TEXT NOT NULL,
  proposed_action TEXT NOT NULL,
  risk_level TEXT CHECK (risk_level IN ('low', 'medium', 'high', 'critical')),
  approval_status TEXT DEFAULT 'pending' CHECK (approval_status IN ('pending', 'approved', 'denied', 'expired')),
  approved_by TEXT,
  approved_at TIMESTAMPTZ,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS corrections (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  correction_number INTEGER NOT NULL,
  issue TEXT NOT NULL,
  root_cause TEXT,
  fix_applied TEXT,
  fix_location TEXT,
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'resolved')),
  reported_at TIMESTAMPTZ DEFAULT NOW(),
  resolved_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS briefings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  agent_id TEXT REFERENCES agents(id),
  cadence TEXT CHECK (cadence IN ('morning', 'evening', 'status_ping', 'daily_coaching')),
  content TEXT NOT NULL,
  linked_task_ids UUID[],
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS grocery_list (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  item TEXT NOT NULL,
  quantity TEXT,
  category TEXT DEFAULT 'other' CHECK (category IN ('produce', 'dairy', 'meat', 'pantry', 'household', 'other')),
  added_by TEXT DEFAULT 'chad',
  added_at TIMESTAMPTZ DEFAULT NOW(),
  purchased BOOLEAN DEFAULT false,
  purchased_at TIMESTAMPTZ,
  list_sent_at TIMESTAMPTZ
);

CREATE TABLE IF NOT EXISTS agent_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  from_agent TEXT REFERENCES agents(id),
  to_agent TEXT REFERENCES agents(id),
  task_id UUID REFERENCES tasks(id),
  message_type TEXT CHECK (message_type IN ('task_assignment', 'status_update', 'escalation', 'approval_request', 'response')),
  content TEXT NOT NULL,
  status TEXT DEFAULT 'sent' CHECK (status IN ('sent', 'received', 'processed')),
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE IF NOT EXISTS agent_assignments (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  task_id UUID REFERENCES tasks(id) ON DELETE CASCADE,
  agent_id TEXT REFERENCES agents(id),
  assignment_type TEXT CHECK (assignment_type IN ('owner', 'reviewer', 'contributor')),
  status TEXT DEFAULT 'active' CHECK (status IN ('active', 'complete', 'reassigned')),
  started_at TIMESTAMPTZ DEFAULT NOW(),
  ended_at TIMESTAMPTZ,
  result_summary TEXT
);

CREATE OR REPLACE FUNCTION update_updated_at()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_agents_updated_at BEFORE UPDATE ON agents FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_tasks_updated_at BEFORE UPDATE ON tasks FOR EACH ROW EXECUTE FUNCTION update_updated_at();
CREATE TRIGGER update_memory_items_updated_at BEFORE UPDATE ON memory_items FOR EACH ROW EXECUTE FUNCTION update_updated_at();

===== FILE: sql/002_seed_agents.sql =====
-- Ari Agent OS — Seed Data: Agent Registry

-- Executive Core (always active)
INSERT INTO agents (id, name, role_summary, domain, default_model, runtime_state, always_on, can_initiate_work, soul_version) VALUES
('ari', 'Ari', 'Chief of Staff, Executive Assistant, Orchestrator', 'executive', 'openai/o3', 'active', true, true, 'v0.1-draft'),
('kirk', 'Kirk', 'Kingdom, Ethics, and Mission Reviewer', 'executive', 'ollama/llama3.1:8b', 'active', true, false, 'v0.1-draft'),
('akston', 'Akston', 'Strategic Architect, Long-View Thinker', 'executive', 'ollama/llama3.1:8b', 'active', true, false, 'v0.1-draft');

-- Active Business Specialists (this weekend)
INSERT INTO agents (id, name, role_summary, domain, default_model, runtime_state, always_on, can_initiate_work, soul_version) VALUES
('jenni', 'Jenni', 'Social Media Marketing Lead', 'business', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft'),
('renee', 'Renee', 'Finance and Accounting Analyst', 'business', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft'),
('elle', 'Elle', 'Legal Operations, IP Sentinel, DR Owner', 'business', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft');

-- Future Business Specialists (seeded but sleeping)
INSERT INTO agents (id, name, role_summary, domain, default_model, runtime_state, always_on, can_initiate_work, soul_version) VALUES
('mason', 'Mason', 'Sales Operations and Funnel Manager', 'business', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft'),
('piper', 'Piper', 'Product and UX Research Lead', 'business', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft'),
('john', 'John G', 'Technical Delivery Manager', 'business', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft'),
('vale', 'Vale', 'QA / UAT / Site Audit Specialist', 'business', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft'),
('mercer', 'Mercer', 'Market and Competitive Intelligence', 'business', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft'),
('nora', 'Nora', 'Knowledge and Documentation Librarian', 'business', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft'),
('bruiser', 'Bruiser', 'Legal Investigations Sidekick', 'business', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft');

-- Personal Specialists (seeded but sleeping)
INSERT INTO agents (id, name, role_summary, domain, default_model, runtime_state, always_on, can_initiate_work, soul_version) VALUES
('ridge', 'Ridge', 'Wellness and Medical-Admin Specialist', 'personal', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft'),
('abe', 'Abe', 'Spiritual Growth Guide', 'personal', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft'),
('julia', 'Julia', 'Meal Planner and Grocery Coordinator', 'personal', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft'),
('philip', 'Philip', 'Relationship and Family Rhythm Advisor', 'personal', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft'),
('sage', 'Sage', 'Personal Planning and Calendar Strategist', 'personal', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft'),
('harbor', 'Harbor', 'Household and Errands Coordinator', 'personal', 'openai/gpt-4o-mini', 'sleeping', false, false, 'v0.1-draft');

===== FILE: sql/migrations/003_status_check_constraint.sql =====
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

