# Claude Code starter kit (English)

[Magyar változat](README.md)

A Claude Code plugin that sets up a working environment in a few minutes: a **main agent** that coordinates and delegates, a small **team of agents** you can extend for your own work, a **rule set** (SOPs) that learns as you work, and an **onboarding** interview so the system knows who you are.

It is not built for any particular profession: the core fits any role, and you tailor it to your own work with the built-in hiring flow.

## Three principles

1. **Delegate, don't do it yourself.** The main agent coordinates; the real work goes to specialised teammates.
2. **Self-learning.** When a recurring rule or preference shows up during work, the system offers to record it, so next time it already knows.
3. **A growing team.** When there is no teammate for a job, the system offers to hire a new agent and builds it in a few steps.

## What's inside

| Part | What it gives you |
|---|---|
| **Built-in teammates** | Rita (recruiter) and Anna (agent architect): they hire new teammates. Bea (session log) and Adam (status reports). |
| **Commands** | `/starter-kit-en:setup`, `/starter-kit-en:onboard`, `/starter-kit-en:new-agent`, `/starter-kit-en:start-session`, `/starter-kit-en:end-session` |
| **Workspace template** | A folder on your machine: the main agent's rules (`CLAUDE.md`), your profile, SOPs, tasks, notes, your own teammates. |
| **Session-start reminder** | On every launch it tells the model where your workspace is and what the next step is (setup or onboarding). |

The plugin is the engine, the workspace is yours: updating the plugin never touches your workspace files.

## Prerequisite

A paid Claude subscription (Pro, Max, Team or Enterprise) or an Anthropic API key. Claude Code does not work with a free account.

## 1. Install Claude Code (macOS)

Pick **one** method:

```bash
# A) Homebrew (if you have brew)
brew install --cask claude-code

# B) Native installer (needs neither brew nor Node)
curl -fsSL https://claude.ai/install.sh | bash

# C) npm (if you have Node.js 22 or newer)
npm install -g @anthropic-ai/claude-code
```

`curl … | bash` downloads and runs a script. If you want to be careful, open `https://claude.ai/install.sh` in a browser first and read it.

Check in a new terminal window:

```bash
claude --version
claude doctor
```

If the `claude` command is not found, close and reopen the terminal.

**Sign in:** start `claude`; a browser opens, sign in with your Claude account. If the browser does not open, the terminal prints a link. Exit with `/exit`.

On Windows and Linux, follow the official Claude Code installation page; using the plugin is the same from there.

## 2. Install the plugin

Start `claude` in any folder and run:

```
/plugin marketplace add outlookonenote/claude-starter-kit
/plugin install starter-kit-en@claude-starter-kit
```

Then exit (`/exit`) and restart `claude` so the plugin loads.

The same marketplace also has the Hungarian edition (`starter-kit`). Install only one of them: both set up a workspace and both add a session-start reminder.

## 3. Setup and onboarding

```
/starter-kit-en:setup
```

It asks where the workspace should go (default: `~/Documents/Workspace`) and what the main agent should be called (default: Max). It copies the template without overwriting anything, so you can safely re-run it later. It also offers `git init`; on a brand-new Mac this may pop up the Xcode Command Line Tools installer, just let it finish.

Onboarding can follow right away:

```
/starter-kit-en:onboard
```

A few rounds of questions (who you are, what you work on, with which tools, how you like to work); it fills in `About Me/about-me.md` and suggests one to three first teammates for your work.

## Daily use

**Start `claude` from the workspace folder**, because the main agent's rules (`CLAUDE.md`) only load there:

```bash
cd ~/Documents/Workspace
claude
```

On first launch Claude Code asks whether you trust this folder. Accept: until you do, the routine commands pre-approved in the workspace's `.claude/settings.json` do not apply, and it asks for approval at every step.

- Start of work: `/starter-kit-en:start-session` — where we are, what is open, what's next.
- End of work: `/starter-kit-en:end-session` — offers to record new rules (self-learning), and Bea writes the log.
- New teammate: `/starter-kit-en:new-agent <the need in one sentence>`, or simply: "Rita, we need something that…"
- Status: "Adam, where are we with X?"

Your own teammates live in the workspace's `Team/<Department>/` folder, and a symlink makes them visible under `~/.claude/agents/`. A new teammate is available from the next `claude` launch.

## Updating

```
/plugin marketplace update claude-starter-kit
```

Then restart `claude`. The installed version is shown in the `/plugin` menu; changes are in [CHANGELOG.md](CHANGELOG.md). An update only replaces the plugin: your workspace (profile, SOPs, notes, own teammates) stays untouched. New template files are added by re-running `/starter-kit-en:setup`, which never overwrites existing ones.

## Troubleshooting

- **`claude doctor`** — checks the installation.
- **The `/starter-kit-en:…` commands are missing.** Restart `claude` and check in the `/plugin` menu that `starter-kit-en` is installed and enabled.
- **The main agent ignores the rules.** You probably did not start `claude` from the workspace folder. Exit, `cd` to the workspace, and start again.
- **One of your own teammates does not show up.** Check the symlink: `ls -la ~/.claude/agents/`. It must point to the teammate's file in the workspace's `Team/…` folder. A new teammate only appears after a restart.
- **You moved the workspace.** Re-run `/starter-kit-en:setup` with the new location (it does not overwrite existing files), and recreate the symlinks of your own teammates (`Team/README.md` explains how).
- **It asks for approval at every step, even for routine commands.** The workspace's `.claude/settings.json` pre-approves some routine commands, but only once you have trusted the folder. Start `claude` from the workspace and answer yes to the question on first launch. An occasional approval prompt is normal regardless; just allow it.
- **You gave the main agent a different name on a re-run, but the old one stayed.** Setup never overwrites existing files. Ask the main agent to replace the name in the workspace's `CLAUDE.md` and under `SOPs/`.

## Uninstall

```
/plugin uninstall starter-kit-en@claude-starter-kit
/plugin marketplace remove claude-starter-kit
```

The workspace folder stays (those are your files), as do your own teammates' symlinks under `~/.claude/agents/`; delete them by hand if you no longer need them.

## Customisation

- **Names:** you choose the main agent's name during setup; your own teammates can have any name. The built-in ones (Rita, Anna, Bea, Adam) live in the plugin; don't rename them, updates would overwrite the change.
- **Task tracking:** `Tasks/` can be markdown or an external tool (Jira, Todoist, Notion); the session rhythm works either way.

## License

MIT, see [LICENSE](LICENSE).
