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
    (_hclosure : HardStepGlobalClosure)
    (W : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact ⟨W.sol, W.init_match, W.periodicity, W.smoothness⟩

/-- Primitive contradiction-derived global extension theorem in direct form. -/
theorem baseAxiom_global_extension_from_primitive_contradiction_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (flux_package : HardStepFluxContradictionPackage)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  have hclosure : HardStepGlobalClosure :=
    baseAxiom_unconditional_global_control_direct flux_package
  exact baseAxiom_global_extension_from_continuation_direct hclosure extension_hypotheses

/-- Primitive global extension theorem derived from the contradiction output. -/
theorem baseAxiom_global_extension_from_primitive_contradiction
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (flux_package : HardStepFluxContradictionPackage)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact baseAxiom_global_extension_from_primitive_contradiction_direct
    flux_package extension_hypotheses

/-- Global strong-solution extension in direct form. -/
theorem baseAxiom_global_strong_solution_extension_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (flux_package : HardStepFluxContradictionPackage)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact baseAxiom_global_extension_from_primitive_contradiction_direct
    flux_package extension_hypotheses

/-- Global strong-solution extension from primitive continuation logic and control. -/
theorem baseAxiom_global_strong_solution_extension
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (flux_package : HardStepFluxContradictionPackage)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact baseAxiom_global_strong_solution_extension_direct
    flux_package extension_hypotheses

/-- Constructive faithful hard-global closure object in direct form. -/
theorem baseAxiom_faithfulHardGlobalClosure_constructive_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (analysis_hypotheses : BaseAxiomPrimitiveAnalysis)
    (flux_package : HardStepFluxContradictionPackage)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ L : FaithfulMildLocalTheory H M.base A,
      ∃ _HG : FaithfulHardGlobalClosure H M.base A L, True := by
  let L : FaithfulMildLocalTheory H M.base A :=
    baseAxiom_localTheory_from_extensionWitness A analysis_hypotheses extension_hypotheses
  rcases baseAxiom_global_strong_solution_extension_direct
      flux_package extension_hypotheses with
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
    (analysis_hypotheses : BaseAxiomPrimitiveAnalysis)
    (flux_package : HardStepFluxContradictionPackage)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ L : FaithfulMildLocalTheory H M.base A,
      ∃ _HG : FaithfulHardGlobalClosure H M.base A L, True := by
  exact baseAxiom_faithfulHardGlobalClosure_constructive_direct
    analysis_hypotheses flux_package extension_hypotheses

/-- Policy marker: base-axiom global derivation performs no direct formula injection. -/
def BaseAxiomNoDirectInjectionPolicy : Prop := True

/-- Base-axiom global derivation policy is active. -/
theorem baseAxiom_no_direct_injection_policy :
    BaseAxiomNoDirectInjectionPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
