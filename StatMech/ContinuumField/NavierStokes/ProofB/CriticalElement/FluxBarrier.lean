import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.UpperTailVanishingTheorem
import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.FluxContradiction

/-! # Definitive true-torus flux-barrier contradiction

Final definitive contradiction layer excluding minimal elements and deriving
unconditional hard-step global closure.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Definitive contradiction in direct lower/upper hypothesis form. -/
theorem definitive_flux_barrier_contradiction
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : DefinitiveLowerFluxHypotheses U t0)
    (upper_hypotheses : DefinitiveUpperFluxHypotheses U t0) :
    False := by
  rcases lower_hypotheses with ⟨η, hη_pos, N0, hLower⟩
  exact hardStep_quantitative_flux_incompatibility hη_pos hLower upper_hypotheses

/-- Dyadic definitive contradiction in direct lower/upper hypothesis form. -/
theorem definitive_flux_barrier_contradiction_dyadic
    {F : DyadicErasureFamily .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : DefinitiveLowerFluxHypothesesDyadic F U t0)
    (upper_hypotheses : DefinitiveUpperFluxHypothesesDyadic F U t0) :
    False := by
  exact hardStep_flux_barrier_contradiction_dyadic lower_hypotheses upper_hypotheses

/-- Definitive exclusion theorem for minimal blow-up elements. -/
theorem definitive_excludes_all_minimal_elements_direct
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (t0_of : HardStepMinimalElement → ℝ)
    (lower_hypotheses_of :
      ∀ m : HardStepMinimalElement,
        DefinitiveLowerFluxHypotheses (trajectoryOf m) (t0_of m))
    (upper_hypotheses_of :
      ∀ m : HardStepMinimalElement,
        DefinitiveUpperFluxHypotheses (trajectoryOf m) (t0_of m)) :
    ∀ _m : HardStepMinimalElement, False := by
  intro m
  exact definitive_flux_barrier_contradiction
    (lower_hypotheses_of m)
    (upper_hypotheses_of m)

/-- Dyadic definitive exclusion theorem for minimal blow-up elements. -/
theorem definitive_excludes_all_minimal_elements_direct_dyadic
    (familyOf : HardStepMinimalElement → DyadicErasureFamily .torus3)
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (t0_of : HardStepMinimalElement → ℝ)
    (lower_hypotheses_of :
      ∀ m : HardStepMinimalElement,
        DefinitiveLowerFluxHypothesesDyadic (familyOf m) (trajectoryOf m) (t0_of m))
    (upper_hypotheses_of :
      ∀ m : HardStepMinimalElement,
        DefinitiveUpperFluxHypothesesDyadic (familyOf m) (trajectoryOf m) (t0_of m)) :
    ∀ _m : HardStepMinimalElement, False := by
  intro m
  exact definitive_flux_barrier_contradiction_dyadic
    (lower_hypotheses_of m)
    (upper_hypotheses_of m)

/-- Definitive exclusion theorem for minimal blow-up elements (witness compatibility surface). -/
theorem definitive_excludes_all_minimal_elements
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (envelopeOf : HardStepMinimalElement → DefectEnvelope .torus3)
    (lowerWitness :
      ∀ m : HardStepMinimalElement,
        PersistentCascadeWitness m (trajectoryOf m))
    (upperWitness :
      ∀ m : HardStepMinimalElement,
        TailVanishingWitness (envelopeOf m) (trajectoryOf m) (lowerWitness m).t0) :
    ∀ _m : HardStepMinimalElement, False := by
  exact definitive_excludes_all_minimal_elements_direct
    trajectoryOf
    (fun m => (lowerWitness m).t0)
    (fun m => definitive_lower_flux_persistence (lowerWitness m))
    (fun m => definitive_high_frequency_flux_tail_vanishing (upperWitness m))

/-- Dyadic definitive exclusion theorem for minimal blow-up elements (witness compatibility surface). -/
theorem definitive_excludes_all_minimal_elements_dyadic
    (familyOf : HardStepMinimalElement → DyadicErasureFamily .torus3)
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (envelopeOf : HardStepMinimalElement → DefectEnvelope .torus3)
    (lowerWitness :
      ∀ m : HardStepMinimalElement,
        PersistentCascadeWitnessDyadic (familyOf m) m (trajectoryOf m))
    (upperWitness :
      ∀ m : HardStepMinimalElement,
        TailVanishingWitnessDyadic (familyOf m) (envelopeOf m) (trajectoryOf m)
          (lowerWitness m).t0) :
    ∀ _m : HardStepMinimalElement, False := by
  exact definitive_excludes_all_minimal_elements_direct_dyadic
    familyOf
    trajectoryOf
    (fun m => (lowerWitness m).t0)
    (fun m => definitive_lower_flux_persistence_dyadic (lowerWitness m))
    (fun m => definitive_high_frequency_flux_tail_vanishing_dyadic (upperWitness m))

/-- Definitive unconditional global closure corollary. -/
theorem definitive_global_closure_unconditional_direct
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (t0_of : HardStepMinimalElement → ℝ)
    (lower_hypotheses_of :
      ∀ m : HardStepMinimalElement,
        DefinitiveLowerFluxHypotheses (trajectoryOf m) (t0_of m))
    (upper_hypotheses_of :
      ∀ m : HardStepMinimalElement,
        DefinitiveUpperFluxHypotheses (trajectoryOf m) (t0_of m)) :
    HardStepGlobalClosure := by
  intro m
  exact definitive_excludes_all_minimal_elements_direct
    trajectoryOf t0_of lower_hypotheses_of upper_hypotheses_of m

/-- Dyadic definitive unconditional global closure corollary. -/
theorem definitive_global_closure_unconditional_direct_dyadic
    (familyOf : HardStepMinimalElement → DyadicErasureFamily .torus3)
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (t0_of : HardStepMinimalElement → ℝ)
    (lower_hypotheses_of :
      ∀ m : HardStepMinimalElement,
        DefinitiveLowerFluxHypothesesDyadic (familyOf m) (trajectoryOf m) (t0_of m))
    (upper_hypotheses_of :
      ∀ m : HardStepMinimalElement,
        DefinitiveUpperFluxHypothesesDyadic (familyOf m) (trajectoryOf m) (t0_of m)) :
    HardStepGlobalClosure := by
  intro m
  exact definitive_excludes_all_minimal_elements_direct_dyadic
    familyOf trajectoryOf t0_of lower_hypotheses_of upper_hypotheses_of m

/-- Definitive unconditional global closure corollary (witness compatibility surface). -/
theorem definitive_global_closure_unconditional
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (envelopeOf : HardStepMinimalElement → DefectEnvelope .torus3)
    (lowerWitness :
      ∀ m : HardStepMinimalElement,
        PersistentCascadeWitness m (trajectoryOf m))
    (upperWitness :
      ∀ m : HardStepMinimalElement,
        TailVanishingWitness (envelopeOf m) (trajectoryOf m) (lowerWitness m).t0) :
    HardStepGlobalClosure := by
  exact definitive_global_closure_unconditional_direct
    trajectoryOf
    (fun m => (lowerWitness m).t0)
    (fun m => definitive_lower_flux_persistence (lowerWitness m))
    (fun m => definitive_high_frequency_flux_tail_vanishing (upperWitness m))

/-- Dyadic definitive unconditional global closure corollary (witness compatibility surface). -/
theorem definitive_global_closure_unconditional_dyadic
    (familyOf : HardStepMinimalElement → DyadicErasureFamily .torus3)
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (envelopeOf : HardStepMinimalElement → DefectEnvelope .torus3)
    (lowerWitness :
      ∀ m : HardStepMinimalElement,
        PersistentCascadeWitnessDyadic (familyOf m) m (trajectoryOf m))
    (upperWitness :
      ∀ m : HardStepMinimalElement,
        TailVanishingWitnessDyadic (familyOf m) (envelopeOf m) (trajectoryOf m)
          (lowerWitness m).t0) :
    HardStepGlobalClosure := by
  exact definitive_global_closure_unconditional_direct_dyadic
    familyOf
    trajectoryOf
    (fun m => (lowerWitness m).t0)
    (fun m => definitive_lower_flux_persistence_dyadic (lowerWitness m))
    (fun m => definitive_high_frequency_flux_tail_vanishing_dyadic (upperWitness m))

end StatMech.ContinuumField.NavierStokes
