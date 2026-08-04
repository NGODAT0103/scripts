# setup.ps1 - Sets up PowerShell profile to load from this repo
# Run from anywhere: pwsh -File D:\code\common-stuff\scripts\windows\setup.ps1

$ErrorActionPreference = "Stop"

# Resolve repo profile.ps1 path relative to this script (not hardcoded)
$RepoProfilePath = Join-Path $PSScriptRoot "profile.ps1"

if (-not (Test-Path $RepoProfilePath)) {
    Write-Error "profile.ps1 not found at $RepoProfilePath"
    exit 1
}

$DotSourceLine = ". `"$RepoProfilePath`""

# Ensure $PROFILE directory exists
$ProfileDir = Split-Path $PROFILE -Parent
if (-not (Test-Path $ProfileDir)) {
    New-Item -ItemType Directory -Path $ProfileDir -Force | Out-Null
    Write-Host "Created profile directory: $ProfileDir"
}

# Create $PROFILE if it doesn't exist
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    Write-Host "Created new profile file: $PROFILE"
}

# Check if already wired up (idempotent - safe to re-run)
$ExistingContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue
if ($ExistingContent -and $ExistingContent.Contains($RepoProfilePath)) {
    Write-Host "Profile already points to repo file. Nothing to do." -ForegroundColor Yellow
}
else {
    # Backup existing profile before modifying, if it has real content
    if ($ExistingContent -and $ExistingContent.Trim().Length -gt 0) {
        $BackupPath = "$PROFILE.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"
        Copy-Item $PROFILE $BackupPath
        Write-Host "Backed up existing profile to: $BackupPath"
    }

    Add-Content -Path $PROFILE -Value "`n# Auto-added by dotfiles setup.ps1`n$DotSourceLine"
    Write-Host "Wired `$PROFILE ($PROFILE) to load: $RepoProfilePath" -ForegroundColor Green
}

# Reload so functions are available immediately in current session
. $PROFILE
Write-Host "Profile reloaded. Try running 'kns <namespace>' now." -ForegroundColor Green