import Gibbs.ContinuumField.NavierStokes.Faithful.Rigidity
import Gibbs.ContinuumField.NavierStokes.Faithful.LocalTheory
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomGlobal

/-! # Faithful true hard-step route

Quantitative critical-element contradiction scaffolding for the faithful
Navier-Stokes hard step.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-! ## Global control -/

/-- Direct theorem endpoint for hard-step global closure. -/
abbrev HardStepGlobalClosureTheorem : Prop :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ E : DecisiveCriticalAnalyticEngine H M,
        ∀ _L : FaithfulMildLocalTheory H M.base E.analytic,
          HardStepGlobalClosure

/-- Direct theorem endpoint for hard-step global extension. -/
abbrev HardStepGlobalExtensionTheorem : Prop :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ E : DecisiveCriticalAnalyticEngine H M,
        ∀ _L : FaithfulMildLocalTheory H M.base E.analytic,
          ∃ sol : StrongSolution M.base.NS,
            sol.vel 0 = H.u0 ∧
            Condition10 sol.vel ∧
            Condition11 M.base.NS sol

/-- Build hard-step global closure from direct closure routes. -/
def hardStepGlobalClosure_from_contradiction_route
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ E : DecisiveCriticalAnalyticEngine H M,
            ∀ _L : FaithfulMildLocalTheory H M.base E.analytic,
              HardStepGlobalClosure) :
    HardStepGlobalClosureTheorem := by
  intro H M E L
  exact global_closure H M E L

/-- Canonical hard-step control route sourcing closure theorems from the analytic engine. -/
def hardStepGlobalClosure_from_engine_route : HardStepGlobalClosureTheorem :=
  hardStepGlobalClosure_from_contradiction_route
    (fun _ _ E _ => decisive_hard_step_global_closure E)

/-- Periodicity propagation used by the hard-step global extension route. -/
theorem hardStep_periodicity_propagation_from_localTheory
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {E : DecisiveCriticalAnalyticEngine H M}
    (L : FaithfulMildLocalTheory H M.base E.analytic) :
    Condition10 L.strong.vel :=
  faithful_periodicity_propagation L

/-- Hard-step global extension theorem derived from continuation and contradiction routes. -/
theorem hardStep_global_extension_from_continuation_route
    (global_closure : HardStepGlobalClosureTheorem) :
    HardStepGlobalExtensionTheorem := by
  intro H M E L
  have hclosure : HardStepGlobalClosure := global_closure H M E L
  exact baseAxiom_global_extension_from_continuation_direct hclosure L

/-- Continuation/long-time control theorem interface from hard-step control package. -/
theorem hardStep_continuation_control_theorem
    (global_closure : HardStepGlobalClosureTheorem) :
    HardStepGlobalClosureTheorem :=
  global_closure

/-- Global extension theorem interface from hard-step control package. -/
theorem hardStep_global_extension_theorem
    (global_closure : HardStepGlobalClosureTheorem) :
    HardStepGlobalExtensionTheorem :=
  hardStep_global_extension_from_continuation_route global_closure

end Gibbs.ContinuumField.NavierStokes
