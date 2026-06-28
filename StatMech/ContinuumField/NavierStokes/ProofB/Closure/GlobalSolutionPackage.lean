import StatMech.ContinuumField.NavierStokes.ProofB.Local.LocalWellposedness

/-! # Faithful hard global step closure

Hard-step closure package used by the faithful final theorem route.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Direct theorem-level hard-global data shape (de-carrierized endpoint form). -/
abbrev FaithfulHardGlobalData
    (H : ClayBHypotheses)
    (M : FaithfulPeriodicModel H)
    (A : FaithfulAnalyticStack)
    (_L : FaithfulMildLocalTheory H M A) : Prop :=
  ∃ sol : StrongSolution M.NS,
    sol.vel 0 = H.u0 ∧
    Condition10 sol.vel ∧
    Condition11 M.NS sol

/-- Faithful global regularity extraction from direct hard-global endpoint data. -/
theorem faithful_global_solution_of_hard_step
    {H : ClayBHypotheses}
    {M : FaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    {L : FaithfulMildLocalTheory H M A}
    (Gd : FaithfulHardGlobalData H M A L) :
    ∃ sol : StrongSolution M.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.NS sol := by
  exact Gd

end StatMech.ContinuumField.NavierStokes
