import StatMech.ContinuumField.NavierStokes.Global.NoBlowup

/-! # Certified finite-dimensional approximations

Interfaces for Galerkin/spectral approximations with explicit error envelopes.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Approximation method family used in certified finite-dimensional truncations. -/
inductive ApproximationMethod where
  | galerkin
  | spectral
  deriving Repr, DecidableEq, Inhabited

/-- Certified finite-dimensional approximation package. -/
structure CertifiedApproximation {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D) where
  /-- Approximation method. -/
  method : ApproximationMethod
  /-- Finite dimension parameter. -/
  dimension : Nat
  /-- Approximate velocity trajectory. -/
  approxVel : VelocityTrajectory D
  /-- Approximate pressure trajectory. -/
  approxPress : PressureTrajectory D
  /-- Explicit error envelope bound. -/
  errorEnvelope : ℝ → ℝ
  /-- Nonnegative envelope. -/
  error_nonneg : ∀ t, 0 ≤ errorEnvelope t
  /-- Certified pointwise error bound (interface-level). -/
  error_bound : Prop

/-- Runtime-accessible error-budget value at time `t`. -/
def certifiedErrorAt {D : SpatialDomain3}
    {NS : IncompressibleNavierStokes D}
    (A : CertifiedApproximation NS) (t : ℝ) : ℝ :=
  A.errorEnvelope t

/-- Certified approximation always provides a nonnegative error budget. -/
theorem certified_error_nonneg {D : SpatialDomain3}
    {NS : IncompressibleNavierStokes D}
    (A : CertifiedApproximation NS) (t : ℝ) :
    0 ≤ certifiedErrorAt A t :=
  A.error_nonneg t

end StatMech.ContinuumField.NavierStokes
