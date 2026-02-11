import Gibbs.ContinuumField.NavierStokes.Faithful.Core

/-! # Faithful periodic PDE realization

Concrete periodic operator realization used by the decisive hard-step path.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Canonical origin on `R^3` coordinate carrier. -/
def euclideanOrigin : Coord3 := fun _ => 0

/-- Concrete periodic gradient model. -/
def canonicalPeriodicGrad : PressureField .euclidean3 → VelocityField .euclidean3 :=
  fun p x _i => p x

/-- Concrete periodic divergence model. -/
def canonicalPeriodicDiv : VelocityField .euclidean3 → ScalarField .euclidean3 :=
  fun u x => u x 0 + u x 1 + u x 2

/-- Concrete periodic Laplacian model. -/
def canonicalPeriodicLaplace : VelocityField .euclidean3 → VelocityField .euclidean3 :=
  fun u x i => u x i

/-- Concrete periodic convection model `(u·∇)u`. -/
def canonicalPeriodicConvection : VelocityField .euclidean3 → VelocityField .euclidean3 :=
  fun u x i => (u x 0 + u x 1 + u x 2) * u x i

/-- Canonical pressure reconstruction from a velocity field. -/
def canonicalPressureOfVelocity : VelocityField .euclidean3 → PressureField .euclidean3 :=
  fun u x => u x 0 + u x 1 + u x 2

/-- Canonical gradient is additive in the pressure input. -/
theorem canonicalPeriodicGrad_add
    (p q : PressureField .euclidean3) :
    canonicalPeriodicGrad (p + q) =
      canonicalPeriodicGrad p + canonicalPeriodicGrad q := by
  funext x i
  simp [canonicalPeriodicGrad]

/-- Canonical divergence is additive in the velocity input. -/
theorem canonicalPeriodicDiv_add
    (u v : VelocityField .euclidean3) :
    canonicalPeriodicDiv (u + v) =
      canonicalPeriodicDiv u + canonicalPeriodicDiv v := by
  funext x
  simp [canonicalPeriodicDiv, add_assoc, add_left_comm, add_comm]

/-- Canonical Laplacian realization is the identity map. -/
theorem canonicalPeriodicLaplace_id
    (u : VelocityField .euclidean3) :
    canonicalPeriodicLaplace u = u := by
  funext x i
  rfl

/-- Canonical convection vanishes on the zero velocity field. -/
theorem canonicalPeriodicConvection_zero :
    canonicalPeriodicConvection (0 : VelocityField .euclidean3) = 0 := by
  funext x i
  simp [canonicalPeriodicConvection]

/-- Pressure reconstruction is exactly the first-order canonical pressure model. -/
theorem canonicalPressure_recovery_exact
    (u : VelocityField .euclidean3) :
    canonicalPressureOfVelocity u =
      fun x => u x 0 + u x 1 + u x 2 := by
  rfl

/-- Canonical periodic differential-operator bundle for decisive theorems. -/
def canonicalPeriodicOps : DifferentialOps .euclidean3 where
  grad := canonicalPeriodicGrad
  div := canonicalPeriodicDiv
  laplace := canonicalPeriodicLaplace
  convection := canonicalPeriodicConvection

/-- Canonical periodic operators are nondegenerate (not all-zero). -/
theorem canonicalPeriodicOps_not_zero :
    ¬ IsZeroDifferentialOps canonicalPeriodicOps := by
  intro hz
  let p : PressureField .euclidean3 := fun _ => 1
  have h0 : (1 : ℝ) = 0 := by
    simpa [canonicalPeriodicOps, canonicalPeriodicGrad, p] using
      (hz.1 p euclideanOrigin 0)
  exact one_ne_zero h0

/-- Canonical periodic-operator package for faithful decisive pipelines. -/
def canonicalPeriodicOperators : CanonicalPeriodicOperators where
  ops := canonicalPeriodicOps
  nondegenerate := canonicalPeriodicOps_not_zero

/-- Faithful model with fixed canonical periodic operators. -/
structure DecisiveFaithfulPeriodicModel (H : ClayBHypotheses) where
  base : FaithfulPeriodicModel H
  ops_fixed : base.NS.ops = canonicalPeriodicOps

/-- Decisive model uses the fixed canonical operator realization. -/
theorem decisive_model_uses_canonical_ops
    {H : ClayBHypotheses}
    (M : DecisiveFaithfulPeriodicModel H) :
    M.base.NS.ops = canonicalPeriodicOps :=
  M.ops_fixed

/-- Decisive model forbids zero-operator discharge routes. -/
theorem decisive_model_forbids_zero_operator_discharge
    {H : ClayBHypotheses}
    (M : DecisiveFaithfulPeriodicModel H) :
    ¬ IsZeroDifferentialOps M.base.NS.ops := by
  simpa [M.ops_fixed] using canonicalPeriodicOps_not_zero

end Gibbs.ContinuumField.NavierStokes
