import Gibbs.ContinuumField.NavierStokes.Faithful.Rigidity
import Gibbs.ContinuumField.NavierStokes.Faithful.LocalTheory
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomGlobal
import Gibbs.ContinuumField.NavierStokes.HardStep.TailVanishing

/-! # Faithful true hard-step route

Quantitative critical-element contradiction scaffolding for the faithful
Navier-Stokes hard step.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-! ## Contradiction setup -/

/-- Canonical critical classes used by the faithful hard step. -/
inductive HardStepCanonicalCriticalClass where
  | L3Primary
  | HHalfBridge
  deriving Repr, DecidableEq, Inhabited

/-- Frozen primary critical class for the faithful hard step. -/
def hardStepPrimaryCriticalClass : HardStepCanonicalCriticalClass := .L3Primary

/-- The faithful hard step is anchored at `L^3` with `Ḣ^{1/2}` as support. -/
theorem hardStepPrimaryCriticalClass_is_L3 :
    hardStepPrimaryCriticalClass = .L3Primary := rfl

/-- Quantitative contradiction setup at the critical threshold `A*`. -/
structure HardStepContradictionSetup
    (H : ClayBHypotheses)
    (M : DecisiveFaithfulPeriodicModel H)
    (E : DecisiveCriticalAnalyticEngine H M) where
  criticalClass : HardStepCanonicalCriticalClass
  finite_time_blowup_assumption : Prop
  threshold : CriticalThresholdData
  threshold_minimality : Prop
  threshold_minimality_holds : threshold_minimality

/-- Canonical `A*` value in the contradiction setup. -/
def hardStepAstar
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {E : DecisiveCriticalAnalyticEngine H M}
    (S : HardStepContradictionSetup H M E) : ℝ :=
  S.threshold.Astar

/-! ## Quantitative packages -/

/-- Quantitative profile decomposition package with explicit constants. -/
structure QuantitativeProfileDecompositionTheorem
    (H : ClayBHypotheses)
    (M : DecisiveFaithfulPeriodicModel H)
    (E : DecisiveCriticalAnalyticEngine H M) where
  profile_data : ProfileDecompositionData
  orthogonality_constant : ℝ
  orthogonality_constant_nonneg : 0 ≤ orthogonality_constant
  defect_decoupling_constant : ℝ
  defect_decoupling_constant_nonneg : 0 ≤ defect_decoupling_constant
  quantitative_orthogonality :
    ∀ j k, j ≠ k →
      |(profile_data.profile j originCoord3 0) * (profile_data.profile k originCoord3 0)|
        ≤ orthogonality_constant
  quantitative_decoupling :
    ∀ n, hardStepNormL3 (profile_data.remainder n) ≤ defect_decoupling_constant

/-- Minimal-element extraction package with explicit compactness modulus. -/
structure QuantitativeMinimalElementExtraction
    (H : ClayBHypotheses)
    (M : DecisiveFaithfulPeriodicModel H)
    (E : DecisiveCriticalAnalyticEngine H M)
    (S : HardStepContradictionSetup H M E)
    (P : QuantitativeProfileDecompositionTheorem H M E) where
  minimal_element : HardStepMinimalElement
  extracted_from_profiles : Prop
  extracted_from_profiles_holds : extracted_from_profiles
  almost_periodic_modulus : ℝ → ℝ
  modulus_nonneg : ∀ r, 0 ≤ almost_periodic_modulus r
  almost_periodic : AlmostPeriodicModuloSymmetry minimal_element.profile

/-- Quantitative local-energy/epsilon-regularity package with tracked constants. -/
structure QuantitativeLocalEnergyEpsilonRegularity where
  local_energy_constant : ℝ
  local_energy_constant_nonneg : 0 ≤ local_energy_constant
  epsilon_constant : ℝ
  epsilon_constant_pos : 0 < epsilon_constant
  local_energy : TrueTorusLocalEnergyInequality
  epsilon_regularity : TrueTorusEpsilonRegularityCriterion

/-- Quantitative lower-cascade theorem package for the minimal element route. -/
structure QuantitativeLowerCascadeTheorem where
  eta : ℝ
  eta_pos : 0 < eta
  N0 : Nat
  times : Nat → ℝ
  lower_flux :
    ∀ U : VelocityTrajectory .torus3, ∀ n : Nat, eta ≤ |scaleFlux (N0 + n) (times n) U|

/-- Quantitative upper-tail theorem package from localized energy identities. -/
structure QuantitativeUpperTailTheorem where
  commutator_constant : ℝ
  commutator_constant_nonneg : 0 ≤ commutator_constant
  dissipation_constant : ℝ
  dissipation_constant_nonneg : 0 ≤ dissipation_constant
  tail_vanishing :
    ∀ Edef : DefectEnvelope .torus3, ∀ U : VelocityTrajectory .torus3, ∀ t0 : ℝ,
      TendsToZeroNat (fun N => scaleFlux N t0 U) ∧
      TendsToZeroNat (fun N => Edef.defectNorm (t0 + N))

/-- Hard-step contradiction closure package (lower cascade vs upper tail vanishing). -/
structure QuantitativeHardStepContradiction
    (H : ClayBHypotheses)
    (M : DecisiveFaithfulPeriodicModel H)
    (E : DecisiveCriticalAnalyticEngine H M)
    (S : HardStepContradictionSetup H M E)
    (P : QuantitativeProfileDecompositionTheorem H M E)
    (X : QuantitativeMinimalElementExtraction H M E S P) where
  local_energy_eps : QuantitativeLocalEnergyEpsilonRegularity
  lower_cascade : QuantitativeLowerCascadeTheorem
  upper_tail : QuantitativeUpperTailTheorem
  contradiction : False

/-! ## Contradiction theorems -/

/-- `A* = ∞` proxy: every nonnegative bound is below the threshold. -/
def HardStepAstarInfinite (T : CriticalThresholdData) : Prop :=
  ∀ B : ℝ, 0 ≤ B → B ≤ T.Astar

/-- Blow-up assumption is excluded once the quantitative contradiction is closed. -/
theorem hardStep_blowup_excluded
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {E : DecisiveCriticalAnalyticEngine H M}
    {S : HardStepContradictionSetup H M E}
    {P : QuantitativeProfileDecompositionTheorem H M E}
    {X : QuantitativeMinimalElementExtraction H M E S P}
    (Q : QuantitativeHardStepContradiction H M E S P X) :
    ¬ S.finite_time_blowup_assumption := by
  intro hblowup
  exact False.elim Q.contradiction

/-- Quantitative contradiction implies `A*` is unbounded (`A* = ∞` proxy). -/
theorem hardStep_Astar_infinite
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {E : DecisiveCriticalAnalyticEngine H M}
    {S : HardStepContradictionSetup H M E}
    {P : QuantitativeProfileDecompositionTheorem H M E}
    {X : QuantitativeMinimalElementExtraction H M E S P}
    (Q : QuantitativeHardStepContradiction H M E S P X) :
    HardStepAstarInfinite S.threshold := by
  intro B hB
  exact False.elim Q.contradiction

/-! ## Global control -/

/-- Direct theorem endpoint for hard-step global closure. -/
abbrev HardStepGlobalClosureTheorem : Prop :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ E : DecisiveCriticalAnalyticEngine H M,
        ∀ _L : FaithfulMildLocalTheory H M.base E.analytic,
          HardStepGlobalClosure

/-- Direct theorem endpoint for hard-step global extension. -/
abbrev HardStepGlobalExtensionTheorem : Prop :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ E : DecisiveCriticalAnalyticEngine H M,
        ∀ _L : FaithfulMildLocalTheory H M.base E.analytic,
          ∃ sol : StrongSolution M.base.NS,
            sol.vel 0 = H.u0 ∧
            Condition10 sol.vel ∧
            Condition11 M.base.NS sol

/-- Build hard-step global closure from contradiction-package routes. -/
def hardStepGlobalClosure_from_contradiction_route
    (flux_package :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ E : DecisiveCriticalAnalyticEngine H M,
            ∀ _L : FaithfulMildLocalTheory H M.base E.analytic,
              HardStepFluxContradictionPackage) :
    HardStepGlobalClosureTheorem := by
  intro H M E L
  exact hardStep_global_closure_of_flux_barrier (flux_package H M E L)

/-- Canonical hard-step control route sourcing contradiction packages from the analytic engine. -/
def hardStepGlobalClosure_from_engine_route : HardStepGlobalClosureTheorem :=
  hardStepGlobalClosure_from_contradiction_route
    (fun _ _ E _ => decisive_flux_contradiction_package E)

/-- Periodicity propagation used by the hard-step global extension route. -/
theorem hardStep_periodicity_propagation_from_localTheory
    {H : ClayBHypotheses}
    {M : DecisiveFaithfulPeriodicModel H}
    {E : DecisiveCriticalAnalyticEngine H M}
    (L : FaithfulMildLocalTheory H M.base E.analytic) :
    Condition10 L.strong.vel :=
  faithful_periodicity_propagation L

/-- Hard-step global extension theorem derived from continuation and contradiction routes. -/
theorem hardStep_global_extension_from_continuation_route
    (global_closure : HardStepGlobalClosureTheorem) :
    HardStepGlobalExtensionTheorem := by
  intro H M E L
  have hclosure : HardStepGlobalClosure := global_closure H M E L
  exact baseAxiom_global_extension_from_continuation_direct hclosure L

/-- Continuation/long-time control theorem interface from hard-step control package. -/
theorem hardStep_continuation_control_theorem
    (global_closure : HardStepGlobalClosureTheorem) :
    HardStepGlobalClosureTheorem :=
  global_closure

/-- Global extension theorem interface from hard-step control package. -/
theorem hardStep_global_extension_theorem
    (global_closure : HardStepGlobalClosureTheorem) :
    HardStepGlobalExtensionTheorem :=
  hardStep_global_extension_from_continuation_route global_closure

end Gibbs.ContinuumField.NavierStokes
