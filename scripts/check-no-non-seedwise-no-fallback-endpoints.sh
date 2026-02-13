#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
COMP_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveCompletion.lean"
SEED_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/SeedConstruction.lean"
GLOBAL_FILE="$ROOT/Gibbs/ContinuumField/NavierStokes/Faithful/DecisiveGlobal.lean"

echo "[check-no-non-seedwise-no-fallback-endpoints] checking for retired non-seedwise no-fallback endpoints"

for f in "$COMP_FILE" "$SEED_FILE" "$GLOBAL_FILE"; do
  if [[ ! -f "$f" ]]; then
    echo "[check-no-non-seedwise-no-fallback-endpoints] FAIL: missing file $f" >&2
    exit 1
  fi
done

check_absent() {
  local file="$1"
  local pattern="$2"
  if rg -n "$pattern" "$file" >/dev/null; then
    echo "[check-no-non-seedwise-no-fallback-endpoints] FAIL: retired endpoint reintroduced in $file: $pattern" >&2
    exit 1
  fi
}

check_absent "$COMP_FILE" "theorem clayBStatement_from_decisive_completion_no_local_fallback\\b"
check_absent "$COMP_FILE" "theorem clayBStatement_from_decisive_completion_no_local_fallback_of_data_family\\b"
check_absent "$COMP_FILE" "theorem clayBStatement_from_decisive_completion_no_local_fallback_of_component_families\\b"
check_absent "$SEED_FILE" "theorem clayBStatement_from_no_local_fallback_global_closure_and_seed_construction\\b"
check_absent "$GLOBAL_FILE" "def decisiveGlobalClosureTheorem_no_local_fallback_of_component_families\\b"

echo "[check-no-non-seedwise-no-fallback-endpoints] PASS"
