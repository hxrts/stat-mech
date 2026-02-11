import Gibbs.ContinuumField.NavierStokes.Linear.Semigroup
import Gibbs.ContinuumField.NavierStokes.LocalTheory

/-! # Duhamel and fixed-point local theory

Duhamel formulation interfaces and fixed-point witnesses for local
well-posedness.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Duhamel forcing integrand model. -/
abbrev DuhamelIntegrand (D : SpatialDomain3) := ℝ → VelocityField D

/-- Duhamel-form velocity candidate from semigroup and source term. -/
def duhamelVelocity {D : SpatialDomain3}
    (S : StokesSemigroup D)
    (u0 : VelocityField D)
    (F : DuhamelIntegrand D) :
    VelocityTrajectory D :=
  fun t => S.apply t u0 + F t

/-- Fixed-point data package for local strong well-posedness. -/
structure FixedPointLocalWitness {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D) where
  /-- Initial data assumptions. -/
  init : InitialDataAssumptions D
  /-- Semigroup used in Duhamel map. -/
  semigroup : StokesSemigroup D
  /-- Local horizon. -/
  T : ℝ
  /-- Positive local time. -/
  T_pos : 0 < T
  /-- Source term in Duhamel form. -/
  source : DuhamelIntegrand D
  /-- Fixed point candidate strong solution. -/
  sol : StrongSolution NS
  /-- Candidate matches initial data at `t = 0`. -/
  initial_value : sol.vel 0 = init.data.u0
  /-- Duhamel representation on `[0,T]` (interface-level assumption). -/
  duhamel_form : ∀ t, 0 ≤ t → t ≤ T → sol.vel t = duhamelVelocity semigroup init.data.u0 source t
  /-- Uniqueness in the fixed-point ball (interface-level assumption). -/
  unique_fixed_point : ∀ s : StrongSolution NS, s.vel 0 = init.data.u0 → s = sol

/-- Fixed-point Duhamel witness yields local existence/uniqueness theorem. -/
theorem duhamel_fixed_point_local_wellposed {D : SpatialDomain3}
    {NS : IncompressibleNavierStokes D}
    (W : FixedPointLocalWitness NS) :
    ∃ T > (0 : ℝ),
      ∃ sol : StrongSolution NS,
        sol.vel 0 = W.init.data.u0 ∧
        (∀ s : StrongSolution NS, s.vel 0 = W.init.data.u0 → s = sol) := by
  exact ⟨W.T, W.T_pos, W.sol, W.initial_value, W.unique_fixed_point⟩

end Gibbs.ContinuumField.NavierStokes
