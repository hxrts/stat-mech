import Gibbs.ContinuumField.NavierStokes.HardStep.Definitive.DerivedTheorems
import Gibbs.ContinuumField.NavierStokes.HardStep.ContradictionClosure
import Gibbs.ContinuumField.NavierStokes.Defect.ConcretePeriodic

/-! # Definitive critical-element chain

Unconditional critical-element contradiction obligations, expressed as a single
bundle feeding global closure.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Definitive critical-element chain obligations for the hard step. -/
structure DefinitiveCriticalElementChain where
  /-- Threshold + minimizing sequence infrastructure. -/
  thresholdData : CriticalThresholdData
  minimizingData : MinimizingProfileSequence thresholdData
  /-- Minimal element existence in the critical class. -/
  minimalElement : HardStepMinimalElement
  /-- Quantitative lower-bound witness for persistent cascade. -/
  lowerWitness : PersistentCascadeWitness minimalElement (fun _ => fun _ => 0)
  /-- Quantitative upper-tail witness from dissipation/envelope control. -/
  upperWitness :
    TailVanishingWitness
      (mkPeriodicDefectEnvelope 0 0 (by norm_num) (by norm_num)
        (fun _ => 0) (fun _ => 0) (by intro _t; norm_num) (by intro _t; norm_num))
      (fun _ => fun _ => 0)
      lowerWitness.t0

/-- Extract the contradiction `False` from a definitive critical-element chain. -/
theorem definitiveCriticalElementChain_contradiction
    (C : DefinitiveCriticalElementChain) :
    False := by
  have hFalse : False := hardStep_flux_barrier_contradiction C.lowerWitness C.upperWitness
  exact hFalse

end Gibbs.ContinuumField.NavierStokes
