import Gibbs.ContinuumField.NavierStokes.Erasure.EnergyFlux

/-!
# Defect envelope

Envelope objects used to bound unresolved-scale defect contributions.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Defect-envelope specification for a chosen erasure/model pair. -/
structure DefectEnvelope (D : SpatialDomain3) where
  /-- Uniform budget for defect magnitude. -/
  budget : ℝ
  /-- Nonnegative budget. -/
  budget_nonneg : 0 ≤ budget
  /-- Time-indexed defect norm proxy. -/
  defectNorm : ℝ → ℝ
  /-- Envelope control condition. -/
  controlled : ∀ t, defectNorm t ≤ budget

/-- Predicate that an envelope is globally bounded in time by its budget. -/
def IsGloballyBoundedEnvelope {D : SpatialDomain3} (E : DefectEnvelope D) : Prop :=
  ∀ t, E.defectNorm t ≤ E.budget

/-- Every envelope witness satisfies global boundedness by definition. -/
theorem envelope_is_globally_bounded {D : SpatialDomain3} (E : DefectEnvelope D) :
    IsGloballyBoundedEnvelope E :=
  E.controlled

end Gibbs.ContinuumField.NavierStokes
