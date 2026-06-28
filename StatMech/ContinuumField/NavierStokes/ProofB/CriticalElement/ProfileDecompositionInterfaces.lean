import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.ThresholdData
import StatMech.ContinuumField.NavierStokes.ProofB.Legacy.Exact.Compactness

/-! # Decisive contradiction-spine profile layer

Exact profile decomposition and extraction theorems for the decisive spine.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Exact profile decomposition theorem for decisive spine. -/
def decisiveSpine_exact_profile_decomposition
    (profile_data : DecisiveProfileData) :
    ProfileDecompositionData :=
  fullProof_exact_profile_decomposition profile_data.toBase

/-- Exact minimizing-sequence extraction theorem for decisive spine. -/
theorem decisiveSpine_minimizing_sequence_extraction
    (threshold : DecisiveThresholdData)
    (minimizing : DecisiveMinimizingData threshold)
    (minimal_element : HardStepMinimalElement) :
    ∃ seq : Nat → ℝ,
      (∀ n, threshold.Astar ≤ seq n) ∧
      (∀ ε : ℝ, 0 < ε →
        ∃ N0 : Nat, ∀ n ≥ N0,
          seq n ≤ threshold.Astar + ε) := by
  exact fullProof_exact_minimizing_sequence_extraction
    threshold.toBase minimizing.toBase minimal_element

/-- Exact compactness-modulo-symmetry extraction theorem for decisive spine. -/
theorem decisiveSpine_compactness_mod_symmetry
    (minimal_element : HardStepMinimalElement)
    (orbit_compactness_modulus :
      DecisiveOrbitCompactnessModulus minimal_element) :
    ∃ Φ : ℝ → Nat, ∀ ε : ℝ, 0 < ε →
      0 < Φ ε ∧ minimal_element.profile.nontrivial := by
  exact fullProof_exact_almostPeriodic_modulus
    minimal_element orbit_compactness_modulus.toBase

/-- Profile-layer policy marker for decisive spine. -/
def DecisiveSpineProfilePolicy : Prop :=
  ∀ profile_data : DecisiveProfileData,
    decisiveSpine_exact_profile_decomposition profile_data =
      fullProof_exact_profile_decomposition profile_data.toBase

/-- Profile-layer policy theorem for decisive spine. -/
theorem decisiveSpine_profile_policy : DecisiveSpineProfilePolicy := by
  intro profile_data
  rfl

end StatMech.ContinuumField.NavierStokes
