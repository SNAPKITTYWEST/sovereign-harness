# SnapKitty Sovereign Harness — iPhone & iPad

The full sovereign stack runs in your browser. No App Store. No download.

## Option 1 — Safari (instant, no install)

1. Open Safari on iPhone or iPad
2. Go to: **https://snapkittywest.github.io/sovereign-harness/**
3. Tap **Share → Add to Home Screen**
4. It installs as a PWA — works offline after first load

The browser UI runs:
- Plasma Gate (7 principles, 8 prohibitions, ERE-5)
- Kneser-Ney language model (sovlm)
- ANU QRNG real quantum entropy
- WORM SHA-256 chain (local storage)
- WebLLM — runs Phi-3 Mini in your browser via WebGPU

## Option 2 — Swift Playgrounds (iPad)

Open Swift Playgrounds on iPad and create a new playground with this code:

```swift
import SwiftUI
import WebKit

struct SovereignHarness: View {
    var body: some View {
        SovereignWebView()
            .ignoresSafeArea()
    }
}

struct SovereignWebView: UIViewRepresentable {
    let url = URL(string: "https://snapkittywest.github.io/sovereign-harness/")!

    func makeUIView(context: Context) -> WKWebView {
        let config = WKWebViewConfiguration()
        config.allowsInlineMediaPlayback = true
        config.mediaTypesRequiringUserActionForPlayback = []
        let wv = WKWebView(frame: .zero, configuration: config)
        wv.load(URLRequest(url: url))
        return wv
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {}
}

// Run it
import PlaygroundSupport
PlaygroundPage.current.setLiveView(SovereignHarness())
```

This opens the full sovereign harness UI inside Swift Playgrounds — same plasma gate, same WORM chain, same WebLLM.

## Option 3 — Shortcuts (iPhone automation)

1. Open the **Shortcuts** app
2. Create a new shortcut
3. Add action: **Open URLs**
4. URL: `https://snapkittywest.github.io/sovereign-harness/`
5. Add to home screen as "Sovereign"

## What runs in the browser (no server needed)

| Component | Browser version |
|-----------|----------------|
| Plasma Gate | plasma_gate.mjs — 7 principles, 8 prohibitions, ERE-5 |
| Language model | sovlm.mjs — Kneser-Ney n-gram, zero GPU |
| WebLLM | @mlc-ai/web-llm — Phi-3 Mini via WebGPU |
| Quantum entropy | quantum.mjs — ANU QRNG + CSPRNG fallback |
| WORM chain | worm.mjs — SHA-256 sealed, localStorage |
| pocketlearn | pocketlearn.mjs — ILP co-occurrence in browser |
| git-command-center | gitdos.js — full git DOS terminal |

**Ω = TRUST ∧ CODE**
