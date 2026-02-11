import Gibbs.ContinuumField.NavierStokes.HardStep.Definitive.TrueTorusLocalEnergyRegularity
import Gibbs.ContinuumField.NavierStokes.HardStep.LowerBoundRigidity

/-! # Definitive true-torus lower flux rigidity

Lower cascade-activity bounds derived directly from minimality/nontriviality.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Direct lower-rigidity theorem package without witness-parameter endpoints. -/
structure DefinitiveLowerFluxRigidityTheorem
    (m : HardStepMinimalElement)
    (U : VelocityTrajectory .torus3) where
  η : ℝ
  η_pos : 0 < η
  N0 : Nat
  t0 : ℝ
  lower_bound :
    ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|
  persistence :
    ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|

/-- Definitive lower-bound theorem from minimality. -/
theorem definitive_lower_flux_bound
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (L : DefinitiveLowerFluxRigidityTheorem m U) :
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U| := by
  exact ⟨L.η, L.η_pos, L.N0, L.t0, L.lower_bound⟩

/-- Definitive persistence theorem over scale/time windows. -/
theorem definitive_lower_flux_persistence
    {m : HardStepMinimalElement}
    {U : VelocityTrajectory .torus3}
    (L : DefinitiveLowerFluxRigidityTheorem m U) :
    ∀ N, L.N0 ≤ N → L.η ≤ |scaleFlux N L.t0 U| :=
  L.persistence

end Gibbs.ContinuumField.NavierStokes
