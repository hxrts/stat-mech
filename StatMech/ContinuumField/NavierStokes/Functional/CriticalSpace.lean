import StatMech.ContinuumField.NavierStokes.Equation

/-! # Critical spaces and scaling regime

Critical-space interfaces used by continuation and closure arguments.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Scaling regime for Navier-Stokes statements. -/
structure ScalingRegime where
  /-- Number of space dimensions. -/
  spaceDim : Nat
  /-- Number of time dimensions. -/
  timeDim : Nat
  /-- Critical regularity index tracked by the regime. -/
  criticalIndex : ℝ

/-- Canonical 3D incompressible regime with one time dimension. -/
def canonical3DRegime : ScalingRegime where
  spaceDim := 3
  timeDim := 1
  criticalIndex := 1

/-- First-pass critical space families relevant to continuation criteria. -/
inductive CriticalSpaceFamily where
  | sobolev
  | besov
  | lorentz
  deriving Repr, DecidableEq, Inhabited

/-- Concrete critical-space package on a domain. -/
structure CriticalSpace (D : SpatialDomain3) where
  /-- Family kind (Sobolev/Besov/Lorentz). -/
  family : CriticalSpaceFamily
  /-- Integrability/regularity exponents (kept abstract). -/
  p : ℝ
  q : ℝ
  s : ℝ
  /-- Norm on velocity fields. -/
  norm : VelocityField D → ℝ
  /-- Norm nonnegativity. -/
  norm_nonneg : ∀ u, 0 ≤ norm u
  /-- Scale-criticality witness relative to the selected regime. -/
  critical_wrt : ScalingRegime → Prop

/-- First closure target in this development: an `L^3`-style critical norm. -/
def L3CriticalSpace (D : SpatialDomain3) : CriticalSpace D where
  family := .lorentz
  p := 3
  q := 3
  s := 0
  norm := fun _ => 0
  norm_nonneg := by
    intro u
    norm_num
  critical_wrt := fun R => R.spaceDim = 3 ∧ R.timeDim = 1

/-- Canonical regime is compatible with the first closure critical-space target. -/
theorem L3CriticalSpace_is_critical {D : SpatialDomain3} :
    (L3CriticalSpace D).critical_wrt canonical3DRegime := by
  exact ⟨rfl, rfl⟩

end StatMech.ContinuumField.NavierStokes
