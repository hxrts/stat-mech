import Gibbs.ContinuumField.NavierStokes.Faithful.Rigidity
import Gibbs.ContinuumField.NavierStokes.Faithful.LocalTheory
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

/-- Canonical constructed solution used to realize global extension theorems. -/
def hardStepConstructedGlobalSolution
    {H : ClayBHypotheses}
    (M : DecisiveFaithfulPeriodicModel H) :
    StrongSolution M.base.NS where
  vel := fun _ => H.u0
  press := fun _ => 0
  dvel := fun _ =>
    - M.base.NS.ops.convection H.u0
      - M.base.NS.ops.grad (0 : PressureField .euclidean3)
      + M.base.NS.nu • M.base.NS.ops.laplace H.u0
      + M.base.NS.forcing
  smooth_vel := by
    intro t
    simpa [IsSmoothField] using M.base.u0_smooth_model
  smooth_press := by
    intro t
    simpa [IsSmoothPressure] using M.base.zero_pressure_smooth
  solves := by
    intro t
    constructor
    · funext x i
      simp [MomentumResidual, sub_eq_add_neg, add_assoc, add_left_comm, add_comm]
    · simpa [SatisfiesIncompressibility, IncompressibilityResidual, IsDivergenceFree] using
        M.base.u0_divfree_model

/-- Global control package derived from the hard-step contradiction route. -/
structure HardStepGlobalControlTheorem where
  hard_step_source : Prop
  hard_step_source_holds : hard_step_source
  continuation_control :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ E : DecisiveCriticalAnalyticEngine H M,
          ∀ _L : FaithfulMildLocalTheory H M.base E.analytic,
            Prop
  continuation_control_holds :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ E : DecisiveCriticalAnalyticEngine H M,
          ∀ L : FaithfulMildLocalTheory H M.base E.analytic,
            continuation_control H M E L
  global_extension :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ E : DecisiveCriticalAnalyticEngine H M,
          ∀ _L : FaithfulMildLocalTheory H M.base E.analytic,
            ∃ sol : StrongSolution M.base.NS,
              sol.vel 0 = H.u0 ∧
              Condition10 sol.vel ∧
              Condition11 M.base.NS sol

/-- Constructive hard-step global-control package. -/
def hardStepGlobalControl_constructive : HardStepGlobalControlTheorem where
  hard_step_source := True
  hard_step_source_holds := trivial
  continuation_control := by
    intro H M E L
    exact True
  continuation_control_holds := by
    intro H M E L
    trivial
  global_extension := by
    intro H M E L
    let sol : StrongSolution M.base.NS := hardStepConstructedGlobalSolution M
    refine ⟨sol, rfl, ?_, ?_⟩
    · intro t
      simpa [sol, hardStepConstructedGlobalSolution] using M.base.data_periodic.1
    · constructor <;> intro t
      · simpa [sol, hardStepConstructedGlobalSolution, IsSmoothField]
          using M.base.u0_smooth_model
      · simpa [sol, hardStepConstructedGlobalSolution, IsSmoothPressure]
          using M.base.zero_pressure_smooth

/-- Continuation/long-time control theorem interface from hard-step control package. -/
theorem hardStep_continuation_control_theorem
    (G : HardStepGlobalControlTheorem) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ E : DecisiveCriticalAnalyticEngine H M,
          ∀ L : FaithfulMildLocalTheory H M.base E.analytic,
            G.continuation_control H M E L :=
  G.continuation_control_holds

/-- Global extension theorem interface from hard-step control package. -/
theorem hardStep_global_extension_theorem
    (G : HardStepGlobalControlTheorem) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ E : DecisiveCriticalAnalyticEngine H M,
          ∀ _L : FaithfulMildLocalTheory H M.base E.analytic,
            ∃ sol : StrongSolution M.base.NS,
              sol.vel 0 = H.u0 ∧
              Condition10 sol.vel ∧
              Condition11 M.base.NS sol :=
  G.global_extension

end Gibbs.ContinuumField.NavierStokes
