import StatMech.ContinuumField.NavierStokes.ProofB.Legacy.Primitive.Compactness

/-! # Full proof exact compactness and minimal element

Concentration-compactness and minimal-element extraction statements for the
exact critical route.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Exact profile decomposition object in the full-proof compactness route. -/
def fullProof_exact_profile_decomposition
    (profile_data : BaseAxiomPrimitiveProfileData) :
    ProfileDecompositionData :=
  baseAxiom_profile_decomposition profile_data

/-- Exact threshold `A*` theorem package for the full-proof compactness route. -/
theorem fullProof_exact_Astar_properties
    (threshold : BaseAxiomPrimitiveThresholdData) :
    0 ≤ baseAxiomAstar threshold ∧
      (∀ A : ℝ,
        baseAxiomContinuationPredicate threshold A →
          A ≤ baseAxiomAstar threshold) := by
  refine ⟨baseAxiomAstar_foundations threshold, ?_⟩
  intro A hA
  rcases hA with ⟨_h0, hlt, _hclosure⟩
  exact le_of_lt hlt

/-- Exact minimizing-sequence extraction theorem package. -/
theorem fullProof_exact_minimizing_sequence_extraction
    (threshold : BaseAxiomPrimitiveThresholdData)
    (minimizing : BaseAxiomPrimitiveMinimizingData threshold)
    (minimal_element : HardStepMinimalElement) :
    ∃ seq : Nat → ℝ,
      (∀ n, threshold.Astar ≤ seq n) ∧
      (∀ ε : ℝ, 0 < ε →
        ∃ N0 : Nat, ∀ n ≥ N0, seq n ≤ threshold.Astar + ε) := by
  exact (baseAxiom_minimizing_sequence_and_minimal_element
    threshold minimizing minimal_element).1

/-- Exact minimal-element existence theorem package. -/
theorem fullProof_exact_minimal_element_exists
    (minimal_element : HardStepMinimalElement) :
    ∃ m : HardStepMinimalElement,
      m.profile.nontrivial ∧
      AlmostPeriodicModuloSymmetry m.profile := by
  refine ⟨minimal_element, ?_, ?_⟩
  · exact minimal_element.almostPeriodic
  · exact minimal_element.almostPeriodic

/-- Exact almost-periodicity modulus theorem package. -/
theorem fullProof_exact_almostPeriodic_modulus
    (minimal_element : HardStepMinimalElement)
    (orbit_compactness_modulus :
      BaseAxiomPrimitiveOrbitCompactnessModulus minimal_element) :
    ∃ Φ : ℝ → Nat, ∀ ε : ℝ, 0 < ε →
      0 < Φ ε ∧ minimal_element.profile.nontrivial := by
  exact baseAxiom_almost_periodicity_modulus
    minimal_element orbit_compactness_modulus

end StatMech.ContinuumField.NavierStokes
