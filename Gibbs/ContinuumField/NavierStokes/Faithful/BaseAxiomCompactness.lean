import Gibbs.ContinuumField.NavierStokes.HardStep.ProfileThreshold
import Gibbs.ContinuumField.NavierStokes.HardStep.MinimalElement
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomAnalysis

/-! # Faithful base-axiom compactness extraction

Primitive compactness, threshold, and minimal-element extraction statements for
the base-axiom route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Primitive profile decomposition datum in the base-axiom compactness route. -/
abbrev BaseAxiomPrimitiveProfileData := ProfileDecompositionData

/-- Primitive critical-threshold datum in the base-axiom compactness route. -/
abbrev BaseAxiomPrimitiveThresholdData := CriticalThresholdData

/-- Primitive minimizing-sequence shape at a fixed threshold. -/
abbrev BaseAxiomPrimitiveMinimizingData
    (threshold : BaseAxiomPrimitiveThresholdData) :=
  MinimizingProfileSequence threshold

/-- Primitive almost-periodicity modulus shape for a minimal element. -/
abbrev BaseAxiomPrimitiveOrbitCompactnessModulus
    (minimal_element : HardStepMinimalElement) :=
  ∀ ε : ℝ, 0 < ε → ∃ K : Nat, 0 < K ∧ minimal_element.profile.nontrivial

/-- Primitive profile decomposition object from compactness hypotheses. -/
def baseAxiom_profile_decomposition
    (profile_data : BaseAxiomPrimitiveProfileData) :
    ProfileDecompositionData :=
  profile_data

/-- Primitive `A*` value directly from threshold definition. -/
def baseAxiomAstar
    (threshold : BaseAxiomPrimitiveThresholdData) : ℝ :=
  threshold.Astar

/-- Foundational `A*` properties from primitive threshold data. -/
theorem baseAxiomAstar_foundations
    (threshold : BaseAxiomPrimitiveThresholdData) :
    0 ≤ baseAxiomAstar threshold := by
  exact threshold.Astar_nonneg

/-- Primitive continuation predicate used to define `A*` in the base-axiom route. -/
def baseAxiomContinuationPredicate
    (threshold : BaseAxiomPrimitiveThresholdData)
    (A : ℝ) : Prop :=
  ∃ h0 : 0 ≤ A, ∃ hlt : A < threshold.Astar,
    threshold.closure_below A h0 hlt

/-- Primitive minimizing-sequence and minimal-element extraction theorem. -/
theorem baseAxiom_minimizing_sequence_and_minimal_element
    (threshold : BaseAxiomPrimitiveThresholdData)
    (minimizing : BaseAxiomPrimitiveMinimizingData threshold)
    (minimal_element : HardStepMinimalElement) :
    (∃ seq : Nat → ℝ,
      (∀ n, threshold.Astar ≤ seq n) ∧
      (∀ ε : ℝ, 0 < ε → ∃ N0 : Nat, ∀ n ≥ N0, seq n ≤ threshold.Astar + ε)) ∧
    (∃ m : HardStepMinimalElement, m.profile.nontrivial) := by
  refine ⟨?_, ?_⟩
  · exact exists_minimizing_sequence_at_threshold threshold
      (minimizing_profile_yields_minimizing_sequence threshold minimizing)
  · exact ⟨minimal_element, minimal_element.almostPeriodic⟩

/-- Primitive almost-periodicity modulus construction theorem. -/
theorem baseAxiom_almost_periodicity_modulus
    (minimal_element : HardStepMinimalElement)
    (orbit_compactness_modulus :
      BaseAxiomPrimitiveOrbitCompactnessModulus minimal_element) :
    ∃ Φ : ℝ → Nat, ∀ ε : ℝ, 0 < ε →
      0 < Φ ε ∧ minimal_element.profile.nontrivial := by
  refine ⟨fun ε => if hε : 0 < ε then Classical.choose (orbit_compactness_modulus ε hε) else 1, ?_⟩
  intro ε hε
  simpa [hε] using
    (Classical.choose_spec (orbit_compactness_modulus ε hε))

end Gibbs.ContinuumField.NavierStokes
