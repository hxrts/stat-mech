import Gibbs.ContinuumField.NavierStokes.Functional.CriticalSpace
import Gibbs.ContinuumField.NavierStokes.Linear.DuhamelFixedPoint
import Gibbs.ContinuumField.NavierStokes.Erasure.ExactIdentities
import Gibbs.ContinuumField.NavierStokes.Defect.Continuation
import Gibbs.ContinuumField.NavierStokes.Global.ClosureAttempt
import Gibbs.ContinuumField.NavierStokes.Blowup.Rigidity

/-!
# Major theorems with explicit scaling regime hypotheses

This module wraps milestone-level theorems with explicit scaling-regime
assumptions so each major statement carries concrete dimension/index data.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Shared scaling hypotheses for major Navier-Stokes theorems. -/
structure MajorTheoremScalingHypotheses where
  /-- Scaling regime used by the theorem statement. -/
  regime : ScalingRegime
  /-- Space dimension (3D target). -/
  spaceDim_three : regime.spaceDim = 3
  /-- Time dimension (single time axis). -/
  timeDim_one : regime.timeDim = 1

/-- Local existence/uniqueness in an explicit scaling regime. -/
theorem major_local_existence_uniqueness {D : SpatialDomain3}
    {NS : IncompressibleNavierStokes D}
    (Hscale : MajorTheoremScalingHypotheses)
    (_hcritical : (L3CriticalSpace D).critical_wrt Hscale.regime)
    (w : LocalWellPosednessWitness NS)
    (huniq : LocalUniqueOnWitness w) :
    ∃ T > (0 : ℝ),
      ∃ sol : StrongSolution NS,
        sol.vel 0 = w.init.data.u0 ∧
        (∀ s : StrongSolution NS, s.vel 0 = w.init.data.u0 → s = sol) := by
  exact local_existence_uniqueness w huniq

/-- Exact coarse momentum identity in an explicit scaling regime. -/
theorem major_exact_coarse_identity {D : SpatialDomain3}
    (Hscale : MajorTheoremScalingHypotheses)
    (_hcritical : (L3CriticalSpace D).critical_wrt Hscale.regime)
    (NS : IncompressibleNavierStokes D)
    (E : ErasureOperator D)
    (u : VelocityField D)
    (p : PressureField D)
    (du_dt : VelocityField D) :
    E.map (MomentumResidual NS u p du_dt) =
      MomentumResidual NS (E.map u) p (E.map du_dt)
        + coarseMomentumDefect NS E u p du_dt := by
  exact exact_coarse_momentum_identity NS E u p du_dt

/-- Conditional regularity from envelope bounds in an explicit scaling regime. -/
theorem major_conditional_regularity {D : SpatialDomain3}
    (Hscale : MajorTheoremScalingHypotheses)
    (_hcritical : (L3CriticalSpace D).critical_wrt Hscale.regime)
    (NS : IncompressibleNavierStokes D)
    (E : DefectEnvelope D)
    (sol : StrongSolution NS)
    (T : ℝ)
    (hT : 0 ≤ T)
    (hbounded : IsGloballyBoundedEnvelope E)
    (hmatch : ∀ t, E.criticalNorm.value (sol.vel t) ≤ E.resolvedCriticalNorm t) :
    NoBlowupUpTo NS E.criticalNorm sol T E.criticalBudget := by
  exact conditional_regularity_of_envelope_bound NS E sol T hT hbounded hmatch

/-- Global regularity from invariant closure in an explicit scaling regime. -/
theorem major_global_regularity_of_closure {D : SpatialDomain3}
    (Hscale : MajorTheoremScalingHypotheses)
    (_hcritical : (L3CriticalSpace D).critical_wrt Hscale.regime)
    (NS : IncompressibleNavierStokes D)
    (I : InvariantEnvelopeSystem NS) :
    GlobalRegularity NS := by
  exact global_regularity_of_invariant_closure NS I

/-- Rigidity contradiction in an explicit scaling regime. -/
theorem major_rigidity_contradiction {D : SpatialDomain3}
    (Hscale : MajorTheoremScalingHypotheses)
    (_hcritical : (L3CriticalSpace D).critical_wrt Hscale.regime)
    (cp : CompactnessProfile D)
    (hbu : SatisfiesBackwardUniquenessCriterion cp)
    (hliouville : SatisfiesLiouvilleCriterion cp)
    (hnontrivial : ∃ x i, cp.limitingVelocity x i ≠ 0) :
    ¬ IsMinimalBlowupObject cp := by
  exact backward_uniqueness_liouville_excludes_minimal_blowup cp hbu hliouville hnontrivial

end Gibbs.ContinuumField.NavierStokes
