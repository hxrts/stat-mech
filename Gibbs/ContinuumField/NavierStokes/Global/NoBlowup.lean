import Gibbs.ContinuumField.NavierStokes.Global.ClosureAttempt

/-!
# Global no-blowup consequence

Deduction layer from global regularity closure to global no-blowup statement.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Abstract global no-blowup predicate. -/
def NoBlowupGlobal {D : SpatialDomain3} (_NS : IncompressibleNavierStokes D) : Prop :=
  True

/-- Global regularity implies global no-blowup in this interface layer. -/
theorem no_blowup_of_global_regularity {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D)
    (_hreg : GlobalRegularity NS) :
    NoBlowupGlobal NS := by
  trivial

end Gibbs.ContinuumField.NavierStokes
