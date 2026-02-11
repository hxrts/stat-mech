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
  vel : ℝ → VelocityField D
  /-- Pressure trajectory. -/
  press : ℝ → PressureField D
  /-- Smoothness assumptions. -/
  smooth_vel : ∀ t, IsSmoothField (vel t)
  smooth_press : ∀ t, IsSmoothPressure (press t)
  /-- Equation satisfaction. -/
  solves : ∀ t, SolvesNavierStokes NS (vel t) (press t)

/-- Mild solution package using the same equation predicate interface. -/
structure MildSolution {D : SpatialDomain3} (NS : IncompressibleNavierStokes D) where
  /-- Velocity trajectory in mild form. -/
  vel : ℝ → VelocityField D
  /-- Pressure trajectory in mild form. -/
  press : ℝ → PressureField D
  /-- Duhamel/mild correctness bundle. -/
  solves_mild : ∀ t, SolvesNavierStokes NS (vel t) (press t)

/-- Leray-Hopf weak solution package. -/
structure LerayHopfSolution {D : SpatialDomain3} (NS : IncompressibleNavierStokes D) where
  /-- Weak velocity trajectory. -/
  vel : ℝ → VelocityField D
  /-- Weak pressure trajectory. -/
  press : ℝ → PressureField D
  /-- Weak equation satisfaction bundle. -/
  solves_weak : ∀ t, SolvesNavierStokes NS (vel t) (press t)
  /-- Energy inequality bookkeeping field. -/
  energy_inequality : Prop

/-- Every strong solution induces a mild-solution witness at the same fields. -/
def StrongSolution.toMild {D : SpatialDomain3} {NS : IncompressibleNavierStokes D}
    (S : StrongSolution NS) : MildSolution NS where
  vel := S.vel
  press := S.press
  solves_mild := S.solves

end Gibbs.ContinuumField.NavierStokes
