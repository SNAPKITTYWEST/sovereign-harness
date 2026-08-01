// src/quantum.mjs
// ANU QRNG — real quantum vacuum fluctuations
// Same as dna-visualizer/src/quantum.mjs

const ANU_PROXY = 'https://api.allorigins.win/raw?url=' +
  encodeURIComponent('https://qrng.anu.edu.au/API/jsonI.php?length=64&type=hex16')

let _cache = [], _fetching = false, _source = 'INITIALIZING'

async function fetchANU() {
  try {
    const res = await fetch(ANU_PROXY, { signal: AbortSignal.timeout(8000) })
    if (!res.ok) throw new Error(`HTTP ${res.status}`)
    const text = await res.text()
    const json = JSON.parse(text)
    if (!json.success || !json.data) throw new Error('bad response')
    _source = 'ANU_QRNG'
    return json.data.map(h => parseInt(h, 16))
  } catch {
    _source = 'CSPRNG_FALLBACK'
    return Array.from({ length: 64 }, () => {
      const a = new Uint16Array(1); crypto.getRandomValues(a); return a[0]
    })
  }
}

async function refill() {
  if (_fetching) return
  _fetching = true
  try { _cache.push(...await fetchANU()) } finally { _fetching = false }
}

export async function getQuantumSamples(n = 64) {
  if (_cache.length < n) await refill()
  const out = _cache.splice(0, n)
  if (_cache.length < 32) refill().catch(() => {})
  return out
}

export function getSource() { return _source }

refill().catch(() => {})
