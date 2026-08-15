#!/usr/bin/env bash
# SnapKitty Sovereign Harness — One-Line Bootstrap
# Mac / Linux / WSL
# curl -fsSL https://snapkittywest.github.io/sovereign-harness/install.sh | bash

set -e

# ── Sovereign Node Key Gate ───────────────────────────────────────────────────
if [ -z "${SNAPKITTY_NODE_KEY}" ]; then
  echo ""
  echo "  ╔══════════════════════════════════════════════════╗"
  echo "  ║     SOVEREIGN NODE KEY REQUIRED                  ║"
  echo "  ║                                                  ║"
  echo "  ║  Set SNAPKITTY_NODE_KEY before running.         ║"
  echo "  ║                                                  ║"
  echo "  ║  Get your key:                                   ║"
  echo "  ║  licensing@snapkittywest.dev                     ║"
  echo "  ║  https://github.com/SNAPKITTYWEST               ║"
  echo "  ║                                                  ║"
  echo "  ║  Copyright (C) 2026 Bel Esprit D'Accord         ║"
  echo "  ║  Irrevocable Trust (EIN 42-697643)               ║"
  echo "  ╚══════════════════════════════════════════════════╝"
  echo ""
  exit 1
fi

# ── Colors ────────────────────────────────────────────────────────────────────
GRN='\033[0;32m'; YLW='\033[0;33m'; CYN='\033[0;36m'
MAG='\033[0;35m'; RED='\033[0;31m'; DIM='\033[2m'; NC='\033[0m'; BOLD='\033[1m'

clear

# ── ASCII Banner ──────────────────────────────────────────────────────────────
echo -e "${GRN}"
cat << 'BANNER'
  ██████  ███    ██  █████  ██████  ██   ██ ██ ████████ ████████ ██    ██
  ██      ████   ██ ██   ██ ██   ██ ██  ██  ██    ██       ██     ██  ██
  ███████ ██ ██  ██ ███████ ██████  █████   ██    ██       ██      ████
       ██ ██  ██ ██ ██   ██ ██      ██  ██  ██    ██       ██       ██
  ███████ ██   ████ ██   ██ ██      ██   ██ ██    ██       ██       ██
BANNER
echo -e "${NC}"
echo -e "${YLW}  ⬡  SOVEREIGN HARNESS  ⬡  BOW-Ω-φ-∂-2026${NC}"
echo -e "${DIM}  Bel Esprit D'Accord Irrevocable Trust · EIN 42-697643${NC}"
echo ""
echo -e "${CYN}  Plasma Gate · ERE-5 · WORM Chain · WebLLM · ANU QRNG${NC}"
echo ""

# ── Detect OS ─────────────────────────────────────────────────────────────────
OS="unknown"
if [[ "$OSTYPE" == "darwin"* ]]; then OS="mac"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then OS="linux"
elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" ]]; then OS="windows"
fi

echo -e "${DIM}  Detected: $OS${NC}"
echo ""

# ── Package manager ───────────────────────────────────────────────────────────
install_pkg() {
  local pkg=$1
  echo -e "  ${DIM}→ installing $pkg...${NC}"
  if [[ "$OS" == "mac" ]]; then
    brew install "$pkg" 2>/dev/null || true
  elif [[ "$OS" == "linux" ]]; then
    sudo apt-get install -y "$pkg" 2>/dev/null || \
    sudo dnf install -y "$pkg" 2>/dev/null || \
    sudo pacman -S --noconfirm "$pkg" 2>/dev/null || true
  fi
}

# ── Check / install Node.js ───────────────────────────────────────────────────
echo -e "${YLW}  [1/5] Checking Node.js...${NC}"
if ! command -v node &>/dev/null; then
  echo -e "  ${RED}Node.js not found.${NC}"
  if [[ "$OS" == "mac" ]]; then
    echo -e "  Installing via Homebrew..."
    command -v brew &>/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    brew install node
  elif [[ "$OS" == "linux" ]]; then
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash - 2>/dev/null || true
    sudo apt-get install -y nodejs 2>/dev/null || true
  fi
else
  echo -e "  ${GRN}✓ Node.js $(node --version)${NC}"
fi

# ── Check / install Git ───────────────────────────────────────────────────────
echo -e "${YLW}  [2/5] Checking Git...${NC}"
if ! command -v git &>/dev/null; then
  install_pkg git
else
  echo -e "  ${GRN}✓ Git $(git --version | cut -d' ' -f3)${NC}"
fi

# ── Check Ollama (optional) ───────────────────────────────────────────────────
echo -e "${YLW}  [3/5] Checking Ollama (optional — WebLLM fallback available)...${NC}"
if command -v ollama &>/dev/null; then
  echo -e "  ${GRN}✓ Ollama found${NC}"
  OLLAMA_AVAILABLE=1
else
  echo -e "  ${DIM}  Ollama not found — browser will use WebLLM (no install needed)${NC}"
  echo -e "  ${DIM}  Optional: curl -fsSL https://ollama.com/install.sh | sh${NC}"
  OLLAMA_AVAILABLE=0
fi

# ── Clone snapkitty-shell ─────────────────────────────────────────────────────
echo -e "${YLW}  [4/5] Installing snapkitty-shell (sk CLI)...${NC}"
SK_DIR="$HOME/.snapkitty/shell"
mkdir -p "$HOME/.snapkitty"
if [ -d "$SK_DIR" ]; then
  echo -e "  ${DIM}  Updating existing install...${NC}"
  git -C "$SK_DIR" pull --quiet 2>/dev/null || true
else
  git clone --quiet https://github.com/SNAPKITTYWEST/snapkitty-shell.git "$SK_DIR"
fi
cd "$SK_DIR" && npm install --silent 2>/dev/null || true

# Add sk to PATH
SK_BIN="$HOME/.snapkitty/bin"
mkdir -p "$SK_BIN"
ln -sf "$SK_DIR/bin/sk.mjs" "$SK_BIN/sk" 2>/dev/null || true
chmod +x "$SK_DIR/bin/sk.mjs" 2>/dev/null || true

# Add to shell profile
for profile in "$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.profile"; do
  if [ -f "$profile" ] && ! grep -q "snapkitty/bin" "$profile" 2>/dev/null; then
    echo '' >> "$profile"
    echo '# SnapKitty Shell' >> "$profile"
    echo 'export PATH="$HOME/.snapkitty/bin:$PATH"' >> "$profile"
  fi
done
export PATH="$HOME/.snapkitty/bin:$PATH"
echo -e "  ${GRN}✓ sk CLI installed${NC}"

# ── Start Ollama + pull nemotron (if available) ───────────────────────────────
echo -e "${YLW}  [5/5] Starting sovereign stack...${NC}"
if [ "$OLLAMA_AVAILABLE" = "1" ]; then
  echo -e "  ${DIM}  Pulling nemotron model (first run may take a few minutes)...${NC}"
  ollama serve &>/dev/null &
  sleep 2
  ollama pull nemotron 2>/dev/null &
  echo -e "  ${GRN}✓ Nemotron pulling in background${NC}"
fi

# ── Done ──────────────────────────────────────────────────────────────────────
echo ""
echo -e "${GRN}  ═══════════════════════════════════════════════${NC}"
echo -e "${GRN}  ✓ SOVEREIGN HARNESS READY${NC}"
echo -e "${GRN}  ═══════════════════════════════════════════════${NC}"
echo ""
echo -e "  ${BOLD}Browser UI:${NC}"
echo -e "  ${CYN}  https://snapkittywest.github.io/sovereign-harness/${NC}"
echo ""
echo -e "  ${BOLD}Terminal:${NC}"
echo -e "  ${YLW}  sk help${NC}               — show all commands"
echo -e "  ${YLW}  sk run git.status${NC}      — check repo status"
echo -e "  ${YLW}  sk worm${NC}               — show WORM chain"
echo ""
echo -e "  ${DIM}  Plasma Gate: 7 principles · 8 prohibitions · ERE-5${NC}"
echo -e "  ${DIM}  WORM: ML-DSA-65 post-quantum sealed${NC}"
echo -e "  ${DIM}  φ = 1.6180339887...${NC}"
echo ""
echo -e "  ${MAG}  Ω = TRUST ∧ CODE${NC}"
echo ""

# Open browser
if command -v open &>/dev/null; then
  open "https://snapkittywest.github.io/sovereign-harness/" 2>/dev/null || true
elif command -v xdg-open &>/dev/null; then
  xdg-open "https://snapkittywest.github.io/sovereign-harness/" 2>/dev/null || true
fi
