import StatMech.ContinuumField.NavierStokes.ProofB.Local.AnalyticNorms
import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.UpperTailVanishing

/-! # Definitive derived theorem interfaces

This module converts witness-centric hard-step interfaces into theorem-level
obligations for the definitive proof path.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Theorem-level long-time perturbation statement (no witness in conclusion shape). -/
def DefinitiveLongTimePerturbationTheorem : Prop :=
  ∀ {NS : IncompressibleNavierStokes .torus3},
    ∀ base perturbed : StrongSolution NS,
      ∀ T ε : ℝ, 0 ≤ T → 0 ≤ ε →
        ∃ C : ℝ, 0 ≤ C ∧
          ∀ t, 0 ≤ t → t ≤ T →
            hardStepNormL3 (base.vel t - perturbed.vel t) ≤ C * ε

/-- Theorem-level envelope robustness statement (no witness in conclusion shape). -/
def DefinitiveEnvelopeRobustnessTheorem : Prop :=
  ∀ {NS : IncompressibleNavierStokes .torus3},
    ∀ (E : DefectEnvelope .torus3),
      ∀ base perturbed : StrongSolution NS,
        ∀ δ : ℝ, 0 ≤ δ →
          (∀ t, E.criticalNorm.value (base.vel t) ≤ E.resolvedCriticalNorm t) →
          (∀ t, E.criticalNorm.value (perturbed.vel t) ≤ E.criticalNorm.value (base.vel t) + δ) →
          ∀ t, E.criticalNorm.value (perturbed.vel t) ≤ E.criticalBudget + δ

/-- Theorem-level persistent-cascade rigidity statement. -/
def DefinitiveLowerBoundRigidityTheorem : Prop :=
  ∀ (_m : HardStepMinimalElement) (U : VelocityTrajectory .torus3),
    ∃ η > (0 : ℝ), ∃ N0 : Nat, ∃ t0 : ℝ,
      ∀ N, N0 ≤ N → η ≤ |scaleFlux N t0 U|

/-- Theorem-level vanishing-tail statement. -/
def DefinitiveTailVanishingTheorem : Prop :=
  ∀ (E : DefectEnvelope .torus3) (U : VelocityTrajectory .torus3) (t0 : ℝ),
    IsGloballyBoundedEnvelope E →
    ∃ tail : Nat → ℝ,
      (∀ N, 0 ≤ tail N) ∧
      (∀ N, |scaleFlux N t0 U| ≤ tail N) ∧
      TendsToZeroNat tail

/-- Bridge: witness-rich perturbation data imply the theorem-level perturbation statement. -/
theorem definitiveLongTimePerturbation_fromWitness
    (hgen :
      ∀ {NS : IncompressibleNavierStokes .torus3},
        ∀ base perturbed : StrongSolution NS,
          ∀ T ε : ℝ, 0 ≤ T → 0 ≤ ε →
            ∃ D : LongTimePerturbationData NS,
              D.base = base ∧ D.perturbed = perturbed ∧ D.T = T ∧ D.ε = ε) :
    DefinitiveLongTimePerturbationTheorem := by
  intro NS base perturbed T ε hT hε
  rcases hgen base perturbed T ε hT hε with ⟨D, hbase, hpert, hDT, hDε⟩
  refine ⟨D.Cstab, D.Cstab_nonneg, ?_⟩
  intro t ht0 htT
  subst hbase
  subst hpert
  subst hDT
  subst hDε
  exact D.perturbation_bound t ht0 htT

/-- Bridge: witness-rich envelope robustness data imply theorem-level robustness statement. -/
theorem definitiveEnvelopeRobustness_fromWitness
    (hgen :
      ∀ {NS : IncompressibleNavierStokes .torus3},
        ∀ (E : DefectEnvelope .torus3),
          ∀ base perturbed : StrongSolution NS,
            ∀ δ : ℝ, 0 ≤ δ →
              (∀ t, E.criticalNorm.value (base.vel t) ≤ E.resolvedCriticalNorm t) →
              (∀ t, E.criticalNorm.value (perturbed.vel t) ≤ E.criticalNorm.value (base.vel t) + δ) →
              ∃ R : EnvelopeRobustnessData NS E,
                R.base = base ∧ R.perturbed = perturbed ∧ R.δ = δ) :
    DefinitiveEnvelopeRobustnessTheorem := by
  intro NS E base perturbed δ hδ hbase hpert t
  rcases hgen E base perturbed δ hδ hbase hpert with ⟨R, hRbase, hRpert, hRδ⟩
  subst hRbase
  subst hRpert
  subst hRδ
  exact envelope_budget_robustness R t

end StatMech.ContinuumField.NavierStokes
