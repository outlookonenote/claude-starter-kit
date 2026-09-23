# SOP-01: Agent file conventions

**Scope:** everyone — mandatory for Anna (agent-architect) in particular

---

## Rule

Every agent file follows a uniform structure, location and frontmatter format.

### Frontmatter

```
---
name: <kebab-case-technical-name>
description: <Persona name> — <one sentence on WHEN the main agent should call it>
tools: <the tools actually needed, e.g. Read, Write, Edit, Bash, Glob>
model: <haiku / sonnet / opus>
---
```

The `description` is the most important field: the main agent uses it to decide when to call the agent. If it is vague, the agent will rarely be used.

### Section order in the system prompt

1. **Intro role** — who the agent is and what its job is (1-2 sentences). Mandatory first sentence: *"You are **[Name]**, the team's [short role description]."*
2. **Scope** — what it does and what it does **not** do.
3. **Workflow** — steps.
4. **Prohibitions** — an explicit "don't" list.
5. **Style** — if needed.

### Location

There are two kinds of agents, and each has one canonical location:

- **Built-in (plugin) teammates** — Rita (`talent-researcher`), Anna (`agent-architect`), Bea (`scribe`), Adam (`status`). They live in the starter-kit-en plugin, are called with a namespace (`starter-kit-en:<name>`), and update when the plugin updates. We don't edit them, and we don't put our own files in the plugin folder (it is overwritten on update).
- **Your own teammates** — live in the workspace, made visible to Claude Code by a symlink:
  - **Canonical file:** `<workspace>/Team/<Department>/<name>.md`
  - **Symlink (flat):** `~/.claude/agents/<name>.md` → the canonical file

```bash
ln -sf "<workspace>/Team/<Department>/<name>.md" \
       "$HOME/.claude/agents/<name>.md"
```

`<workspace>` is always replaced by the absolute path (given in the session-start context: `Workspace: <path>`). Departments: whatever the work needs (e.g. `Development`, `Marketing`, `Clients`). Your own agent's technical name must not match a built-in one. We do **not** put agents in project-specific folders (`<project>/.claude/agents/`) — everything stays in one place so the structure remains portable (reachable from any session).

### Choosing a model

- **haiku** — simple, focused, reading/summarising
- **sonnet** — planning, code, structured output
- **opus** — hard reasoning, complex decisions

### Least-privilege tools

Every agent gets only the tools its job **actually** needs. A read-only agent gets no Write; a writing agent gets no Bash.

## Why

A uniform structure lets the main agent know reliably which agent to call when, what it does and what it doesn't. The canonical file + symlink setup ensures that Claude Code sees the current definition in every session, and that your own team can be moved to another machine by copying one folder (the plugin brings the built-in ones).

## How to apply

- **New agent (Anna):** follow the section order, don't skip Prohibitions. Make the "when" clear in the `description`.
- **Refining (own agent):** edit the canonical file in the department folder — thanks to the symlink, it takes effect from the next session start.
- **Removing (own agent):** delete the `.md` **and** the symlink under `~/.claude/agents/`.
- **Updating the index:** after every hire/removal, update the tables in `Team/README.md` and `Team/team-index.md`.

## Prohibitions

- A duplicate agent with an existing scope — always run an overlap check (`team-index.md`, including the built-in ones).
- Unnecessary tools.
- A vague `description`.
- Writing an agent without a brief (research and the brief are Rita's job; Anna works from a finished brief).
