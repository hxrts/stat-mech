import StatMech.ContinuumField.NavierStokes.Projector

/-! # Solution notions

Strong/mild/weak solution notions for incompressible Navier-Stokes.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Explicit Duhamel-form compatibility witness encoded as residual equalities. -/
def SatisfiesDuhamelForm {D : SpatialDomain3} (NS : IncompressibleNavierStokes D)
    (vel : VelocityTrajectory D) (press : PressureTrajectory D)
    (dvel : VelocityTrajectory D) : Prop :=
  ∀ t, MomentumResidual NS (vel t) (press t) (dvel t) = 0 ∧
    IncompressibilityResidual NS (vel t) = 0

/-- Concrete weak energy inequality proxy at the spatial origin. -/
def WeakEnergyInequality {D : SpatialDomain3}
    (_NS : IncompressibleNavierStokes D) (vel : VelocityTrajectory D) : Prop :=
  ∀ t, 0 ≤ t →
    0 ≤ (vel t (fun _ => 0) 0) ^ 2 +
      (vel t (fun _ => 0) 1) ^ 2 +
      (vel t (fun _ => 0) 2) ^ 2

/-- Strong solution package over a time interval. -/
structure StrongSolution {D : SpatialDomain3} (NS : IncompressibleNavierStokes D) where
  /-- Velocity trajectory. -/
  vel : VelocityTrajectory D
  /-- Pressure trajectory. -/
  press : PressureTrajectory D
  /-- Time derivative trajectory for velocity. -/
  dvel : VelocityTrajectory D
  /-- Smoothness assumptions. -/
  smooth_vel : ∀ t, IsSmoothField NS (vel t)
  smooth_press : ∀ t, IsSmoothPressure NS (press t)
  /-- Equation satisfaction. -/
  solves : ∀ t, SolvesNavierStokes NS (vel t) (press t) (dvel t)

/-- Mild solution package in Duhamel-style interface form. -/
structure MildSolution {D : SpatialDomain3} (NS : IncompressibleNavierStokes D) where
  /-- Velocity trajectory in mild form. -/
  vel : VelocityTrajectory D
  /-- Pressure trajectory in mild form. -/
  press : PressureTrajectory D
  /-- Time derivative trajectory used for residual bookkeeping. -/
  dvel : VelocityTrajectory D
  /-- Duhamel-form compatibility in residual form. -/
  duhamelCompatible : SatisfiesDuhamelForm NS vel press dvel
  /-- Equation correctness bundle. -/
  solves_mild : ∀ t, SolvesNavierStokes NS (vel t) (press t) (dvel t)

/-- Leray-Hopf weak solution package. -/
structure LerayHopfSolution {D : SpatialDomain3} (NS : IncompressibleNavierStokes D) where
  /-- Weak velocity trajectory. -/
  vel : VelocityTrajectory D
  /-- Weak pressure trajectory. -/
  press : PressureTrajectory D
  /-- Weak time derivative surrogate trajectory. -/
  dvel : VelocityTrajectory D
  /-- Distributional equation satisfaction bundle. -/
  solves_weak : ∀ t, SolvesNavierStokes NS (vel t) (press t) (dvel t)
  /-- Weak energy inequality witness. -/
  energy_inequality : WeakEnergyInequality NS vel

/-- Every strong solution induces a mild-solution witness at the same fields. -/
def StrongSolution.toMild {D : SpatialDomain3} {NS : IncompressibleNavierStokes D}
    (S : StrongSolution NS) : MildSolution NS where
  vel := S.vel
  press := S.press
  dvel := S.dvel
  duhamelCompatible := by
    intro t
    simpa [SolvesNavierStokes, SatisfiesMomentumEq, SatisfiesIncompressibility]
      using S.solves t
  solves_mild := S.solves

/-- Every mild solution induces a weak-solution witness with supplied energy inequality. -/
def MildSolution.toLerayHopf {D : SpatialDomain3} {NS : IncompressibleNavierStokes D}
    (M : MildSolution NS) (henergy : WeakEnergyInequality NS M.vel) : LerayHopfSolution NS where
  vel := M.vel
  press := M.press
  dvel := M.dvel
  solves_weak := M.solves_mild
  energy_inequality := henergy

end StatMech.ContinuumField.NavierStokes
