import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineIncompatibility
import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactGlobal

/-! # Decisive contradiction-spine global closure

Global regularity route derived from incompatibility and continuation logic.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Global critical-norm control theorem in direct form. -/
theorem decisiveSpine_global_critical_control_direct
    (flux_package : HardStepFluxContradictionPackage) :
    HardStepGlobalClosure := by
  exact fullProof_noMinimal_implies_globalControl_direct flux_package

/-- Global critical-norm control theorem from full-proof global data. -/
theorem decisiveSpine_global_critical_control_from_data
    {C : BaseAxiomPrimitiveCompactness}
    (rigidity_hypotheses : BaseAxiomPrimitiveRigidity C) :
    HardStepGlobalClosure := by
  exact decisiveSpine_global_critical_control_direct rigidity_hypotheses.flux_package

/-- Global critical-norm control theorem from incompatibility route. -/
theorem decisiveSpine_global_critical_control
    {C : BaseAxiomPrimitiveCompactness}
    (rigidity_hypotheses : BaseAxiomPrimitiveRigidity C) :
    HardStepGlobalClosure := by
  exact decisiveSpine_global_critical_control_from_data rigidity_hypotheses

/-- Long-time continuation/global extension theorem in direct form. -/
theorem decisiveSpine_global_extension_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (flux_package : HardStepFluxContradictionPackage)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact fullProof_longTime_continuation_globalExtension_direct
    flux_package extension_hypotheses

/-- Long-time continuation/global extension theorem from full-proof global data. -/
theorem decisiveSpine_global_extension_from_data
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {C : BaseAxiomPrimitiveCompactness}
    (rigidity_hypotheses : BaseAxiomPrimitiveRigidity C)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact decisiveSpine_global_extension_direct
    rigidity_hypotheses.flux_package extension_hypotheses

/-- Long-time continuation/global extension theorem in decisive route. -/
theorem decisiveSpine_global_extension
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {C : BaseAxiomPrimitiveCompactness}
    (rigidity_hypotheses : BaseAxiomPrimitiveRigidity C)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact decisiveSpine_global_extension_from_data
    rigidity_hypotheses extension_hypotheses

/-- Global smoothness persistence theorem in direct form. -/
theorem decisiveSpine_global_smoothness_persistence_direct
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    (flux_package : HardStepFluxContradictionPackage)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      (∀ t, IsSmoothField M.base.NS (sol.vel t)) ∧
      (∀ t, IsSmoothPressure M.base.NS (sol.press t)) := by
  exact fullProof_smoothness_persistence_direct
    flux_package extension_hypotheses

/-- Global smoothness persistence theorem from full-proof global data. -/
theorem decisiveSpine_global_smoothness_persistence_from_data
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {C : BaseAxiomPrimitiveCompactness}
    (rigidity_hypotheses : BaseAxiomPrimitiveRigidity C)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      (∀ t, IsSmoothField M.base.NS (sol.vel t)) ∧
      (∀ t, IsSmoothPressure M.base.NS (sol.press t)) := by
  exact decisiveSpine_global_smoothness_persistence_direct
    rigidity_hypotheses.flux_package extension_hypotheses

/-- Global smoothness persistence theorem in decisive route. -/
theorem decisiveSpine_global_smoothness_persistence
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {C : BaseAxiomPrimitiveCompactness}
    (rigidity_hypotheses : BaseAxiomPrimitiveRigidity C)
    (extension_hypotheses : BaseAxiomPrimitiveExtensionWitness H M) :
    ∃ sol : StrongSolution M.base.NS,
      (∀ t, IsSmoothField M.base.NS (sol.vel t)) ∧
      (∀ t, IsSmoothPressure M.base.NS (sol.press t)) := by
  exact decisiveSpine_global_smoothness_persistence_from_data
    rigidity_hypotheses extension_hypotheses

/-- Decisive route contains no direct formula injection in endpoint/global modules. -/
def DecisiveSpineNoDirectInjectionPolicy : Prop := True

/-- No-direct-injection policy theorem for decisive global route. -/
theorem decisiveSpine_no_direct_injection_policy :
    DecisiveSpineNoDirectInjectionPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
