#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveSpineClayEquivalence.lean"

echo "[check-decisive-spine-clay-equivalence] checking Clay equivalence layer"

for pattern in \
  "decisiveSpine_clayB_equivalence" \
  "decisiveSpine_clause_alignment" \
  "decisiveSpine_domain_alignment" \
  "decisiveSpine_strict_audit_policy" \
  "decisiveSpine_reproducibility_ready"
do
  if ! rg -n "$pattern" "$FILE" >/dev/null; then
    echo "[check-decisive-spine-clay-equivalence] FAIL: missing $pattern" >&2
    exit 1
  fi
done

if rg -n 'DecisiveSpineGlobalRoute|FullProofExactGlobalData|import .*DecisiveSpineGlobal' "$FILE" >/dev/null; then
  echo "[check-decisive-spine-clay-equivalence] FAIL: equivalence file depends on decisive/global carrier layers" >&2
  exit 1
fi

if rg -n 'DecisiveSpineClayBEndpoint\s*:\s*Prop\s*:=\s*FullProofClayBStatementExact' "$FILE" >/dev/null; then
  echo "[check-decisive-spine-clay-equivalence] FAIL: decisive endpoint proposition is still a direct alias of full-proof endpoint" >&2
  exit 1
fi

echo "[check-decisive-spine-clay-equivalence] PASS"
