# IWE Life OS — Todo Pipeline Reference

> **Canonical source.** This document defines the authoritative status model for the `todos_backlog` table. All skill files, agents, and automation defer to this doc. If something contradicts this file, this file wins.

## The 9 Statuses

| # | Status | Definition | Who sets it |
|---|--------|-----------|-------------|
| 1 | `backlog` | Captured but not refined. May lack AC, DoR, scope. | Anyone (default on creation) |
| 2 | `ready` | DoR met, AC written, scope clear, prerequisites identified. Available for executor claim. | Refiner (Ari or Chad) after DoR pass + Chad approval |
| 3 | `in_progress` | Claimed by executor, work underway. | Executor on pickup |
| 4 | `blocked` | Hit a dependency, missing input, or question. `notes` **must** say what's blocking. | Executor |
| 5 | `awaiting_approval_gate` | Executor reached a pre-defined approval gate or global preclusion. Paused until Chad approves/rejects. `current_gate_id` identifies which gate. | Executor |
| 6 | `pending_verification` | Work complete, proof submitted. Waiting for verifier to judge against AC. | Executor after proof submission |
| 7 | `pending_approval` | Verifier passed. Waiting for Chad's final review. | Verifier after PASS verdict |
| 8 | `done` | Chad reviewed and approved. **Terminal.** | **Chad only** (Rule 15) |
| 9 | `cancelled` | Killed. **Terminal.** | Chad, or Ari with Chad's explicit instruction |

## Transition Diagram

```
                          ┌──────────────────┐
                          │     backlog       │
                          └────────┬─────────┘
                                   │ refine + Chad approves DoR
                                   ▼
                          ┌──────────────────┐
                          │      ready        │
                          └────────┬─────────┘
                                   │ executor claims
                                   ▼
                     ┌────────────────────────────┐
              ┌──────│        in_progress          │◄─────────────────┐
              │      └──┬──────────┬───────────┬──┘                   │
              │         │          │           │                       │
              │         ▼          ▼           ▼                       │
              │  ┌──────────┐ ┌────────────────────────┐  ┌──────────────────────┐
              │  │ blocked   │ │ awaiting_approval_gate │  │ pending_verification │
              │  └──┬───┬───┘ └────────┬───────┬───────┘  └──────────┬───────────┘
              │     │   │              │       │                      │
              │     │   │   approved───┘       │ rejected             │ verifier passes
              │     │   │   → in_progress      │ → blocked            ▼
              │     │   │                      │              ┌──────────────────┐
              │     │   └──────────────────────┘              │ pending_approval  │
              │     │                                         └────┬─────────┬───┘
              │     │ unblocked → in_progress                      │         │
              │     │                                              │         │
              │     ▼                                              ▼         │
              │  ┌──────────┐                              ┌──────────┐     │
              └─▶│ cancelled │◄─────── Chad cancels ──────│   done    │◄────┘
                 └──────────┘                              └──────────┘
                  (terminal)                                (terminal)
```

### Transitions (text list)

```
backlog                  → ready
ready                    → in_progress
in_progress              → pending_verification | blocked | awaiting_approval_gate
blocked                  → in_progress | cancelled
awaiting_approval_gate   → in_progress (approved) | blocked (rejected)
pending_verification     → pending_approval | in_progress (returned for fix)
pending_approval         → done | in_progress (Chad rejects — return-for-fix, same path as verifier fail) | cancelled (Chad kills it)
done                     → (terminal)
cancelled                → (terminal)
```

## Governing Rules

### Rule 15 — Only Chad sets `done`

No agent, automation, or cron job may set `status = 'done'`. The only valid path to done is: executor submits proof → verifier passes → Chad reviews and approves. Chad stamps `chad_approved_at` when setting done.

**Chad rejection at `pending_approval`:** If Chad declines to approve at the final gate, the row routes back to `in_progress` (return-for-fix — same path as a verifier fail). `cancelled` is reserved for "killed / no longer needed," not for "needs more work."

### Rule 16b — Proof-of-work gate

No agent may report a task as "complete" or "done" without first:
1. Re-reading the todo's current status from `todos_backlog` and confirming it is `pending_verification`
2. Confirming the expected deliverable file exists on disk at the stated path **and is non-trivial** (real content + AC section, not a stub)

A report that skips either check is considered unverified and must not be delivered.

### Separation of duties

An agent that executed a task must not verify its own work. Verification is a separate role (typically Ari or Chad-via-Claude). See `task-verification` skill.

## Field Requirements by Status

| Status | Required fields |
|--------|----------------|
| `blocked` | `notes` — must explain what is blocking |
| `awaiting_approval_gate` | `current_gate_id` — identifies which gate is active |
| `pending_verification` | `proof_submission`, `proof_submitted_at` — proof must be present |
| `pending_approval` | `verification_history` — at least one PASS entry |
| `done` | `chad_approved_at` — timestamp of Chad's approval |

## Implementing Skills

The pipeline is implemented across three skills:

| Skill | File | Pipeline role |
|-------|------|---------------|
| DoR Refinement | `~/ari-os/skills/dor-refinement/SKILL.md` | `backlog` → `ready` |
| Task Execution | `~/ari-os/skills/task-execution/SKILL.md` | `ready` → `pending_verification` (with `blocked` and `awaiting_approval_gate` side-paths) |
| Task Verification | `~/ari-os/skills/task-verification/SKILL.md` | `pending_verification` → `pending_approval` (or return to `in_progress`) |

## DB Constraint

The `todos_backlog_status_check` CHECK constraint enforces these 9 values at the database level. Migration: `~/ari-os/sql/migrations/003_status_check_constraint.sql`.
