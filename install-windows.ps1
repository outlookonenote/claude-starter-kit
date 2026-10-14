param([switch]$English)

# Claude Code starter kit: one-line Windows installer (bootstrap).
#
#   [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072; irm https://raw.githubusercontent.com/outlookonenote/claude-starter-kit/main/install-windows.ps1 | iex
#
# English edition:
#   [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor 3072; & ([scriptblock]::Create((irm https://raw.githubusercontent.com/outlookonenote/claude-starter-kit/main/install-windows.ps1))) -English
#
# (The TLS 1.2 prefix is for Windows PowerShell 5.1 on systems where .NET
# does not offer TLS 1.2 by default; 3072 = Tls12. Harmless in PowerShell 7.)
#
# This file is deliberately pure ASCII and saved WITHOUT a BOM. Reason: with
# "irm | iex" the downloaded text is executed as a string, and a leading BOM
# (U+FEFF) is not whitespace to the PowerShell parser, so it breaks the first
# token. Without a BOM, Windows PowerShell 5.1 reads a local .ps1 as ANSI,
# which only matters for non-ASCII text, and there is none here.
#
# The real installer (windows/installer.ps1, Hungarian text, UTF-8 with BOM)
# is fetched as raw bytes, decoded as UTF-8 explicitly, stripped of its BOM
# and run as a script block. That path does not depend on how irm decodes
# text or on the execution policy. When this file is run from a clone, the
# sibling windows/installer.ps1 is used instead of downloading.
#
# RELEASE: the installer is downloaded from the git tag in $ReleaseRef below,
# not from the moving main branch. Every release must bump this constant AND
# RELEASE_REF in install-mac.sh (and create the tag) together with the plugin
# versions; see CHANGELOG.md.
#
# STARTER_KIT_REF (environment variable) overrides the ref for testing a
# branch; a yellow warning is printed when it is set.

$ReleaseRef = 'v0.2.1'

& {
    param([bool]$UseEnglish, [string]$ReleaseRef)

    $ErrorActionPreference = 'Stop'
    $ProgressPreference = 'SilentlyContinue'

    $ref = $ReleaseRef
    if ($env:STARTER_KIT_REF) { $ref = $env:STARTER_KIT_REF }
    $url = "https://raw.githubusercontent.com/outlookonenote/claude-starter-kit/$ref/windows/installer.ps1"

    # Hungarian messages built from code points, so this file stays ASCII.
    if ($UseEnglish) {
        $failMsg = 'Could not download the installer. Check the internet connection and try again.'
        $testMsg = 'Test source (installer): '
    } else {
        $failMsg = [regex]::Unescape('Nem siker\u00fclt let\u00f6lteni a telep\u00edt\u0151t. Ellen\u0151rizd az internetkapcsolatot, \u00e9s pr\u00f3b\u00e1ld \u00fajra.')
        $testMsg = [regex]::Unescape('Teszt forr\u00e1s (telep\u00edt\u0151): ')
    }
    if ($env:STARTER_KIT_REF) { Write-Host ($testMsg + $url) -ForegroundColor Yellow }

    try {
        $bytes = $null
        $local = $null
        if ($PSScriptRoot) { $local = Join-Path $PSScriptRoot 'windows\installer.ps1' }
        if ($local -and (Test-Path -LiteralPath $local -PathType Leaf)) {
            $bytes = [IO.File]::ReadAllBytes($local)
        } else {
            # Windows PowerShell 5.1 on older builds may not offer TLS 1.2 by default.
            try {
                [Net.ServicePointManager]::SecurityProtocol = [Net.ServicePointManager]::SecurityProtocol -bor [Net.SecurityProtocolType]::Tls12
            } catch {
                $null = $_
            }
            $client = New-Object System.Net.WebClient
            try { $bytes = $client.DownloadData($url) } finally { $client.Dispose() }
        }
        $text = [Text.Encoding]::UTF8.GetString($bytes)
        $text = $text.TrimStart([char]0xFEFF)
    } catch {
        Write-Host $failMsg -ForegroundColor Red
        return
    }

    $installer = [scriptblock]::Create($text)
    if ($UseEnglish) { & $installer -English -Ref $ref } else { & $installer -Ref $ref }
} $English.IsPresent $ReleaseRef
