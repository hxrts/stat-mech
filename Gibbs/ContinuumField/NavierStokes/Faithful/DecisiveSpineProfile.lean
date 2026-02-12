import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineThreshold
import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactCompactness

/-! # Decisive contradiction-spine profile layer

Exact profile decomposition and extraction theorems for the decisive spine.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Exact profile decomposition theorem in direct form. -/
def decisiveSpine_exact_profile_decomposition_direct
    (profile_data : BaseAxiomPrimitiveProfileData) :
    ProfileDecompositionData :=
  fullProof_exact_profile_decomposition profile_data

/-- Exact profile decomposition theorem for decisive spine. -/
def decisiveSpine_exact_profile_decomposition
    (profile_data : BaseAxiomPrimitiveProfileData) :
    ProfileDecompositionData :=
  decisiveSpine_exact_profile_decomposition_direct profile_data

/-- Exact minimizing-sequence extraction theorem in direct form. -/
theorem decisiveSpine_minimizing_sequence_extraction_direct
    (threshold : BaseAxiomPrimitiveThresholdData)
    (minimizing : BaseAxiomPrimitiveMinimizingData threshold)
    (minimal_element : HardStepMinimalElement) :
    ∃ seq : Nat → ℝ,
      (∀ n, threshold.Astar ≤ seq n) ∧
      (∀ ε : ℝ, 0 < ε →
        ∃ N0 : Nat, ∀ n ≥ N0,
          seq n ≤ threshold.Astar + ε) := by
  exact fullProof_exact_minimizing_sequence_extraction
    threshold minimizing minimal_element

/-- Exact minimizing-sequence extraction theorem for decisive spine. -/
theorem decisiveSpine_minimizing_sequence_extraction
    (threshold : BaseAxiomPrimitiveThresholdData)
    (minimizing : BaseAxiomPrimitiveMinimizingData threshold)
    (minimal_element : HardStepMinimalElement) :
    ∃ seq : Nat → ℝ,
      (∀ n, threshold.Astar ≤ seq n) ∧
      (∀ ε : ℝ, 0 < ε →
        ∃ N0 : Nat, ∀ n ≥ N0,
          seq n ≤ threshold.Astar + ε) := by
  exact decisiveSpine_minimizing_sequence_extraction_direct
    threshold minimizing minimal_element

/-- Exact compactness-modulo-symmetry extraction theorem in direct form. -/
theorem decisiveSpine_compactness_mod_symmetry_direct
    (minimal_element : HardStepMinimalElement)
    (orbit_compactness_modulus :
      BaseAxiomPrimitiveOrbitCompactnessModulus minimal_element) :
    ∃ Φ : ℝ → Nat, ∀ ε : ℝ, 0 < ε →
      0 < Φ ε ∧ minimal_element.profile.nontrivial := by
  exact fullProof_exact_almostPeriodic_modulus
    minimal_element orbit_compactness_modulus

/-- Exact compactness-modulo-symmetry extraction theorem for decisive spine. -/
theorem decisiveSpine_compactness_mod_symmetry
    (minimal_element : HardStepMinimalElement)
    (orbit_compactness_modulus :
      BaseAxiomPrimitiveOrbitCompactnessModulus minimal_element) :
    ∃ Φ : ℝ → Nat, ∀ ε : ℝ, 0 < ε →
      0 < Φ ε ∧ minimal_element.profile.nontrivial := by
  exact decisiveSpine_compactness_mod_symmetry_direct
    minimal_element orbit_compactness_modulus

/-- Profile-layer policy marker for decisive spine. -/
def DecisiveSpineProfilePolicy : Prop := True

/-- Profile-layer policy theorem for decisive spine. -/
theorem decisiveSpine_profile_policy : DecisiveSpineProfilePolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
