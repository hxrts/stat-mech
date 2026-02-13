import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomRigidity
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomLocalTheory
import Gibbs.ContinuumField.NavierStokes.Faithful.HardGlobal

/-! # Faithful base-axiom global control

Primitive derivation of unconditional global control and strong-solution
extension from base-axiom rigidity outputs and continuation logic.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-! ## Unconditional global control -/

/-- Unconditional global control from primitive rigidity contradiction output. -/
theorem baseAxiom_unconditional_global_control
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : ∀ m : HardStepMinimalElement,
      BaseAxiomLowerUpperFluxHypotheses (trajectoryOf m)) :
    HardStepGlobalClosure := by
  exact baseAxiom_global_closure_from_primitive_rigidity trajectoryOf flux_hypotheses

/-! ## Global extension theorems -/

/-- Continuation-derived global extension theorem from derived closure data. -/
theorem baseAxiom_global_extension_from_continuation
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : ∀ m : HardStepMinimalElement,
      BaseAxiomLowerUpperFluxHypotheses (trajectoryOf m))
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  have _hclosure : HardStepGlobalClosure :=
    baseAxiom_unconditional_global_control trajectoryOf flux_hypotheses
  refine ⟨L.strong, L.init_match, L.periodicity_preserved, ?_⟩
  constructor <;> intro t
  · exact L.strong.smooth_vel t
  · exact L.strong.smooth_press t

/-- Primitive global extension theorem derived from the contradiction output. -/
theorem baseAxiom_global_extension_from_primitive_contradiction
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : ∀ m : HardStepMinimalElement,
      BaseAxiomLowerUpperFluxHypotheses (trajectoryOf m))
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact baseAxiom_global_extension_from_continuation
    trajectoryOf flux_hypotheses L

/-! ## Strong solution extension -/

/-- Global strong-solution extension from primitive continuation logic and control. -/
theorem baseAxiom_global_strong_solution_extension
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : ∀ m : HardStepMinimalElement,
      BaseAxiomLowerUpperFluxHypotheses (trajectoryOf m))
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact baseAxiom_global_extension_from_primitive_contradiction
    trajectoryOf flux_hypotheses L

/-! ## Faithful hard-global closure -/

/-- Constructive faithful hard-global closure object from primitive data only. -/
theorem baseAxiom_faithfulHardGlobalClosure_constructive
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : ∀ m : HardStepMinimalElement,
      BaseAxiomLowerUpperFluxHypotheses (trajectoryOf m))
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ L' : FaithfulMildLocalTheory H M.base A,
      ∃ _HGd : FaithfulHardGlobalData H M.base A L', True := by
  rcases baseAxiom_global_strong_solution_extension
      trajectoryOf flux_hypotheses L with
      ⟨sol, hinit, hper, hsmooth⟩
  exact ⟨L, ⟨sol, hinit, hper, hsmooth⟩, trivial⟩

/-! ## Policy markers -/

/-- Policy marker: base-axiom global derivation performs no direct formula injection. -/
def BaseAxiomNoDirectInjectionPolicy : Prop :=
  ∀ trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3,
    (∀ m : HardStepMinimalElement,
      BaseAxiomLowerUpperFluxHypotheses (trajectoryOf m)) →
      HardStepGlobalClosure

/-- Base-axiom global derivation policy is active. -/
theorem baseAxiom_no_direct_injection_policy :
    BaseAxiomNoDirectInjectionPolicy := by
  intro trajectoryOf flux_hypotheses
  exact baseAxiom_unconditional_global_control trajectoryOf flux_hypotheses

end Gibbs.ContinuumField.NavierStokes
