# team-index — team overview

A short index of the active agents. Rita (`starter-kit-en:talent-researcher`) checks it for overlap, and the main agent uses it to decide whom to call. The detailed roster: `README.md`.

## Built-in (plugin)

### HR
- **Rita** (`starter-kit-en:talent-researcher`) — clarifies new agent requests, researches, writes briefs. Call: "Rita, we need something that…"
- **Anna** (`starter-kit-en:agent-architect`) — writes the agent `.md` from an approved brief. Call: "Anna, here's the brief, write it."

### Operations
- **Bea** (`starter-kit-en:scribe`) — end-of-session log. Call: "Bea, wrap it up."
- **Adam** (`starter-kit-en:status`) — status report. Call: "Adam, where are we with X?"

## Your own teammates

_None yet. Anna appends new teammates here by department, one line each: **Name** (`technical-name`) — what it does. Call: "…"_

## Hiring process (in short)

1. The owner states the need to **Rita** in one sentence (or `/starter-kit-en:new-agent <need>`).
2. Rita clarifies, checks for overlap (this file: built-in and own), researches, writes a brief.
3. The owner approves, then the main agent hands it to **Anna**: "Anna, here's the brief, write it."
4. Anna writes the `.md` under `Team/<Department>/`, symlinks it under `~/.claude/agents/`, and updates `README.md` and this index.

Details: `SOPs/SOP-01-agent-conventions.md`.
