# Setup Script for Windows Dotfiles
# Links PowerShell profile and Nushell configuration

$RepoRoot = $PSScriptRoot | Split-Path -Parent
$WindowsDir = Join-Path $RepoRoot "windows"

# 1. Setup PowerShell Profile
Write-Host "Setting up PowerShell profile..." -ForegroundColor Cyan
$ProfileDir = $PROFILE | Split-Path
if (-not (Test-Path $ProfileDir)) {
    New-Item -ItemType Directory -Path $ProfileDir -Force
}

$ProfileSourceLine = ". `"$WindowsDir\PowerShell_profile.ps1`""

if (Test-Path $PROFILE) {
    $Content = Get-Content $PROFILE -Raw
    if ($Content -notlike "*$ProfileSourceLine*") {
        Write-Host "Backing up existing profile..."
        Copy-Item $PROFILE "$PROFILE.bak" -Force
        Add-Content $PROFILE "`n$ProfileSourceLine"
    } else {
        Write-Host "Profile already linked."
    }
} else {
    Set-Content $PROFILE $ProfileSourceLine
}

# 2. Setup Nushell Config
Write-Host "Setting up Nushell configuration..." -ForegroundColor Cyan
$NuConfigDir = Join-Path $env:APPDATA "nushell"
if (-not (Test-Path $NuConfigDir)) {
    New-Item -ItemType Directory -Path $NuConfigDir -Force
}

$FilesToLink = @("config.nu", "env.nu")
foreach ($File in $FilesToLink) {
    $Source = Join-Path "$WindowsDir\nushell" $File
    $Dest = Join-Path $NuConfigDir $File
    
    if (Test-Path $Dest) {
        Write-Host "Backing up existing $File..."
        Move-Item $Dest "$Dest.bak" -Force
    }
    
    Write-Host "Linking $File..."
    # Using hard link or copy if symlink fails (symlinks often require admin on Windows)
    New-Item -ItemType SymbolicLink -Path $Dest -Target $Source -ErrorAction SilentlyContinue
    if (-not (Test-Path $Dest)) {
        Write-Host "Symlink failed, copying instead..." -ForegroundColor Yellow
        Copy-Item $Source $Dest -Force
    }
}

# 3. Create Starship Cache Dir (to prevent Nushell source error on startup)
$StarshipCacheDir = Join-Path $env:USERPROFILE ".cache\starship"
if (-not (Test-Path $StarshipCacheDir)) {
    New-Item -ItemType Directory -Path $StarshipCacheDir -Force
}
# Pre-generate the init script so source doesn't fail
if (Get-Command starship -ErrorAction SilentlyContinue) {
    starship init nu | Set-Content (Join-Path $StarshipCacheDir "init.nu")
}

Write-Host "Setup complete! Please restart your terminal." -ForegroundColor Green
