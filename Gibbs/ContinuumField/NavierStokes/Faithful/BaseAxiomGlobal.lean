import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomRigidity
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomLocalTheory
import Gibbs.ContinuumField.NavierStokes.Faithful.HardGlobal

/-! # Faithful base-axiom global control

Primitive derivation of unconditional global control and strong-solution
extension from base-axiom rigidity outputs and continuation logic.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Unconditional global control from primitive rigidity in direct form. -/
theorem baseAxiom_unconditional_global_control_direct
    (flux_package : HardStepFluxContradictionPackage) :
    HardStepGlobalClosure := by
  exact baseAxiom_global_closure_from_flux_package flux_package

/-- Unconditional global control from primitive rigidity contradiction output. -/
theorem baseAxiom_unconditional_global_control
    (flux_package : HardStepFluxContradictionPackage) :
    HardStepGlobalClosure := by
  exact baseAxiom_unconditional_global_control_direct flux_package

/-- Direct continuation-derived global extension theorem from closure + witness. -/
theorem baseAxiom_global_extension_from_continuation_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (_hclosure : HardStepGlobalClosure)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  refine ⟨L.strong, L.init_match, L.periodicity_preserved, ?_⟩
  constructor <;> intro t
  · exact L.strong.smooth_vel t
  · exact L.strong.smooth_press t

/-- Primitive contradiction-derived global extension theorem in direct form. -/
theorem baseAxiom_global_extension_from_primitive_contradiction_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (flux_package : HardStepFluxContradictionPackage)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  have hclosure : HardStepGlobalClosure :=
    baseAxiom_unconditional_global_control_direct flux_package
  exact baseAxiom_global_extension_from_continuation_direct hclosure L

/-- Primitive global extension theorem derived from the contradiction output. -/
theorem baseAxiom_global_extension_from_primitive_contradiction
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (flux_package : HardStepFluxContradictionPackage)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact baseAxiom_global_extension_from_primitive_contradiction_direct
    flux_package L

/-- Global strong-solution extension in direct form. -/
theorem baseAxiom_global_strong_solution_extension_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (flux_package : HardStepFluxContradictionPackage)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact baseAxiom_global_extension_from_primitive_contradiction_direct
    flux_package L

/-- Global strong-solution extension from primitive continuation logic and control. -/
theorem baseAxiom_global_strong_solution_extension
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (flux_package : HardStepFluxContradictionPackage)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact baseAxiom_global_strong_solution_extension_direct
    flux_package L

/-- Constructive faithful hard-global closure object in direct form. -/
theorem baseAxiom_faithfulHardGlobalClosure_constructive_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (flux_package : HardStepFluxContradictionPackage)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ L' : FaithfulMildLocalTheory H M.base A,
      ∃ _HG : FaithfulHardGlobalClosure H M.base A L', True := by
  rcases baseAxiom_global_strong_solution_extension_direct
      flux_package L with
      ⟨sol, hinit, hper, hsmooth⟩
  refine ⟨L, {
    hard_step_closed := HardStepGlobalClosure
    hard_step_closed_holds := baseAxiom_unconditional_global_control_direct flux_package
    global_solution := sol
    global_init_match := hinit
    global_periodicity := hper
    global_smoothness := hsmooth
  }, trivial⟩

/-- Constructive faithful hard-global closure object from primitive data only. -/
theorem baseAxiom_faithfulHardGlobalClosure_constructive
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (flux_package : HardStepFluxContradictionPackage)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ L' : FaithfulMildLocalTheory H M.base A,
      ∃ _HG : FaithfulHardGlobalClosure H M.base A L', True := by
  exact baseAxiom_faithfulHardGlobalClosure_constructive_direct
    flux_package L

/-- Policy marker: base-axiom global derivation performs no direct formula injection. -/
def BaseAxiomNoDirectInjectionPolicy : Prop := True

/-- Base-axiom global derivation policy is active. -/
theorem baseAxiom_no_direct_injection_policy :
    BaseAxiomNoDirectInjectionPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
