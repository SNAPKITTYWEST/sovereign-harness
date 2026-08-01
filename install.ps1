# SnapKitty Sovereign Harness — Windows Bootstrap
# Run in PowerShell:
# iwr -useb https://snapkittywest.github.io/sovereign-harness/install.ps1 | iex

$ErrorActionPreference = "SilentlyContinue"
Clear-Host

Write-Host ""
Write-Host "  ██████  ███    ██  █████  ██████  ██   ██ ██ ████████ ████████ ██    ██" -ForegroundColor Green
Write-Host "  ██      ████   ██ ██   ██ ██   ██ ██  ██  ██    ██       ██     ██  ██ " -ForegroundColor Green
Write-Host "  ███████ ██ ██  ██ ███████ ██████  █████   ██    ██       ██      ████  " -ForegroundColor Green
Write-Host "       ██ ██  ██ ██ ██   ██ ██      ██  ██  ██    ██       ██       ██   " -ForegroundColor Green
Write-Host "  ███████ ██   ████ ██   ██ ██      ██   ██ ██    ██       ██       ██   " -ForegroundColor Green
Write-Host ""
Write-Host "  ⬡  SOVEREIGN HARNESS  ⬡  BOW-Ω-φ-∂-2026" -ForegroundColor Yellow
Write-Host "  Bel Esprit D'Accord Irrevocable Trust · EIN 42-697643" -ForegroundColor DarkGray
Write-Host ""
Write-Host "  Plasma Gate · ERE-5 · WORM Chain · WebLLM · ANU QRNG" -ForegroundColor Cyan
Write-Host ""

# Check Node
Write-Host "  [1/4] Checking Node.js..." -ForegroundColor Yellow
$node = Get-Command node -ErrorAction SilentlyContinue
if ($node) {
    $ver = node --version
    Write-Host "  ✓ Node.js $ver" -ForegroundColor Green
} else {
    Write-Host "  Node.js not found. Install from https://nodejs.org" -ForegroundColor Red
    Write-Host "  Or via winget: winget install OpenJS.NodeJS" -ForegroundColor DarkGray
    Start-Process "https://nodejs.org"
}

# Check Git
Write-Host "  [2/4] Checking Git..." -ForegroundColor Yellow
$git = Get-Command git -ErrorAction SilentlyContinue
if ($git) {
    Write-Host "  ✓ Git found" -ForegroundColor Green
} else {
    Write-Host "  Git not found. Installing via winget..." -ForegroundColor DarkGray
    winget install Git.Git --silent 2>$null
}

# Check Ollama
Write-Host "  [3/4] Checking Ollama (optional)..." -ForegroundColor Yellow
$ollama = Get-Command ollama -ErrorAction SilentlyContinue
if ($ollama) {
    Write-Host "  ✓ Ollama found" -ForegroundColor Green
} else {
    Write-Host "  Ollama not found — browser will use WebLLM (no install needed)" -ForegroundColor DarkGray
    Write-Host "  Optional: https://ollama.com/download" -ForegroundColor DarkGray
}

# Clone snapkitty-shell
Write-Host "  [4/4] Installing snapkitty-shell (sk CLI)..." -ForegroundColor Yellow
$skDir = "$env:USERPROFILE\.snapkitty\shell"
if (!(Test-Path $skDir)) {
    git clone --quiet https://github.com/SNAPKITTYWEST/snapkitty-shell.git $skDir
}
Set-Location $skDir
npm install --silent 2>$null

# Add to PATH
$skBin = "$env:USERPROFILE\.snapkitty\bin"
New-Item -ItemType Directory -Force -Path $skBin | Out-Null
$currentPath = [Environment]::GetEnvironmentVariable("PATH", "User")
if ($currentPath -notlike "*snapkitty*") {
    [Environment]::SetEnvironmentVariable("PATH", "$skBin;$currentPath", "User")
}
Copy-Item "$skDir\bin\sk.mjs" "$skBin\sk.mjs" -Force 2>$null

Write-Host ""
Write-Host "  ═══════════════════════════════════════════════" -ForegroundColor Green
Write-Host "  ✓ SOVEREIGN HARNESS READY" -ForegroundColor Green
Write-Host "  ═══════════════════════════════════════════════" -ForegroundColor Green
Write-Host ""
Write-Host "  Browser UI:" -ForegroundColor White
Write-Host "  https://snapkittywest.github.io/sovereign-harness/" -ForegroundColor Cyan
Write-Host ""
Write-Host "  Terminal (restart shell first):" -ForegroundColor White
Write-Host "  node $skDir\bin\sk.mjs help" -ForegroundColor Yellow
Write-Host ""
Write-Host "  Ω = TRUST ∧ CODE" -ForegroundColor Magenta
Write-Host ""

Start-Process "https://snapkittywest.github.io/sovereign-harness/"
