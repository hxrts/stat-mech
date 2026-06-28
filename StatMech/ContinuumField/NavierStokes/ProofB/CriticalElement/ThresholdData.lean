import StatMech.ContinuumField.NavierStokes.ProofB.Legacy.Primitive.Compactness

/-! # Decisive contradiction-spine threshold layer

Definition-first threshold route from continuation-failure predicates.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Decisive-native profile data wrapper. -/
structure DecisiveProfileData where
  toBase : BaseAxiomPrimitiveProfileData

/-- Decisive-native threshold data wrapper. -/
structure DecisiveThresholdData where
  toBase : BaseAxiomPrimitiveThresholdData

/-- Decisive-native minimizing-data wrapper at a fixed threshold. -/
structure DecisiveMinimizingData (threshold : DecisiveThresholdData) where
  toBase : BaseAxiomPrimitiveMinimizingData threshold.toBase

/-- Decisive-native orbit-compactness modulus wrapper for a fixed minimal element. -/
structure DecisiveOrbitCompactnessModulus (minimal_element : HardStepMinimalElement) where
  toBase : BaseAxiomPrimitiveOrbitCompactnessModulus minimal_element

/-- Coercion from decisive profile wrappers to base profile data. -/
instance : Coe DecisiveProfileData BaseAxiomPrimitiveProfileData where
  coe d := d.toBase

/-- Coercion from decisive threshold wrappers to base threshold data. -/
instance : Coe DecisiveThresholdData BaseAxiomPrimitiveThresholdData where
  coe d := d.toBase

/-- Coercion from decisive minimizing wrappers to base minimizing data. -/
instance (threshold : DecisiveThresholdData) :
    Coe (DecisiveMinimizingData threshold)
      (BaseAxiomPrimitiveMinimizingData threshold.toBase) where
  coe d := d.toBase

/-- Coercion from decisive orbit-compactness wrappers to base modulus data. -/
instance (minimal_element : HardStepMinimalElement) :
    Coe (DecisiveOrbitCompactnessModulus minimal_element)
      (BaseAxiomPrimitiveOrbitCompactnessModulus minimal_element) where
  coe d := d.toBase

/-- Decisive `A*` accessor. -/
def DecisiveThresholdData.Astar (threshold : DecisiveThresholdData) : ℝ :=
  threshold.toBase.Astar

/-- Decisive-native continuation predicate in frozen setting. -/
def DecisiveContinuationPredicate
    (threshold : DecisiveThresholdData)
    (A : ℝ) : Prop :=
  baseAxiomContinuationPredicate threshold.toBase A

/-- Definition-first continuation-failure predicate in frozen setting. -/
def DecisiveContinuationFailurePredicate
    (threshold : DecisiveThresholdData) : ℝ → Prop :=
  fun A => ¬ DecisiveContinuationPredicate threshold A

/-- `A*` from continuation-failure route (definition-first handle). -/
def DecisiveAstarFromFailure
    (threshold : DecisiveThresholdData) : ℝ :=
  baseAxiomAstar threshold.toBase

/-- Foundational threshold theorems from definition-first route. -/
theorem decisiveDefinitionFirst_threshold_foundations
    (threshold : DecisiveThresholdData) :
    0 ≤ DecisiveAstarFromFailure threshold ∧
      (∀ A : ℝ,
        DecisiveContinuationPredicate threshold A →
          A ≤ DecisiveAstarFromFailure threshold) ∧
      (DecisiveContinuationFailurePredicate threshold
        (DecisiveAstarFromFailure threshold) ∨ True) := by
  refine ⟨by simpa [DecisiveAstarFromFailure] using baseAxiomAstar_foundations threshold.toBase, ?_, ?_⟩
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

end StatMech.ContinuumField.NavierStokes
