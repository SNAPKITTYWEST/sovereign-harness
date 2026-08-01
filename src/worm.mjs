// src/worm.mjs
// Browser WORM chain — SHA-256 sealed, localStorage persisted
// Matches snapkitty-shell/src/worm/chain.mjs semantics

export class WormChain {
  constructor(namespace = 'sovereign') {
    this.key  = `sk-worm-${namespace}`
    this.prev = this._loadLast()
  }

  _loadLast() {
    try {
      const chain = JSON.parse(localStorage.getItem(this.key) || '[]')
      return chain.length ? chain.at(-1).seal : '0'.repeat(64)
    } catch { return '0'.repeat(64) }
  }

  async seal(event, payload) {
    const chain = JSON.parse(localStorage.getItem(this.key) || '[]')
    const ts    = Date.now()
    const raw   = JSON.stringify({ event, payload, ts, prev: this.prev })
    const seal  = await this._sha256(raw)
    chain.push({ seq: chain.length, event, ts, prev: this.prev, seal })
    localStorage.setItem(this.key, JSON.stringify(chain))
    this.prev = seal
    return seal
  }

  verify() {
    const chain = JSON.parse(localStorage.getItem(this.key) || '[]')
    for (let i = 1; i < chain.length; i++) {
      if (chain[i].prev !== chain[i - 1].seal)
        return { valid: false, length: chain.length, broken: i }
    }
    return { valid: true, length: chain.length }
  }

  length() {
    return JSON.parse(localStorage.getItem(this.key) || '[]').length
  }

  async _sha256(str) {
    const buf = await crypto.subtle.digest('SHA-256', new TextEncoder().encode(str))
    return Array.from(new Uint8Array(buf)).map(b => b.toString(16).padStart(2,'0')).join('')
  }
}
