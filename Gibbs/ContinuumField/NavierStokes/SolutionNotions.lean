import Gibbs.ContinuumField.NavierStokes.Projector

/-!
# Solution notions

Strong/mild/weak solution notions for incompressible Navier-Stokes.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

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
  /-- Duhamel compatibility side condition placeholder. -/
  duhamelCompatible : Prop
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
  /-- Energy inequality bookkeeping field. -/
  energy_inequality : Prop

/-- Every strong solution induces a mild-solution witness at the same fields. -/
def StrongSolution.toMild {D : SpatialDomain3} {NS : IncompressibleNavierStokes D}
    (S : StrongSolution NS) : MildSolution NS where
  vel := S.vel
  press := S.press
  dvel := S.dvel
  duhamelCompatible := True
  solves_mild := S.solves

/-- Every mild solution induces a weak-solution witness with supplied energy inequality. -/
def MildSolution.toLerayHopf {D : SpatialDomain3} {NS : IncompressibleNavierStokes D}
    (M : MildSolution NS) (henergy : Prop) : LerayHopfSolution NS where
  vel := M.vel
  press := M.press
  dvel := M.dvel
  solves_weak := M.solves_mild
  energy_inequality := henergy

end Gibbs.ContinuumField.NavierStokes
