import Gibbs.ContinuumField.NavierStokes.Faithful.LocalTheory

/-! # Faithful hard global step closure

Hard-step closure package used by the faithful final theorem route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Faithful hard-step package for global regularity closure. -/
structure FaithfulHardGlobalClosure
    (H : ClayBHypotheses)
    (M : FaithfulPeriodicModel H)
    (A : FaithfulAnalyticStack)
    (L : FaithfulMildLocalTheory H M A) where
  hard_step_closed : Prop
  hard_step_closed_holds : hard_step_closed
  global_solution : StrongSolution M.NS
  global_init_match : global_solution.vel 0 = H.u0
  global_periodicity : Condition10 global_solution.vel
  global_smoothness : Condition11 M.NS global_solution

/-- Faithful hard-step closure theorem interface. -/
theorem faithful_hard_step_closed
    {H : ClayBHypotheses}
    {M : FaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    {L : FaithfulMildLocalTheory H M A}
    (G : FaithfulHardGlobalClosure H M A L) :
    G.hard_step_closed := by
  exact G.hard_step_closed_holds

/-- Faithful global regularity extraction from hard-step closure. -/
theorem faithful_global_solution_of_hard_step
    {H : ClayBHypotheses}
    {M : FaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    {L : FaithfulMildLocalTheory H M A}
    (G : FaithfulHardGlobalClosure H M A L) :
    ∃ sol : StrongSolution M.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.NS sol := by
  exact ⟨G.global_solution, G.global_init_match, G.global_periodicity, G.global_smoothness⟩

end Gibbs.ContinuumField.NavierStokes
