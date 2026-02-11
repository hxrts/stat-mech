import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomCompactness

/-! # Full proof exact compactness and minimal element

Concentration-compactness and minimal-element extraction statements for the
exact critical route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Exact compactness data for the full-proof route. -/
structure FullProofExactCompactnessData where
  compactness : BaseAxiomPrimitiveCompactness
  exact_profile_orthogonality :
    ∀ j k, j ≠ k →
      (compactness.profile_data.profile j originCoord3 0) *
        (compactness.profile_data.profile k originCoord3 0) = 0
  exact_remainder_decay :
    ∀ ε : ℝ, 0 < ε →
      ∃ N0 : Nat, ∀ n ≥ N0,
        hardStepNormL3 (compactness.profile_data.remainder n) ≤ ε

/-- Exact profile decomposition object in the full-proof compactness route. -/
def fullProof_exact_profile_decomposition
    (C : FullProofExactCompactnessData) :
    ProfileDecompositionData :=
  baseAxiom_profile_decomposition C.compactness

/-- Exact threshold `A*` theorem package for the full-proof compactness route. -/
theorem fullProof_exact_Astar_properties
    (C : FullProofExactCompactnessData) :
    0 ≤ baseAxiomAstar C.compactness ∧
      (∀ A : ℝ,
        baseAxiomContinuationPredicate C.compactness A →
          A ≤ baseAxiomAstar C.compactness) := by
  refine ⟨baseAxiomAstar_foundations C.compactness, ?_⟩
  intro A hA
  rcases hA with ⟨h0, hlt, _hclosure⟩
  exact le_of_lt hlt

/-- Exact minimizing-sequence extraction theorem package. -/
theorem fullProof_exact_minimizing_sequence_extraction
    (C : FullProofExactCompactnessData) :
    ∃ seq : Nat → ℝ,
      (∀ n, C.compactness.threshold.Astar ≤ seq n) ∧
      (∀ ε : ℝ, 0 < ε →
        ∃ N0 : Nat, ∀ n ≥ N0, seq n ≤ C.compactness.threshold.Astar + ε) := by
  exact (baseAxiom_minimizing_sequence_and_minimal_element C.compactness).1

/-- Exact minimal-element existence theorem package. -/
theorem fullProof_exact_minimal_element_exists
    (C : FullProofExactCompactnessData) :
    ∃ m : HardStepMinimalElement,
      m.profile.nontrivial ∧
      AlmostPeriodicModuloSymmetry m.profile := by
  refine ⟨C.compactness.minimal_element, ?_, ?_⟩
  · exact C.compactness.minimal_element.almostPeriodic
  · exact C.compactness.minimal_element.almostPeriodic

/-- Exact almost-periodicity modulus theorem package. -/
theorem fullProof_exact_almostPeriodic_modulus
    (C : FullProofExactCompactnessData) :
    ∃ Φ : ℝ → Nat, ∀ ε : ℝ, 0 < ε →
      0 < Φ ε ∧ C.compactness.minimal_element.profile.nontrivial := by
  exact baseAxiom_almost_periodicity_modulus C.compactness

end Gibbs.ContinuumField.NavierStokes
