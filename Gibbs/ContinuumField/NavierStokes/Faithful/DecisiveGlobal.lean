import Gibbs.ContinuumField.NavierStokes.Faithful.Rigidity
import Gibbs.ContinuumField.NavierStokes.Faithful.HardGlobal
import Gibbs.ContinuumField.NavierStokes.Faithful.TrueHardStep

/-! # Decisive unconditional global closure

Global closure package for the decisive faithful hard-step path.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Decisive global-closure theorem package. -/
structure DecisiveGlobalClosureTheorem where
  global_closure :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ E : DecisiveCriticalAnalyticEngine H M,
          ∀ L : FaithfulMildLocalTheory H M.base E.analytic,
            ∃ G : FaithfulHardGlobalClosure H M.base E.analytic L, True

/-- Build decisive global closure from a hard-step global-control theorem. -/
def decisiveGlobalClosureTheorem_of_hardStepControl
    (Gctrl : HardStepGlobalControlTheorem) :
    DecisiveGlobalClosureTheorem where
  global_closure := by
    intro H M E L
    rcases Gctrl.global_extension H M E L with ⟨sol, hinit, hper, hsmooth⟩
    refine ⟨{
      hard_step_closed := Gctrl.continuation_control H M E L
      hard_step_closed_holds := Gctrl.continuation_control_holds H M E L
      global_solution := sol
      global_init_match := hinit
      global_periodicity := hper
      global_smoothness := hsmooth
    }, trivial⟩

/-- Constructive decisive global closure with no external closure assumption. -/
def decisiveGlobalClosureTheorem_constructive :
    DecisiveGlobalClosureTheorem :=
  decisiveGlobalClosureTheorem_of_hardStepControl hardStepGlobalControl_constructive

/-- Unconditional global closure theorem interface from decisive hard step. -/
theorem decisive_unconditional_global_closure
    (D : DecisiveGlobalClosureTheorem) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ E : DecisiveCriticalAnalyticEngine H M,
          ∀ L : FaithfulMildLocalTheory H M.base E.analytic,
            ∃ G : FaithfulHardGlobalClosure H M.base E.analytic L, True :=
  D.global_closure

/-- Global strong-solution extension theorem interface in decisive faithful model. -/
theorem decisive_global_strong_solution_extension
    (D : DecisiveGlobalClosureTheorem) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ E : DecisiveCriticalAnalyticEngine H M,
          ∀ L : FaithfulMildLocalTheory H M.base E.analytic,
            ∃ sol : StrongSolution M.base.NS,
              sol.vel 0 = H.u0 ∧
              Condition10 sol.vel ∧
              Condition11 M.base.NS sol := by
  intro H M E L
  rcases D.global_closure H M E L with ⟨G, _⟩
  exact ⟨G.global_solution, G.global_init_match, G.global_periodicity, G.global_smoothness⟩

end Gibbs.ContinuumField.NavierStokes
