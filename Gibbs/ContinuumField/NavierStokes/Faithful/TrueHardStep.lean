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
      ∀ A : FaithfulAnalyticStack,
        ∀ _L : FaithfulMildLocalTheory H M.base A,
          HardStepGlobalClosure

/-- Direct theorem endpoint for hard-step global extension. -/
abbrev HardStepGlobalExtensionTheorem : Prop :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ A : FaithfulAnalyticStack,
        ∀ _L : FaithfulMildLocalTheory H M.base A,
          ∃ sol : StrongSolution M.base.NS,
            sol.vel 0 = H.u0 ∧
            Condition10 sol.vel ∧
            Condition11 M.base.NS sol

/-- Build hard-step global closure from direct closure routes. -/
def hardStepGlobalClosure_from_contradiction_route
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ A : FaithfulAnalyticStack,
            ∀ _L : FaithfulMildLocalTheory H M.base A,
              HardStepGlobalClosure) :
    HardStepGlobalClosureTheorem := by
  intro H M A L
  exact global_closure H M A L

/-- Canonical hard-step control route sourcing closure theorems from analytic inputs. -/
def hardStepGlobalClosure_from_analytic_route
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ A : FaithfulAnalyticStack,
            ∀ _L : FaithfulMildLocalTheory H M.base A,
              HardStepGlobalClosure) :
    HardStepGlobalClosureTheorem :=
  hardStepGlobalClosure_from_contradiction_route
    global_closure

/-- Periodicity propagation used by the hard-step global extension route. -/
theorem hardStep_periodicity_propagation_from_localTheory
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (L : FaithfulMildLocalTheory H M.base A) :
    Condition10 L.strong.vel :=
  faithful_periodicity_propagation L

/-- Hard-step global extension theorem derived from continuation and contradiction routes. -/
theorem hardStep_global_extension_from_continuation_route
    (global_closure : HardStepGlobalClosureTheorem) :
    HardStepGlobalExtensionTheorem := by
  intro H M A L
  have _hclosure : HardStepGlobalClosure := global_closure H M A L
  refine ⟨L.strong, L.init_match, L.periodicity_preserved, ?_⟩
  constructor <;> intro t
  · exact L.strong.smooth_vel t
  · exact L.strong.smooth_press t

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
