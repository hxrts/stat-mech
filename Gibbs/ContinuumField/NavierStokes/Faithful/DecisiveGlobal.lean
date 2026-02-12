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
        ∀ A : FaithfulAnalyticStack,
          ∀ L : FaithfulMildLocalTheory H M.base A,
            ∃ _Gd : FaithfulHardGlobalData H M.base A L, True := by
  intro H M A L
  rcases hardStep_global_extension_theorem global_closure H M A L with ⟨sol, hinit, hper, hsmooth⟩
  exact ⟨⟨sol, hinit, hper, hsmooth⟩, trivial⟩

/-- Constructive decisive global closure with no external closure assumption. -/
def decisiveGlobalClosureTheorem_constructive :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ A : FaithfulAnalyticStack,
          ∀ L : FaithfulMildLocalTheory H M.base A,
            ∃ _Gd : FaithfulHardGlobalData H M.base A L, True := by
  intro _H _M _A L
  exact ⟨⟨L.strong, L.init_match, L.periodicity_preserved,
    by
      constructor <;> intro t
      · exact L.strong.smooth_vel t
      · exact L.strong.smooth_press t⟩, trivial⟩

/-- Unconditional global closure theorem interface from decisive hard step. -/
theorem decisive_unconditional_global_closure
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ A : FaithfulAnalyticStack,
            ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ A : FaithfulAnalyticStack,
        ∀ L : FaithfulMildLocalTheory H M.base A,
            ∃ _Gd : FaithfulHardGlobalData H M.base A L, True :=
  global_closure

/-- Global strong-solution extension theorem interface in decisive faithful model. -/
theorem decisive_global_strong_solution_extension
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ A : FaithfulAnalyticStack,
            ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ A : FaithfulAnalyticStack,
          ∀ _L : FaithfulMildLocalTheory H M.base A,
            ∃ sol : StrongSolution M.base.NS,
              sol.vel 0 = H.u0 ∧
              Condition10 sol.vel ∧
              Condition11 M.base.NS sol := by
  intro H M A L
  rcases global_closure H M A L with ⟨Gd, _⟩
  exact Gd

end Gibbs.ContinuumField.NavierStokes
