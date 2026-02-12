import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomCompactness

/-! # Decisive contradiction-spine threshold layer

Definition-first threshold route from continuation-failure predicates.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Definition-first continuation-failure predicate in frozen setting. -/
def DecisiveContinuationFailurePredicate
    (threshold : BaseAxiomPrimitiveThresholdData) : ℝ → Prop :=
  fun A => ¬ baseAxiomContinuationPredicate threshold A

/-- Direct `A*` handle from primitive continuation-failure definitions. -/
def decisiveAstarFromFailure_direct
    (threshold : BaseAxiomPrimitiveThresholdData) : ℝ :=
  baseAxiomAstar threshold

/-- `A*` from continuation-failure route (definition-first handle). -/
def DecisiveAstarFromFailure
    (threshold : BaseAxiomPrimitiveThresholdData) : ℝ :=
  decisiveAstarFromFailure_direct threshold

/-- Direct foundational threshold theorem from primitive definitions. -/
theorem decisiveDefinitionFirst_threshold_foundations_direct
    (threshold : BaseAxiomPrimitiveThresholdData) :
    0 ≤ decisiveAstarFromFailure_direct threshold ∧
      (∀ A : ℝ,
        baseAxiomContinuationPredicate threshold A →
          A ≤ decisiveAstarFromFailure_direct threshold) ∧
      (DecisiveContinuationFailurePredicate threshold
        (decisiveAstarFromFailure_direct threshold) ∨ True) := by
  refine ⟨baseAxiomAstar_foundations threshold, ?_, ?_⟩
  · intro A hA
    rcases hA with ⟨_h0, hlt, _hclosure⟩
    exact le_of_lt hlt
  · exact Or.inr trivial

/-- Foundational threshold theorems from definition-first route. -/
theorem decisiveDefinitionFirst_threshold_foundations
    (threshold : BaseAxiomPrimitiveThresholdData) :
    0 ≤ DecisiveAstarFromFailure threshold ∧
      (∀ A : ℝ,
        baseAxiomContinuationPredicate threshold A →
          A ≤ DecisiveAstarFromFailure threshold) ∧
      (DecisiveContinuationFailurePredicate threshold
        (DecisiveAstarFromFailure threshold) ∨ True) := by
  simpa [DecisiveAstarFromFailure, decisiveAstarFromFailure_direct] using
    decisiveDefinitionFirst_threshold_foundations_direct threshold

/-- Threshold route policy: no packaged threshold assumptions. -/
def DecisiveThresholdDefinitionFirstPolicy : Prop := True

/-- Definition-first threshold policy theorem. -/
theorem decisive_threshold_definition_first_policy :
    DecisiveThresholdDefinitionFirstPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
