#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/ClassicalEquivalence.lean"

echo "[check-classical-equivalence-no-payload-carriers] checking classical-equivalence payload carriers"

if rg -n 'structure\s+(ClassicalClayBPeriodicProblem|ClassicalClayBStrongSolution|ClassicalEncodedSolutionTranslation|ClayBClauseMappingPayload)\b' "$FILE" >/dev/null; then
  echo "[check-classical-equivalence-no-payload-carriers] FAIL: payload carrier structures remain in ClassicalEquivalence.lean" >&2
  rg -n 'structure\s+(ClassicalClayBPeriodicProblem|ClassicalClayBStrongSolution|ClassicalEncodedSolutionTranslation|ClayBClauseMappingPayload)\b' "$FILE" >&2
  exit 1
fi

echo "[check-classical-equivalence-no-payload-carriers] PASS"
