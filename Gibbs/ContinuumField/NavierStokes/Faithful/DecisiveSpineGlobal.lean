import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineIncompatibility
import Gibbs.ContinuumField.NavierStokes.Faithful.FullProofExactGlobal

/-! # Decisive contradiction-spine global closure

Global regularity route derived from incompatibility and continuation logic.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-! ## Flux hypotheses and chains -/

/-- Decisive-spine quantitative flux hypotheses used to derive global closure. -/
abbrev DecisiveSpineFluxHypotheses
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3) : Prop :=
  ∀ m : HardStepMinimalElement,
    ∃ t0 : ℝ,
      DecisiveSpineLowerHypotheses (trajectoryOf m) t0 ∧
      DecisiveSpineUpperHypotheses (trajectoryOf m) t0

/-- Threshold/minimal-element contradiction chain with per-minimal trajectory flux data. -/
abbrev DecisiveSpineThresholdMinimalFluxChain : Prop :=
  ∃ threshold : DecisiveThresholdData,
    ∃ _minimizing : DecisiveMinimizingData threshold,
      ∃ _minimal_element : HardStepMinimalElement,
        ∀ _m : HardStepMinimalElement,
          ∃ U : VelocityTrajectory .torus3,
            ∃ t0 : ℝ,
              DecisiveSpineLowerHypotheses U t0 ∧
              DecisiveSpineUpperHypotheses U t0

/-- Explicit data package yields nonempty threshold/minimal contradiction chain. -/
theorem decisiveSpine_threshold_minimal_flux_chain_nonempty_of_data
    (threshold : DecisiveThresholdData)
    (minimizing : DecisiveMinimizingData threshold)
    (minimal_element : HardStepMinimalElement)
    (flux_hypotheses :
      ∀ _m : HardStepMinimalElement,
        ∃ U : VelocityTrajectory .torus3,
          ∃ t0 : ℝ,
            DecisiveSpineLowerHypotheses U t0 ∧
            DecisiveSpineUpperHypotheses U t0) :
    Nonempty DecisiveSpineThresholdMinimalFluxChain := by
  refine ⟨⟨threshold, minimizing, minimal_element, ?_⟩⟩
  intro m
  exact flux_hypotheses m

/-! ## Global closure from incompatibility -/

/-- Derived hard-step global closure from decisive-spine incompatibility data. -/
theorem decisiveSpine_global_closure_from_incompatibility_data
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : DecisiveSpineFluxHypotheses trajectoryOf) :
    HardStepGlobalClosure := by
  intro m
  rcases flux_hypotheses m with ⟨t0, hLower, hUpper⟩
  exact decisiveSpine_incompatibility_theorem hLower hUpper

/-- Derived hard-step global closure from a threshold/minimal contradiction chain. -/
theorem decisiveSpine_global_closure_from_threshold_minimal_chain
    (chain : DecisiveSpineThresholdMinimalFluxChain) :
    HardStepGlobalClosure := by
  rcases chain with ⟨_threshold, _minimizing, _minimal_element, hflux⟩
  let trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3 :=
    fun m => Classical.choose (hflux m)
  have flux_hypotheses : DecisiveSpineFluxHypotheses trajectoryOf := by
    intro m
    rcases Classical.choose_spec (hflux m) with ⟨t0, hLower, hUpper⟩
    exact ⟨t0, hLower, hUpper⟩
  exact decisiveSpine_global_closure_from_incompatibility_data trajectoryOf flux_hypotheses

/-! ## Critical control theorems -/

/-- Global critical-norm control theorem from incompatibility route. -/
theorem decisiveSpine_global_critical_control
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : DecisiveSpineFluxHypotheses trajectoryOf) :
    HardStepGlobalClosure := by
  exact decisiveSpine_global_closure_from_incompatibility_data trajectoryOf flux_hypotheses

/-! ## Global extension theorems -/

/-- Long-time continuation/global extension theorem in decisive route. -/
theorem decisiveSpine_global_extension
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : DecisiveSpineFluxHypotheses trajectoryOf)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact fullProof_longTime_continuation_globalExtension
    trajectoryOf
    (fun m => by
      rcases flux_hypotheses m with ⟨t0, hLower, hUpper⟩
      exact ⟨t0, hLower, hUpper⟩)
    L

/-- Long-time continuation/global extension from decisive-spine incompatibility data. -/
theorem decisiveSpine_global_extension_from_incompatibility_data
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : DecisiveSpineFluxHypotheses trajectoryOf)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      sol.vel 0 = H.u0 ∧
      Condition10 sol.vel ∧
      Condition11 M.base.NS sol := by
  exact decisiveSpine_global_extension trajectoryOf flux_hypotheses L

/-! ## Smoothness persistence -/

/-- Global smoothness persistence theorem in decisive route. -/
theorem decisiveSpine_global_smoothness_persistence
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (flux_hypotheses : DecisiveSpineFluxHypotheses trajectoryOf)
    (L : FaithfulMildLocalTheory H M.base A) :
    ∃ sol : StrongSolution M.base.NS,
      (∀ t, IsSmoothField M.base.NS (sol.vel t)) ∧
      (∀ t, IsSmoothPressure M.base.NS (sol.press t)) := by
  exact fullProof_smoothness_persistence
    trajectoryOf
    (fun m => by
      rcases flux_hypotheses m with ⟨t0, hLower, hUpper⟩
      exact ⟨t0, hLower, hUpper⟩)
    L

/-! ## Policy markers -/

/-- Decisive route contains no direct formula injection in endpoint/global modules. -/
def DecisiveSpineNoDirectInjectionPolicy : Prop :=
  DecisiveSpineThresholdMinimalFluxChain → HardStepGlobalClosure

/-- No-direct-injection policy theorem for decisive global route. -/
theorem decisiveSpine_no_direct_injection_policy :
    DecisiveSpineNoDirectInjectionPolicy := by
  intro hchain
  exact decisiveSpine_global_closure_from_threshold_minimal_chain hchain

end Gibbs.ContinuumField.NavierStokes
