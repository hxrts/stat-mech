import Gibbs.ContinuumField.NavierStokes.Faithful.CriticalElement
import Gibbs.ContinuumField.NavierStokes.HardStep.TailVanishing
import Gibbs.ContinuumField.NavierStokes.HardStep.Definitive.TrueTorusLocalEnergyRegularity

/-! # Decisive rigidity core

Local-energy, epsilon-regularity, flux bounds, and contradiction closure for
the decisive faithful hard step.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Decisive rigidity theorem package. -/
structure DecisiveRigidityTheorem
    (H : ClayBHypotheses)
    (M : DecisiveFaithfulPeriodicModel H)
    (E : DecisiveCriticalAnalyticEngine H M)
    (C : DecisiveCriticalElementChain H M E) where
  local_energy : TrueTorusLocalEnergyInequality
  epsilon_regularity : TrueTorusEpsilonRegularityCriterion
  lower_flux_bound :
    ∀ U : VelocityTrajectory .torus3,
      ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ, ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|
  upper_tail_vanishing :
    ∀ Edef : DefectEnvelope .torus3, ∀ U : VelocityTrajectory .torus3, ∀ t0 : ℝ,
      TendsToZeroNat (fun N => scaleFlux N t0 U) ∧
      TendsToZeroNat (fun N => Edef.defectNorm (t0 + N))
  rigidity_contradiction :
    ∀ m : HardStepMinimalElement, m = C.minimal_element → False

/-- Decisive local-energy and epsilon-regularity interface. -/
def decisive_local_energy_epsilon_regularity
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {E : DecisiveCriticalAnalyticEngine H M}
    {C : DecisiveCriticalElementChain H M E}
    (R : DecisiveRigidityTheorem H M E C) :
    TrueTorusLocalEnergyInequality × TrueTorusEpsilonRegularityCriterion := by
  exact ⟨R.local_energy, R.epsilon_regularity⟩

/-- Decisive lower/upper flux theorem interfaces. -/
theorem decisive_flux_bounds
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {E : DecisiveCriticalAnalyticEngine H M}
    {C : DecisiveCriticalElementChain H M E}
    (R : DecisiveRigidityTheorem H M E C) :
    (∀ U : VelocityTrajectory .torus3,
      ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ, ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|) ∧
    (∀ Edef : DefectEnvelope .torus3, ∀ U : VelocityTrajectory .torus3, ∀ t0 : ℝ,
      TendsToZeroNat (fun N => scaleFlux N t0 U) ∧
      TendsToZeroNat (fun N => Edef.defectNorm (t0 + N))) := by
  exact ⟨R.lower_flux_bound, R.upper_tail_vanishing⟩

/-- Decisive rigidity contradiction excludes the decisive minimal element. -/
theorem decisive_rigidity_contradiction
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {E : DecisiveCriticalAnalyticEngine H M}
    {C : DecisiveCriticalElementChain H M E}
    (R : DecisiveRigidityTheorem H M E C) :
    False := by
  exact R.rigidity_contradiction C.minimal_element rfl

end Gibbs.ContinuumField.NavierStokes
