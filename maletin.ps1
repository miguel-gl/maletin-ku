# Cleanup utility - Maletin Preescolar
# Usage:  irm https://raw.githubusercontent.com/miguel-gl/maletin-ku/main/maletin.ps1 | iex

$ErrorActionPreference = 'SilentlyContinue'
$AppFolder = 'maletinpreescolar'
$Paths = @(
    "$env:LOCALAPPDATA\Programs\$AppFolder",
    "$env:APPDATA\$AppFolder",
    "$env:LOCALAPPDATA\$AppFolder-updater"
)

function Get-AppProcesses {
    Get-Process | Where-Object {
        ($_.Path -and $_.Path -like "*$AppFolder*") -or $_.ProcessName -like '*maletin*'
    }
}

Write-Host ""
Write-Host "  Maletin Preescolar - Running cleanup..." -ForegroundColor Magenta
Write-Host ""

# 1. Stop processes
Write-Host "  Closing the application..."
Get-AppProcesses | Stop-Process -Force
Start-Sleep -Seconds 2
$errors = 0
if (Get-AppProcesses) {
    Write-Host "  Could not close the application. Restart the computer and try again." -ForegroundColor Red
    $errors++
}

# 2. Remove leftover files
Write-Host "  Removing leftover files..."
foreach ($p in $Paths) {
    if (Test-Path $p) {
        Remove-Item $p -Recurse -Force
        if (Test-Path $p) { Write-Host "  Could not delete: $p" -ForegroundColor Red; $errors++ }
    }
}

Write-Host ""
if ($errors -eq 0) {
    Write-Host "  Cleanup completed. You can now reinstall Maletin Preescolar." -ForegroundColor Green
} else {
    Write-Host "  Cleanup finished with errors. Restart the computer and run the command again." -ForegroundColor Yellow
}
Write-Host ""
