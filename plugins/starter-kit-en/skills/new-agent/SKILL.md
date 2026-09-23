---
name: new-agent
description: Add a new teammate (agent) of your own to the team. Runs the whole hiring flow - Rita (starter-kit-en:talent-researcher) clarifies and writes a brief, the owner approves it, Anna (starter-kit-en:agent-architect) writes the agent into the workspace, symlinks it and updates the team index. Use it when the user wants an agent for a new, recurring task ("we need something that...").
argument-hint: "<the need in one sentence>"
---

# Hiring a new teammate

The need from the user, in one sentence: `$ARGUMENTS`

If the need is empty, ask in one sentence: "What would the new teammate do? For example: review my email drafts before I send them, and flag anything that could be misread."

**The workspace path** appears in the session-start context as a `Workspace: <path>` line. If there is no such line, or the folder does not exist, do not start hiring: explain that `/starter-kit-en:setup` comes first, and offer to run it.

## Steps

1. **Rita.** Call the `starter-kit-en:talent-researcher` agent. Give her: the need in the user's words, the absolute workspace path, and, if available, the gist of the owner's profile (`<path>/About Me/about-me.md`). Rita may ask back (at most 3 questions); pass her questions on to the user and the answers back to Rita.

2. **Approval.** Show Rita's brief to the user and ask if it is good as is. If they want changes, take it back to Rita. Do not go further without approval.

3. **Anna.** Pass the approved brief to the `starter-kit-en:agent-architect` agent, together with the absolute workspace path. Anna writes the agent `.md` under `<path>/Team/<Department>/`, symlinks it under `~/.claude/agents/`, and updates `Team/README.md` and `team-index.md`.

4. **Wrap-up.** Tell the user where the new teammate went, what it does in one sentence, and how to call it (with an example sentence). Mention that Claude Code sees it from the next session start (`/exit`, then `claude`).

This is how the system grows: every new role goes down this path. The main agent also offers it on its own when it notices there is no suitable teammate for a recurring task.
