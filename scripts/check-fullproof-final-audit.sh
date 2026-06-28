#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/StatMech/ContinuumField/NavierStokes/Faithful/FullProofClayFinalization.lean"

echo "[check-fullproof-final-audit] checking finalization theorem coverage"

for pattern in \
  "fullProof_clayQuantifier_equivalence" \
  "fullProof_endpoint_classicalObject_translation" \
  "fullProof_clause_alignment" \
  "fullProof_domain_periodicity_alignment" \
  "fullProof_audit_certification" \
  "fullProof_reproducibility_bundle_ready"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-fullproof-final-audit] FAIL: missing $pattern" >&2
    exit 1
  fi
done

if rg -n 'structure\s+FullProofAuditCertification\b' "$FILE" >/dev/null; then
  echo "[check-fullproof-final-audit] FAIL: finalization still uses FullProofAuditCertification carrier structure" >&2
  exit 1
fi

if rg -n 'FullProofExactGlobalData|DecisiveSpineGlobalRoute|import .*FullProofExactGlobal' "$FILE" >/dev/null; then
  echo "[check-fullproof-final-audit] FAIL: finalization file depends on global-route carrier layers" >&2
  exit 1
fi

if rg -n 'FullProofClayBStatementExact\s*:\s*Prop\s*:=\s*ClayBStatement_base_axiom_e2e' "$FILE" >/dev/null; then
  echo "[check-fullproof-final-audit] FAIL: endpoint proposition is still a direct alias of base-axiom endpoint" >&2
  exit 1
fi

echo "[check-fullproof-final-audit] PASS"
