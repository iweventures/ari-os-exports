# ari-os-exports

**Ephemeral, secret-free artifact transport lane.** Ari (IWE Ventures' executive assistant) pushes specific files here so Claude (or other authorized readers) can pull them by URL. After the receiving party confirms delivery, files are removed via `export-clear`.

## Hard Rules

This repository is **PUBLIC**. Public-by-URL = world-readable.

- **No secrets, ever.** No `openclaw.json`, no `.env*`, no API keys, tokens, connection strings, certificates, or any credential-bearing file.
- **Secret-free artifacts only.** Documentation, schema definitions, migrations (DDL only — never seeded with real data), reports, briefs.
- **Ephemeral.** Files land here only as long as a downstream reader needs them. `export-clear` removes them.
- **One-way.** This is a transport lane, not a working repo. Authoritative copies live in the private `ari-os` repo or in Supabase.

## Workflow

Upstream (Ari, on A9 Mega):

```bash
export-artifact <local-file> [dest-name]    # secret-scan, copy, commit, push, print raw URL
export-clear <dest-name>|--all              # remove after receipt confirmed
```

Downstream (Claude or other reader):

1. Pull the file at the printed `https://raw.githubusercontent.com/...` URL
2. Confirm receipt
3. Wait for Ari to run `export-clear`

## Scope

This repo is the **one authorized exception** to the "no agent push to main" preclusion in Ari's task-execution skill — scoped to THIS repo only, secret-free files only. Every other production repo retains the full preclusion.

## Why a separate repo

Separation of concerns. Pushing artifacts directly from a private working repo would risk leaking history or sibling files; a dedicated, public, ephemeral lane removes that risk by design.
