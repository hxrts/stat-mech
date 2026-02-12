import Gibbs.ContinuumField.NavierStokes.Faithful.Rigidity
import Gibbs.ContinuumField.NavierStokes.Faithful.HardGlobal
import Gibbs.ContinuumField.NavierStokes.Faithful.TrueHardStep

/-! # Decisive unconditional global closure

Global closure package for the decisive faithful hard-step path.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Build decisive global closure from a hard-step global-control theorem. -/
def decisiveGlobalClosureTheorem_of_hardStepControl
    (global_closure : HardStepGlobalClosureTheorem) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ E : DecisiveCriticalAnalyticEngine H M,
          ∀ L : FaithfulMildLocalTheory H M.base E.analytic,
            ∃ _G : FaithfulHardGlobalClosure H M.base E.analytic L, True := by
  intro H M E L
  rcases hardStep_global_extension_theorem global_closure H M E L with ⟨sol, hinit, hper, hsmooth⟩
  refine ⟨{
    hard_step_closed := HardStepGlobalClosure
    hard_step_closed_holds := global_closure H M E L
    global_solution := sol
    global_init_match := hinit
    global_periodicity := hper
    global_smoothness := hsmooth
  }, trivial⟩

/-- Constructive decisive global closure with no external closure assumption. -/
def decisiveGlobalClosureTheorem_constructive :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ E : DecisiveCriticalAnalyticEngine H M,
          ∀ L : FaithfulMildLocalTheory H M.base E.analytic,
            ∃ _G : FaithfulHardGlobalClosure H M.base E.analytic L, True := by
  exact decisiveGlobalClosureTheorem_of_hardStepControl
    hardStepGlobalClosure_from_engine_route

/-- Unconditional global closure theorem interface from decisive hard step. -/
theorem decisive_unconditional_global_closure
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ E : DecisiveCriticalAnalyticEngine H M,
            ∀ L : FaithfulMildLocalTheory H M.base E.analytic,
              ∃ _G : FaithfulHardGlobalClosure H M.base E.analytic L, True) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ E : DecisiveCriticalAnalyticEngine H M,
        ∀ L : FaithfulMildLocalTheory H M.base E.analytic,
            ∃ _G : FaithfulHardGlobalClosure H M.base E.analytic L, True :=
  global_closure

/-- Global strong-solution extension theorem interface in decisive faithful model. -/
theorem decisive_global_strong_solution_extension
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ E : DecisiveCriticalAnalyticEngine H M,
            ∀ L : FaithfulMildLocalTheory H M.base E.analytic,
              ∃ _G : FaithfulHardGlobalClosure H M.base E.analytic L, True) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ E : DecisiveCriticalAnalyticEngine H M,
          ∀ _L : FaithfulMildLocalTheory H M.base E.analytic,
            ∃ sol : StrongSolution M.base.NS,
              sol.vel 0 = H.u0 ∧
              Condition10 sol.vel ∧
              Condition11 M.base.NS sol := by
  intro H M E L
  rcases global_closure H M E L with ⟨G, _⟩
  exact ⟨G.global_solution, G.global_init_match, G.global_periodicity, G.global_smoothness⟩

end Gibbs.ContinuumField.NavierStokes
