import Gibbs.ContinuumField.NavierStokes.Defect.Continuation

/-! # Global closure attempt

Interface for the key closure step: turning defect control into global
regularity continuation.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Hypothesis asserting global-in-time closure of the defect envelope. -/
structure GlobalClosureHypothesis {D : SpatialDomain3} (NS : IncompressibleNavierStokes D) where
  /-- Strong solution trajectory controlled by the envelope. -/
  sol : StrongSolution NS
  /-- The envelope whose control is assumed globally. -/
  envelope : DefectEnvelope D
  /-- Global control statement. -/
  globally_controlled : IsGloballyBoundedEnvelope envelope
  /-- Link between physical critical norm and envelope-tracked resolved norm. -/
  critical_match : ∀ t, envelope.criticalNorm.value (sol.vel t) ≤ envelope.resolvedCriticalNorm t

/-- Invariant-envelope system used to express a concrete closure attempt. -/
structure InvariantEnvelopeSystem {D : SpatialDomain3} (NS : IncompressibleNavierStokes D) where
  /-- Controlled strong solution. -/
  sol : StrongSolution NS
  /-- Candidate envelope. -/
  envelope : DefectEnvelope D
  /-- Invariant family intended to hold globally. -/
  invariant : ℝ → Prop
  /-- Global invariant validity. -/
  invariant_holds : ∀ t, invariant t
  /-- Invariant-to-bound implication. -/
  bounds_of_invariant :
    ∀ t, invariant t →
      envelope.defectNorm t ≤ envelope.defectBudget ∧
      envelope.resolvedCriticalNorm t ≤ envelope.criticalBudget
  /-- Link between physical critical norm and envelope-tracked resolved norm. -/
  critical_match : ∀ t, envelope.criticalNorm.value (sol.vel t) ≤ envelope.resolvedCriticalNorm t

/-- Abstract global regularity predicate expressed via uniform critical control. -/
def GlobalRegularity {D : SpatialDomain3} (NS : IncompressibleNavierStokes D) : Prop :=
  ∃ K : CriticalNorm D,
    ∃ sol : StrongSolution NS,
      ∃ B : ℝ,
        ∀ T, 0 ≤ T → NoBlowupUpTo NS K sol T B

/-- Closure theorem attempt: invariants imply global envelope boundedness. -/
theorem closure_of_invariant_system {D : SpatialDomain3}
    {NS : IncompressibleNavierStokes D}
    (I : InvariantEnvelopeSystem NS) :
    IsGloballyBoundedEnvelope I.envelope := by
  refine ⟨?_, ?_⟩
  · intro t
    exact (I.bounds_of_invariant t (I.invariant_holds t)).1
  · intro t
    exact (I.bounds_of_invariant t (I.invariant_holds t)).2

/-- Global regularity follows from the closure hypothesis. -/
theorem global_regularity_of_closure {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D)
    (H : GlobalClosureHypothesis NS) :
    GlobalRegularity NS := by
  refine ⟨H.envelope.criticalNorm, H.sol, H.envelope.criticalBudget, ?_⟩
  intro T hT
  exact continuation_of_defect_envelope NS H.envelope H.sol T hT
    H.globally_controlled H.critical_match

/-- Global regularity follows from a successful invariant-based closure attempt. -/
theorem global_regularity_of_invariant_closure {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D)
    (I : InvariantEnvelopeSystem NS) :
    GlobalRegularity NS := by
  refine global_regularity_of_closure NS ?_
  exact
    { sol := I.sol
      envelope := I.envelope
      globally_controlled := closure_of_invariant_system I
      critical_match := I.critical_match }

end Gibbs.ContinuumField.NavierStokes
