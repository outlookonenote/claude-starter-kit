---
name: end-session
description: Close the session. Offers to record rules and preferences that came up during the day (self-learning, SOP-00), then after a substantive session Bea (starter-kit-en:scribe) appends a dated entry to the workspace session log.
argument-hint: "[optional note for the log]"
---

# Session close

Let's close the session (→ `SOPs/SOP-03-session-rhythm.md`).

**The workspace path** appears in the session-start context as a `Workspace: <path>` line. If there is no such line, or the folder does not exist, explain that `/starter-kit-en:setup` comes first, and offer to run it.

The user's note for the close (may be empty): `$ARGUMENTS`

1. **Self-learning (SOP-00).** Check whether a recurring rule, preference or decision came up today that is worth recording (SOP, `About Me`, or a note). If so, offer it in one sentence; the owner decides. Do not create a rule without approval.

2. **Logging.** If real progress, a decision or new information came up, call **Bea** (`starter-kit-en:scribe`): she should append a dated entry to `<path>/Notes/session-log.md`. Give her the absolute workspace path, what happened, what was decided, and what the open thread is.

3. If the session was empty (nothing substantive happened), logging is skipped; just mention it.
