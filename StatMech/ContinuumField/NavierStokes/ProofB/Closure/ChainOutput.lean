import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.FluxBarrier

/-! # Definitive threshold-chain output theorem surface

Hard-step definitive theorem-level surface producing explicit threshold/minimal
flux-chain outputs, independent of faithful endpoint plumbing.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Definitive theorem-level threshold/minimal flux-chain output. -/
abbrev DefinitiveThresholdMinimalFluxChainOutput : Prop :=
  ∃ threshold : CriticalThresholdData,
    ∃ _minimizing : MinimizingProfileSequence threshold,
      ∃ _minimal_element : HardStepMinimalElement,
        ∀ _m : HardStepMinimalElement,
          ∃ U : VelocityTrajectory .torus3,
            ∃ t0 : ℝ,
              DefinitiveLowerFluxHypotheses U t0 ∧
              DefinitiveUpperFluxHypotheses U t0

/-- Dyadic definitive theorem-level threshold/minimal flux-chain output. -/
abbrev DefinitiveThresholdMinimalFluxChainOutputDyadic : Prop :=
  ∃ threshold : CriticalThresholdData,
    ∃ _minimizing : MinimizingProfileSequence threshold,
      ∃ _minimal_element : HardStepMinimalElement,
        ∀ _m : HardStepMinimalElement,
          ∃ F : DyadicErasureFamily .torus3,
            ∃ U : VelocityTrajectory .torus3,
              ∃ t0 : ℝ,
                DefinitiveLowerFluxHypothesesDyadic F U t0 ∧
                DefinitiveUpperFluxHypothesesDyadic F U t0

/-- Build definitive threshold/minimal flux-chain output from direct theorem components. -/
theorem definitive_threshold_minimal_flux_chain_output_of_direct_components
    (threshold : CriticalThresholdData)
    (minimizing : MinimizingProfileSequence threshold)
    (minimal_element : HardStepMinimalElement)
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (t0_of : HardStepMinimalElement → ℝ)
    (lower_hypotheses_of :
      ∀ m : HardStepMinimalElement,
        DefinitiveLowerFluxHypotheses (trajectoryOf m) (t0_of m))
    (upper_hypotheses_of :
      ∀ m : HardStepMinimalElement,
        DefinitiveUpperFluxHypotheses (trajectoryOf m) (t0_of m)) :
    DefinitiveThresholdMinimalFluxChainOutput := by
  refine ⟨threshold, minimizing, minimal_element, ?_⟩
  intro m
  exact ⟨trajectoryOf m, t0_of m, lower_hypotheses_of m, upper_hypotheses_of m⟩

/-- Build dyadic definitive threshold/minimal flux-chain output from direct theorem components. -/
theorem definitive_threshold_minimal_flux_chain_output_of_direct_components_dyadic
    (threshold : CriticalThresholdData)
    (minimizing : MinimizingProfileSequence threshold)
    (minimal_element : HardStepMinimalElement)
    (familyOf : HardStepMinimalElement → DyadicErasureFamily .torus3)
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (t0_of : HardStepMinimalElement → ℝ)
    (lower_hypotheses_of :
      ∀ m : HardStepMinimalElement,
        DefinitiveLowerFluxHypothesesDyadic (familyOf m) (trajectoryOf m) (t0_of m))
    (upper_hypotheses_of :
      ∀ m : HardStepMinimalElement,
        DefinitiveUpperFluxHypothesesDyadic (familyOf m) (trajectoryOf m) (t0_of m)) :
    DefinitiveThresholdMinimalFluxChainOutputDyadic := by
  refine ⟨threshold, minimizing, minimal_element, ?_⟩
  intro m
  exact ⟨familyOf m, trajectoryOf m, t0_of m, lower_hypotheses_of m, upper_hypotheses_of m⟩

/-- Build definitive threshold/minimal flux-chain output from witness-level rigidity/tail data. -/
theorem definitive_threshold_minimal_flux_chain_output_of_witness_components
    (threshold : CriticalThresholdData)
    (minimizing : MinimizingProfileSequence threshold)
    (minimal_element : HardStepMinimalElement)
    (trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3)
    (envelopeOf : HardStepMinimalElement → DefectEnvelope .torus3)
    (lowerWitness :
      ∀ m : HardStepMinimalElement,
        PersistentCascadeWitness m (trajectoryOf m))
    (upperWitness :
      ∀ m : HardStepMinimalElement,
        TailVanishingWitness (envelopeOf m) (trajectoryOf m) (lowerWitness m).t0) :
    DefinitiveThresholdMinimalFluxChainOutput := by
  refine definitive_threshold_minimal_flux_chain_output_of_direct_components
    threshold
    minimizing
    minimal_element
    trajectoryOf
    (fun m => (lowerWitness m).t0)
    (fun m => definitive_lower_flux_persistence (lowerWitness m))
    (fun m => definitive_high_frequency_flux_tail_vanishing (upperWitness m))

/-- Build dyadic definitive threshold/minimal flux-chain output from witness-level rigidity/tail data. -/
theorem definitive_threshold_minimal_flux_chain_output_of_witness_components_dyadic
    (threshold : CriticalThresholdData)
    (minimizing : MinimizingProfileSequence threshold)
    (minimal_element : HardStepMinimalElement)
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
    DefinitiveThresholdMinimalFluxChainOutputDyadic := by
  refine definitive_threshold_minimal_flux_chain_output_of_direct_components_dyadic
    threshold
    minimizing
    minimal_element
    familyOf
    trajectoryOf
    (fun m => (lowerWitness m).t0)
    (fun m => definitive_lower_flux_persistence_dyadic (lowerWitness m))
    (fun m => definitive_high_frequency_flux_tail_vanishing_dyadic (upperWitness m))

end StatMech.ContinuumField.NavierStokes
