# TOOLS.md — Local Notes for A9 Mega

Skills define _how_ tools work. This file is for my specifics — auth patterns,
endpoints, gotchas unique to this host.

---

## MCP Servers

Two HTTP/SSE MCP servers are configured on this host via `openclaw.json →
mcp.servers.*`. Neither is currently promoted to a first-class agent tool in my
session — I call them directly via `curl` as JSON-RPC 2.0 over HTTPS.

### Shared request pattern

- **Transport:** streamable-HTTP / SSE. Each request is a POST returning a
  `text/event-stream` response with one `event: message` / `data: {...}` line.
  No `mcp-session-id` is returned → **treat every call as stateless**; do not
  try to reuse session state between invocations.
- **Method:** JSON-RPC 2.0 (`initialize`, `tools/list`, `tools/call`).
- **Common headers (both servers):**
  - `Authorization: Bearer <SUPABASE_SERVICE_ROLE_JWT>`
  - `apikey: <SUPABASE_SERVICE_ROLE_JWT>` (same value)
  - `Content-Type: application/json`
  - `Accept: application/json, text/event-stream`
- **Server-specific secret header:** see each server below. The service-role
  JWT alone is **not sufficient** — the edge function gates on a separate
  brain/life-os key.
- **Discovery tip:** a CORS preflight (`curl -X OPTIONS -D -`) reveals the
  full accepted header list, including the required `x-*-key` variant. Useful
  when onboarding a new server with unknown auth.

Values for all secrets live in `~/.openclaw/openclaw.json` under
`mcp.servers.<name>.headers`. **Never paste the secret values into this file.**

### Open Brain MCP (`open-brain`)

- **Endpoint:** `https://gjoliqciuwwutugvyznf.supabase.co/functions/v1/open-brain-mcp`
- **Server version:** `open-brain/1.0.0`
- **Required headers:** `Authorization`, `apikey`, `x-brain-key`
- **Tools:**
  - `capture_thought(content)` — save a thought; embedding + metadata extraction
    happens server-side.
  - `list_thoughts({limit, type, topic, person, days})` — recent thoughts,
    filterable. Types: observation, task, idea, reference, person_note.
  - `search_thoughts({query, limit, threshold})` — semantic search.
  - `thought_stats()` — totals, types, top topics, top people.
- **Scope:** general memory + notes for Ari and whoever else has the key.
  "Thoughts" are not todos.

### IWE Life OS MCP (`iwe-life-os`)

- **Endpoint:** `https://gjoliqciuwwutugvyznf.supabase.co/functions/v1/iwe-life-os`
- **Server version:** `iwe-life-os/3.0.0`
- **Required headers:** `Authorization`, `apikey`, `x-life-os-key`
- **Tools — PILLARS! daily diary:**
  - `pillars_log({entry_date, scripture_ref?, prayer_items?, energy_level?,
    wins?, priority_1?, priority_2?, human_quote?, ai_quote?, social_action?,
    ai_factorial?})` — upsert a daily entry; partial updates fine.
  - `pillars_get({entry_date})`
  - `pillars_list({limit})` — most recent first; default 7.
  - `pillars_streak()` — consecutive days with entries up to today.
- **Tools — Todos backlog (`todos_backlog` table):**
  - `todo_add({title, description?, deadline?, contexts?, tags?, impact?,
    importance?, urgency?, assigned_to?, notes?})`
  - `todo_update({id, ...fields})` — any subset.
  - `todo_list({status?, context?, limit?})` — default limit 20; filter by
    status (`backlog | in_progress | blocked | waiting | pending_review | done
    | cancelled`).
  - `todo_search({query})` — keyword search in title + description.
    **Result shape: `{count, todos:[...]}`**, not a bare array — parse
    accordingly.
  - `todo_prioritize({limit})` — composite score `urgency×2 + impact×1.5 +
    importance`; adds a `_score` field per item.
  - `todo_done({id})` — mark done and set `completed_at`.
- **Scope:** Chad's real-world todo backlog + PILLARS! daily spiritual/tactical
  log. Authoritative source of "what Chad should do next."

### Ready-to-paste curl template

```bash
URL='<endpoint>'
SERVICE='<service-role-jwt-from-openclaw.json>'
KEY='<x-brain-key OR x-life-os-key>'
KEY_HEADER='x-brain-key'  # or x-life-os-key

curl -sS -X POST "$URL" \
  -H "Authorization: Bearer $SERVICE" \
  -H "apikey: $SERVICE" \
  -H "$KEY_HEADER: $KEY" \
  -H 'Content-Type: application/json' \
  -H 'Accept: application/json, text/event-stream' \
  -d '{"jsonrpc":"2.0","id":1,"method":"tools/call","params":{"name":"<tool>","arguments":{...}}}'
```

---

## MCP → First-class Agent Tool Promotion (research, 2026-04-21)

**Question:** does `openclaw` support promoting an HTTP MCP endpoint to a
first-class tool I can invoke from inside an agent session, instead of
hand-rolling `curl` calls?

### Findings from `openclaw config schema`

**Canonical path:** `mcp.servers.<name>`
- Same object `openclaw mcp list / show / set / unset` manipulates.
- Schema supports **both** transport flavors on one object:
  - Stdio: `{ command, args?, env?, cwd?, workingDirectory? }`
  - HTTP: `{ url, headers? }`
- Schema note says: _"OpenClaw stores them in its own config and runtime
  adapters decide which transports are supported at execution time."_

That last line is the answer: **there is no explicit config flag like
`tools.mcp.enabled` or `agents.defaults.mcp.allow`.** MCP server
availability-per-agent is a runtime-adapter decision gated by:

1. The active tool **profile** (`tools.profile` = `minimal | coding | messaging
   | full`) — the `messaging` profile is narrower and likely does not
   auto-surface MCP tools; `full` / `coding` probably do.
2. Whether the running harness/adapter implements MCP bridging at all. Certain
   plugin paths (observed: plugin-level `mcpServers`, bundle-mcp) load MCP
   servers as *tools* and surface them under name-prefixed tool calls.

No dedicated `tools.mcp.allow` or `agents.entries[].mcp` path exists in the
schema.

### Practical options for this host

- **Do nothing** — keep calling HTTP MCP endpoints via `curl` inside `exec`.
  Works today; zero config change; stateless by design.
- **Broaden my tool profile** — switch agent `main` from its current profile
  to `full` or `coding` and see if MCP tools auto-surface via the
  bundle-mcp/openclaw-mcp bridge. **Requires a gateway restart + Chad's
  approval.** Risks exposing more tools than intended on this profile.
- **Write a tiny helper script / skill** — wrap the two servers in a local
  shell function (or a SKILL.md with scripts/) so calls look like
  `mcp-brain list_thoughts` instead of raw curl. Lowest-risk, purely
  workspace-local.

### Proposed commands (DO NOT RUN without Chad's approval)

_Checking the profile first:_

```bash
openclaw config get tools.profile
openclaw config get agents.entries            # per-agent overrides
```

_Switching profile (example — don't apply blindly):_

```bash
openclaw config set tools.profile full
openclaw config validate
# openclaw gateway restart   # needs explicit approval
```

_Validating without restart:_

```bash
openclaw config validate      # schema check only
```

Until Chad greenlights either a profile change or a helper script, default
access pattern remains: **raw curl via `exec`, following the template above.**

---

## Akston — loaded model (verified 2026-04-21)

- **Config binding:** `custom-172-27-48-1-11434/deepseek-r1:70b`
- **Actual loaded model** (via `curl http://172.27.48.1:11434/api/ps` after a
  forced load): `deepseek-r1:70b`, 70.6B params, Q4_K_M quant, 66.3 GB VRAM,
  131k ctx, family=llama, digest `d37b54d01a76…`.
- **Quirk:** `expires_at` comes back in year 2318 → effectively pinned-forever
  keep_alive. Same never-unload pattern Kirk has. Backlog item
  `33f16ff3…` tracks fixing this.
- **Trust rule:** do NOT trust Akston's self-reported model name. `deepseek-r1`
  without tool access can't introspect its own runtime — check `/api/ps`.

---

## Conventions

- **Secrets:** live in `~/.openclaw/openclaw.json` (and env). Never paste
  values into this file, workspace notes, daily logs, or MEMORY.md.
- **Edits to this file are cheap.** When you learn a new tool quirk, add a
  section instead of keeping a "mental note."
