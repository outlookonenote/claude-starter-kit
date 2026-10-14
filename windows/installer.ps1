param([switch]$English, [string]$Ref)

# Claude Code starter kit: Windows installer (main part).
#
# Normally started by ../install-windows.ps1 (the one-line bootstrap), which
# downloads this file and runs it as a script block. It can also be run on
# its own: powershell -ExecutionPolicy Bypass -File .\windows\installer.ps1
#
# Must work in Windows PowerShell 5.1 and PowerShell 7: no PS7-only syntax
# (no ??, ?:, &&, ||, -Parallel). Saved as UTF-8 WITH BOM so that 5.1 reads
# the Hungarian text correctly when run as a local file.
#
# Never calls `exit`: when run through `irm | iex` that would close the
# user's PowerShell window. Errors end the run with one plain sentence.
#
# Steps (each is skipped when already done, so re-running is safe):
#   1. Windows 10 1809+ / 11, 64-bit
#   2. Git for Windows (Git Bash); installed with winget when missing
#   3. Claude Code; installed with the official install.ps1 when missing
#   4. Marketplace + plugin via the claude CLI (no login needed for this)
#   5. Workspace via the plugin's setup-workspace.sh run in Git Bash
#
# -Ref is the release ref the bootstrap downloaded this file from (shown in
# the title only). The marketplace itself is added WITHOUT a ref on purpose:
# a marketplace added as owner/repo#<tag> stays on that tag for good
# ("claude plugin marketplace update" never leaves it, and re-adding with a
# newer ref does not change it), so users would never get later releases.
# Unpinned, it follows the default branch, which only receives releases.
# Contract with the plugin that therefore must stay compatible across
# releases: scripts/setup-workspace.sh <data-dir> <path> [name], and the data
# dir name <plugin>-claude-starter-kit.
#
# Test overrides (each prints a yellow warning): STARTER_KIT_REF adds the
# marketplace at that branch (it then stays there until
# "claude plugin marketplace remove claude-starter-kit"), STARTER_KIT_SOURCE
# replaces the marketplace source (e.g. a local clone).

$ErrorActionPreference = 'Stop'
$ProgressPreference = 'SilentlyContinue'

$Repo = 'outlookonenote/claude-starter-kit'
$MarketplaceName = 'claude-starter-kit'

if ($English) {
    $Plugin = 'starter-kit-en'
    $OtherPlugin = 'starter-kit'
    $DefaultName = 'Max'
    $DefaultFolder = 'Workspace'
} else {
    $Plugin = 'starter-kit'
    $OtherPlugin = 'starter-kit-en'
    $DefaultName = 'Máté'
    $DefaultFolder = 'Munkaterulet'
}
$PluginId = "$Plugin@$MarketplaceName"

# --- Messages ---------------------------------------------------------------

if ($English) {
    $M = @{
        Title            = 'Claude Code starter kit installer (Windows)'
        TestSource       = 'Test source (marketplace): {0}. Not for regular use; afterwards: claude plugin marketplace remove claude-starter-kit'
        MigrateHint      = 'Your own teammates from the earlier version are still in the old location: start claude in the workspace and run /starter-kit-en:setup, which offers to move them.'
        NotWindows       = 'This installer is for Windows. On macOS and Linux, follow the README.'
        OldWindows       = 'This needs Windows 10 (version 1809 or newer) or Windows 11. Update Windows, then run this installer again.'
        Not64            = 'Claude Code only runs on 64-bit Windows.'
        X86Shell         = 'You opened the 32-bit PowerShell. Open the normal "Windows PowerShell" app (without x86) and run this installer there.'
        Step1            = '[1/5] Checking Windows'
        Step2            = '[2/5] Git for Windows (Git Bash)'
        Step3            = '[3/5] Claude Code'
        Step4            = '[4/5] The starter kit plugin'
        Step5            = '[5/5] The workspace'
        WindowsOk        = 'Windows {0}: OK'
        GitFound         = 'Git Bash found: {0}'
        GitInstalling    = 'Git for Windows is missing, installing it with winget now. If Windows asks for permission, allow it.'
        NoWinget         = 'Git for Windows is missing and winget is not available on this computer. Download and install it from https://git-scm.com/downloads/win (the defaults are fine for every question), then open a new PowerShell window and run this installer again.'
        GitInstallFailed = 'Installing Git for Windows did not succeed. Install it by hand from https://git-scm.com/downloads/win, then open a new PowerShell window and run this installer again.'
        GitBashEnv       = 'Claude Code will find Git Bash through the CLAUDE_CODE_GIT_BASH_PATH user environment variable.'
        ClaudeFound      = 'Claude Code found: {0}'
        ClaudeInstalling = 'Claude Code is missing, installing it with the official installer now (no administrator rights needed).'
        ClaudeFailed     = 'Installing Claude Code did not succeed. Try it by hand: irm https://claude.ai/install.ps1 | iex, then run this installer again.'
        ClaudeNotOnPath  = 'Claude Code was installed, but I cannot find it in this window. Open a new PowerShell window and run this installer again.'
        MpPresent        = 'The marketplace is already added.'
        MpAdding         = 'Adding the marketplace: {0}'
        MpFailed         = 'Adding the marketplace did not succeed. Check the internet connection, then run this installer again.'
        PluginPresent    = 'The plugin is already installed ({0}), checking for updates.'
        PluginInstalling = 'Installing the plugin: {0}'
        PluginFailed     = 'Installing the plugin did not succeed. Run this installer again; if it fails again, see the troubleshooting section of the README.'
        PluginEnabled    = 'The plugin was disabled; I enabled it.'
        PluginNoPath     = 'The plugin is installed, but I cannot find its folder. Start claude in the workspace folder and run /starter-kit-en:setup there.'
        BothEditions     = 'Note: the Hungarian edition (starter-kit) is installed too. One is enough; you can disable the other in claude with the /plugin menu.'
        WsExisting       = 'A workspace is already set up: {0}. Missing template files will be added, existing files are left alone.'
        AskName          = 'What should the main agent be called? (Enter = {0})'
        WsCreating       = 'Creating the workspace: {0}'
        WsFailed         = 'Creating the workspace did not succeed (details above). Run this installer again, or start claude and run /starter-kit-en:setup.'
        NameWarn         = 'Note: the main agent name did not make it into CLAUDE.md. After starting claude, ask the main agent to put its name into CLAUDE.md.'
        AskGit           = 'Put the workspace under version control (git)? It lets you go back to earlier versions of your notes and rules. (Y/n)'
        GitInitDone      = 'The workspace is now a git repository.'
        GitInitFailed    = 'git init did not succeed; you can run it later in the workspace folder.'
        GitAlready       = 'The workspace is already a git repository.'
        Unexpected       = 'Unexpected error: {0}'
        UnexpectedHint   = 'Run the installer again; if the error repeats, send this message to whoever helps you.'
        Done             = 'Done. What happened:'
        DoneGit          = '  - Git for Windows: {0}'
        DoneClaude       = '  - Claude Code: {0}'
        DonePlugin       = '  - Plugin: {0}'
        DoneWs           = '  - Workspace: {0} (main agent: {1})'
        Next             = 'How to start (this window works too):'
        Next1            = '  1. {0}'
        Next2            = '  2. claude'
        Next3            = '  3. Log in with your Claude account in the browser that opens (a paid plan is needed).'
        Next4            = '  4. When asked whether you trust this folder, answer Yes.'
        Next5            = '  5. Type: {0}'
        NextHint         = 'If PowerShell does not find the claude command, open a new window and start again from step 1.'
        YesPattern       = '^(y|yes)?$'
    }
} else {
    $M = @{
        Title            = 'Claude Code starter kit telepítő (Windows)'
        TestSource       = 'Teszt forrás (marketplace): {0}. Nem rendes használatra; utána: claude plugin marketplace remove claude-starter-kit'
        MigrateHint      = 'A korábbi verzióval felvett saját kollégáid még a régi helyükön vannak: indítsd el a claude-ot a munkaterületen, és add ki a /starter-kit:setup parancsot, ami felajánlja az áthelyezésüket.'
        NotWindows       = 'Ez a telepítő Windowsra készült. macOS-en és Linuxon a README leírását kövesd.'
        OldWindows       = 'Ehhez Windows 10 (1809-es vagy újabb kiadás) vagy Windows 11 kell. Frissítsd a Windowst, majd futtasd újra ezt a telepítőt.'
        Not64            = 'A Claude Code csak 64 bites Windowson fut.'
        X86Shell         = 'A 32 bites PowerShellt nyitottad meg. Nyisd meg a sima „Windows PowerShell” alkalmazást (x86 nélkül), és ott futtasd újra ezt a telepítőt.'
        Step1            = '[1/5] Windows ellenőrzése'
        Step2            = '[2/5] Git for Windows (Git Bash)'
        Step3            = '[3/5] Claude Code'
        Step4            = '[4/5] A starter kit plugin'
        Step5            = '[5/5] A munkaterület'
        WindowsOk        = 'Windows {0}: rendben'
        GitFound         = 'Git Bash megvan: {0}'
        GitInstalling    = 'A Git for Windows hiányzik, most telepítem a wingettel. Ha a Windows engedélyt kér, fogadd el.'
        NoWinget         = 'A Git for Windows hiányzik, és a winget sem érhető el ezen a gépen. Töltsd le és telepítsd innen: https://git-scm.com/downloads/win (minden kérdésnél jó az alapértelmezés), majd nyiss új PowerShell ablakot, és futtasd újra ezt a telepítőt.'
        GitInstallFailed = 'A Git for Windows telepítése nem sikerült. Telepítsd kézzel innen: https://git-scm.com/downloads/win, majd nyiss új PowerShell ablakot, és futtasd újra ezt a telepítőt.'
        GitBashEnv       = 'A Claude Code a CLAUDE_CODE_GIT_BASH_PATH felhasználói környezeti változóból találja meg a Git Basht.'
        ClaudeFound      = 'Claude Code megvan: {0}'
        ClaudeInstalling = 'A Claude Code hiányzik, most telepítem a hivatalos telepítővel (rendszergazdai jog nem kell).'
        ClaudeFailed     = 'A Claude Code telepítése nem sikerült. Próbáld kézzel: irm https://claude.ai/install.ps1 | iex, majd futtasd újra ezt a telepítőt.'
        ClaudeNotOnPath  = 'A Claude Code települt, de ebben az ablakban nem találom. Nyiss új PowerShell ablakot, és futtasd újra ezt a telepítőt.'
        MpPresent        = 'A marketplace már fel van véve.'
        MpAdding         = 'Marketplace felvétele: {0}'
        MpFailed         = 'A marketplace felvétele nem sikerült. Ellenőrizd az internetkapcsolatot, majd futtasd újra ezt a telepítőt.'
        PluginPresent    = 'A plugin már telepítve van ({0}), frissítést keresek.'
        PluginInstalling = 'Plugin telepítése: {0}'
        PluginFailed     = 'A plugin telepítése nem sikerült. Futtasd újra ezt a telepítőt; ha ismét hibát kapsz, nézd meg a README hibaelhárítás részét.'
        PluginEnabled    = 'A plugin ki volt kapcsolva, bekapcsoltam.'
        PluginNoPath     = 'A plugin telepítve van, de a mappáját nem találom. Indítsd el a claude-ot a munkaterület mappájában, és ott add ki a /starter-kit:setup parancsot.'
        BothEditions     = 'Megjegyzés: az angol kiadás (starter-kit-en) is telepítve van. Elég az egyik; a másikat a claude-ban a /plugin menüben kapcsolhatod ki.'
        WsExisting       = 'Már van beállított munkaterület: {0}. A hiányzó sablonfájlokat pótolom, a meglévőkhöz nem nyúlok.'
        AskName          = 'Mi legyen a fő-agent neve? (Enter = {0})'
        WsCreating       = 'Munkaterület létrehozása: {0}'
        WsFailed         = 'A munkaterület létrehozása nem sikerült (a részletek fent). Futtasd újra ezt a telepítőt, vagy indítsd el a claude-ot, és add ki a /starter-kit:setup parancsot.'
        NameWarn         = 'Figyelem: a fő-agent neve nem került be a CLAUDE.md fájlba. A claude indítása után kérd meg a fő-agentet, hogy írja be a nevét a CLAUDE.md fájlba.'
        AskGit           = 'Legyen verziókövetés (git) a munkaterületen? Így a jegyzeteid és szabályaid korábbi állapota is visszanézhető. (I/n)'
        GitInitDone      = 'A munkaterület mostantól git repó.'
        GitInitFailed    = 'A git init nem sikerült; később a munkaterület mappájában pótolhatod.'
        GitAlready       = 'A munkaterület már git repó.'
        Unexpected       = 'Váratlan hiba: {0}'
        UnexpectedHint   = 'Futtasd újra a telepítőt; ha a hiba ismétlődik, küldd el ezt az üzenetet annak, aki segít.'
        Done             = 'Kész. Ami megtörtént:'
        DoneGit          = '  - Git for Windows: {0}'
        DoneClaude       = '  - Claude Code: {0}'
        DonePlugin       = '  - Plugin: {0}'
        DoneWs           = '  - Munkaterület: {0} (fő-agent: {1})'
        Next             = 'Így indulj (ebben az ablakban is mehet):'
        Next1            = '  1. {0}'
        Next2            = '  2. claude'
        Next3            = '  3. A megnyíló böngészőben jelentkezz be a Claude-fiókoddal (fizetős előfizetés kell).'
        Next4            = '  4. Arra a kérdésre, hogy megbízol-e ebben a mappában, válaszolj igennel (Yes).'
        Next5            = '  5. Írd be: {0}'
        NextHint         = 'Ha a PowerShell nem találja a claude parancsot, nyiss új ablakot, és kezdd újra az 1. lépéstől.'
        YesPattern       = '^(i|igen|y|yes)?$'
    }
}

# --- Helpers ----------------------------------------------------------------

# A failure we expect and explain in one sentence (no stack trace). Marked
# through Exception.Data instead of a PowerShell class, which is fragile in
# 5.1 when the script runs as a dynamically created script block.
function Stop-Installer([string]$Message) {
    $exception = New-Object System.InvalidOperationException $Message
    $exception.Data['StarterKitInstaller'] = $true
    throw $exception
}

function Write-Step([string]$Text) {
    Write-Host ''
    Write-Host $Text -ForegroundColor Cyan
}

function Write-Info([string]$Text) {
    Write-Host "  $Text"
}

# Rebuild PATH for this session from the machine and user values (what a new
# window would see), keeping anything already set here, plus ~\.local\bin
# where the official Claude Code installer puts claude.exe.
function Update-SessionPath {
    $all = @()
    $sources = @(
        [Environment]::GetEnvironmentVariable('Path', 'Machine'),
        [Environment]::GetEnvironmentVariable('Path', 'User'),
        $env:Path,
        (Join-Path $env:USERPROFILE '.local\bin')
    )
    foreach ($source in $sources) {
        if (-not $source) { continue }
        foreach ($entry in $source.Split(';')) {
            $entry = $entry.Trim()
            if ($entry -and ($all -notcontains $entry)) { $all += $entry }
        }
    }
    $env:Path = $all -join ';'
}

# Run a native program without letting Windows PowerShell 5.1 turn its stderr
# into a terminating error. Output goes straight to the console unless
# -Capture is given, in which case stdout is returned (stderr is dropped).
# -Tee shows stdout on the console AND returns it.
function Invoke-Native {
    param(
        [Parameter(Mandatory = $true)][string]$FilePath,
        [string[]]$ArgumentList = @(),
        [switch]$Capture,
        [switch]$Tee
    )
    $previous = $ErrorActionPreference
    $ErrorActionPreference = 'Continue'
    try {
        if ($Capture) {
            $out = & $FilePath @ArgumentList 2>$null
            $text = ($out | ForEach-Object { "$_" }) -join "`n"
        } elseif ($Tee) {
            & $FilePath @ArgumentList | Tee-Object -Variable teeOut | Out-Host
            $text = ($teeOut | ForEach-Object { "$_" }) -join "`n"
        } else {
            & $FilePath @ArgumentList | Out-Host
            $text = ''
        }
        return [pscustomobject]@{ ExitCode = $LASTEXITCODE; Output = $text }
    } finally {
        $ErrorActionPreference = $previous
    }
}

function ConvertFrom-JsonSafe([string]$Text) {
    if (-not $Text) { return $null }
    $start = $Text.IndexOfAny([char[]]@('[', '{'))
    if ($start -lt 0) { return $null }
    try { return ($Text.Substring($start) | ConvertFrom-Json) } catch { return $null }
}

# Git Bash only: never a bare "bash" from PATH, which may be WSL's bash.exe.
function Find-GitBash {
    $candidates = @()
    if ($env:CLAUDE_CODE_GIT_BASH_PATH) { $candidates += $env:CLAUDE_CODE_GIT_BASH_PATH }
    $git = Get-Command git.exe -ErrorAction SilentlyContinue
    if ($git) {
        $gitDir = Split-Path -Parent $git.Source
        $candidates += (Join-Path $gitDir '..\bin\bash.exe')
        $candidates += (Join-Path $gitDir '..\..\bin\bash.exe')
    }
    $roots = @($env:ProgramFiles, ${env:ProgramFiles(x86)}, $env:ProgramW6432)
    if ($env:LOCALAPPDATA) { $roots += (Join-Path $env:LOCALAPPDATA 'Programs') }
    foreach ($root in $roots) {
        if ($root) { $candidates += (Join-Path $root 'Git\bin\bash.exe') }
    }
    foreach ($candidate in $candidates) {
        if ($candidate -and (Test-Path -LiteralPath $candidate -PathType Leaf)) {
            return (Resolve-Path -LiteralPath $candidate).Path
        }
    }
    return $null
}

function Find-Claude {
    $local = Join-Path $env:USERPROFILE '.local\bin\claude.exe'
    if (Test-Path -LiteralPath $local -PathType Leaf) { return $local }
    $cmd = Get-Command claude -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
    if ($cmd) { return $cmd.Source }
    return $null
}

function Get-InstalledPlugins([string]$Claude) {
    $result = Invoke-Native -FilePath $Claude -ArgumentList @('plugin', 'list', '--json') -Capture
    $items = ConvertFrom-JsonSafe $result.Output
    $list = @()
    foreach ($item in $items) { if ($item) { $list += $item } }
    return $list
}

# Forward slashes: Git Bash and setup-workspace.sh both accept "C:/..." paths.
function ConvertTo-BashArg([string]$Path) {
    return ($Path -replace '\\', '/')
}

function Test-Yes([string]$Answer) {
    return ((("$Answer").Trim().ToLowerInvariant()) -match $M.YesPattern)
}

# --- Steps ------------------------------------------------------------------

function Assert-Windows {
    Write-Step $M.Step1
    if ($env:OS -ne 'Windows_NT') { Stop-Installer $M.NotWindows }
    if (-not [Environment]::Is64BitOperatingSystem) { Stop-Installer $M.Not64 }
    if (-not [Environment]::Is64BitProcess) { Stop-Installer $M.X86Shell }
    $version = [Environment]::OSVersion.Version
    if ($version.Major -lt 10 -or ($version.Major -eq 10 -and $version.Build -lt 17763)) {
        Stop-Installer $M.OldWindows
    }
    Write-Info ($M.WindowsOk -f $version.ToString())
}

function Install-GitIfMissing {
    Write-Step $M.Step2
    $bash = Find-GitBash
    if (-not $bash) {
        $winget = Get-Command winget.exe -ErrorAction SilentlyContinue
        if (-not $winget) { Stop-Installer $M.NoWinget }
        Write-Info $M.GitInstalling
        $common = @('install', '--id', 'Git.Git', '-e', '--source', 'winget',
            '--accept-package-agreements', '--accept-source-agreements')
        # A per-user install needs no administrator rights; fall back to the
        # machine-wide installer if the per-user one is not offered.
        $null = Invoke-Native -FilePath $winget.Source -ArgumentList ($common + @('--scope', 'user'))
        Update-SessionPath
        $bash = Find-GitBash
        if (-not $bash) {
            $null = Invoke-Native -FilePath $winget.Source -ArgumentList $common
            Update-SessionPath
            $bash = Find-GitBash
        }
        if (-not $bash) { Stop-Installer $M.GitInstallFailed }
    }
    Write-Info ($M.GitFound -f $bash)

    # Claude Code looks for Git Bash next to git.exe on PATH. If git is not on
    # PATH, point it at bash.exe explicitly (user variable, no admin needed).
    if (-not (Get-Command git.exe -ErrorAction SilentlyContinue) -and -not $env:CLAUDE_CODE_GIT_BASH_PATH) {
        [Environment]::SetEnvironmentVariable('CLAUDE_CODE_GIT_BASH_PATH', $bash, 'User')
        $env:CLAUDE_CODE_GIT_BASH_PATH = $bash
        Write-Info $M.GitBashEnv
    }
    return $bash
}

function Install-ClaudeIfMissing {
    Write-Step $M.Step3
    Update-SessionPath
    $claude = Find-Claude
    if (-not $claude) {
        Write-Info $M.ClaudeInstalling
        # Run the official installer in a child PowerShell: it calls `exit`,
        # which would otherwise end this script (and close an iex window).
        $shell = (Get-Process -Id $PID).Path
        $result = Invoke-Native -FilePath $shell -ArgumentList @(
            '-NoProfile', '-ExecutionPolicy', 'Bypass', '-Command',
            '[Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072; irm https://claude.ai/install.ps1 | iex')
        Update-SessionPath
        $claude = Find-Claude
        if (-not $claude) {
            if ($result.ExitCode -ne 0) { Stop-Installer $M.ClaudeFailed }
            Stop-Installer $M.ClaudeNotOnPath
        }
    }
    $version = (Invoke-Native -FilePath $claude -ArgumentList @('--version') -Capture).Output
    if ($version) { Write-Info ($M.ClaudeFound -f "$claude ($($version.Trim()))") }
    else { Write-Info ($M.ClaudeFound -f $claude) }
    return $claude
}

function Install-Plugin([string]$Claude) {
    Write-Step $M.Step4

    # Marketplace: unpinned (see the header for why); test overrides only.
    $source = Get-MarketplaceSource
    $known = ConvertFrom-JsonSafe (Invoke-Native -FilePath $Claude -ArgumentList @('plugin', 'marketplace', 'list', '--json') -Capture).Output
    $present = $false
    foreach ($entry in $known) { if ($entry -and $entry.name -eq $MarketplaceName) { $present = $true } }
    if ($present) {
        Write-Info $M.MpPresent
        $null = Invoke-Native -FilePath $Claude -ArgumentList @('plugin', 'marketplace', 'update', $MarketplaceName)
    } else {
        Write-Info ($M.MpAdding -f $source)
        $r = Invoke-Native -FilePath $Claude -ArgumentList @('plugin', 'marketplace', 'add', $source)
        if ($r.ExitCode -ne 0) { Stop-Installer $M.MpFailed }
    }

    # Plugin.
    $plugins = Get-InstalledPlugins $Claude
    $mine = $null
    $other = $null
    foreach ($p in $plugins) {
        if ($p.id -eq $PluginId) { $mine = $p }
        if ($p.id -eq "$OtherPlugin@$MarketplaceName") { $other = $p }
    }
    if ($mine) {
        Write-Info ($M.PluginPresent -f $mine.version)
        $null = Invoke-Native -FilePath $Claude -ArgumentList @('plugin', 'update', $PluginId)
        if ($mine.enabled -eq $false) {
            $null = Invoke-Native -FilePath $Claude -ArgumentList @('plugin', 'enable', $PluginId)
            Write-Info $M.PluginEnabled
        }
    } else {
        Write-Info ($M.PluginInstalling -f $PluginId)
        $r = Invoke-Native -FilePath $Claude -ArgumentList @('plugin', 'install', $PluginId)
        if ($r.ExitCode -ne 0) { Stop-Installer $M.PluginFailed }
    }
    if ($other) { Write-Info $M.BothEditions }

    # Where the installed copy lives (the update above may have moved it).
    foreach ($p in (Get-InstalledPlugins $Claude)) {
        if ($p.id -eq $PluginId -and $p.installPath) { return $p.installPath }
    }
    Stop-Installer $M.PluginNoPath
}

function Get-MarketplaceSource {
    if ($env:STARTER_KIT_SOURCE) { return $env:STARTER_KIT_SOURCE }
    if ($env:STARTER_KIT_REF) { return "$Repo#$($env:STARTER_KIT_REF)" }
    return $Repo
}

function Read-ConfigWorkspace([string]$ConfigFile) {
    if (-not (Test-Path -LiteralPath $ConfigFile -PathType Leaf)) { return $null }
    foreach ($line in (Get-Content -LiteralPath $ConfigFile -Encoding UTF8)) {
        if ($line -like 'workspace=*') {
            $value = $line.Substring('workspace='.Length).Trim()
            if ($value) { return ($value -replace '/', '\') }
        }
    }
    return $null
}

function New-Workspace([string]$Bash, [string]$PluginPath) {
    Write-Step $M.Step5
    $configDir = $env:CLAUDE_CONFIG_DIR
    if (-not $configDir) { $configDir = Join-Path $env:USERPROFILE '.claude' }
    $dataDir = Join-Path $configDir "plugins\data\$Plugin-$MarketplaceName"
    $configFile = Join-Path $dataDir 'config'
    $setupScript = Join-Path $PluginPath 'scripts\setup-workspace.sh'

    $existing = Read-ConfigWorkspace $configFile
    $name = $DefaultName
    if ($existing -and (Test-Path -LiteralPath $existing -PathType Container)) {
        $target = $existing
        Write-Info ($M.WsExisting -f $target)
    } else {
        $target = Join-Path $env:USERPROFILE $DefaultFolder
        $answer = Read-Host ('  ' + ($M.AskName -f $DefaultName))
        if ($answer) {
            # Quotes and control characters would break the native call.
            # Trailing backslashes would escape the closing quote that
            # Windows PowerShell 5.1 adds around arguments with spaces.
            $clean = ($answer -replace '["\p{Cc}]', '').Trim().TrimEnd('\').Trim()
            if ($clean) { $name = $clean }
        }
        Write-Info ($M.WsCreating -f $target)
    }

    # Git Bash prints UTF-8; the bash side gets a UTF-8 locale explicitly.
    $previousLcAll = $env:LC_ALL
    $env:LC_ALL = 'C.UTF-8'
    try {
        $bashArgs = @((ConvertTo-BashArg $setupScript), (ConvertTo-BashArg $dataDir), (ConvertTo-BashArg $target))
        # The default name is the script's own default: not passing it keeps
        # accented defaults away from command line encoding entirely.
        if ($name -cne $DefaultName) { $bashArgs += $name }
        $r = Invoke-Native -FilePath $Bash -ArgumentList $bashArgs -Tee
    } finally {
        $env:LC_ALL = $previousLcAll
    }
    if ($r.ExitCode -ne 0) { Stop-Installer $M.WsFailed }

    $workspace = Read-ConfigWorkspace $configFile
    if (-not $workspace -or -not (Test-Path -LiteralPath $workspace -PathType Container)) { Stop-Installer $M.WsFailed }

    # Check that a non-default name survived the trip through the command line.
    if (-not $existing -and $name -cne $DefaultName) {
        $claudeMd = Join-Path $workspace 'CLAUDE.md'
        if (Test-Path -LiteralPath $claudeMd) {
            $text = [IO.File]::ReadAllText($claudeMd, [Text.Encoding]::UTF8)
            if (-not $text.Contains($name)) { Write-Host ('  ' + $M.NameWarn) -ForegroundColor Yellow }
        }
    }

    # Offer git init (only once: skipped when the folder is already a repo).
    if (Test-Path -LiteralPath (Join-Path $workspace '.git')) {
        Write-Info $M.GitAlready
    } else {
        $answer = Read-Host ('  ' + $M.AskGit)
        if (Test-Yes $answer) {
            # Git for Windows ships git.exe next to bin\bash.exe.
            $git = Join-Path (Split-Path -Parent $Bash) 'git.exe'
            if (-not (Test-Path -LiteralPath $git -PathType Leaf)) {
                $git = $null
                $cmd = Get-Command git -CommandType Application -ErrorAction SilentlyContinue | Select-Object -First 1
                if ($cmd) { $git = $cmd.Source }
            }
            $ok = $false
            if ($git) {
                $g = Invoke-Native -FilePath $git -ArgumentList @('-C', $workspace, 'init', '--quiet') -Capture
                $ok = ($g.ExitCode -eq 0)
            }
            if ($ok) { Write-Info $M.GitInitDone } else { Write-Info $M.GitInitFailed }
        }
    }

    $legacy = ($r.Output -match 'migrate-agents\.sh')
    return [pscustomobject]@{ Path = $workspace; Name = $name; IsNew = (-not $existing); LegacyAgents = $legacy }
}

function Write-Summary($Bash, $Claude, $Workspace) {
    $profileDir = $env:USERPROFILE.TrimEnd('\')
    if ($Workspace.Path.StartsWith($profileDir + '\', [StringComparison]::OrdinalIgnoreCase)) {
        $cd = 'cd "~\' + $Workspace.Path.Substring($profileDir.Length + 1) + '"'
    } else {
        $cd = 'cd "' + $Workspace.Path + '"'
    }
    $shownName = $Workspace.Name
    if (-not $Workspace.IsNew) { $shownName = '-' }
    Write-Host ''
    Write-Host $M.Done -ForegroundColor Green
    Write-Host ($M.DoneGit -f $Bash)
    Write-Host ($M.DoneClaude -f $Claude)
    Write-Host ($M.DonePlugin -f $PluginId)
    Write-Host ($M.DoneWs -f $Workspace.Path, $shownName)
    if ($Workspace.LegacyAgents) { Write-Host ('  ' + $M.MigrateHint) -ForegroundColor Yellow }
    Write-Host ''
    Write-Host $M.Next -ForegroundColor Green
    Write-Host ($M.Next1 -f $cd)
    Write-Host $M.Next2
    Write-Host $M.Next3
    Write-Host $M.Next4
    Write-Host ($M.Next5 -f "/$($Plugin):onboard")
    Write-Host ''
    Write-Host $M.NextHint
}

# --- Main -------------------------------------------------------------------

$previousEncoding = $null
try {
    try {
        $previousEncoding = [Console]::OutputEncoding
        [Console]::OutputEncoding = New-Object System.Text.UTF8Encoding($false)
    } catch {
        $previousEncoding = $null
    }
    $title = $M.Title
    if ($Ref) { $title = "$title, $Ref" }
    Write-Host $title -ForegroundColor Green
    if ($env:STARTER_KIT_SOURCE -or $env:STARTER_KIT_REF) {
        Write-Host ($M.TestSource -f (Get-MarketplaceSource)) -ForegroundColor Yellow
    }
    Assert-Windows
    $bashExe = Install-GitIfMissing
    $claudeExe = Install-ClaudeIfMissing
    $pluginPath = Install-Plugin $claudeExe
    $ws = New-Workspace -Bash $bashExe -PluginPath $pluginPath
    Write-Summary -Bash $bashExe -Claude $claudeExe -Workspace $ws
} catch {
    Write-Host ''
    if ($_.Exception.Data['StarterKitInstaller']) {
        Write-Host $_.Exception.Message -ForegroundColor Red
    } else {
        Write-Host ($M.Unexpected -f $_.Exception.Message) -ForegroundColor Red
        Write-Host $M.UnexpectedHint -ForegroundColor Red
    }
} finally {
    if ($previousEncoding) {
        try { [Console]::OutputEncoding = $previousEncoding } catch { $null = $_ }
    }
}
