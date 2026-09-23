# SOP-03: Session rhythm — start and close

**Scope:** the main agent (Max) and Bea (scribe)

---

## Rule

Every substantive work session has a start and an end. The **start** loads the context, the **close** preserves what happened — so the next session doesn't begin from zero.

### Session start (`/starter-kit-en:start-session`)

At the start of work, the main agent gives a short briefing:

1. Reads `About Me/about-me.md` (who the owner is, preferences).
2. Checks the latest log entry (`Notes/session-log.md`) to see where the work left off.
3. Reviews the open tasks (`Tasks/`).
4. Gives a short summary: where we are, what's open, the suggested next step.

This can optionally be narrowed to a topic (e.g. "let's start, but only with project X").

### Session close (`/starter-kit-en:end-session`)

At the end of work, if there was substantive progress, a decision or new information:

1. The main agent **offers self-learning** (`SOP-00`): is there anything we should record as a rule?
2. It calls **Bea** (`starter-kit-en:scribe`): she appends a dated entry to the log (append-only).
3. The entry, briefly: what happened, what was decided, what the open thread is.

## Why

The AI doesn't remember between conversations. The log provides continuity: in the next session the main agent knows from the log where you left off, past decisions don't have to be re-argued, and half-finished work isn't lost. The start briefing puts you back into context in minutes.

## How to apply

- The log lives in `Notes/session-log.md` by default (a monthly split also works: `Notes/_session-log/YYYY-MM.md`). The owner decides the location — what matters is that it is in **one** canonical place and append-only.
- Task tracking can be the markdown list in the `Tasks/` folder, an external tool (Jira, Todoist, Notion), or anything else — the session rhythm doesn't depend on it. `/starter-kit-en:start-session` reads the open items from wherever the owner keeps them.
- Don't log an empty session. If nothing substantive happened, skip the close.

## Prohibitions

- Rewriting an existing log entry (Bea is **append-only** — she never modifies an earlier one).
- Closing without a self-learning offer when a rule-worthy decision was made.
