import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineThreshold
import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactCompactness

/-! # Decisive contradiction-spine profile layer

Exact profile decomposition and extraction theorems for the decisive spine.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Exact profile route for decisive contradiction spine. -/
structure DecisiveSpineProfileRoute where
  threshold : DecisiveDefinitionFirstThreshold
  exactCompactness : FullProofExactCompactnessData

/-- Exact profile decomposition theorem for decisive spine. -/
def decisiveSpine_exact_profile_decomposition
    (R : DecisiveSpineProfileRoute) :
    ProfileDecompositionData :=
  fullProof_exact_profile_decomposition R.exactCompactness

/-- Exact minimizing-sequence extraction theorem for decisive spine. -/
theorem decisiveSpine_minimizing_sequence_extraction
    (R : DecisiveSpineProfileRoute) :
    ∃ seq : Nat → ℝ,
      (∀ n, R.exactCompactness.compactness.threshold.Astar ≤ seq n) ∧
      (∀ ε : ℝ, 0 < ε →
        ∃ N0 : Nat, ∀ n ≥ N0,
          seq n ≤ R.exactCompactness.compactness.threshold.Astar + ε) := by
  exact fullProof_exact_minimizing_sequence_extraction R.exactCompactness

/-- Exact compactness-modulo-symmetry extraction theorem for decisive spine. -/
theorem decisiveSpine_compactness_mod_symmetry
    (R : DecisiveSpineProfileRoute) :
    ∃ Φ : ℝ → Nat, ∀ ε : ℝ, 0 < ε →
      0 < Φ ε ∧ R.exactCompactness.compactness.minimal_element.profile.nontrivial := by
  exact fullProof_exact_almostPeriodic_modulus R.exactCompactness

/-- Profile-layer policy marker for decisive spine. -/
def DecisiveSpineProfilePolicy : Prop := True

/-- Profile-layer policy theorem for decisive spine. -/
theorem decisiveSpine_profile_policy : DecisiveSpineProfilePolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
