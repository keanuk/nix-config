# PowerShell Profile
# Sets up environment and launches Nushell

# Set Starship Config
$RepoRoot = $PSScriptRoot | Split-Path -Parent
$env:NIX_CONFIG_ROOT = $RepoRoot
$StarshipConfig = Join-Path $RepoRoot "home\_mixins\shell\starship\starship.toml"

if (Test-Path $StarshipConfig) {
    $env:STARSHIP_CONFIG = $StarshipConfig
} else {
    Write-Warning "Starship config not found at $StarshipConfig"
}

# Initialize Starship for PowerShell (only if not already in Nu)
if (-not $env:NU_VERSION) {
    if (Get-Command starship -ErrorAction SilentlyContinue) {
        Invoke-Expression (&starship init powershell)
    }

    # Launch Nushell as default shell
    if (Get-Command nu -ErrorAction SilentlyContinue) {
        nu
    } else {
        Write-Warning "Nushell (nu) not found."
    }
}
