---
name: setup
description: Create or re-run the starter kit workspace. Asks for the workspace location and the main agent's name, copies the template without overwriting anything (including the hidden .claude folder), puts the name into CLAUDE.md, and saves the workspace path to the plugin config. Use it when the user has just installed the plugin, or when the session-start context says no workspace is configured.
argument-hint: "[location: <folder>] [name: <main agent name>]"
---

# Workspace setup

Your task is to create the starter kit workspace (or safely re-run the setup). Talk to the user in English, concisely.

Fixed paths in this installation (use these literally in commands, not an environment variable):

- Plugin folder: `${CLAUDE_PLUGIN_ROOT}`
- Plugin data folder (the config lives here): `${CLAUDE_PLUGIN_DATA}`
- Installer script: `${CLAUDE_PLUGIN_ROOT}/scripts/setup-workspace.sh`

Arguments given by the user (may be empty): `$ARGUMENTS`

## 1. Is there a workspace already?

Check the config:

```bash
cat "${CLAUDE_PLUGIN_DATA}/config" 2>/dev/null
```

If it has a `workspace=<path>` line and that folder exists (`ls -d "<path>"`), a workspace is already configured. Tell the user (including the path), and **ask before doing anything**: re-run into the same place (only missing template files are added, no existing file is overwritten), or set it up in a new location. Exception: if the user gave this same location in the arguments, that counts as a confirmed re-run, and you may continue without asking (the script overwrites nothing).

## 2. Location and name

If the arguments contain them (e.g. `location: ~/Documents/Workspace, name: Max`), use those and do not ask again. Ask for whatever is missing in one message:

- **The workspace location.** Default: `~/Documents/Workspace`. This is a folder where your notes, rules and your own teammates live.
- **The main agent's name** (the one who coordinates and delegates). Default: `Max`.

If the user just says "the defaults are fine", use the values above.

## 3. Installation

Run the script (pass the path in quotes, it may contain spaces or accented characters; `~` is allowed too):

```bash
bash "${CLAUDE_PLUGIN_ROOT}/scripts/setup-workspace.sh" "${CLAUDE_PLUGIN_DATA}" "<location>" "<name>"
```

The script:
- copies the template (including the hidden `.claude` folder), but **never overwrites an existing file**;
- replaces the main agent's name only in the files it has just created;
- writes the absolute workspace path into the `${CLAUDE_PLUGIN_DATA}/config` file.

Do not copy by hand, do not write into the user's global settings (`~/.claude/settings.json`), and do not add permissions.

As a check, list the workspace including hidden files (`ls -la "<absolute path>"`), and summarize from the script output: how many new files were created and what was left untouched.

## 4. Git (offer)

If the script says the workspace is not a git repository yet, offer `git init` (version control is useful for notes and rules). Run it only after a yes, and **do not commit**. Mention: on a brand-new Mac the very first `git` command may start the Xcode Command Line Tools installation in a system window; this is normal, wait until it finishes. If the arguments indicate a non-interactive run (nobody to answer), only suggest git, do not run it.

## 5. Wrap-up

Say briefly:

1. The workspace is ready: `<absolute path>`.
2. **From now on, start `claude` from the workspace folder** (`cd "<absolute path>"`, then `claude`), because the `CLAUDE.md` holding the main agent's rules is only loaded there.
3. Offer to **start onboarding right away** (`/starter-kit-en:onboard`): a few rounds of questions to get to know you, and I fill in `About Me/about-me.md`. If the user says yes, invoke the `starter-kit-en:onboard` skill.
