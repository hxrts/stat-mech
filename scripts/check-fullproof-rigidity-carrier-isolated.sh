#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
TARGET="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful"
SOURCE="$TARGET/FullProofExactRigidity.lean"

echo "[check-fullproof-rigidity-carrier-isolated] checking FullProof rigidity carrier isolation"

if [[ ! -f "$SOURCE" ]]; then
  echo "[check-fullproof-rigidity-carrier-isolated] FAIL: missing source file $SOURCE" >&2
  exit 1
fi

if rg -n --glob '*.lean' "FullProofExactRigidityData" "$TARGET" >/dev/null; then
  echo "[check-fullproof-rigidity-carrier-isolated] FAIL: FullProofExactRigidityData should be fully removed from faithful route" >&2
  rg -n --glob '*.lean' "FullProofExactRigidityData" "$TARGET" >&2
  exit 1
fi

echo "[check-fullproof-rigidity-carrier-isolated] PASS"
