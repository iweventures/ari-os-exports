# Operating Rules Inventory

_Discovery sweep — 2026-05-23. No rules created or modified. Verbatim transcription only._

---

## Numbering Schemes Found

Two distinct numbering layers exist and have drifted over time:

1. **Core Behaviors (1–9)** — defined in `souls/ari.md` as operational behaviors
2. **SOUL Rules (13, 15, 16, 16b, 17)** — governance-layer rules referenced in `skills/task-execution/SKILL.md` and `SOUL.md`
3. **Legacy numbering (1–12)** — an older scheme captured in Open Brain (2026-04-07) that partially overlaps with but does not match the current Core Behaviors

These are documented separately below.

---

## Layer 1: Core Behaviors (souls/ari.md)

Source: `~/ari-os/souls/ari.md` lines 19–27

### Core Behavior 1 — Specification Gate
**Verbatim:** "Specification Gate: Classify every request as Clear / Clear-with-assumptions / Too-vague. Too-vague returns a Crisp Requirements Card before proceeding."
**Source:** `~/ari-os/souls/ari.md#L19`
**Also referenced in:** `~/.openclaw/workspace/MEMORY.md` (§ Core Behaviors, item 1)

### Core Behavior 2 — Route by Function
**Verbatim:** "Route by function: Use the routing matrix to delegate to the right specialist."
**Source:** `~/ari-os/souls/ari.md#L20`
**Also referenced in:** `~/.openclaw/workspace/MEMORY.md` (§ Core Behaviors, item 2)

### Core Behavior 3 — Wake/Sleep Specialists
**Verbatim:** "Wake/Sleep specialists: Wake sleeping agents for bounded tasks, collect output, sleep them."
**Source:** `~/ari-os/souls/ari.md#L21`
**Also referenced in:** `~/.openclaw/workspace/MEMORY.md` (§ Core Behaviors, item 3)

### Core Behavior 4 — Approval Packets
**Verbatim:** "Approval packets: Present structured packet with context, recommendation, risk assessment, and clear yes/no decision point."
**Source:** `~/ari-os/souls/ari.md#L22`
**Also referenced in:** `~/.openclaw/workspace/MEMORY.md` (§ Core Behaviors, item 4)

### Core Behavior 5 — Quality Standard
**Verbatim:** "Quality standard: Every deliverable must meet definition of done with evidence."
**Source:** `~/ari-os/souls/ari.md#L23`
**Also referenced in:** `~/.openclaw/workspace/MEMORY.md` (§ Core Behaviors, item 5)

### Core Behavior 6 — Daily Coaching Note
**Verbatim:** "Daily coaching note (once daily): One thing Chad did well, one ambiguity that hurt, one crisper framing example."
**Source:** `~/ari-os/souls/ari.md#L24`
**Also referenced in:** `~/.openclaw/workspace/MEMORY.md` (§ Core Behaviors, item 9 — different numbering)

### Core Behavior 7 — Database-first
**Verbatim:** "Database-first: Read/write operational state to Supabase via bridge."
**Source:** `~/ari-os/souls/ari.md#L25`
**Also referenced in:** `~/.openclaw/workspace/MEMORY.md` (§ Core Behaviors, item 5 — "Database-first — Supabase is canonical; files are export artifacts.")
**Conflicts/Notes:** MEMORY.md numbers this as item 5 and phrases it differently; souls/ari.md numbers it as 7.

### Core Behavior 8 — Cost Visibility
**Verbatim:** "Cost visibility: Log model used and estimated cost on every agent_run. Use the right model for the task — quality over cost savings. Chad enforces budget limits externally."
**Source:** `~/ari-os/souls/ari.md#L26`
**Also referenced in:** `~/.openclaw/workspace/MEMORY.md` (§ Core Behaviors, item 7)

### Core Behavior 9 — Priority Override
**Verbatim:** "Priority Override: When Chad issues override, immediately INSERT into tasks and memory_items via bridge, pause current work, execute, deliver, resume."
**Source:** `~/ari-os/souls/ari.md#L27`
**Also referenced in:** `~/.openclaw/workspace/MEMORY.md` (§ Core Behaviors, item 6)

---

## Layer 2: SOUL Rules (Governance Layer)

### Rule 13 — No Direct openclaw.json Edits
**Verbatim:** "Editing `openclaw.json` directly (Rule 13 — always use `openclaw config set`)"
**Source:** `~/ari-os/skills/task-execution/SKILL.md#L54` (Global preclusions list)
**Also referenced in:**
- `~/ari-os/bin/set-role-model#L122`: `# --- Apply via openclaw config set (Rule 13) ---`
- `~/ari-os/bin/set-role-model#L143`: `# Read MCP credentials via openclaw config get (Rule 13 — never touch openclaw.json directly)`
- `~/ari-os/proofs/role-model-helpers-20260522-0638.md#L210`: "Rule 13 Attestation" section
- `~/ari-os/briefs/ari-token-cost-strategy-20260522.md#L6`: "respecting… Rule 13 (no direct openclaw.json edits)"
- `~/ari-os/briefs/ari-token-cost-strategy-20260522.md#L177`: "all config changes proposed use `openclaw config set` or `openclaw cron set` commands, never direct file editing"
- `~/ari-os/briefs/openclaw-5.12-audit.md#L72`: "`localService` config requires `openclaw.json` model provider edits → Rule 13."
**Conflicts/Notes:** None. Consistently defined and referenced.

### Rule 15 — Only Chad Sets Done
**Verbatim (task-execution/SKILL.md, description):** "Critical rule — executors NEVER set status to done. Only Chad sets done."
**Verbatim (task-execution/SKILL.md, § The absolute rule):** "You do not set status to `done`. Ever. [...] If you write code or logic that auto-sets status to `done`, you have broken the contract. The only valid path to done is through Chad. This rule is non-negotiable."
**Verbatim (task-verification/SKILL.md, § What you never do):** "Set status to `done` (that's Chad's gate, exclusively)"
**Source:** `~/ari-os/skills/task-execution/SKILL.md#L3` (description), `#L12-L21` (§ The absolute rule)
**Also referenced in:**
- `~/ari-os/skills/task-execution/SKILL.md#L63`: "Modifying any of the three SOUL Rules (15, 16, 17) or this preclusion list itself"
- `~/ari-os/skills/task-verification/SKILL.md#L113`
- Chad's directives in conversation (2026-05-23): "closes are Chad's call (Rule 15)"
**Conflicts/Notes:** The number "15" itself is only seen in the preclusion list reference ("the three SOUL Rules (15, 16, 17)") and in Chad's messages. The substance is thoroughly defined in task-execution/SKILL.md but without the number in the body text.

### Rule 16 — Proof of Work Standard
**Verbatim (task-execution/SKILL.md, preclusion reference):** "Modifying any of the three SOUL Rules (15, 16, 17) or this preclusion list itself"
**Verbatim (Open Brain, 2026-04-07):** "(12) Proof of work required for every completion." [INFORMAL — this is the legacy numbering; the substance was later assigned number 16]
**Source:** Referenced in `~/ari-os/skills/task-execution/SKILL.md#L63`; substantive definition evolved into Rule 16b below.
**Conflicts/Notes:** The original Rule 16 appears to be the general principle that proof of work is required. Rule 16b (below) is the specific operational gate. No standalone verbatim "Rule 16" definition found outside the preclusion list reference and the Open Brain legacy entry.

### Rule 16b — Proof-of-Work Gate
**Verbatim:** "Proof-of-work gate (Rule 16b). No "done" or "complete" report may be sent to Chad until the reporting agent has, in the same turn: (1) re-read each executed row's current `status` from `todos_backlog` (the canonical source, accessed via MCP or Supabase bridge) and confirmed it is `pending_verification`; and (2) confirmed the expected deliverable file exists on disk at the stated path **and is non-trivial** — containing real deliverable content and an AC section, not a stub or placeholder. These checks apply whether the row was executed directly or via a spawned sub-agent. A report that skips either check is considered unverified and must not be delivered. If any row fails, report the specific failure instead of claiming completion."
**Source:** `~/.openclaw/workspace/SOUL.md` (§ Proof-of-Work) — applied 2026-05-23
**Also referenced in:** `~/.openclaw/workspace/MEMORY.md` (§ Proof-of-Work, identical text in project context)
**Conflicts/Notes:** None. Freshly codified.

### Rule 17 — Data Isolation / No Bulk Data in Memory Tables
**Verbatim (task-execution/SKILL.md, preclusion reference):** "Modifying any of the three SOUL Rules (15, 16, 17) or this preclusion list itself"
**Source:** Referenced in `~/ari-os/skills/task-execution/SKILL.md#L63`
**Also referenced in:** Chad's messages (2026-05-23): "Rule 17 is already assigned ('no bulk data in memory tables without dedicated architecture')"
**Conflicts/Notes:** No standalone verbatim definition found in any file or Open Brain thought. The substance ("no bulk data in memory_items without dedicated table architecture") is known only from Chad's verbal reference. The Open Brain search for "Rule 17", "data isolation", "bulk", and "memory_items" returned no matching thoughts. **[DEFINITION INCOMPLETE — only the preclusion cross-reference and Chad's verbal description exist; no formal written definition found.]**

---

## Layer 3: Legacy Numbering (Open Brain, 2026-04-07)

A single Open Brain thought (captured 2026-04-07, type: reference, topics: rules/work/database, person: Ari) records an older rule set:

**Verbatim:** "Ari's SOUL.md contains 12 rules: (1) Start by reading from database, (2) Do real work every session, (3) Never fabricate information, (3.5) Priority overrides written immediately, (3.6) Read corrections every session, (4) Never do destructive actions without approval, (5) Security, (10) Specification Gate for new tasks, (11) Model Selection per task, (12) Proof of work required for every completion."
**Source:** Open Brain thought, captured 2026-04-07

### Legacy mapping to current rules:

| Legacy # | Legacy label | Current equivalent | Notes |
|---|---|---|---|
| 1 | Start by reading from database | Core Behavior 7 (Database-first) | Substance preserved, renumbered |
| 2 | Do real work every session | — | No current equivalent found |
| 3 | Never fabricate information | — | Implicit in SOUL.md ("Be resourceful before asking") but no numbered rule |
| 3.5 | Priority overrides written immediately | Core Behavior 9 (Priority Override) | Substance preserved, renumbered |
| 3.6 | Read corrections every session | souls/ari.md § CORRECTIONS | Preserved as a section, not a numbered behavior |
| 4 | Never do destructive actions without approval | souls/ari.md § BOUNDARIES | "Cannot make irreversible external changes without approval" |
| 5 | Security | souls/ari.md § SECURITY | Preserved as a section |
| 6–9 | — | — | Gap — no rules 6–9 in the Open Brain capture |
| 10 | Specification Gate for new tasks | Core Behavior 1 | Substance preserved, renumbered |
| 11 | Model Selection per task | Core Behavior 8 (Cost visibility) / dor-refinement routing | Split across multiple locations |
| 12 | Proof of work required for every completion | Rule 16 / Rule 16b | Renumbered into governance layer |

---

## Referenced but Definition Not Found

### "Rule 4 (config hard-stop)"
**Referenced by:** Chad (2026-05-23 message: "Earlier references exist to a Rule 4 (config hard-stop)")
**Closest match:** Legacy Rule 4 "Never do destructive actions without approval" (Open Brain 2026-04-07) OR the Global Preclusion for config changes ("Cannot make config/infrastructure changes without approval" — `souls/ari.md#L31`). Neither is formally labeled "Rule 4" in current files.
**Status:** [REFERENCED, FORMAL DEFINITION NOT FOUND]

### "Rule 7 (delegate to cheaper models)"
**Referenced by:** Chad (2026-05-23 message: "Earlier references exist to a Rule 7 (delegate to cheaper models)")
**Closest match:** `dor-refinement/SKILL.md#L63`: "Bias toward free models. Only escalate to ari or sonnet when there's a concrete reason — judgment, voice, ambiguity, novelty, or a quality bar local roles can't reliably hit." Also Core Behavior 8 (Cost visibility) and `~/ari-os/briefs/ari-token-cost-strategy-20260522.md` cost strategy. Neither is formally labeled "Rule 7."
**Status:** [REFERENCED, FORMAL DEFINITION NOT FOUND]

---

## Unnamed / Structural Rules (not numbered but operative)

### Global Preclusions List
**Verbatim:** (full list)
```
- Editing `openclaw.json` directly (Rule 13 — always use `openclaw config set`)
- Editing `SOUL.md` or any agent governance file
- Touching credentials, API keys, secrets, or `.env` files
- `git push` to main on any IWE production repo
- Any DNS change on the 96 portfolio domains
- Spend over $1 not pre-approved in the todo
- Sending email, Slack message, or social post on Chad's behalf
- File deletes outside `/tmp` or workspace scratch directories
- Schema changes to any Supabase project
- Modifying any of the three SOUL Rules (15, 16, 17) or this preclusion list itself
```
**Source:** `~/ari-os/skills/task-execution/SKILL.md#L52-L63`

### Boundaries (Ari)
**Verbatim:**
```
- Cannot redesign system architecture without approval
- Cannot make config/infrastructure changes without approval
- Cannot make irreversible external changes without approval
```
**Source:** `~/ari-os/souls/ari.md#L30-L32`

### Separation of Duties
**Verbatim:** "you do not verify your own executor work. If you executed the task and the verification request lands with you, escalate to a different verifier or directly to Chad."
**Source:** `~/ari-os/skills/task-verification/SKILL.md#L14-L15`

### Verification Loop Ceiling
**Verbatim:** "When `verification_attempts >= 3`, do not loop further. Escalate to Chad."
**Source:** `~/ari-os/skills/task-verification/SKILL.md#L60`

### DoR Gate — Eight Criteria
**Verbatim:** "A todo is at DoR if and only if all eight are true: [1] Intent is unambiguous. [2] Acceptance criteria are testable. [3] Proof artifact is named. [4] Inputs and prerequisites are listed. [5] Out of scope is declared. [6] Model is assigned with rationale. [7] Frontier prep is complete (if needed). [8] Chad has approved."
**Source:** `~/ari-os/skills/dor-refinement/SKILL.md#L12-L19`

### Chad Final Gate on DoR
**Verbatim:** "`dor_met = true` is only set by Chad. No agent self-approves DoR."
**Source:** `~/ari-os/skills/dor-refinement/SKILL.md#L19`

### Web Research Protocol
**Verbatim:** (full protocol in SOUL.md — intent gate, curated execution, injection sweep, approval gate, graceful degradation)
**Source:** `~/.openclaw/workspace/SOUL.md` (§ Web Research Protocol)

### AMPLIYFII Spelling
**Verbatim:** "AMPLIYFII is always spelled: A-M-P-L-I-Y-F-I-I."
**Source:** `~/ari-os/souls/ari.md#L40`; `~/.openclaw/workspace/MEMORY.md` (§ Hard Rules)

### Kirk Boundaries
**Verbatim:** "Do not override Ari operational decisions unless mission alignment is at stake" / "Do not escalate to paid models without Ari approval"
**Source:** `~/ari-os/souls/kirk.md` (§ BOUNDARIES)

### Akston Boundaries
**Verbatim:** "Do not override Ari unless long-term risk is significant" / "Do not escalate to paid models without Ari approval"
**Source:** `~/ari-os/souls/akston.md` (§ BOUNDARIES)

---

## Sources Swept

| Source | Checked | Rule content found |
|---|---|---|
| `~/.openclaw/workspace/SOUL.md` | ✅ | Rule 16b, Web Research Protocol |
| `~/ari-os/souls/ari.md` | ✅ | Core Behaviors 1–9, Boundaries, Security, Corrections, Communication |
| `~/ari-os/souls/kirk.md` | ✅ | Kirk boundaries |
| `~/ari-os/souls/akston.md` | ✅ | Akston boundaries |
| `~/ari-os/souls/elle.md` | ✅ | No numbered rules |
| `~/ari-os/souls/jenni.md` | ✅ | No numbered rules |
| `~/ari-os/souls/renee.md` | ✅ | No numbered rules |
| `~/ari-os/skills/task-execution/SKILL.md` | ✅ | Rule 13, Rule 15 substance, Rules 15/16/17 cross-ref, Global Preclusions |
| `~/ari-os/skills/task-verification/SKILL.md` | ✅ | Rule 15 substance, Separation of Duties, Loop Ceiling |
| `~/ari-os/skills/dor-refinement/SKILL.md` | ✅ | DoR 8 criteria, free-model bias, Chad gate |
| `~/ari-os/bin/set-role-model` | ✅ | Rule 13 references (comments) |
| `~/ari-os/bin/get-role-model` | ✅ | No rule references |
| `~/ari-os/briefs/*.md` | ✅ | Rule 13 references |
| `~/ari-os/proofs/*.md` | ✅ | Rule 13 attestation |
| `~/.openclaw/workspace/MEMORY.md` | ✅ | Core Behaviors (renumbered), Hard Rules |
| `~/.openclaw/workspace/memory/*.md` | ✅ | No formal rule definitions |
| `~/.openclaw/agents/kirk/` | ✅ | Same as souls/kirk.md |
| `~/.openclaw/agents/akston/` | ✅ | Same as souls/akston.md |
| Open Brain (search_thoughts) | ✅ | Legacy 12-rule list (2026-04-07) |
| CORRECTIONS.md | ✅ | File not found — corrections are in Supabase per souls/ari.md |

---

## Known Gaps

1. **Rule 17 has no formal written definition.** Only the preclusion cross-reference and Chad's verbal description ("no bulk data in memory tables without dedicated architecture") exist.
2. **"Rule 4 (config hard-stop)" and "Rule 7 (delegate to cheaper models)"** as Chad labeled them have no formal definition matching those labels. Closest matches identified above.
3. **Legacy rules 6–9** are unaccounted for — the Open Brain capture skips from 5 to 10.
4. **Legacy rule 2 ("Do real work every session")** has no current equivalent.
5. **MEMORY.md Core Behaviors numbering** doesn't match `souls/ari.md` numbering — items are reordered and renumbered.

---

## Supabase Sweep + Coverage

_Sweep date: 2026-05-25. Read-only discovery. No changes applied._

### Bridge-Reachable Tables

The Supabase bridge (`http://localhost:8080/query`) has an allowlist. Tables tested:

| Table | Accessible | Row count | Notes |
|---|---|---|---|
| `todos_backlog` | ✅ | 116 | **LIVE canonical backlog.** 9-status pipeline enforced by `todos_backlog_status_check` constraint. |
| `agent_tasks` | ✅ | 51 | **LEGACY.** Pre-pipeline table. Statuses: not_started(28), complete(13), blocked(5), in_progress(5). No CHECK constraint. |
| `agent_briefings` | ✅ | 0 | Empty table. |
| `tasks` | ❌ | — | Not in allowlist. |
| `memory_items` | ❌ | — | Not in allowlist. |
| `thoughts` | ❌ | — | Not in allowlist (Open Brain thoughts accessed via MCP only). |
| `corrections` | ❌ | — | Not in allowlist. Cannot sweep via bridge. |
| `rules` | ❌ | — | Table does not exist or not in allowlist. |
| `governance` | ❌ | — | Table does not exist or not in allowlist. |
| `pillars_entries` | ❌ | — | Not in allowlist (accessed via IWE Life OS MCP only). |

### tasks (legacy) vs todos_backlog — Which Is Live?

**`todos_backlog` is live.** 116 rows with the canonical 9-status pipeline, CHECK constraint enforced. Status distribution: backlog(84), done(18), pending_verification(7), in_progress(6), ready(1).

**`agent_tasks` is legacy.** 51 rows with freeform statuses (not_started, complete, blocked, in_progress). No CHECK constraint. The Kirk & Akston SOULs task (a9b2c175) exists in both tables — `agent_tasks` shows "complete", `todos_backlog` shows "done".

### corrections Table

Not in the bridge allowlist. Cannot sweep. Per `souls/ari.md`, corrections are read from Supabase each session, but the table is not bridge-reachable. **Gap: corrections data is inaccessible to agents via the bridge.**

### Governance Text in todos_backlog

Searched for: rule, preclusion, governance, soul, separation of duties, proof of work, boundary.

**Hits with governance-relevant content:**

| ID (prefix) | Title | Status | Governance relevance |
|---|---|---|---|
| `6b03d3bb` | Formalize ari-os-exports transport lane (rulebook entry + docs + handoff handshake) | backlog | References "no-agent-push-to-main preclusion", mandatory secret-scan, handoff verification rule extending Rule 16. |
| `170d0458` | Operationalize role-to-model lookup with audit trail | done | References Rule 13 (no direct openclaw.json edits). First todo through full DoR pipeline. |
| `2fd91e6a` | Revisit overloading of verification_history (verdict + execution records) — split or keep? | backlog | Defines the `type` discriminator field pattern (type="verdict" vs type="execution") for verification_history entries. |
| `703a630f` | Fix ari/main model drift — live config on opus-4-6, spec is opus-4-7 | backlog | Model governance — config vs spec divergence. |
| `bda38d89` | Fix Ari's verbosity — stop giving intermediate build details | backlog | References updating SOUL.md with explicit rule. |
| `16b05ce4` | Reinstate richer soul cards for all agents (token-budget aware) | backlog | Agent soul card governance. |

**No todos_backlog row contains a more complete version of SOUL.md governance rules than what's in `~/.openclaw/workspace/SOUL.md` or `~/ari-os/skills/task-execution/SKILL.md`.** The closest is `6b03d3bb` which proposes extending Rule 16 to the transport layer but is still backlog (not yet codified).

### Governance Text in Open Brain

278 thoughts total (2026-04-07 through 2026-05-25). Semantic search for governance terms ("numbered rules for agents", "Chad approval required", "no agent push to main", "agent must not set done", etc.) returned only low-relevance matches (≤50.6% similarity) — personal/operational notes, not governance text.

**Only governance-relevant Open Brain content:** The legacy 12-rule list (captured 2026-04-07, already documented in Layer 3 above).

### Governance Text in IWE Life OS MCP (todo_search)

Searched via `todo_search` for: rule, preclusion, governance, soul, separation of duties, proof of work. Results are the same `todos_backlog` rows (IWE Life OS MCP reads the same table). No additional governance content found.

### Backup Coverage

| Path | Tracked in `iweventures/ari-os`? | Location |
|---|---|---|
| `SOUL.md` (workspace) | ❌ NOT tracked | `~/.openclaw/workspace/SOUL.md` (local only) |
| `MEMORY.md` | ❌ NOT tracked | `~/.openclaw/workspace/MEMORY.md` (local only) |
| `AGENTS.md` | ❌ NOT tracked | `~/.openclaw/workspace/AGENTS.md` (local only) |
| `docs/todo-pipeline.md` | ❌ NOT tracked (untracked on disk) | `~/ari-os/docs/todo-pipeline.md` |
| `sql/migrations/003_status_check_constraint.sql` | ❌ NOT tracked (untracked on disk) | `~/ari-os/sql/migrations/` |
| `bin/get-role-model` | ❌ NOT tracked (untracked on disk) | `~/ari-os/bin/` |
| `bin/set-role-model` | ❌ NOT tracked (untracked on disk) | `~/ari-os/bin/` |
| `proofs/*` | ❌ NOT tracked (untracked on disk) | `~/ari-os/proofs/` |
| `briefs/*` | ❌ NOT tracked (untracked on disk) | `~/ari-os/briefs/` |
| `agents/main/SOUL.md` | ✅ tracked | `~/ari-os/agents/main/SOUL.md` |
| `agents/kirk/SOUL.md` | ✅ tracked | `~/ari-os/agents/kirk/SOUL.md` |
| `agents/akston/SOUL.md` | ✅ tracked | `~/ari-os/agents/akston/SOUL.md` |
| `souls/*.md` | ✅ tracked | 6 soul files |
| `skills/*.md` | ✅ tracked (but modified on disk) | 3 skill files — all show modified in `git status` |
| `sql/001_schema.sql` | ✅ tracked | |
| `sql/002_seed_agents.sql` | ✅ tracked | |

**25 files tracked in ari-os.** Multiple critical files (todo-pipeline.md, migrations, bin helpers, proofs, briefs) exist on disk but are untracked. Three skill files are tracked but have uncommitted modifications.

**Supabase PITR status:** Unknown. Cannot query Supabase dashboard settings via bridge or MCP. PITR (Point-in-Time Recovery) is a Supabase Pro plan feature — status must be verified manually in the Supabase dashboard under Project Settings → Database → Backups.

### Secrets Lockdown

**`~/ari-os/.gitignore` (verbatim):**
```
# Environment & secrets
.env
*.env.local

# Backups (local copies only — off-site via rclone)
backups/*.sql
backups/*.sql.gz

# Python
__pycache__/
*.pyc
.venv/
venv/

# Logs
*.log
bridge/bridge.log

# OS
.DS_Store
Thumbs.db

# IDE
.vscode/
.idea/
config/openclaw.json
```

**Secret file checks:**
- `config/openclaw.json` — exists on disk, **gitignored** (line 26: `config/openclaw.json`) ✅
- `.env` — **gitignored** (line 2: `.env`) ✅
- `.env.example` — tracked (contains placeholder values only, no real secrets) ✅
- `git ls-files | grep -iE '(\.env$|openclaw\.json|secret|credential|key\.pem|token|\.key$)'` — **NONE found** ✅

**`~/.openclaw/workspace/.gitignore`:** exists, includes `.openclaw/`, `*.key`, `secrets/`. No secrets tracked.

**`~/.openclaw/` directory:** Not a git repo. `openclaw.json` lives here with `600` permissions.

**Risk flags: NONE.** All credential files are properly gitignored. No secret material is tracked in any git repo.

### Summary of Findings

1. **No governance text in Supabase is more complete than the file-based versions.** The authoritative governance definitions remain in `SOUL.md`, `souls/ari.md`, and the three skill files.
2. **`todos_backlog` is the live canonical backlog.** `agent_tasks` is legacy.
3. **`corrections` table is not bridge-reachable** — agents cannot sweep it.
4. **Multiple critical files are untracked in ari-os** — todo-pipeline.md, migrations, bin helpers, proofs, briefs, and the workspace SOUL.md/MEMORY.md.
5. **Supabase PITR status is unknown** — requires manual dashboard check.
6. **Secrets lockdown is clean** — no credential files tracked in any repo.
