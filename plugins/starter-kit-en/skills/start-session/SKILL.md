---
name: start-session
description: Session-start briefing. Reads the owner's profile, the latest session log entry and the open tasks, then says concisely where we are, what is open and what the suggested next step is. Can optionally be narrowed to one topic.
argument-hint: "[optional topic]"
---

# Session start

Give a concise briefing (→ `SOPs/SOP-03-session-rhythm.md`).

**The workspace path** appears in the session-start context as a `Workspace: <path>` line; every file below is relative to it. If there is no such line, or the folder does not exist, explain that `/starter-kit-en:setup` comes first, and offer to run it.

1. Read `<path>/About Me/about-me.md` (who the owner is, what their preferences are), and keep it in mind throughout. If it is still empty, offer `/starter-kit-en:onboard` at the end.
2. Look at the latest entry in `<path>/Notes/session-log.md`: where the work left off.
3. Review the open tasks under `<path>/Tasks/` (or wherever the owner keeps them according to `Tasks/README.md`).
4. Report back briefly: **where we are**, **what is open**, **what the suggested next step is**.

Narrow to a topic (if empty, no narrowing): `$ARGUMENTS`

Do not read everything out verbatim: the essentials are what is needed, in a few sentences.
