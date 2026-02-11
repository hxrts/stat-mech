import Gibbs.ContinuumField.NavierStokes.SolutionNotions

/-!
# Local well-posedness scaffolding

A minimal local-theory interface that can be strengthened as analytic
infrastructure is added.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Witness object for local well-posedness on `[0,T]`. -/
structure LocalWellPosednessWitness {D : SpatialDomain3} (NS : IncompressibleNavierStokes D) where
  /-- Existence horizon. -/
  T : ℝ
  /-- Positive-time horizon. -/
  T_pos : 0 < T
  /-- Realizing strong solution. -/
  sol : StrongSolution NS

/-- Local existence theorem in witness form. -/
theorem local_existence_of_witness {D : SpatialDomain3} {NS : IncompressibleNavierStokes D}
    (w : LocalWellPosednessWitness NS) :
    ∃ T > (0 : ℝ), ∃ sol : StrongSolution NS, sol = w.sol := by
  exact ⟨w.T, w.T_pos, w.sol, rfl⟩

/-- Local uniqueness theorem from an explicit uniqueness hypothesis. -/
theorem local_uniqueness_of_witness {D : SpatialDomain3} {NS : IncompressibleNavierStokes D}
    (w : LocalWellPosednessWitness NS)
    (huniq : ∀ s : StrongSolution NS, s = w.sol) :
    ∀ s : StrongSolution NS, s = w.sol := by
  intro s
  exact huniq s

end Gibbs.ContinuumField.NavierStokes
