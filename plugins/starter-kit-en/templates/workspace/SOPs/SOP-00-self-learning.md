# SOP-00: Self-learning — how a rule becomes a recorded rule

**Scope:** the main agent (Max) and every teammate

---

## Rule

The system **learns while working**. When a recurring rule, preference or decision comes up, the main agent **offers to record it** — it doesn't create it silently, and it doesn't forget it either.

### When to offer recording

- The owner **corrects** something in a way that will still apply next time ("not like this, like that", "from now on always…").
- The same decision or question comes up a **second time**.
- A **non-obvious fact** about the work, a client or a tool comes to light that will matter later.
- The owner **explicitly approves** an approach ("yes, do it exactly like this").

### How to offer

In one sentence, without interrupting the work:

> "Should I record this as a rule, so it happens this way on its own next time?"

If yes, decide **where** it goes:

| This is… | …it goes here |
|---|---|
| A general working rule that applies to several tasks | **A new SOP** in `SOPs/` (`SOP-NN-short-name.md`) |
| Who the owner is, what they do, a lasting preference | Update **`About Me/about-me.md`** |
| The status or to-dos of a specific project/client | The project's note in `Notes/` or in `Tasks/` |
| Refining the behaviour of one of your own agents | That agent's `.md` under `Team/<Department>/` (for a built-in teammate, which lives in the plugin: a new SOP or `CLAUDE.md`, because the plugin's files are overwritten on update) |

### Creating a new SOP

1. Pick the next free number (`SOP-05`, `SOP-06`, …).
2. Follow the format: `## Rule`, `## Why`, `## How to apply`, optionally `## Prohibitions`.
3. The `Rule` should be concrete and testable, the `Why` one or two sentences (so it doesn't have to be re-derived later).
4. If it also applies to an agent, put a pointer in the agent's `.md` (don't copy the full text).

## Why

The AI has no memory between conversations. Knowledge survives only if it goes into a **file**. Without self-learning, the same rule has to be explained again and again — offering to record it solves this once and for all, and keeps it under the owner's control (they decide what becomes a rule).

## How to apply

- **Suggest, don't dictate.** The owner decides what becomes a rule. Don't create an SOP without approval.
- **Don't batch.** One insight → one offer. Don't save them up for the end.
- **Avoid duplication.** Before recording, check whether an SOP on this already exists; if so, extend it.
- **Remove bad rules.** If an earlier rule turns out to be wrong, propose updating or deleting the SOP.

## Prohibitions

- A rule created or changed silently (there must always be an offer).
- Promoting a one-off, conversation-specific thing to an SOP — that is not a rule, just momentary context.
- Copying the same rule to several places (one canonical place + pointers).
