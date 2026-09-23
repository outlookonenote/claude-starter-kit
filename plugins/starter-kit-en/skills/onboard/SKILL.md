---
name: onboard
description: Onboarding interview with the owner. Asks in rounds (who you are, what you do, with whom, tools, preferences, focus), writes the workspace's About Me/about-me.md from the answers, then suggests 1-3 first teammates of your own. Use it when the profile is still empty, or the user wants to tell again who they are.
argument-hint: "[optional: what you would already tell about yourself]"
---

# Onboarding interview

Build the owner's profile: interview them, then write the workspace's `About Me/about-me.md` from their answers (following the file's existing structure).

**The workspace path** appears in the session-start context as a `Workspace: <path>` line. If there is no such line, or the folder does not exist, do not start the interview: explain that `/starter-kit-en:setup` comes first, and offer to run it.

If the user already said something about themselves at launch, use it and do not ask it again: `$ARGUMENTS`

## 1. Ask in rounds, not everything at once

2-4 related questions per round, wait for the answer, then move to the next round. Cover these topics:

- **Who I am:** name, job/role, a few sentences of background.
- **What I do:** main activities, projects; if they wear several "hats" (e.g. a day job and a side project), all of them, and when which one applies.
- **With whom / for whom:** clients, audience, team, partners.
- **My tools:** computer/OS, email, the main platforms they work with.
- **How to work with me:** tone (brief or detailed, formal or informal tone), ask or assume, how deep you may go, banned styles/words, when they want honest pushback.
- **Current focus:** what they are working on right now.

## 2. Topics can be skipped

If they skip something, or the answer is "I don't know", move on, do not push. Whatever they do not say stays empty in the file.

## 3. Writing about-me.md

- Write `<path>/About Me/about-me.md` from the answers, concisely, **in the owner's own words** (do not pad it with AI filler).
- Replace the italic guidance lines that received an answer with the answer; an unanswered section may stay empty.
- At the top, in the `_Last updated: —_` line, replace `—` with today's date (`date +%Y-%m-%d`), for example `_Last updated: 2026-01-15_`. This tells the system the profile is filled in.
- Show what you wrote, and ask if anything should be adjusted. If so, fix it.

## 4. First teammates of your own (closing step)

Based on the answers (role, work, tools), suggest **1-3 first teammates of their own**, each in one sentence: what it would do, and why it would help them in particular. Make them concrete and tied to the owner's real work (e.g. "an email draft checker, because you write a lot of client emails"). Do not suggest anything the built-in teammates already cover (Rita and Anna: hiring, Bea: log, Adam: status report).

- If the owner picks one: start hiring with **Rita** (`starter-kit-en:talent-researcher`). Give her the need in one sentence, the absolute workspace path and the gist of the profile. Show Rita's brief for approval; if the owner agrees, pass it to **Anna** (`starter-kit-en:agent-architect`) with the brief and the workspace path. At the end, tell them how to call the new teammate, and that it becomes visible from the next session start.
- If they do not want one now: just mention that they can add a new teammate any time with `/starter-kit-en:new-agent <the need in one sentence>`, or simply like this: "Rita, we need something that…".

## 5. Wrap-up

Mention in one sentence: the profile will also grow on its own through self-learning (SOP-00); as we work, I will offer to record important preferences. They can say at any time: "add this to about-me.md".
