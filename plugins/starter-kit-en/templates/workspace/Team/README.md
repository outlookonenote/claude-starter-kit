# Team — the agents' office

*The main agent (Max) is the orchestrator: it coordinates and delegates, it does not do the work itself. Teammates come from two places: the **built-in** ones live in the starter-kit-en plugin (they update when the plugin updates), and **your own teammates** live in this folder, in subfolders by department. Your own teammates are made visible to Claude Code by symlinks under `~/.claude/agents/` (flat).*

Short index and hiring process: [team-index.md](team-index.md).

---

## Built-in (plugin)

These are part of the starter-kit-en plugin, called with a namespace (`starter-kit-en:<name>`), and they don't clash with your own agents. Don't edit them in the plugin folder: they are overwritten on update.

### HR
| Name | Agent | When to call | Model | Tools |
|---|---|---|---|---|
| Rita | `starter-kit-en:talent-researcher` | For a "we need something…" request, or when a brief is unclear | sonnet | Read, Glob, Grep, WebSearch, WebFetch |
| Anna | `starter-kit-en:agent-architect` | After Rita's brief — "Anna, here's the brief, write it" | sonnet | Read, Write, Edit, Bash, Glob |

### Operations
| Name | Agent | When to call | Model | Tools |
|---|---|---|---|---|
| Bea | `starter-kit-en:scribe` | At the end of a session — "Bea, wrap it up" | haiku | Read, Edit, Bash |
| Adam | `starter-kit-en:status` | "Adam, where are we with X?" | haiku | Read, Grep, Glob, Bash |

---

## Your own teammates — by department

*Empty for now. After the first own teammate is hired, the department sections (e.g. `Development`, `Marketing`) and their rows go here, in the same table format: Name · Agent · When to call · Model · Tools.*

---

## Maintenance

- **Hiring a new agent:** tell **Rita** the need in one sentence (or `/starter-kit-en:new-agent <need>`). Rita clarifies, researches and writes a brief (with a department suggestion). Based on the approved brief, **Anna** writes a new `.md` into the right department folder here under `Team/`, symlinks it under `~/.claude/agents/`, and updates this README and `team-index.md`.
- **Refining your own agent:** edit the `.md` in the department folder. Thanks to the symlink, Claude Code picks up the change at the next session start.
- **Removing your own agent:** delete the `.md` from the department folder **and** the symlink under `~/.claude/agents/`.
- **Moving to another department:** `mv` the file into the target folder, then `ln -sf` the symlink to the new path.
- **Built-in agent:** cannot be edited here. If you want it to behave differently, hire your own teammate with the desired behaviour under a different technical name.

## Layout principle

**All your own agents live in one place — we do NOT put them in project-specific folders** (portable folder structure: reachable from any session).

- **Canonical file:** `<workspace>/Team/<Department>/<name>.md`
- **Symlink (flat):** `~/.claude/agents/<name>.md` → the canonical file

New symlink by hand:
```bash
ln -sf "<workspace>/Team/<Department>/<name>.md" \
       "$HOME/.claude/agents/<name>.md"
```

## System prompt conventions

In detail: `../SOPs/SOP-01-agent-conventions.md`. In short:
- **English**, concise, no AI buzzwords (→ SOP-04).
- **Section order:** intro role → scope → workflow → prohibitions → style.
- **First sentence:** "You are **[Name]**, the team's [role]."
- **Least-privilege tools**, a clear `description` field.
