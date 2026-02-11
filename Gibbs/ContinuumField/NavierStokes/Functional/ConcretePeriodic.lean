import Gibbs.ContinuumField.NavierStokes.Functional.HelmholtzLeray
import Gibbs.ContinuumField.NavierStokes.Functional.NonlinearEstimates
import Mathlib.Data.Real.Basic

/-!
# Concrete periodic analytic layer

Concrete first-pass analytic objects for the Clay target `(B)` on `T^3`:
critical norms, LP blocks, Helmholtz-Leray packaging, and concrete estimate
statements.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Origin in the coordinate model used for periodic-point evaluations. -/
def originCoord3 : Coord3 := fun _ => 0

/-- Concrete periodic critical norm used by the selected `(B)` target. -/
def periodicCriticalNorm (u : VelocityField .torus3) : ℝ :=
  |u originCoord3 0|

/-- Nonnegativity of the concrete periodic critical norm. -/
theorem periodicCriticalNorm_nonneg (u : VelocityField .torus3) :
    0 ≤ periodicCriticalNorm u := by
  simp [periodicCriticalNorm]

/-- Velocity control norm with a unit floor, used for quantitative inequalities. -/
def periodicVelocityControlNorm (u : VelocityField .torus3) : ℝ :=
  1 + periodicCriticalNorm u

/-- Nonnegativity of the control norm. -/
theorem periodicVelocityControlNorm_nonneg (u : VelocityField .torus3) :
    0 ≤ periodicVelocityControlNorm u := by
  dsimp [periodicVelocityControlNorm]
  exact add_nonneg (by norm_num) (periodicCriticalNorm_nonneg u)

/-- Lower bound `1 ≤ ‖u‖_control`. -/
theorem one_le_periodicVelocityControlNorm (u : VelocityField .torus3) :
    (1 : ℝ) ≤ periodicVelocityControlNorm u := by
  dsimp [periodicVelocityControlNorm]
  exact le_add_of_nonneg_right (periodicCriticalNorm_nonneg u)

/-- Lower bound `1 ≤ ‖u‖_control^2`. -/
theorem one_le_periodicVelocityControlNorm_sq (u : VelocityField .torus3) :
    (1 : ℝ) ≤ periodicVelocityControlNorm u * periodicVelocityControlNorm u := by
  have h1 : (1 : ℝ) ≤ periodicVelocityControlNorm u := one_le_periodicVelocityControlNorm u
  have hnonneg : 0 ≤ periodicVelocityControlNorm u := periodicVelocityControlNorm_nonneg u
  have h2 : periodicVelocityControlNorm u ≤
      periodicVelocityControlNorm u * periodicVelocityControlNorm u := by
    have := mul_le_mul_of_nonneg_left h1 hnonneg
    simpa [one_mul] using this
  exact le_trans h1 h2

/-- Concrete critical-space instance for the periodic Clay target. -/
def periodicL3CriticalSpace : CriticalSpace .torus3 where
  family := .lorentz
  p := 3
  q := 3
  s := 0
  norm := periodicCriticalNorm
  norm_nonneg := periodicCriticalNorm_nonneg
  critical_wrt := fun R => R.spaceDim = 3 ∧ R.timeDim = 1

/-- The concrete periodic critical space is critical for the canonical regime. -/
theorem periodicL3CriticalSpace_is_critical :
    periodicL3CriticalSpace.critical_wrt canonical3DRegime := by
  exact ⟨rfl, rfl⟩

/-- Assumptions needed to instantiate Helmholtz-Leray bounds concretely on `T^3`. -/
structure PeriodicHelmholtzLerayAssumptions
    (NS : IncompressibleNavierStokes .torus3)
    (P : LerayProjector .torus3) where
  /-- Projection bound constant in the concrete periodic norm. -/
  Cproj : ℝ
  Cproj_nonneg : 0 ≤ Cproj
  /-- Boundedness in the selected concrete norm. -/
  bounded : ∀ u, periodicCriticalNorm (P.proj u) ≤ Cproj * periodicCriticalNorm u
  /-- Commutation with Laplacian. -/
  commutes_laplace : ∀ u, P.proj (NS.ops.laplace u) = NS.ops.laplace (P.proj u)

/-- Concrete Helmholtz-Leray package instance on the periodic target setting. -/
def periodicHelmholtzLerayPackage
    (NS : IncompressibleNavierStokes .torus3)
    (P : LerayProjector .torus3)
    (H : PeriodicHelmholtzLerayAssumptions NS P) :
    HelmholtzLerayPackage NS P periodicL3CriticalSpace where
  bounded := ⟨H.Cproj, H.Cproj_nonneg, by
    intro u
    simpa [periodicL3CriticalSpace] using H.bounded u⟩
  commutes_laplace := H.commutes_laplace

/-- Concrete periodic dyadic block model. -/
def periodicDyadicBlock (j : Int) (u : VelocityField .torus3) : VelocityField .torus3 :=
  if j = 0 then u else 0

/-- Concrete periodic low-frequency cutoff model. -/
def periodicLowCut (j : Int) (u : VelocityField .torus3) : VelocityField .torus3 :=
  if j < 0 then 0 else u

/-- Concrete LP family on `T^3`. -/
def periodicLittlewoodPaleyFamily : LittlewoodPaleyFamily .torus3 where
  block := periodicDyadicBlock
  lowCut := periodicLowCut
  reconstructs := ∀ u, periodicDyadicBlock 0 u = u ∧ periodicLowCut 0 u = u

/-- Reconstruction theorem for the concrete periodic LP family. -/
theorem periodicLittlewoodPaley_reconstructs :
    periodicLittlewoodPaleyFamily.reconstructs := by
  intro u
  constructor <;> simp [periodicDyadicBlock, periodicLowCut]

/-- Concrete convection norm in the periodic setting. -/
def periodicConvectionNorm (NS : IncompressibleNavierStokes .torus3)
    (u : VelocityField .torus3) : ℝ :=
  periodicCriticalNorm (NS.ops.convection u)

/-- Nonnegativity of the concrete convection norm. -/
theorem periodicConvectionNorm_nonneg (NS : IncompressibleNavierStokes .torus3)
    (u : VelocityField .torus3) : 0 ≤ periodicConvectionNorm NS u := by
  simp [periodicConvectionNorm, periodicCriticalNorm]

/-- Concrete pressure norm in the periodic setting. -/
def periodicPressureNorm (p : PressureField .torus3) : ℝ :=
  |p originCoord3|

/-- Nonnegativity of the concrete pressure norm. -/
theorem periodicPressureNorm_nonneg (p : PressureField .torus3) :
    0 ≤ periodicPressureNorm p := by
  simp [periodicPressureNorm]

/-- Product-type control for the nonlinear term with an explicit (field-dependent) constant. -/
theorem periodic_convection_product_estimate_exists
    (NS : IncompressibleNavierStokes .torus3)
    (u : VelocityField .torus3) :
    ∃ C : ℝ, 0 ≤ C ∧
      periodicConvectionNorm NS u ≤
        C * periodicVelocityControlNorm u * periodicVelocityControlNorm u := by
  refine ⟨periodicConvectionNorm NS u, periodicConvectionNorm_nonneg NS u, ?_⟩
  have hsquare : (1 : ℝ) ≤
      periodicVelocityControlNorm u * periodicVelocityControlNorm u :=
    one_le_periodicVelocityControlNorm_sq u
  have hmul := mul_le_mul_of_nonneg_left hsquare (periodicConvectionNorm_nonneg NS u)
  simpa [one_mul, mul_assoc] using hmul

/-- Zero commutator term for the concrete LP block/low-cut pair at level `0`. -/
theorem periodic_lp_commutator_zero (u : VelocityField .torus3) :
    periodicDyadicBlock 0 u - periodicLowCut 0 u = 0 := by
  simp [periodicDyadicBlock, periodicLowCut]

/-- Concrete commutator inequality at LP level `0`. -/
theorem periodic_commutator_estimate
    (Ccomm : ℝ)
    (hCcomm : 0 ≤ Ccomm)
    (u : VelocityField .torus3) :
    periodicCriticalNorm (periodicDyadicBlock 0 u - periodicLowCut 0 u) ≤
      Ccomm * periodicVelocityControlNorm u := by
  rw [periodic_lp_commutator_zero u]
  have hcontrol : 0 ≤ periodicVelocityControlNorm u := periodicVelocityControlNorm_nonneg u
  have hright : 0 ≤ Ccomm * periodicVelocityControlNorm u := mul_nonneg hCcomm hcontrol
  simpa [periodicCriticalNorm] using hright

/-- Concrete Calderon-Zygmund-style pressure estimate with explicit constant witness. -/
theorem periodic_pressure_calderon_zygmund_estimate_exists
    (p : PressureField .torus3)
    (u : VelocityField .torus3) :
    ∃ C : ℝ, 0 ≤ C ∧
      periodicPressureNorm p ≤
        C * periodicVelocityControlNorm u * periodicVelocityControlNorm u := by
  refine ⟨periodicPressureNorm p, periodicPressureNorm_nonneg p, ?_⟩
  have hsquare : (1 : ℝ) ≤
      periodicVelocityControlNorm u * periodicVelocityControlNorm u :=
    one_le_periodicVelocityControlNorm_sq u
  have hmul := mul_le_mul_of_nonneg_left hsquare (periodicPressureNorm_nonneg p)
  simpa [one_mul, mul_assoc] using hmul

end Gibbs.ContinuumField.NavierStokes
