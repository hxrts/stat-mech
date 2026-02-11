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

/-- Finite-time blow-up witness as failure of every finite critical bound up to `T*`. -/
structure FiniteTimeBlowupWitness {D : SpatialDomain3} (NS : IncompressibleNavierStokes D) where
  /-- Candidate strong solution trajectory. -/
  sol : StrongSolution NS
  /-- Critical norm used to witness norm inflation. -/
  K : CriticalNorm D
  /-- Candidate singular time. -/
  Tstar : ℝ
  /-- Positivity of `T*`. -/
  Tstar_pos : 0 < Tstar
  /-- Every finite budget is violated on `[0, T*]`. -/
  exceed_every_budget : ∀ B : ℝ,
    ∃ t : ℝ, 0 ≤ t ∧ t ≤ Tstar ∧ B < K.value (sol.vel t)

end Gibbs.ContinuumField.NavierStokes
