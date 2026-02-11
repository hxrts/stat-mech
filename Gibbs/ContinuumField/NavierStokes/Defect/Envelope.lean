import Gibbs.ContinuumField.NavierStokes.Erasure.EnergyFlux

/-!
# Defect envelope

Envelope objects used to bound unresolved-scale defect contributions.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- First-pass critical norm targets for continuation attempts. -/
inductive CriticalNormTarget where
  | L3
  | HHalf
  | BesovMinusOneInfinityInfinity
  deriving Repr, DecidableEq, Inhabited

/-- Critical norm package used by continuation statements. -/
structure CriticalNorm (D : SpatialDomain3) where
  /-- Chosen critical norm family. -/
  target : CriticalNormTarget
  /-- Numerical norm proxy on velocity fields. -/
  value : VelocityField D → ℝ
  /-- Nonnegativity of the norm. -/
  nonneg : ∀ u, 0 ≤ value u

/-- Defect-envelope specification for a chosen erasure/model pair. -/
structure DefectEnvelope (D : SpatialDomain3) where
  /-- Critical norm tracked in the program. -/
  criticalNorm : CriticalNorm D
  /-- Uniform budget for defect magnitude. -/
  defectBudget : ℝ
  /-- Uniform budget for critical norm. -/
  criticalBudget : ℝ
  /-- Nonnegative budgets. -/
  defectBudget_nonneg : 0 ≤ defectBudget
  criticalBudget_nonneg : 0 ≤ criticalBudget
  /-- Time-indexed defect norm proxy. -/
  defectNorm : ℝ → ℝ
  /-- Time-indexed resolved critical norm proxy. -/
  resolvedCriticalNorm : ℝ → ℝ
  /-- Envelope control conditions. -/
  defect_controlled : ∀ t, defectNorm t ≤ defectBudget
  critical_controlled : ∀ t, resolvedCriticalNorm t ≤ criticalBudget

/-- Predicate that an envelope is globally bounded by its budgets. -/
def IsGloballyBoundedEnvelope {D : SpatialDomain3} (E : DefectEnvelope D) : Prop :=
  (∀ t, E.defectNorm t ≤ E.defectBudget) ∧
  (∀ t, E.resolvedCriticalNorm t ≤ E.criticalBudget)

/-- Every envelope witness satisfies global boundedness by definition. -/
theorem envelope_is_globally_bounded {D : SpatialDomain3} (E : DefectEnvelope D) :
    IsGloballyBoundedEnvelope E := by
  exact ⟨E.defect_controlled, E.critical_controlled⟩

/-- Default first closure target for this program: `L^3`. -/
abbrev firstClosureTarget : CriticalNormTarget := .L3

end Gibbs.ContinuumField.NavierStokes
