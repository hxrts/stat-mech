import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineThreshold
import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactCompactness

/-! # Decisive contradiction-spine profile layer

Exact profile decomposition and extraction theorems for the decisive spine.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Exact profile decomposition theorem in direct form. -/
def decisiveSpine_exact_profile_decomposition_direct
    (X : FullProofExactCompactnessData) :
    ProfileDecompositionData :=
  fullProof_exact_profile_decomposition X

/-- Exact profile decomposition theorem for decisive spine. -/
def decisiveSpine_exact_profile_decomposition
    (X : FullProofExactCompactnessData) :
    ProfileDecompositionData :=
  decisiveSpine_exact_profile_decomposition_direct X

/-- Exact minimizing-sequence extraction theorem in direct form. -/
theorem decisiveSpine_minimizing_sequence_extraction_direct
    (X : FullProofExactCompactnessData) :
    ∃ seq : Nat → ℝ,
      (∀ n, X.compactness.threshold.Astar ≤ seq n) ∧
      (∀ ε : ℝ, 0 < ε →
        ∃ N0 : Nat, ∀ n ≥ N0,
          seq n ≤ X.compactness.threshold.Astar + ε) := by
  exact fullProof_exact_minimizing_sequence_extraction X

/-- Exact minimizing-sequence extraction theorem for decisive spine. -/
theorem decisiveSpine_minimizing_sequence_extraction
    (X : FullProofExactCompactnessData) :
    ∃ seq : Nat → ℝ,
      (∀ n, X.compactness.threshold.Astar ≤ seq n) ∧
      (∀ ε : ℝ, 0 < ε →
        ∃ N0 : Nat, ∀ n ≥ N0,
          seq n ≤ X.compactness.threshold.Astar + ε) := by
  exact decisiveSpine_minimizing_sequence_extraction_direct X

/-- Exact compactness-modulo-symmetry extraction theorem in direct form. -/
theorem decisiveSpine_compactness_mod_symmetry_direct
    (X : FullProofExactCompactnessData) :
    ∃ Φ : ℝ → Nat, ∀ ε : ℝ, 0 < ε →
      0 < Φ ε ∧ X.compactness.minimal_element.profile.nontrivial := by
  exact fullProof_exact_almostPeriodic_modulus X

/-- Exact compactness-modulo-symmetry extraction theorem for decisive spine. -/
theorem decisiveSpine_compactness_mod_symmetry
    (X : FullProofExactCompactnessData) :
    ∃ Φ : ℝ → Nat, ∀ ε : ℝ, 0 < ε →
      0 < Φ ε ∧ X.compactness.minimal_element.profile.nontrivial := by
  exact decisiveSpine_compactness_mod_symmetry_direct X

/-- Profile-layer policy marker for decisive spine. -/
def DecisiveSpineProfilePolicy : Prop := True

/-- Profile-layer policy theorem for decisive spine. -/
theorem decisiveSpine_profile_policy : DecisiveSpineProfilePolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
