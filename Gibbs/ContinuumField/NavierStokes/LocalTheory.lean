import Gibbs.ContinuumField.NavierStokes.SolutionNotions

/-! # Local well-posedness scaffolding

A local-theory interface that can be strengthened as analytic
infrastructure is added.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Compatibility conditions on initial data for local strong theory. -/
structure InitialDataAssumptions (D : SpatialDomain3) where
  /-- Initial velocity data package. -/
  data : InitialVelocityField D
  /-- Strictly positive viscosity available in the selected model. -/
  viscosityCompatible : Prop

/-- Witness object for local well-posedness on `[0,T]`. -/
structure LocalWellPosednessWitness {D : SpatialDomain3} (NS : IncompressibleNavierStokes D) where
  /-- Admissible initial data assumptions. -/
  init : InitialDataAssumptions D
  /-- Existence horizon. -/
  T : ℝ
  /-- Positive-time horizon. -/
  T_pos : 0 < T
  /-- Realizing strong solution. -/
  sol : StrongSolution NS
  /-- Initial-value constraint at time `0`. -/
  initial_value : sol.vel 0 = init.data.u0

/-- Local uniqueness specification around a witness. -/
def LocalUniqueOnWitness {D : SpatialDomain3} {NS : IncompressibleNavierStokes D}
    (w : LocalWellPosednessWitness NS) : Prop :=
  ∀ s : StrongSolution NS, s.vel 0 = w.init.data.u0 → s = w.sol

/-- Milestone-A theorem statement in witness form: local existence + uniqueness. -/
theorem local_existence_uniqueness {D : SpatialDomain3} {NS : IncompressibleNavierStokes D}
    (w : LocalWellPosednessWitness NS)
    (huniq : LocalUniqueOnWitness w) :
    ∃ T > (0 : ℝ),
      ∃ sol : StrongSolution NS,
        sol.vel 0 = w.init.data.u0 ∧
        (∀ s : StrongSolution NS, s.vel 0 = w.init.data.u0 → s = sol) := by
  refine ⟨w.T, w.T_pos, w.sol, w.initial_value, ?_⟩
  intro s hs0
  exact huniq s hs0

end Gibbs.ContinuumField.NavierStokes
