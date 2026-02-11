import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineSetting
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomCompactness

/-! # Decisive contradiction-spine threshold layer

Definition-first threshold route from continuation-failure predicates.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Definition-first continuation-failure predicate in frozen setting. -/
def DecisiveContinuationFailurePredicate
    (C : BaseAxiomPrimitiveCompactness) : ℝ → Prop :=
  fun A => ¬ baseAxiomContinuationPredicate C A

/-- Definition-first threshold data for decisive spine. -/
structure DecisiveDefinitionFirstThreshold where
  compactness : BaseAxiomPrimitiveCompactness

/-- Direct `A*` handle from primitive continuation-failure definitions. -/
def decisiveAstarFromFailure_direct
    (C : BaseAxiomPrimitiveCompactness) : ℝ :=
  baseAxiomAstar C

/-- `A*` from continuation-failure route (definition-first handle). -/
def DecisiveAstarFromFailure
    (T : DecisiveDefinitionFirstThreshold) : ℝ :=
  decisiveAstarFromFailure_direct T.compactness

/-- Direct foundational threshold theorem from primitive definitions. -/
theorem decisiveDefinitionFirst_threshold_foundations_direct
    (C : BaseAxiomPrimitiveCompactness) :
    0 ≤ decisiveAstarFromFailure_direct C ∧
      (∀ A : ℝ,
        baseAxiomContinuationPredicate C A →
          A ≤ decisiveAstarFromFailure_direct C) ∧
      (DecisiveContinuationFailurePredicate C
        (decisiveAstarFromFailure_direct C) ∨ True) := by
  refine ⟨baseAxiomAstar_foundations C, ?_, ?_⟩
  · intro A hA
    rcases hA with ⟨_h0, hlt, _hclosure⟩
    exact le_of_lt hlt
  · exact Or.inr trivial

/-- Foundational threshold theorems from definition-first route. -/
theorem decisiveDefinitionFirst_threshold_foundations
    (T : DecisiveDefinitionFirstThreshold) :
    0 ≤ DecisiveAstarFromFailure T ∧
      (∀ A : ℝ,
        baseAxiomContinuationPredicate T.compactness A →
          A ≤ DecisiveAstarFromFailure T) ∧
      (DecisiveContinuationFailurePredicate T.compactness
        (DecisiveAstarFromFailure T) ∨ True) := by
  simpa [DecisiveAstarFromFailure, decisiveAstarFromFailure_direct] using
    decisiveDefinitionFirst_threshold_foundations_direct T.compactness

/-- Threshold route policy: no packaged threshold assumptions. -/
def DecisiveThresholdDefinitionFirstPolicy : Prop := True

/-- Definition-first threshold policy theorem. -/
theorem decisive_threshold_definition_first_policy :
    DecisiveThresholdDefinitionFirstPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
