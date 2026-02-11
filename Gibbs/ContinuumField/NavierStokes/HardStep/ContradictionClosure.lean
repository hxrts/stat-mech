import Gibbs.ContinuumField.NavierStokes.HardStep.TailVanishing

/-! # Hard-step contradiction and closure

Final contradiction theorem combining lower-bound rigidity with upper-tail
vanishing, and global-closure corollaries.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Core hard-step contradiction: persistent cascade lower bound vs vanishing tail. -/
theorem hardStep_flux_barrier_contradiction
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    (Wlower : PersistentCascadeWitness m U)
    (Wupper : TailVanishingWitness E U Wlower.t0) :
    False := by
  have htwo_pos : 0 < (2 : ℝ) := by norm_num
  have hhalf_pos : 0 < Wlower.η / 2 := div_pos Wlower.η_pos htwo_pos
  rcases (scaleFlux_tail_vanishes Wupper) (Wlower.η / 2) hhalf_pos with ⟨N1, hN1⟩
  let N : Nat := max Wlower.N0 N1
  have hlow : Wlower.η ≤ |scaleFlux N Wlower.t0 U| :=
    Wlower.persistent_flux N (le_max_left _ _)
  have hhigh : |scaleFlux N Wlower.t0 U| ≤ Wlower.η / 2 :=
    hN1 N (le_max_right _ _)
  have hη_half : Wlower.η ≤ Wlower.η / 2 := le_trans hlow hhigh
  exact (not_le_of_gt (half_lt_self Wlower.η_pos)) hη_half

/-- Hard-step global-closure statement: no minimal element can survive the flux barrier. -/
def HardStepGlobalClosure : Prop :=
  ∀ _m : HardStepMinimalElement, False

/-- Data package needed to derive hard-step global closure from flux contradiction. -/
structure HardStepFluxContradictionPackage where
  trajectoryOf : HardStepMinimalElement → VelocityTrajectory .torus3
  envelopeOf : HardStepMinimalElement → DefectEnvelope .torus3
  lowerWitness :
    ∀ m : HardStepMinimalElement,
      PersistentCascadeWitness m (trajectoryOf m)
  upperWitness :
    ∀ m : HardStepMinimalElement,
      TailVanishingWitness (envelopeOf m) (trajectoryOf m) (lowerWitness m).t0

/-- Global closure corollary from the hard-step flux contradiction package. -/
theorem hardStep_global_closure_of_flux_barrier
    (P : HardStepFluxContradictionPackage) :
    HardStepGlobalClosure := by
  intro m
  exact hardStep_flux_barrier_contradiction (P.lowerWitness m) (P.upperWitness m)

end Gibbs.ContinuumField.NavierStokes
