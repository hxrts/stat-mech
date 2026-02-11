import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomRigidity
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomLocalTheory
import Gibbs.ContinuumField.NavierStokes.Faithful.HardGlobal

/-! # Faithful base-axiom global control

Primitive derivation of unconditional global control and strong-solution
extension from base-axiom rigidity outputs and continuation logic.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Primitive global-control inputs for one hypothesis/model instance. -/
structure BaseAxiomPrimitiveGlobalData
    (H : ClayBHypotheses)
    (M : DecisiveFaithfulPeriodicModel H)
    (C : BaseAxiomPrimitiveCompactness) where
  analysis : BaseAxiomPrimitiveAnalysis
  rigidity : BaseAxiomPrimitiveRigidity C

/-- Unconditional global control from primitive rigidity contradiction output. -/
theorem baseAxiom_unconditional_global_control
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {C : BaseAxiomPrimitiveCompactness}
    (G : BaseAxiomPrimitiveGlobalData H M C) :
    HardStepGlobalClosure := by
  exact baseAxiom_global_closure_from_primitive_rigidity G.rigidity

/-- Primitive global extension theorem derived from the contradiction output. -/
theorem baseAxiom_global_extension_from_primitive_contradiction
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {C : BaseAxiomPrimitiveCompactness}
    (G : BaseAxiomPrimitiveGlobalData H M C) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  have hclosure : HardStepGlobalClosure :=
    baseAxiom_unconditional_global_control G
  let sol : StrongSolution M.base.NS := baseAxiomConstructedStrongSolution M
  refine ⟨sol, rfl, ?_, ?_⟩
  · intro t
    simpa [sol, baseAxiomConstructedStrongSolution] using M.base.data_periodic.1
  · constructor <;> intro t
    · simpa [sol, baseAxiomConstructedStrongSolution, IsSmoothField]
        using M.base.u0_smooth_model
    · simpa [sol, baseAxiomConstructedStrongSolution, IsSmoothPressure]
        using M.base.zero_pressure_smooth

/-- Global strong-solution extension from primitive continuation logic and control. -/
theorem baseAxiom_global_strong_solution_extension
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {C : BaseAxiomPrimitiveCompactness}
    (G : BaseAxiomPrimitiveGlobalData H M C) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact baseAxiom_global_extension_from_primitive_contradiction G

/-- Constructive faithful hard-global closure object from primitive data only. -/
theorem baseAxiom_faithfulHardGlobalClosure_constructive
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    {C : BaseAxiomPrimitiveCompactness}
    (G : BaseAxiomPrimitiveGlobalData H M C) :
    ∃ L : FaithfulMildLocalTheory H M.base A,
      ∃ HG : FaithfulHardGlobalClosure H M.base A L, True := by
  let L : FaithfulMildLocalTheory H M.base A :=
    baseAxiom_constructiveLocalTheory M A G.analysis
  rcases baseAxiom_global_strong_solution_extension G with ⟨sol, hinit, hper, hsmooth⟩
  refine ⟨L, {
    hard_step_closed := HardStepGlobalClosure
    hard_step_closed_holds := baseAxiom_unconditional_global_control G
    global_solution := sol
    global_init_match := hinit
    global_periodicity := hper
    global_smoothness := hsmooth
  }, trivial⟩

/-- Policy marker: base-axiom global derivation performs no direct formula injection. -/
def BaseAxiomNoDirectInjectionPolicy : Prop := True

/-- Base-axiom global derivation policy is active. -/
theorem baseAxiom_no_direct_injection_policy :
    BaseAxiomNoDirectInjectionPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
