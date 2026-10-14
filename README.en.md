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

## Install with one command

On Windows and on a Mac alike, pasting a single line installs everything you need. Pick your system; the manual route is further down, under [Manual install](#manual-install).

### On Windows

Open **Windows PowerShell** (Start menu, "PowerShell"; no need to start it as administrator) and paste this line, then press Enter:

```powershell
[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072; & ([scriptblock]::Create((irm https://raw.githubusercontent.com/outlookonenote/claude-starter-kit/main/install-windows.ps1))) -English
```

The start of the line (`SecurityProtocol … 3072`) is for older Windows PowerShell 5.1: it turns on TLS 1.2, which GitHub requires. It does no harm in PowerShell 7. (The same line ending in `irm https://raw.githubusercontent.com/outlookonenote/claude-starter-kit/main/install-windows.ps1 | iex` instead installs the Hungarian edition.)

The installer, in order:

1. checks Windows (Windows 10 version 1809 or newer, or Windows 11, 64-bit);
2. installs **Git for Windows** with winget if it is missing (the plugin's scripts run in the Git Bash that comes with it, so on Windows it is required). It first installs it for your user only, which normally needs no administrator rights. If that fails, it tries a machine-wide install, and then Windows asks for approval (UAC); on a centrally managed company PC, ask your IT team for help;
3. installs **Claude Code** with the official installer if it is missing (no administrator rights needed);
4. adds the marketplace and installs the `starter-kit-en` plugin;
5. creates the workspace in `~\Workspace` (it only asks for the main agent's name, default: Max), and offers `git init`.

### On a Mac

Open the **Terminal** app (Cmd+Space, type "Terminal"), paste this line, then press Enter:

```bash
curl -fsSL https://raw.githubusercontent.com/outlookonenote/claude-starter-kit/main/install-mac.sh | bash -s -- --english
```

(The same line ending in `| bash` instead installs the Hungarian edition.)

The installer, in order:

1. checks macOS (version 13, Ventura, or newer);
2. if they are missing, starts the installation of the **Xcode Command Line Tools** (they include git, which is needed to download the plugin and for version control). A system window opens: click Install, wait until it finishes, then run the same command again;
3. installs **Claude Code** with the official installer if it is missing (no administrator password needed), and puts the `~/.local/bin` folder on the PATH in `~/.zshrc` (the official installer only suggests this);
4. adds the marketplace and installs the `starter-kit-en` plugin;
5. creates the workspace in `~/Workspace` (it only asks for the main agent's name, default: Max), and offers `git init`. Deliberately not under Documents: if iCloud syncs your Desktop and Documents folders, it can break the workspace's git repository.

### Afterwards, on both systems

It is safe to run the installer again: finished steps are skipped, existing files are never overwritten, and the plugin gets updated. You do not need to sign in for the installation, only on first launch. At the end it prints what to do next:

```bash
cd ~/Workspace
claude
```

(On Windows `cd ~\Workspace`.) If the installer tells you to open a new window (on a Mac, after a fresh Claude Code install), do that first. On first launch, sign in with your Claude account in the browser, answer Yes when asked whether you trust this folder, then type `/starter-kit-en:onboard`. From there, [Daily use](#daily-use) applies.

The command downloads and runs a script. If you want to be careful, read it in the repository first: on Windows [install-windows.ps1](install-windows.ps1) (a short bootstrap) and [windows/installer.ps1](windows/installer.ps1) (the installer itself), on a Mac [install-mac.sh](install-mac.sh) and [mac/installer.sh](mac/installer.sh).

## Manual install

If you do not use the install command (or you are on Linux), these three steps get you to the same place.

### 1. Install Claude Code

**macOS**, pick **one** method:

```bash
# A) Homebrew (if you have brew)
brew install --cask claude-code

# B) Native installer (needs neither brew nor Node)
curl -fsSL https://claude.ai/install.sh | bash

# C) npm (if you have Node.js 22 or newer)
npm install -g @anthropic-ai/claude-code
```

`curl … | bash` downloads and runs a script. If you want to be careful, open `https://claude.ai/install.sh` in a browser first and read it. The native installer puts `claude` into `~/.local/bin`; if the command is not found afterwards, run `echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc` and open a new Terminal window.

**Windows:** install Git for Windows (https://git-scm.com/downloads/win), then Claude Code in PowerShell: `irm https://claude.ai/install.ps1 | iex` (or `winget install Anthropic.ClaudeCode`, which does not update itself).

**Linux:** follow the official Claude Code installation page; using the plugin is the same from there.

Check in a new terminal window:

```bash
claude --version
claude doctor
```

If the `claude` command is not found, close and reopen the terminal.

**Sign in:** start `claude`; a browser opens, sign in with your Claude account. If the browser does not open, the terminal prints a link. Exit with `/exit`.

### 2. Install the plugin

Start `claude` in any folder and run:

```
/plugin marketplace add outlookonenote/claude-starter-kit
/plugin install starter-kit-en@claude-starter-kit
```

Then exit (`/exit`) and restart `claude` so the plugin loads.

The same marketplace also has the Hungarian edition (`starter-kit`). Install only one of them: both set up a workspace and both add a session-start reminder.

### 3. Setup and onboarding

```
/starter-kit-en:setup
```

It asks where the workspace should go (default: `~/Workspace`, deliberately not under Documents, which iCloud or OneDrive often syncs) and what the main agent should be called (default: Max). It copies the template without overwriting anything, so you can safely re-run it later. It also offers `git init`; on a brand-new Mac this may pop up the Xcode Command Line Tools installer, just let it finish.

Onboarding can follow right away:

```
/starter-kit-en:onboard
```

A few rounds of questions (who you are, what you work on, with which tools, how you like to work); it fills in `About Me/about-me.md` and suggests one to three first teammates for your work.

## Daily use

**Start `claude` from the workspace folder**, because the main agent's rules (`CLAUDE.md`) only load there:

```bash
cd ~/Workspace
claude
```

On first launch Claude Code asks whether you trust this folder. Accept: until you do, the routine commands pre-approved in the workspace's `.claude/settings.json` do not apply, and it asks for approval at every step.

- Start of work: `/starter-kit-en:start-session` — where we are, what is open, what's next.
- End of work: `/starter-kit-en:end-session` — offers to record new rules (self-learning), and Bea writes the log.
- New teammate: `/starter-kit-en:new-agent <the need in one sentence>`, or simply: "Rita, we need something that…"
- Status: "Adam, where are we with X?"

Your own teammates live in the workspace's `.claude/agents/<Department>/` folder (their roster is in the `Team/` folder), and Claude Code loads them when you start it from the workspace. A new teammate is available from the next `claude` launch.

## Updating

```
/plugin marketplace update claude-starter-kit
```

Then restart `claude`. The installed version is shown in the `/plugin` menu; changes are in [CHANGELOG.md](CHANGELOG.md). An update only replaces the plugin: your workspace (profile, SOPs, notes, own teammates) stays untouched. New template files are added by re-running `/starter-kit-en:setup`, which never overwrites existing ones. Re-running the install command (on Windows and on a Mac) also updates.

**From 0.1.x to 0.2.0:** your own teammates have moved (from symlinks to the workspace's `.claude/agents/` folder). After updating, run `/starter-kit-en:setup`: if it finds teammates in the old location, it shows what it would move and only does it after you approve. Details: [CHANGELOG.md](CHANGELOG.md).

## Troubleshooting

- **`claude doctor`** — checks the installation.
- **The `/starter-kit-en:…` commands are missing.** Restart `claude` and check in the `/plugin` menu that `starter-kit-en` is installed and enabled.
- **The main agent ignores the rules.** You probably did not start `claude` from the workspace folder. Exit, `cd` to the workspace, and start again.
- **One of your own teammates does not show up.** Its file must be in the workspace's `.claude/agents/<Department>/` folder, and `claude` must be started from the workspace. A new teammate only appears after a restart. If you updated from 0.1.x, run `/starter-kit-en:setup`, which offers to move the old teammates.
- **You moved the workspace.** Re-run `/starter-kit-en:setup` with the new location (it does not overwrite existing files). Your own teammates moved with the folder; nothing to do for them.
- **It asks for approval at every step, even for routine commands.** The workspace's `.claude/settings.json` pre-approves some routine commands, but only once you have trusted the folder. Start `claude` from the workspace and answer yes to the question on first launch. An occasional approval prompt is normal regardless; just allow it.
- **Windows: PowerShell does not find the `claude` command.** Open a new PowerShell window (after installation PATH only updates in new windows). The program lives at `%USERPROFILE%\.local\bin\claude.exe`.
- **Windows: Claude Code complains about missing Git Bash, or the session-start reminder does not appear.** Install Git for Windows (https://git-scm.com/downloads/win), or run the install command again. If Git is not in the usual place, set the Git Bash path in `%USERPROFILE%\.claude\settings.json`: `"env": { "CLAUDE_CODE_GIT_BASH_PATH": "C:\\Program Files\\Git\\bin\\bash.exe" }`.
- **The installer reported an error at a step (Windows or Mac).** Every error message says what to do next. The installer is safe to run again; finished steps are skipped.
- **Mac: Terminal does not find the `claude` command.** Open a new Terminal window: the installer put `~/.local/bin` on the PATH in `~/.zshrc`, which only applies to new windows. The program lives at `~/.local/bin/claude`.
- **Mac: the installer stopped at the Command Line Tools.** That is on purpose: finish the installation in the system window that opened, then run the same command again. If no window appeared, type `xcode-select --install`.
- **You gave the main agent a different name on a re-run, but the old one stayed.** Setup never overwrites existing files. Ask the main agent to replace the name in the workspace's `CLAUDE.md` and under `SOPs/`.

## Uninstall

```
/plugin uninstall starter-kit-en@claude-starter-kit
/plugin marketplace remove claude-starter-kit
```

The workspace folder stays (those are your files, your own teammates included). If symlinks from 0.1.x are left under `~/.claude/agents/`, delete them by hand if you no longer need them.

## Customisation

- **Names:** you choose the main agent's name during setup; your own teammates can have any name. The built-in ones (Rita, Anna, Bea, Adam) live in the plugin; don't rename them, updates would overwrite the change.
- **Task tracking:** `Tasks/` can be markdown or an external tool (Jira, Todoist, Notion); the session rhythm works either way.

## License

MIT, see [LICENSE](LICENSE).
