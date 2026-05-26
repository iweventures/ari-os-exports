# Governance Content Export
# Generated: 2026-05-26T01:01 CDT
# Source: Supabase via bridge at localhost:8080

===== TABLE: corrections =====

**Status:** NOT AVAILABLE via bridge.
Error: "Table 'corrections' is not in the allowed list"
The corrections table exists in Supabase but is not on the bridge allowlist.
(See todo: e9ace594 — "Add corrections table to bridge allowlist")

===== TABLE: rules =====

**Status:** NOT AVAILABLE via bridge.
Error: "Table 'rules' is not in the allowed list"

===== TABLE: governance =====

**Status:** NOT AVAILABLE via bridge.
Error: "Table 'governance' is not in the allowed list"

===== TABLE: agent_tasks (schema + stats + sample) =====

**Row count:** 51

**Schema (columns observed):**
- `id` (uuid)
- `title` (text)
- `description` (text, nullable)
- `category` (text) — e.g. "system"
- `priority` (text) — e.g. "critical", "high", "medium"
- `status` (text) — e.g. "complete", "blocked"
- `owner_agent` (text) — e.g. "ari"
- `parent_task_id` (uuid, nullable)
- `requires_approval` (boolean)
- `approval_type` (text, nullable)
- `success_criteria` (text, nullable)
- `definition_of_done` (text, nullable)
- `due_at` (timestamptz, nullable)
- `created_by` (text) — e.g. "chad"
- `created_at` (timestamptz)
- `updated_at` (timestamptz)

**3 Representative Rows:**

1. **id:** 954f731f-612a-4e20-a9d4-2f564ef387d2
   **title:** Migrate TASK_LIST.md into Supabase
   **category:** system | **priority:** critical | **status:** complete
   **owner_agent:** ari | **created_by:** chad
   **success_criteria:** All open tasks in Markdown inserted into tasks table; TASK_LIST.md archived with timestamp
   **created_at:** 2026-03-06T16:42:02Z | **updated_at:** 2026-04-06T20:57:05Z

2. **id:** 990d11e1-b974-4cce-b7c0-f55568b21a4f
   **title:** Configure backup via rclone to servers.com
   **category:** system | **priority:** high | **status:** blocked
   **owner_agent:** ari | **created_by:** chad
   **success_criteria:** Nightly encrypted backups succeed; success log emailed; credentials stored securely
   **created_at:** 2026-03-06T16:42:14Z

3. **id:** ff4fd96c-84fb-45e5-8e19-03c2aac09d70
   **title:** X/Twitter API access setup
   **category:** system | **priority:** medium | **status:** blocked
   **owner_agent:** ari | **created_by:** chad
   **success_criteria:** X developer account established; API keys stored securely; sample search endpoint returns data
   **created_at:** 2026-03-06T19:53:17Z

===== TABLE: todos_backlog (5 specific rows) =====

--- Row 1: 6b03d3bb-dd4e-494f-91c0-b1506839e013 ---

**Title:** Formalize ari-os-exports transport lane (rulebook entry + docs + handoff handshake)

**Description:**
The ari-os-exports public repo is the approved Phase A export/transport lane — the one authorized exception to the no-agent-push-to-main preclusion, scoped to that repo only, secret-free files only. Now that it is becoming real infrastructure, formalize it:

(1) RULEBOOK (Phase B): add to reconciled SOUL.md — the push-to-main carve-out scoped to ari-os-exports, the public/secret-free hard rule, and the mandatory pre-push secret-scan in export-artifact.
(2) DOCS: document the export-artifact / export-clear helpers, the secret-scan patterns, and the fetch-confirm-then-clear handshake (sender reports raw URL -> recipient confirms receipt -> only then export-clear).
(3) HANDOFF VERIFICATION RULE: delivery/hand-off claims (pasted/pushed/sent/delivered) must carry a recipient-verifiable handle (fetchable URL, committed git SHA, or readable DB row); a bare "delivered" with no handle is treated as NOT delivered. Grounded in the 2026-05-25 files-not-delivered incident. Extends proof-of-work (Rule 16) to the transport layer.
(4) LONG-TERM SHAPE: decide separate-public-repo-on-main (current) vs branch-based.

Dependency: lane must exist (Ari building it now).

**Notes:** (none)
**Proof Submission:** (none)

--- Row 2: 2fd91e6a-abd9-44f9-8fc6-7c531fc62bf2 ---

**Title:** Revisit overloading of verification_history (verdict + execution records) — split or keep?

**Description:**
Surfaced during refinement of b43346ab-502e-491b-98bf-21bd00a6eb71 (Ari runtime skill pipeline).

DECISION TO REVISIT: Overloading public.todos_backlog.verification_history (jsonb) to hold BOTH verdict records (from task-verification) AND executor-touch records (which actor did which sub-task, needed for the verifier-identity refusal rule on mixed-model rows). Records use a "type" discriminator field — type="verdict" or type="execution".

EVALUATION QUESTIONS (run roughly 2026-06-19):
1. Average entries per active row at that point — is the mixed-type array becoming hard to scan?
2. Has any code path needed to filter the array and felt clunky?
3. Are there pending features (executor analytics, audit reports) that would be substantially easier with a split?
4. Any bugs traceable to type confusion in the array?

OUTCOME: Either (a) keep overloaded — document the pattern in skills and move on, or (b) migrate — add agent_execution_history table (or execution_history jsonb column on todos_backlog), write backfill script, update task-verification and task-execution handlers to write to the new location. Migration cost estimate: 1-2 days of ari time including handler updates and proof.

**Notes:** (none)
**Proof Submission:** (none)

--- Row 3: 703a630f-cc4f-437d-9507-6e96f26d6d64 ---

**Title:** Fix ari/main model drift — live config on opus-4-6, spec is opus-4-7

**Description:**
Ari/main is running on the wrong model. Live config (agents.defaults.model.primary) resolves ari/main to anthropic/claude-opus-4-6, but spec for Ari (Chief of Staff) is claude-opus-4-7. Confirmed live on 2026-05-22 via the new get-role-model helper during verification of the role-to-model-lookup task — this is the same gateway-default discrepancy flagged on 2026-05-16 (gateway log showed claude-opus-4-6 as default while Ari is supposed to use opus-4-7), now confirmed rather than suspected.

FIX: set agents.defaults.model.primary to anthropic/claude-opus-4-7 via `openclaw config set` (Rule 13 — never edit openclaw.json directly). Then verify with get-role-model ari/main and confirm the gateway picks it up (check gateway startup log / health).

BEFORE FLIPPING: confirm there wasn't a deliberate reason ari was pinned to opus-4-6 (cost, availability, a known issue with 4-7 in OpenClaw). Changing this swaps the live model the Chief-of-Staff agent runs on, so it's a deliberate change, not a blind correction. If 4-6 was intentional, update the spec/MEMORY.md instead so the "correct" model is unambiguous going forward.

NOT caused by the role-to-model-lookup task — that task surfaced the pre-existing drift; Ari was already running on opus-4-6.

**Notes:** (none)
**Proof Submission:** (none)

--- Row 4: bda38d89-b775-4726-aa58-3ade7f76eef3 ---

**Title:** Fix Ari's verbosity — stop giving intermediate build details

**Description:**
Ari burns tokens and annoys Chad by narrating every step of multi-step work (compilation output, file sizes, QA checks). Fix: (1) Update SOUL.md with explicit rule — when Chad says 'go build X', reply ONLY when the final deliverable file is ready to download. No intermediate status, no blow-by-blow, no QA details unless asked. (2) Consider adding a 'silent work mode' flag that suppresses all chat output until deliverable is ready. (3) Route build/compile work to scripts that run silently and only surface the final result.

**Notes:** (none)
**Proof Submission:** (none)

--- Row 5: 16b05ce4-ced8-4665-be58-f0d4e83742e1 ---

**Title:** Reinstate richer soul cards for all agents (token-budget aware)

**Description:**
Originals in ~/ari-os/souls/*.md. Current agent workspaces have generic SOUL.md. Adapt originals with token-budget awareness: compressed soul preamble (<500 tokens) + full soul in reference file the agent can optionally deep-read. Balance personality with efficiency for 30B/70B local models.

**Notes:** (none)
**Proof Submission:** (none)

===== END OF EXPORT =====
