import Gibbs.ContinuumField.NavierStokes.Defect.Estimates
import Gibbs.ContinuumField.NavierStokes.LocalTheory

/-!
# Defect-based continuation

Conditional continuation scaffolding: envelope control implies no-blowup claims
under explicit hypotheses.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- No-blowup predicate up to time `T` relative to a critical-norm budget. -/
def NoBlowupUpTo {D : SpatialDomain3} (NS : IncompressibleNavierStokes D)
    (K : CriticalNorm D) (sol : StrongSolution NS) (T budget : ℝ) : Prop :=
  ∀ t, 0 ≤ t → t ≤ T → K.value (sol.vel t) ≤ budget

/-- Conditional continuation theorem from global envelope control. -/
theorem continuation_of_defect_envelope {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D)
    (E : DefectEnvelope D)
    (sol : StrongSolution NS)
    (T : ℝ)
    (_hT : 0 ≤ T)
    (hbounded : IsGloballyBoundedEnvelope E)
    (hmatch : ∀ t, E.criticalNorm.value (sol.vel t) ≤ E.resolvedCriticalNorm t) :
    NoBlowupUpTo NS E.criticalNorm sol T E.criticalBudget := by
  intro t ht0 htT
  have hcrit_t : E.resolvedCriticalNorm t ≤ E.criticalBudget := hbounded.2 t
  exact le_trans (hmatch t) hcrit_t

/-- Milestone-C style theorem: global envelope bound yields conditional regularity. -/
theorem conditional_regularity_of_envelope_bound {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D)
    (E : DefectEnvelope D)
    (sol : StrongSolution NS)
    (T : ℝ)
    (hT : 0 ≤ T)
    (hbounded : IsGloballyBoundedEnvelope E)
    (hmatch : ∀ t, E.criticalNorm.value (sol.vel t) ≤ E.resolvedCriticalNorm t) :
    NoBlowupUpTo NS E.criticalNorm sol T E.criticalBudget :=
  continuation_of_defect_envelope NS E sol T hT hbounded hmatch

end Gibbs.ContinuumField.NavierStokes
