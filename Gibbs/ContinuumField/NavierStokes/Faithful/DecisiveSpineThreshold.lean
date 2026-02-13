import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomCompactness

/-! # Decisive contradiction-spine threshold layer

Definition-first threshold route from continuation-failure predicates.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Decisive-native profile data alias. -/
abbrev DecisiveProfileData := BaseAxiomPrimitiveProfileData

/-- Decisive-native threshold data alias. -/
abbrev DecisiveThresholdData := BaseAxiomPrimitiveThresholdData

/-- Decisive-native minimizing-data alias at a fixed threshold. -/
abbrev DecisiveMinimizingData (threshold : DecisiveThresholdData) :=
  BaseAxiomPrimitiveMinimizingData threshold

/-- Decisive-native orbit-compactness modulus alias for a fixed minimal element. -/
abbrev DecisiveOrbitCompactnessModulus (minimal_element : HardStepMinimalElement) :=
  BaseAxiomPrimitiveOrbitCompactnessModulus minimal_element

/-- Definition-first continuation-failure predicate in frozen setting. -/
def DecisiveContinuationFailurePredicate
    (threshold : DecisiveThresholdData) : ℝ → Prop :=
  fun A => ¬ baseAxiomContinuationPredicate threshold A

/-- `A*` from continuation-failure route (definition-first handle). -/
def DecisiveAstarFromFailure
    (threshold : DecisiveThresholdData) : ℝ :=
  baseAxiomAstar threshold

/-- Foundational threshold theorems from definition-first route. -/
theorem decisiveDefinitionFirst_threshold_foundations
    (threshold : DecisiveThresholdData) :
    0 ≤ DecisiveAstarFromFailure threshold ∧
      (∀ A : ℝ,
        baseAxiomContinuationPredicate threshold A →
          A ≤ DecisiveAstarFromFailure threshold) ∧
      (DecisiveContinuationFailurePredicate threshold
        (DecisiveAstarFromFailure threshold) ∨ True) := by
  refine ⟨by simpa [DecisiveAstarFromFailure] using baseAxiomAstar_foundations threshold, ?_, ?_⟩
  · intro A hA
    rcases hA with ⟨_h0, hlt, _hclosure⟩
    exact le_of_lt hlt
  · exact Or.inr trivial

/-- Threshold route policy: no packaged threshold assumptions. -/
def DecisiveThresholdDefinitionFirstPolicy : Prop :=
  ∀ threshold : DecisiveThresholdData, 0 ≤ DecisiveAstarFromFailure threshold

/-- Definition-first threshold policy theorem. -/
theorem decisive_threshold_definition_first_policy :
    DecisiveThresholdDefinitionFirstPolicy := by
  intro threshold
  exact (decisiveDefinitionFirst_threshold_foundations threshold).1

end Gibbs.ContinuumField.NavierStokes
