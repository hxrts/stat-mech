# Justfile

# Max parallel threads for Lake/Lean builds
lean_threads := "3"

# Default task
default: build

# Build Lean library
build:
    LEAN_NUM_THREADS={{lean_threads}} lake build

# Test Lean installation
test:
    @echo "Testing Lean installation..."
    @lean --version
    @lake --version

# Check Lean architecture and style conformance
check-arch-lean *args:
    ./scripts/check-arch-lean.sh {{args}}

# Report escape hatches (sorry, axiom, unsafe, partial, etc.)
escape:
    ./scripts/check-escape.sh

# Enforce no new placeholder-style declarations in the final Clay(B) dependency cone
check-navier-final-cone:
    bash ./scripts/check-navier-final-cone-placeholders.sh

# Enforce no `axiom`/`sorry` in the Navier-Stokes theorem cone
check-clayb-cone-no-axiom-sorry:
    bash ./scripts/check-clayb-cone-no-axiom-sorry.sh

# Generate an import-based dependency-cone report for the Clay(B) final theorem path
report-clayb-dependency-cone:
    bash ./scripts/report-clayb-dependency-cone.sh

# Freeze theorem checkpoint metadata (hash + git head snapshot)
freeze-clayb-checkpoint:
    bash ./scripts/freeze-clayb-checkpoint.sh

# Clay(B) proof-completion gate
check-clayb-proof-gate:
    LEAN_NUM_THREADS={{lean_threads}} lake build Gibbs.ContinuumField.NavierStokes
    bash ./scripts/check-navier-final-cone-placeholders.sh
    bash ./scripts/check-clayb-cone-no-axiom-sorry.sh
    bash ./scripts/report-clayb-dependency-cone.sh

# Enforce faithful-cone policy (no placeholders/bridge/witness tokens)
check-faithful-clayb-cone:
    bash ./scripts/check-faithful-clayb-cone.sh

# Generate dependency-cone report for faithful final theorem path
report-faithful-clayb-cone:
    bash ./scripts/report-faithful-clayb-cone.sh

# Freeze faithful final theorem checkpoint metadata (hash + git head snapshot)
freeze-faithful-clayb-checkpoint:
    bash ./scripts/freeze-faithful-clayb-checkpoint.sh

# Faithful Clay(B) proof-completion gate
check-faithful-clayb-proof-gate:
    LEAN_NUM_THREADS={{lean_threads}} lake build Gibbs.ContinuumField.NavierStokes.Faithful.Final
    bash ./scripts/check-faithful-clayb-cone.sh
    bash ./scripts/check-clayb-cone-no-axiom-sorry.sh
    bash ./scripts/report-faithful-clayb-cone.sh

# Enforce decisive hard-step cone hygiene
check-decisive-hardstep-cone:
    bash ./scripts/check-decisive-hardstep-cone.sh

# Report decisive hard-step dependency cone
report-decisive-hardstep-cone:
    bash ./scripts/report-decisive-hardstep-cone.sh

# Freeze decisive hard-step checkpoint metadata
freeze-decisive-hardstep-checkpoint:
    bash ./scripts/freeze-decisive-hardstep-checkpoint.sh

# Decisive hard-step proof-completion gate
check-decisive-hardstep-proof-gate:
    LEAN_NUM_THREADS={{lean_threads}} lake build Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveCompletion
    bash ./scripts/check-faithful-clayb-cone.sh
    bash ./scripts/check-decisive-hardstep-cone.sh
    bash ./scripts/check-clayb-cone-no-axiom-sorry.sh
    bash ./scripts/report-decisive-hardstep-cone.sh

# Enforce no Nonempty-based seed-family assumptions in final decisive completion endpoint
check-decisive-no-seed-family:
    bash ./scripts/check-decisive-no-seed-family.sh

# Enforce no Nonempty-based seed assumptions in decisive completion route
check-decisive-completion-no-nonempty-seeds:
    bash ./scripts/check-decisive-completion-no-nonempty-seeds.sh

# Enforce removal of decisive kernel theorem/seed carrier structures
check-decisive-kernel-no-carriers:
    bash ./scripts/check-decisive-kernel-no-carriers.sh

# Enforce faithful smoothness-regularity fidelity constraints
check-faithful-smoothness-fidelity:
    bash ./scripts/check-faithful-smoothness-fidelity.sh

# Enforce quantitative hard-step theorem routing in decisive global closure
check-hardstep-quantitative-route:
    bash ./scripts/check-hardstep-quantitative-route.sh

# Prevent direct closed-form solution injection in decisive closure constructors
check-no-direct-closure-injection:
    bash ./scripts/check-no-direct-closure-injection.sh

# Report classical-equivalence theorem cone
report-classical-equivalence-cone:
    bash ./scripts/report-classical-equivalence-cone.sh

# Enforce removal of classical-equivalence payload carrier structures
check-classical-equivalence-no-payload-carriers:
    bash ./scripts/check-classical-equivalence-no-payload-carriers.sh

# Enforce removal of seed/classical-semantics bridge carrier wrappers
check-classical-bridge-no-carriers:
    bash ./scripts/check-classical-bridge-no-carriers.sh

# Freeze classical-equivalence theorem checkpoint metadata
freeze-classical-equivalence-checkpoint:
    bash ./scripts/freeze-classical-equivalence-checkpoint.sh

# Enforce base-axiom endpoint signature policy (no theorem/package/seed assumptions)
check-base-axiom-no-package-assumptions:
    bash ./scripts/check-base-axiom-no-package-assumptions.sh

# Enforce primitive-import policy for base-axiom analysis/compactness/rigidity/global/completion modules
check-base-axiom-primitive-imports:
    bash ./scripts/check-base-axiom-primitive-imports.sh

# Report base-axiom e2e theorem cone
report-base-axiom-e2e-cone:
    bash ./scripts/report-base-axiom-e2e-cone.sh

# Report remaining carrier-assumption frontier in base-axiom modules
report-base-axiom-carrier-frontier:
    bash ./scripts/report-base-axiom-carrier-frontier.sh

# Report base-axiom cone imports with shortcut-module policy
report-base-axiom-no-shortcut-cone:
    bash ./scripts/report-base-axiom-no-shortcut-cone.sh

# Freeze base-axiom e2e checkpoint metadata
freeze-base-axiom-e2e-checkpoint:
    bash ./scripts/freeze-base-axiom-e2e-checkpoint.sh

# Freeze base-axiom definitive-readiness checkpoint metadata
freeze-base-axiom-definitive-readiness-checkpoint:
    bash ./scripts/freeze-base-axiom-definitive-readiness-checkpoint.sh

# Enforce no simplified stand-ins in full-proof files
check-fullproof-no-simplified-standins:
    bash ./scripts/check-fullproof-no-simplified-standins.sh

# Enforce theorem-derived local theory route in full-proof files
check-fullproof-local-theory-derived:
    bash ./scripts/check-fullproof-local-theory-derived.sh

# Enforce removal of full-proof analysis route carrier structures
check-fullproof-analysis-no-route-carriers:
    bash ./scripts/check-fullproof-analysis-no-route-carriers.sh

# Enforce compactness derivation route in full-proof files
check-fullproof-compactness-derived:
    bash ./scripts/check-fullproof-compactness-derived.sh

# Enforce rigidity derivation route in full-proof files
check-fullproof-rigidity-derived:
    bash ./scripts/check-fullproof-rigidity-derived.sh

# Enforce isolation of FullProof rigidity carrier type
check-fullproof-rigidity-carrier-isolated:
    bash ./scripts/check-fullproof-rigidity-carrier-isolated.sh

# Enforce global derivation route in full-proof files
check-fullproof-global-derived:
    bash ./scripts/check-fullproof-global-derived.sh

# Enforce final theorem/audit coverage in full-proof files
check-fullproof-final-audit:
    bash ./scripts/check-fullproof-final-audit.sh

# Enforce no endpoint witness-family alias in full-proof finalization
check-fullproof-final-no-witness-family:
    bash ./scripts/check-fullproof-final-no-witness-family.sh

# Report full-proof final theorem cone
report-fullproof-final-cone:
    bash ./scripts/report-fullproof-final-cone.sh

# Freeze full-proof final checkpoint metadata
freeze-fullproof-final-checkpoint:
    bash ./scripts/freeze-fullproof-final-checkpoint.sh

# Enforce decisive-spine frozen-setting import policy
check-decisive-spine-frozen-setting-imports:
    bash ./scripts/check-decisive-spine-frozen-setting-imports.sh

# Enforce definition-first threshold route in decisive spine
check-decisive-spine-threshold-definition-first:
    bash ./scripts/check-decisive-spine-threshold-definition-first.sh

# Enforce profile derivation route in decisive spine
check-decisive-spine-profile-derived:
    bash ./scripts/check-decisive-spine-profile-derived.sh

# Enforce minimal-element derivation route in decisive spine
check-decisive-spine-minimal-element-derived:
    bash ./scripts/check-decisive-spine-minimal-element-derived.sh

# Enforce local-energy derivation route in decisive spine
check-decisive-spine-local-energy-derived:
    bash ./scripts/check-decisive-spine-local-energy-derived.sh

# Enforce lower/upper mechanism derivation route in decisive spine
check-decisive-spine-lower-upper-derived:
    bash ./scripts/check-decisive-spine-lower-upper-derived.sh

# Enforce incompatibility theorem route in decisive spine
check-decisive-spine-incompatibility:
    bash ./scripts/check-decisive-spine-incompatibility.sh

# Enforce removal of decisive-spine route/package carrier structures
check-decisive-spine-no-route-carriers:
    bash ./scripts/check-decisive-spine-no-route-carriers.sh

# Enforce global derivation route in decisive spine
check-decisive-spine-global-derived:
    bash ./scripts/check-decisive-spine-global-derived.sh

# Enforce Clay equivalence/audit route in decisive spine
check-decisive-spine-clay-equivalence:
    bash ./scripts/check-decisive-spine-clay-equivalence.sh

# Report decisive-spine final theorem cone
report-decisive-spine-final-cone:
    bash ./scripts/report-decisive-spine-final-cone.sh

# Freeze decisive-spine final checkpoint metadata
freeze-decisive-spine-final-checkpoint:
    bash ./scripts/freeze-decisive-spine-final-checkpoint.sh

# Enforce no definitive shortcut route in base-axiom cone
check-base-axiom-no-definitive-shortcuts:
    bash ./scripts/check-base-axiom-no-definitive-shortcuts.sh

# Enforce no shortcut-module imports in base-axiom cone
check-base-axiom-no-shortcut-cone:
    bash ./scripts/check-base-axiom-no-shortcut-cone.sh

# Enforce compactness module import policy in base-axiom cone
check-base-axiom-compactness-imports:
    bash ./scripts/check-base-axiom-compactness-imports.sh

# Enforce rigidity module import policy in base-axiom cone
check-base-axiom-rigidity-imports:
    bash ./scripts/check-base-axiom-rigidity-imports.sh

# Prevent direct formula injection in base-axiom endpoint/global files
check-base-axiom-no-direct-injection:
    bash ./scripts/check-base-axiom-no-direct-injection.sh

# Enforce endpoint has no local-theory assumption handles
check-base-axiom-no-local-theory-handle:
    bash ./scripts/check-base-axiom-no-local-theory-handle.sh

# Enforce contradiction-derived extension route in base-axiom global theorem path
check-base-axiom-extension-derived-route:
    bash ./scripts/check-base-axiom-extension-derived-route.sh

# Enforce removal of legacy carrier-assumption fields in base-axiom cone
check-base-axiom-no-carrier-assumptions:
    bash ./scripts/check-base-axiom-no-carrier-assumptions.sh

# Enforce no `axiom`/`sorry` in base-axiom cone files
check-base-axiom-cone-no-axiom-sorry:
    bash ./scripts/check-base-axiom-cone-no-axiom-sorry.sh

# Remaining classical-content closure gate
check-classical-closure-proof-gate:
    LEAN_NUM_THREADS={{lean_threads}} lake build Gibbs.ContinuumField.NavierStokes.Faithful.ClassicalEquivalence
    bash ./scripts/check-decisive-no-seed-family.sh
    bash ./scripts/check-decisive-completion-no-nonempty-seeds.sh
    bash ./scripts/check-decisive-kernel-no-carriers.sh
    bash ./scripts/check-classical-equivalence-no-payload-carriers.sh
    bash ./scripts/check-classical-bridge-no-carriers.sh
    bash ./scripts/check-faithful-smoothness-fidelity.sh
    bash ./scripts/check-hardstep-quantitative-route.sh
    bash ./scripts/check-no-direct-closure-injection.sh
    bash ./scripts/report-classical-equivalence-cone.sh

# Base-axiom end-to-end closure gate
check-base-axiom-e2e-proof-gate:
    LEAN_NUM_THREADS={{lean_threads}} lake build Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomCompletion
    bash ./scripts/check-base-axiom-no-package-assumptions.sh
    bash ./scripts/check-base-axiom-primitive-imports.sh
    bash ./scripts/check-no-direct-closure-injection.sh
    bash ./scripts/report-base-axiom-e2e-cone.sh

# Base-axiom definitive-readiness gate (current tranche)
check-base-axiom-definitive-readiness:
    LEAN_NUM_THREADS={{lean_threads}} lake build Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomCompletion
    bash ./scripts/check-base-axiom-no-package-assumptions.sh
    bash ./scripts/check-base-axiom-primitive-imports.sh
    bash ./scripts/check-base-axiom-no-definitive-shortcuts.sh
    bash ./scripts/check-base-axiom-no-shortcut-cone.sh
    bash ./scripts/check-base-axiom-compactness-imports.sh
    bash ./scripts/check-base-axiom-rigidity-imports.sh
    bash ./scripts/check-base-axiom-no-direct-injection.sh
    bash ./scripts/check-base-axiom-no-local-theory-handle.sh
    bash ./scripts/check-base-axiom-extension-derived-route.sh
    bash ./scripts/check-base-axiom-no-carrier-assumptions.sh
    bash ./scripts/check-rigidity-carrier-isolated.sh
    bash ./scripts/check-base-axiom-cone-no-axiom-sorry.sh
    bash ./scripts/report-base-axiom-carrier-frontier.sh
    bash ./scripts/report-base-axiom-no-shortcut-cone.sh
    bash ./scripts/report-base-axiom-e2e-cone.sh

# Full-proof final gate
check-fullproof-clay-proof-gate:
    LEAN_NUM_THREADS={{lean_threads}} lake build Gibbs.ContinuumField.NavierStokes.Faithful.FullProofClayFinalization
    just check-base-axiom-definitive-readiness
    bash ./scripts/check-final-endpoint-no-carrier-types.sh
    bash ./scripts/check-final-cone-no-synthetic-local-constructors.sh
    bash ./scripts/check-fullproof-no-simplified-standins.sh
    bash ./scripts/check-fullproof-local-theory-derived.sh
    bash ./scripts/check-fullproof-analysis-no-route-carriers.sh
    bash ./scripts/check-fullproof-compactness-derived.sh
    bash ./scripts/check-fullproof-rigidity-derived.sh
    bash ./scripts/check-fullproof-rigidity-carrier-isolated.sh
    bash ./scripts/check-fullproof-global-derived.sh
    bash ./scripts/check-fullproof-final-audit.sh
    bash ./scripts/check-fullproof-final-no-witness-family.sh
    bash ./scripts/report-fullproof-final-cone.sh

# Decisive contradiction-spine final gate
check-decisive-spine-proof-gate:
    LEAN_NUM_THREADS={{lean_threads}} lake build Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineClayEquivalence
    just check-fullproof-clay-proof-gate
    bash ./scripts/check-decisive-spine-frozen-setting-imports.sh
    bash ./scripts/check-decisive-spine-threshold-definition-first.sh
    bash ./scripts/check-decisive-spine-profile-derived.sh
    bash ./scripts/check-decisive-spine-minimal-element-derived.sh
    bash ./scripts/check-decisive-spine-local-energy-derived.sh
    bash ./scripts/check-decisive-spine-lower-upper-derived.sh
    bash ./scripts/check-decisive-spine-incompatibility.sh
    bash ./scripts/check-decisive-spine-no-route-carriers.sh
    bash ./scripts/check-decisive-spine-global-derived.sh
    bash ./scripts/check-decisive-spine-clay-equivalence.sh
    bash ./scripts/report-decisive-spine-final-cone.sh

# Clean build artifacts
clean:
    rm -rf .lake docs/book

# Update dependencies
update:
    lake update

# Generate docs/SUMMARY.md from Markdown files in docs/ and subfolders
summary:
    #!/usr/bin/env bash
    set -euo pipefail

    docs="docs"
    build_dir="$docs/book"
    out="$docs/SUMMARY.md"

    echo "# Summary" > "$out"
    echo "" >> "$out"

    # Find all .md files under docs/, excluding SUMMARY.md itself and the build output
    while IFS= read -r f; do
        rel="${f#$docs/}"

        # Skip SUMMARY.md
        [ "$rel" = "SUMMARY.md" ] && continue

        # Skip files under the build output directory
        case "$f" in "$build_dir"/*) continue ;; esac

        # Derive the title from the first H1; fallback to filename
        title="$(grep -m1 '^# ' "$f" | sed 's/^# *//')"
        if [ -z "$title" ]; then
            base="$(basename "${f%.*}")"
            title="$(printf '%s\n' "$base" \
                | tr '._-' '   ' \
                | awk '{for(i=1;i<=NF;i++){ $i=toupper(substr($i,1,1)) substr($i,2) }}1')"
        fi

        # Indent two spaces per directory depth
        depth="$(awk -F'/' '{print NF-1}' <<<"$rel")"
        indent="$(printf '%*s' $((depth*2)) '')"

        echo "${indent}- [$title](${rel})" >> "$out"
    done < <(find "$docs" -type f -name '*.md' -not -name 'SUMMARY.md' -not -path "$build_dir/*" | LC_ALL=C sort)

    echo "Wrote $out"

# Generate transient build assets (mermaid, mathjax theme override)
_gen-assets:
    #!/usr/bin/env bash
    set -euo pipefail
    mdbook-mermaid install . > /dev/null 2>&1 || true
    # Patch mermaid-init.js with null guards for mdbook 0.5.x theme buttons
    sed -i.bak 's/document\.getElementById(\(.*\))\.addEventListener/const el = document.getElementById(\1); if (el) el.addEventListener/' mermaid-init.js && rm -f mermaid-init.js.bak
    # Generate theme/index.hbs with MathJax v2 inline $ config injected before MathJax loads
    mkdir -p theme
    mdbook init --theme /tmp/mdbook-theme-gen <<< $'n\n' > /dev/null 2>&1
    sed 's|<script async src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>|<script>window.MathJax = { tex2jax: { inlineMath: [["$","$"],["\\\\(","\\\\)"]], displayMath: [["$$","$$"],["\\\\[","\\\\]"]], processEscapes: true } };</script>\n        <script async src="https://cdnjs.cloudflare.com/ajax/libs/mathjax/2.7.1/MathJax.js?config=TeX-AMS-MML_HTMLorMML"></script>|' /tmp/mdbook-theme-gen/theme/index.hbs > theme/index.hbs
    rm -rf /tmp/mdbook-theme-gen

# Clean transient build assets
_clean-assets:
    rm -f mermaid-init.js mermaid.min.js
    rm -rf theme

# Build the book after regenerating the summary
book: summary _gen-assets
    mdbook build && just _clean-assets

# Serve locally with live reload
serve: summary _gen-assets
    #!/usr/bin/env bash
    trap 'just _clean-assets' EXIT
    mdbook serve --open
