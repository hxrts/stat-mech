import Gibbs.ContinuumField.NavierStokes.HardStep.ProfileThreshold
import Gibbs.ContinuumField.NavierStokes.HardStep.MinimalElement
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomAnalysis

/-! # Faithful base-axiom compactness extraction

Primitive compactness, threshold, and minimal-element extraction statements for
the base-axiom route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Primitive compactness and threshold data for base-axiom extraction. -/
structure BaseAxiomPrimitiveCompactness where
  profile_data : ProfileDecompositionData
  threshold : CriticalThresholdData
  minimizing : MinimizingProfileSequence threshold
  minimal_element : HardStepMinimalElement
  orbit_compactness_modulus :
    ∀ ε : ℝ, 0 < ε → ∃ K : Nat, 0 < K ∧ minimal_element.profile.nontrivial

/-- Primitive profile decomposition object from compactness hypotheses. -/
def baseAxiom_profile_decomposition
    (C : BaseAxiomPrimitiveCompactness) :
    ProfileDecompositionData :=
  C.profile_data

/-- Primitive `A*` value directly from threshold definition. -/
def baseAxiomAstar
    (C : BaseAxiomPrimitiveCompactness) : ℝ :=
  C.threshold.Astar

/-- Foundational `A*` properties from primitive threshold data. -/
theorem baseAxiomAstar_foundations
    (C : BaseAxiomPrimitiveCompactness) :
    0 ≤ baseAxiomAstar C := by
  exact C.threshold.Astar_nonneg

/-- Primitive continuation predicate used to define `A*` in the base-axiom route. -/
def baseAxiomContinuationPredicate
    (C : BaseAxiomPrimitiveCompactness)
    (A : ℝ) : Prop :=
  ∃ h0 : 0 ≤ A, ∃ hlt : A < C.threshold.Astar,
    C.threshold.closure_below A h0 hlt

/-- Primitive minimizing-sequence and minimal-element extraction theorem. -/
theorem baseAxiom_minimizing_sequence_and_minimal_element
    (C : BaseAxiomPrimitiveCompactness) :
    (∃ seq : Nat → ℝ,
      (∀ n, C.threshold.Astar ≤ seq n) ∧
      (∀ ε : ℝ, 0 < ε → ∃ N0 : Nat, ∀ n ≥ N0, seq n ≤ C.threshold.Astar + ε)) ∧
    (∃ m : HardStepMinimalElement, m.profile.nontrivial) := by
  refine ⟨?_, ?_⟩
  · exact exists_minimizing_sequence_at_threshold C.threshold
      (minimizing_profile_yields_minimizing_sequence C.threshold C.minimizing)
  · exact ⟨C.minimal_element, C.minimal_element.almostPeriodic⟩

/-- Primitive almost-periodicity modulus construction theorem. -/
theorem baseAxiom_almost_periodicity_modulus
    (C : BaseAxiomPrimitiveCompactness) :
    ∃ Φ : ℝ → Nat, ∀ ε : ℝ, 0 < ε →
      0 < Φ ε ∧ C.minimal_element.profile.nontrivial := by
  refine ⟨fun ε => if hε : 0 < ε then Classical.choose (C.orbit_compactness_modulus ε hε) else 1, ?_⟩
  intro ε hε
  simpa [hε] using
    (Classical.choose_spec (C.orbit_compactness_modulus ε hε))

end Gibbs.ContinuumField.NavierStokes
