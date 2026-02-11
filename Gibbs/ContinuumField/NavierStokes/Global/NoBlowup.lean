import Gibbs.ContinuumField.NavierStokes.Global.ClosureAttempt

/-!
# Global no-blowup consequence

Deduction layer from global regularity closure to global no-blowup statement.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Global no-blowup predicate as a time-uniform critical norm bound. -/
def NoBlowupGlobal {D : SpatialDomain3} (NS : IncompressibleNavierStokes D) : Prop :=
  ∃ K : CriticalNorm D,
    ∃ sol : StrongSolution NS,
      ∃ B : ℝ,
        ∀ t, 0 ≤ t → K.value (sol.vel t) ≤ B

/-- Global regularity implies global no-blowup in this interface layer. -/
theorem no_blowup_of_global_regularity {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D)
    (hreg : GlobalRegularity NS) :
    NoBlowupGlobal NS := by
  rcases hreg with ⟨K, sol, B, hT⟩
  refine ⟨K, sol, B, ?_⟩
  intro t ht
  have hUpTo : NoBlowupUpTo NS K sol t B := hT t ht
  exact hUpTo t ht (le_rfl)

end Gibbs.ContinuumField.NavierStokes
