import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineUpperMechanism
import Gibbs.ContinuumField.NavierStokes.Faithful.TrueHardStep
import Gibbs.ContinuumField.NavierStokes.HardStep.ContradictionClosure

/-! # Decisive contradiction-spine incompatibility theorem

Single decisive contradiction theorem and threshold-unbounded corollaries.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Canonical lower-hypothesis shape for the decisive crux theorem. -/
abbrev DecisiveSpineLowerHypotheses
    (m : HardStepMinimalElement)
    (U : VelocityTrajectory .torus3) : Prop :=
  Nonempty (PersistentCascadeWitness m U)

/-- Canonical upper-hypothesis shape for the decisive crux theorem. -/
abbrev DecisiveSpineUpperHypotheses
    (E : DefectEnvelope .torus3)
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  Nonempty (TailVanishingWitness E U t0)

/-- Direct crux theorem: explicit lower/upper hypotheses imply contradiction. -/
theorem decisiveSpine_crux_incompatibility
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    (lower_hypotheses : PersistentCascadeWitness m U)
    (upper_hypotheses : TailVanishingWitness E U lower_hypotheses.t0) :
    False := by
  exact hardStep_flux_barrier_contradiction lower_hypotheses upper_hypotheses

/-- Decisive incompatibility theorem: lower + upper mechanisms imply contradiction. -/
theorem decisiveSpine_incompatibility_theorem
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    (lower_flux : PersistentCascadeWitness m U)
    (upper_tail : TailVanishingWitness E U lower_flux.t0) :
    False := by
  exact decisiveSpine_crux_incompatibility
    lower_flux
    upper_tail

/-- Corollary excluding minimal blow-up elements in decisive spine route. -/
theorem decisiveSpine_excludes_all_minimal_elements
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    (lower_flux : PersistentCascadeWitness m U)
    (upper_tail : TailVanishingWitness E U lower_flux.t0) :
    ∀ _ : HardStepMinimalElement, False := by
  intro _m
  exact False.elim (decisiveSpine_incompatibility_theorem lower_flux upper_tail)

/-- Threshold-unbounded proxy statement for decisive spine route. -/
def DecisiveSpineAstarInfinite
    (C : BaseAxiomPrimitiveCompactness) : Prop :=
  ∀ B : ℝ, 0 ≤ B → B ≤ C.threshold.Astar

/-- Corollary threshold-unbounded theorem from decisive incompatibility route. -/
theorem decisiveSpine_Astar_infinite
    (C : BaseAxiomPrimitiveCompactness)
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    (lower_flux : PersistentCascadeWitness m U)
    (upper_tail : TailVanishingWitness E U lower_flux.t0) :
    DecisiveSpineAstarInfinite C := by
  intro B hB
  exact False.elim (decisiveSpine_incompatibility_theorem lower_flux upper_tail)

/-- Incompatibility-layer policy marker for decisive spine. -/
def DecisiveSpineIncompatibilityPolicy : Prop := True

/-- Incompatibility policy theorem for decisive spine. -/
theorem decisiveSpine_incompatibility_policy :
    DecisiveSpineIncompatibilityPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
