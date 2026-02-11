import Gibbs.ContinuumField.NavierStokes.SolutionNotions
import Mathlib.Data.Real.Basic
import Mathlib.Data.Real.Sqrt

/-!
# Clay Navier-Stokes specification layer

This module encodes the official Clay problem variants (A/B/C/D) and the
condition bundles (4)-(11) from the Fefferman statement as reusable Lean
predicates and theorem templates.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical
noncomputable section

/-- Time-dependent external forcing field `f(x,t)`. -/
abbrev ExternalForceField (D : SpatialDomain3) : Type :=
  ℝ → VelocityField D

/-- Euclidean norm on 3-vectors encoded as `Fin 3 → ℝ`. -/
def coord3Norm (v : Coord3) : ℝ :=
  Real.sqrt ((v 0) ^ 2 + (v 1) ^ 2 + (v 2) ^ 2)

/-- Nonnegativity of the coordinate norm. -/
theorem coord3Norm_nonneg (v : Coord3) : 0 ≤ coord3Norm v :=
  Real.sqrt_nonneg _

/-- Predicate that a forcing field is identically zero. -/
def ForceIsZero {D : SpatialDomain3} (f : ExternalForceField D) : Prop :=
  ∀ t x i, f t x i = 0

/-- Canonical zero forcing field. -/
def zeroForce (D : SpatialDomain3) : ExternalForceField D :=
  fun _ _ => 0

/-- Zero forcing satisfies `ForceIsZero`. -/
theorem forceIsZero_zeroForce (D : SpatialDomain3) :
    ForceIsZero (zeroForce D) := by
  intro t x i
  simp [zeroForce]

/-- Unit translation vector in coordinate direction `j`. -/
def unitVector (j : Fin 3) : Coord3 :=
  fun i => if i = j then 1 else 0

/-- Spatial shift by one unit along coordinate `j`. -/
def shiftByUnit (x : Coord3) (j : Fin 3) : Coord3 :=
  fun i => x i + unitVector j i

/-- Spatial periodicity predicate for velocity fields. -/
def SpacePeriodicVelocity {D : SpatialDomain3} (u : VelocityField D) : Prop :=
  ∀ j x, u (shiftByUnit x j) = u x

/-- Spatial periodicity predicate for pressure fields. -/
def SpacePeriodicPressure {D : SpatialDomain3} (p : PressureField D) : Prop :=
  ∀ j x, p (shiftByUnit x j) = p x

/-- Differential operators used to express decay conditions (4),(5),(9). -/
structure ClayDerivativeOps where
  /-- Spatial derivatives of velocity/initial data. -/
  dVel : (Fin 3 → Nat) → VelocityField .euclidean3 → VelocityField .euclidean3
  /-- Mixed spatial/time derivatives of external force. -/
  dForce : (Fin 3 → Nat) → Nat → ExternalForceField .euclidean3 → ExternalForceField .euclidean3

/-- Condition (4): rapid spatial decay of all spatial derivatives of `u₀`. -/
def Condition4 (ops : ClayDerivativeOps) (u0 : VelocityField .euclidean3) : Prop :=
  ∀ α K : Nat,
    ∃ C : ℝ,
      0 ≤ C ∧
      ∀ x,
        coord3Norm ((ops.dVel α u0) x) ≤ C / (1 + coord3Norm x) ^ K

/-- Condition (5): rapid space-time decay of all derivatives of `f`. -/
def Condition5 (ops : ClayDerivativeOps) (f : ExternalForceField .euclidean3) : Prop :=
  ∀ α m K : Nat,
    ∃ C : ℝ,
      0 ≤ C ∧
      ∀ x t,
        0 ≤ t →
        coord3Norm ((ops.dForce α m f t) x) ≤ C / (1 + coord3Norm x + t) ^ K

/-- Condition (8): spatial periodicity of initial data and forcing. -/
def Condition8 (u0 : VelocityField .euclidean3) (f : ExternalForceField .euclidean3) : Prop :=
  SpacePeriodicVelocity u0 ∧ ∀ t, SpacePeriodicVelocity (f t)

/-- Condition (9): periodic forcing has rapid time-decay for all derivatives. -/
def Condition9 (ops : ClayDerivativeOps) (f : ExternalForceField .euclidean3) : Prop :=
  ∀ α m K : Nat,
    ∃ C : ℝ,
      0 ≤ C ∧
      ∀ x t,
        0 ≤ t →
        coord3Norm ((ops.dForce α m f t) x) ≤ C / (1 + t) ^ K

/-- Condition (10): velocity is periodic in space for all times. -/
def Condition10 (u : VelocityTrajectory .euclidean3) : Prop :=
  ∀ t, SpacePeriodicVelocity (u t)

/-- Condition (6): smoothness in the whole-space setting. -/
def Condition6 (NS : IncompressibleNavierStokes .euclidean3)
    (sol : StrongSolution NS) : Prop :=
  (∀ t, IsSmoothField NS (sol.vel t)) ∧ (∀ t, IsSmoothPressure NS (sol.press t))

/-- Condition (11): smoothness in the periodic setting. -/
def Condition11 (NS : IncompressibleNavierStokes .euclidean3)
    (sol : StrongSolution NS) : Prop :=
  (∀ t, IsSmoothField NS (sol.vel t)) ∧ (∀ t, IsSmoothPressure NS (sol.press t))

/-- Abstract energy functional used for condition (7). -/
structure EnergyFunctional (D : SpatialDomain3) where
  /-- Kinetic-energy-like quantity for a velocity field. -/
  energy : VelocityField D → ℝ

/-- Condition (7): globally bounded energy. -/
def Condition7 {NS : IncompressibleNavierStokes .euclidean3}
    (E : EnergyFunctional .euclidean3) (sol : StrongSolution NS) : Prop :=
  ∃ C : ℝ, 0 < C ∧ ∀ t, 0 ≤ t → E.energy (sol.vel t) < C

/-- Compatibility relation between model forcing and an external-force field. -/
def CompatibleWithExternalForce {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D) (f : ExternalForceField D) : Prop :=
  ∀ t, NS.forcing = f t

/-- Clay theorem labels from Fefferman's statement. -/
inductive ClayStatementLabel where
  | A
  | B
  | C
  | D
  deriving Repr, DecidableEq, Inhabited

/-- Primary target frozen for this development: periodic existence/smoothness (B). -/
def PrimaryClayTarget : ClayStatementLabel := .B

/-- Sanity theorem for frozen target selection. -/
theorem primaryClayTarget_is_B : PrimaryClayTarget = .B := rfl

/-- Hypothesis package for Clay statement (A). -/
structure ClayAHypotheses where
  ν : ℝ
  ν_pos : 0 < ν
  derivOps : ClayDerivativeOps
  energy : EnergyFunctional .euclidean3
  u0 : VelocityField .euclidean3
  u0_smooth : Prop
  u0_divfree : Prop
  cond4 : Condition4 derivOps u0

/-- Hypothesis package for Clay statement (B). -/
structure ClayBHypotheses where
  ν : ℝ
  ν_pos : 0 < ν
  u0 : VelocityField .euclidean3
  u0_smooth : Prop
  u0_divfree : Prop
  f : ExternalForceField .euclidean3
  f_zero : ForceIsZero f
  cond8 : Condition8 u0 f

/-- Hypothesis package for Clay statement (C). -/
structure ClayCHypotheses where
  ν : ℝ
  ν_pos : 0 < ν
  derivOps : ClayDerivativeOps
  energy : EnergyFunctional .euclidean3
  u0 : VelocityField .euclidean3
  f : ExternalForceField .euclidean3
  u0_smooth : Prop
  u0_divfree : Prop
  cond4 : Condition4 derivOps u0
  cond5 : Condition5 derivOps f

/-- Hypothesis package for Clay statement (D). -/
structure ClayDHypotheses where
  ν : ℝ
  ν_pos : 0 < ν
  derivOps : ClayDerivativeOps
  u0 : VelocityField .euclidean3
  f : ExternalForceField .euclidean3
  u0_smooth : Prop
  u0_divfree : Prop
  cond8 : Condition8 u0 f
  cond9 : Condition9 derivOps f

/-- Clay statement (A) as a theorem template. -/
def ClayAStatement : Prop :=
  ∀ H : ClayAHypotheses,
    ∃ NS : IncompressibleNavierStokes .euclidean3,
      NS.nu = H.ν ∧
      NS.forcing = 0 ∧
      ∃ sol : StrongSolution NS,
        sol.vel 0 = H.u0 ∧
        Condition6 NS sol ∧
        Condition7 H.energy sol

/-- Clay statement (B) as a theorem template. -/
def ClayBStatement : Prop :=
  ∀ H : ClayBHypotheses,
    ∃ NS : IncompressibleNavierStokes .euclidean3,
      NS.nu = H.ν ∧
      NS.forcing = 0 ∧
      ∃ sol : StrongSolution NS,
        sol.vel 0 = H.u0 ∧
        Condition10 sol.vel ∧
        Condition11 NS sol

/-- Clay statement (C) as a theorem template. -/
def ClayCStatement : Prop :=
  ∃ H : ClayCHypotheses,
    ∀ NS : IncompressibleNavierStokes .euclidean3,
      NS.nu = H.ν →
      CompatibleWithExternalForce NS H.f →
      ¬ (∃ sol : StrongSolution NS,
          sol.vel 0 = H.u0 ∧
          Condition6 NS sol ∧
          Condition7 H.energy sol)

/-- Clay statement (D) as a theorem template. -/
def ClayDStatement : Prop :=
  ∃ H : ClayDHypotheses,
    ∀ NS : IncompressibleNavierStokes .euclidean3,
      NS.nu = H.ν →
      CompatibleWithExternalForce NS H.f →
      ¬ (∃ sol : StrongSolution NS,
          sol.vel 0 = H.u0 ∧
          Condition10 sol.vel ∧
          Condition11 NS sol)

/-- Working periodic assumptions currently used in this project. -/
structure WorkingPeriodicAssumptions where
  ν : ℝ
  ν_pos : 0 < ν
  u0 : VelocityField .torus3
  u0_smooth : Prop
  u0_divfree : Prop
  u0_periodic : SpacePeriodicVelocity u0

/-- If `u₀` is periodic, condition (8) holds with zero forcing. -/
theorem condition8_of_periodic_zero_force (u0 : VelocityField .euclidean3)
    (hper : SpacePeriodicVelocity u0) :
    Condition8 u0 (zeroForce .euclidean3) := by
  refine ⟨hper, ?_⟩
  intro t j x
  funext i
  simp [zeroForce]

/-- Current project assumptions imply the hypotheses of the frozen target (B). -/
theorem workingAssumptions_imply_clayBHypotheses
    (W : WorkingPeriodicAssumptions) :
    ∃ H : ClayBHypotheses, H.ν = W.ν ∧ H.u0 = W.u0 := by
  refine ⟨{
    ν := W.ν
    ν_pos := W.ν_pos
    u0 := (W.u0 : VelocityField .euclidean3)
    u0_smooth := W.u0_smooth
    u0_divfree := W.u0_divfree
    f := zeroForce .euclidean3
    f_zero := forceIsZero_zeroForce .euclidean3
    cond8 := condition8_of_periodic_zero_force (W.u0 : VelocityField .euclidean3) W.u0_periodic
  }, rfl, rfl⟩

end
end Gibbs.ContinuumField.NavierStokes
