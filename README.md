# sovereign-harness

[![License: Sovereign Source v1.0](https://img.shields.io/badge/License-Sovereign_Source_v1.0-black?style=flat-square)](./LICENSE)
[![Pages](https://img.shields.io/badge/GitHub_Pages-live-green?style=flat-square)](https://snapkittywest.github.io/sovereign-harness/)
[![Trust](https://img.shields.io/badge/Trust-EIN_42--697643-gold?style=flat-square)](#license)

**One-line bootstrap. Browser-first. Every platform.**

The unified entry point for the SnapKitty sovereign AI stack.

---

## Install

**Mac / Linux / WSL**
```bash
curl -fsSL https://snapkittywest.github.io/sovereign-harness/install.sh | bash
```

**Windows PowerShell**
```powershell
iwr -useb https://snapkittywest.github.io/sovereign-harness/install.ps1 | iex
```

**iPhone / iPad**
- Safari → [snapkittywest.github.io/sovereign-harness](https://snapkittywest.github.io/sovereign-harness/) → Add to Home Screen
- Or see [install-ios.html](https://snapkittywest.github.io/sovereign-harness/install-ios.html) for Swift Playgrounds

---

## What it does

The install script:
1. Prints colorful ASCII SnapKitty banner
2. Checks Node.js, Git, Ollama
3. Clones + installs [snapkitty-shell](https://github.com/SNAPKITTYWEST/snapkitty-shell) (`sk` CLI)
4. Pulls Nemotron via Ollama (background)
5. Opens the browser UI

After install:
```bash
sk help              # all commands
sk run git.status    # run a command
sk worm              # show WORM chain
```

---

## Browser UI

**[snapkittywest.github.io/sovereign-harness](https://snapkittywest.github.io/sovereign-harness/)**

Runs in any browser, offline after first load. No server needed.

| Layer | Browser implementation |
|-------|----------------------|
| Plasma Gate | `src/plasma_gate.mjs` — 7 principles, 8 prohibitions, ERE-5 |
| WORM chain | `src/worm.mjs` — SHA-256, localStorage |
| Quantum entropy | `src/quantum.mjs` — ANU QRNG + CSPRNG fallback |
| LLM | Ollama (local) → WebLLM fallback |

When Ollama is running locally, the UI automatically upgrades to Nemotron.

---

## The sovereign stack (10 repos wired)

```
sovereign-xml-compiler  → XML spec from natural language
claudes-harness         → Prolog identity gate
snapkitty-nemotron-harness → Constitutional kernel (plasma_gate.pl)
sovereign-transformer   → Datalog corpus gate
lean-llm-starter        → NO PROOF = NO ACCEPTANCE
systemic-intelligence   → SUBLEQ routing + φ-Born collapse
pocketlearn             → ILP learns from rejections
sovlm                   → Kneser-Ney language model
sovereign-forge         → Lean-proven stack machine + WORM
cartographer-agent      → Sovereign law corpus
```

---

## Links

- [DNA Visualizer](https://snapkittywest.github.io/dna-visualizer/) — quantum entropy + biological DNA
- [Git Command Center](https://snapkittywest.github.io/git-command-center/) — Apple GitDOS terminal
- [snapkitty-shell](https://github.com/SNAPKITTYWEST/snapkitty-shell) — `sk` CLI

---

**Ω = TRUST ∧ CODE**
Ahmad Ali Parr · Bel Esprit D'Accord Irrevocable Trust · EIN 42-697643
