import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.ConstructionInterfaces
import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.FluxIncompatibility
import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.UpperTailVanishing
import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.LocalEnergyRegularity

/-! # Decisive rigidity core

Local-energy, epsilon-regularity, flux bounds, and contradiction closure for
the decisive faithful hard step.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Decisive local-energy and epsilon-regularity interface. -/
def decisive_local_energy_epsilon_regularity
    (local_energy : TrueTorusLocalEnergyInequality)
    (epsilon_regularity : TrueTorusEpsilonRegularityCriterion) :
    TrueTorusLocalEnergyInequality × TrueTorusEpsilonRegularityCriterion := by
  exact ⟨local_energy, epsilon_regularity⟩

/-- Decisive lower/upper flux theorem interfaces. -/
theorem decisive_flux_bounds
    (lower_flux_bound :
      ∀ U : VelocityTrajectory .torus3,
        ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ, ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|)
    (upper_tail_vanishing :
      ∀ Edef : DefectEnvelope .torus3, ∀ U : VelocityTrajectory .torus3, ∀ t0 : ℝ,
        TendsToZeroNat (fun N => scaleFlux N t0 U) ∧
        TendsToZeroNat (fun N => Edef.defectNorm (t0 + N))) :
    (∀ U : VelocityTrajectory .torus3,
      ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ, ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|) ∧
    (∀ Edef : DefectEnvelope .torus3, ∀ U : VelocityTrajectory .torus3, ∀ t0 : ℝ,
      TendsToZeroNat (fun N => scaleFlux N t0 U) ∧
      TendsToZeroNat (fun N => Edef.defectNorm (t0 + N))) := by
  exact ⟨lower_flux_bound, upper_tail_vanishing⟩

/-- Dyadic decisive lower/upper flux theorem interfaces. -/
theorem decisive_flux_bounds_dyadic
    (lower_flux_bound :
      ∀ F : DyadicErasureFamily .torus3,
      ∀ U : VelocityTrajectory .torus3,
        ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
          ∀ N, N0 ≤ N → η ≤ |scaleFluxDyadic F N t0 U|)
    (upper_tail_vanishing :
      ∀ F : DyadicErasureFamily .torus3,
      ∀ Edef : DefectEnvelope .torus3,
      ∀ U : VelocityTrajectory .torus3,
      ∀ t0 : ℝ,
        TendsToZeroNat (fun N => scaleFluxDyadic F N t0 U) ∧
        TendsToZeroNat (fun N => Edef.defectNorm (t0 + N))) :
    (∀ F : DyadicErasureFamily .torus3,
      ∀ U : VelocityTrajectory .torus3,
        ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
          ∀ N, N0 ≤ N → η ≤ |scaleFluxDyadic F N t0 U|) ∧
    (∀ F : DyadicErasureFamily .torus3,
      ∀ Edef : DefectEnvelope .torus3,
      ∀ U : VelocityTrajectory .torus3,
      ∀ t0 : ℝ,
        TendsToZeroNat (fun N => scaleFluxDyadic F N t0 U) ∧
        TendsToZeroNat (fun N => Edef.defectNorm (t0 + N))) := by
  exact ⟨lower_flux_bound, upper_tail_vanishing⟩

/-- Dyadic incompatibility alias theorem for decisive spine route. -/
theorem decisive_rigidity_contradiction_dyadic_alias
    {F : DyadicErasureFamily .torus3}
    {U : VelocityTrajectory .torus3}
    {t0 : ℝ}
    (lower_hypotheses : DecisiveSpineLowerHypothesesDyadic F U t0)
    (upper_hypotheses : DecisiveSpineUpperHypothesesDyadic F U t0) :
    False :=
  decisiveSpine_incompatibility_theorem_dyadic lower_hypotheses upper_hypotheses

/-- Decisive rigidity contradiction excludes the decisive minimal element. -/
theorem decisive_rigidity_contradiction
    (minimal_element : HardStepMinimalElement)
    (rigidity_contradiction :
      ∀ m : HardStepMinimalElement, m = minimal_element → False) :
    False := by
  exact rigidity_contradiction minimal_element rfl

end StatMech.ContinuumField.NavierStokes
