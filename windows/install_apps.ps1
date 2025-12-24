# Install Apps Script
# Imports Winget packages from winget_packages.json

$WingetFile = Join-Path $PSScriptRoot "winget_packages.json"

if (Test-Path $WingetFile) {
    Write-Host "Installing packages from $WingetFile..."
    winget import -i $WingetFile --accept-package-agreements --accept-source-agreements
} else {
    Write-Error "Winget package file not found at $WingetFile"
}
