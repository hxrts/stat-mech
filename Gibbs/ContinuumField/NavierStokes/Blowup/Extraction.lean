import Gibbs.ContinuumField.NavierStokes.Global.NoBlowup

/-!
# Blow-up extraction scaffolding

Data objects for first-singular-time normalization and blow-up sequence setup.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Blow-up candidate sequence normalized around a putative singular time. -/
structure BlowupSequence (D : SpatialDomain3) where
  /-- Candidate velocity profiles. -/
  profiles : Nat → VelocityField D
  /-- Candidate pressure profiles. -/
  pressures : Nat → PressureField D
  /-- Candidate singular time. -/
  singularTime : ℝ
  /-- Positive singular time guard. -/
  singularTime_pos : 0 < singularTime

/-- First singular time witness object. -/
structure FirstSingularTimeWitness (D : SpatialDomain3) where
  /-- Candidate Navier-Stokes system. -/
  NS : IncompressibleNavierStokes D
  /-- Candidate first singular time. -/
  Tstar : ℝ
  /-- Positivity of first singular time. -/
  Tstar_pos : 0 < Tstar

end Gibbs.ContinuumField.NavierStokes
