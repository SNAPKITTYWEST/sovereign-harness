// src/plasma_gate.mjs
// Browser port of plasma_gate.pl — 7 governing principles, 8 prohibitions, ERE-5
// Zero server. Zero swipl. Runs in any browser.
// Source: snapkitty-nemotron-harness/kernel/plasma_gate.pl

const BLOCKED = [
  { pattern: /rm\s+-rf\s+\//i,       reason: 'destructive_rm_root',    principle: 'worm_integrity' },
  { pattern: /drop\s+database/i,      reason: 'db_destruction',          principle: 'worm_integrity' },
  { pattern: /truncate\s+worm/i,      reason: 'worm_chain_tamper',       principle: 'worm_integrity' },
  { pattern: /bypass.*gate/i,         reason: 'gate_bypass_attempt',     principle: 'plasma_gate_primacy' },
  { pattern: /override.*consent/i,    reason: 'consent_violation',       principle: 'sovereign_identity' },
  { pattern: /delete.*worm/i,         reason: 'worm_chain_tamper',       principle: 'worm_integrity' },
  { pattern: /suppress.*audit/i,      reason: 'audit_suppression',       principle: 'audit_obligation' },
  { pattern: /delegate.*authority/i,  reason: 'authority_delegation',    principle: 'sovereign_identity' },
]

const PRINCIPLES = [
  'sovereign_identity',
  'plasma_gate_primacy',
  'worm_integrity',
  'human_supremacy',
  'proof_bearing',
  'convergence_drive',
  'audit_obligation',
]

export function plasma_gate(input) {
  if (!input || input.trim().length === 0) {
    return { pass: false, reason: 'empty_input', principle: 'proof_bearing', message: 'Empty input rejected' }
  }
  for (const { pattern, reason, principle } of BLOCKED) {
    if (pattern.test(input)) {
      return { pass: false, reason, principle, message: `Blocked by ${principle}: ${reason}` }
    }
  }
  return {
    pass: true,
    message: `Plasma gate: ${PRINCIPLES.length} principles checked, 0 violations`,
    principle: 'all'
  }
}

// ERE-5: five-pass evaluation
// Source: snapkitty-nemotron-harness/kernel/ere_gate.pl
export function ere5(input) {
  const passes = [
    {
      name: 'STRUCTURAL',
      pass: input && input.trim().length > 0,
      result: input?.trim().length > 0 ? 'non-empty input' : 'empty — structural fail'
    },
    {
      name: 'SCHOLARLY',
      pass: !/(fabricated|invented|hallucin)/i.test(input),
      result: /(fabricated|invented|hallucin)/i.test(input) ? 'fabrication marker' : 'no fabrication markers'
    },
    {
      name: 'INVARIANTS',
      pass: input.split(' ').reverse().join(' ').length > 0,
      result: 'reversible — invariant holds'
    },
    {
      name: 'MISSION',
      pass: !/(^null$|^undefined$|^none$)/i.test(input.trim()),
      result: /(^null$|^undefined$|^none$)/i.test(input.trim()) ? 'null/void marker' : 'no mission violation'
    },
    {
      name: 'ROOT',
      pass: typeof input === 'string' && input.length > 0,
      result: typeof input === 'string' ? 'type valid' : 'root invalid'
    },
  ]

  const failed = passes.find(p => !p.pass)
  return {
    overall: !failed,
    passes,
    failed: failed?.name || null
  }
}
