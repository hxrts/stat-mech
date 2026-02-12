import Gibbs.ContinuumField.NavierStokes.Faithful.CriticalEngine
import Gibbs.ContinuumField.NavierStokes.HardStep.MinimalElement

/-! # Decisive critical-element construction

Concrete critical-element chain for the decisive faithful path.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Decisive critical-element chain. -/
structure DecisiveCriticalElementChain
    (H : ClayBHypotheses)
    (M : DecisiveFaithfulPeriodicModel H)
    (_E : DecisiveCriticalAnalyticEngine H M) where
  profile_data : ProfileDecompositionData
  orthogonality_decoupling :
    ∀ j k, j ≠ k →
      (profile_data.profile j originCoord3 0) * (profile_data.profile k originCoord3 0) = 0
  threshold : CriticalThresholdData
  minimizing_sequence : MinimizingSequenceAtThreshold threshold
  minimal_element : HardStepMinimalElement
  minimal_from_threshold : Prop
  minimal_from_threshold_holds : minimal_from_threshold
  almost_periodic : AlmostPeriodicModuloSymmetry minimal_element.profile

/-- Decisive profile decomposition interface. -/
def decisive_profile_decomposition
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {E : DecisiveCriticalAnalyticEngine H M}
    (C : DecisiveCriticalElementChain H M E) :
    ProfileDecompositionData :=
  C.profile_data

/-- Decisive threshold and minimizing-sequence theorem interface. -/
theorem decisive_threshold_minimizing_sequence
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {E : DecisiveCriticalAnalyticEngine H M}
    (C : DecisiveCriticalElementChain H M E) :
    ∃ T : CriticalThresholdData,
      ∃ _S : MinimizingSequenceAtThreshold T, True := by
  exact ⟨C.threshold, C.minimizing_sequence, trivial⟩

/-- Decisive minimal-element construction theorem interface. -/
theorem decisive_minimal_element_construction
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {E : DecisiveCriticalAnalyticEngine H M}
    (C : DecisiveCriticalElementChain H M E) :
    ∃ m : HardStepMinimalElement, AlmostPeriodicModuloSymmetry m.profile := by
  exact ⟨C.minimal_element, C.almost_periodic⟩

end Gibbs.ContinuumField.NavierStokes
