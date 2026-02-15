import Gibbs.ContinuumField.NavierStokes.Faithful.Rigidity
import Gibbs.ContinuumField.NavierStokes.Faithful.HardGlobal
import Gibbs.ContinuumField.NavierStokes.Faithful.TrueHardStep
import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineGlobal
import Gibbs.ContinuumField.NavierStokes.HardStep.Definitive.ChainOutput

/-! # Decisive unconditional global closure

Global closure package for the decisive faithful hard-step path.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-! ## Global closure theorems -/

/-- Build decisive global closure from a hard-step global-control theorem. -/
def decisiveGlobalClosureTheorem_of_hardStepControl
    (global_closure : HardStepGlobalClosureTheorem) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ A : FaithfulAnalyticStack,
          ∀ L : FaithfulMildLocalTheory H M.base A,
            ∃ _Gd : FaithfulHardGlobalData H M.base A L, True := by
  intro H M A L
  rcases hardStep_global_extension_theorem global_closure H M A L with ⟨sol, hinit, hper, hsmooth⟩
  exact ⟨⟨sol, hinit, hper, hsmooth⟩, trivial⟩

/-- Threshold-chain-routed decisive global closure theorem (non-endpoint bridge). -/
def decisiveGlobalClosureTheorem_from_threshold_minimal_chain :
    ∀ _chain : DecisiveSpineThresholdMinimalFluxChain,
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ A : FaithfulAnalyticStack,
          ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True := by
  intro chain
  have hclosure : HardStepGlobalClosure :=
    decisiveSpine_global_closure_from_threshold_minimal_chain chain
  exact decisiveGlobalClosureTheorem_of_hardStepControl
    (hardStepGlobalClosure_from_analytic_route
      (fun _H _M _A _L => hclosure))

/-! ## Chain generators and data families -/

/-- Explicit theorem-level generator of threshold/minimal contradiction chains. -/
abbrev DecisiveSpineThresholdChainGenerator : Prop :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ A : FaithfulAnalyticStack,
        ∀ _L : FaithfulMildLocalTheory H M.base A,
          Nonempty DecisiveSpineThresholdMinimalFluxChain

/-- Explicit theorem-level output family of threshold/minimal contradiction chains. -/
abbrev DecisiveSpineThresholdChainOutputFamily : Prop :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ A : FaithfulAnalyticStack,
        ∀ _L : FaithfulMildLocalTheory H M.base A,
          DecisiveSpineThresholdMinimalFluxChain

/-- Extract an explicit chain-output family from chain-generator theorem outputs. -/
theorem decisiveSpine_chain_output_family_of_chain_generator
    (chain_generator : DecisiveSpineThresholdChainGenerator) :
    DecisiveSpineThresholdChainOutputFamily := by
  intro H M A L
  exact Classical.choice (chain_generator H M A L)

/-- Build decisive chain-output families from definitive hard-step chain-output theorem data. -/
theorem decisiveSpine_chain_output_family_of_definitive_chain_output
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput) :
    DecisiveSpineThresholdChainOutputFamily := by
  rcases definitive_output with
    ⟨threshold, minimizing, minimal_element, flux_hypotheses⟩
  intro H M A L
  refine ⟨⟨threshold⟩, ⟨minimizing⟩, minimal_element, ?_⟩
  intro m
  rcases flux_hypotheses m with ⟨U, t0, hLower, hUpper⟩
  exact ⟨U, t0, hLower, hUpper⟩

/-- Build decisive chain generators from definitive hard-step chain-output theorem data. -/
theorem decisiveSpine_chain_generator_of_definitive_chain_output
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput) :
    DecisiveSpineThresholdChainGenerator := by
  intro H M A L
  exact ⟨(decisiveSpine_chain_output_family_of_definitive_chain_output definitive_output)
    H M A L⟩

/-- Any explicit chain-output family induces a chain-generator theorem. -/
theorem decisiveSpine_chain_generator_of_chain_output_family
    (output_family : DecisiveSpineThresholdChainOutputFamily) :
    DecisiveSpineThresholdChainGenerator := by
  intro H M A L
  exact ⟨output_family H M A L⟩

/-- Constructive per-instance trajectory component family. -/
abbrev DecisiveSpineConstructiveTrajectoryComponentFamily : Type :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ A : FaithfulAnalyticStack,
        ∀ _L : FaithfulMildLocalTheory H M.base A,
          HardStepMinimalElement → VelocityTrajectory .torus3

/-- Constructive per-instance time component family keyed by `U_of`. -/
abbrev DecisiveSpineConstructiveTimeComponentFamily
    (_U_of : DecisiveSpineConstructiveTrajectoryComponentFamily) : Type :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ A : FaithfulAnalyticStack,
        ∀ _L : FaithfulMildLocalTheory H M.base A,
          ∀ _m : HardStepMinimalElement,
            ℝ

/-- Constructive per-instance lower-hypothesis component family keyed by `U_of/t0_of`. -/
abbrev DecisiveSpineConstructiveLowerFluxHypothesisComponentFamily
    (U_of : DecisiveSpineConstructiveTrajectoryComponentFamily)
    (t0_of : DecisiveSpineConstructiveTimeComponentFamily U_of) : Prop :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ A : FaithfulAnalyticStack,
        ∀ L : FaithfulMildLocalTheory H M.base A,
          ∀ m : HardStepMinimalElement,
            DecisiveSpineLowerHypotheses
              ((U_of H M A L) m)
              (t0_of H M A L m)

/-- Constructive per-instance upper-hypothesis component family keyed by `U_of/t0_of`. -/
abbrev DecisiveSpineConstructiveUpperFluxHypothesisComponentFamily
    (U_of : DecisiveSpineConstructiveTrajectoryComponentFamily)
    (t0_of : DecisiveSpineConstructiveTimeComponentFamily U_of) : Prop :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ A : FaithfulAnalyticStack,
        ∀ L : FaithfulMildLocalTheory H M.base A,
          ∀ m : HardStepMinimalElement,
            DecisiveSpineUpperHypotheses
              ((U_of H M A L) m)
              (t0_of H M A L m)

/-- Constructive per-instance threshold component family. -/
abbrev DecisiveSpineConstructiveThresholdComponentFamily : Type :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ A : FaithfulAnalyticStack,
        ∀ _L : FaithfulMildLocalTheory H M.base A,
          DecisiveThresholdData

/-- Constructive per-instance minimizing component family keyed by `threshold_of`. -/
abbrev DecisiveSpineConstructiveMinimizingComponentFamily
    (threshold_of : DecisiveSpineConstructiveThresholdComponentFamily) : Type :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ A : FaithfulAnalyticStack,
        ∀ L : FaithfulMildLocalTheory H M.base A,
          DecisiveMinimizingData (threshold_of H M A L)

/-- Constructive per-instance minimal-element component family. -/
abbrev DecisiveSpineConstructiveMinimalElementComponentFamily : Type :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ A : FaithfulAnalyticStack,
        ∀ _L : FaithfulMildLocalTheory H M.base A,
          HardStepMinimalElement

/-- Packaged constructive no-local-fallback components for one decisive route. -/
structure DecisiveSpineConstructiveComponentPackage where
  threshold_of : DecisiveSpineConstructiveThresholdComponentFamily
  minimizing_of : DecisiveSpineConstructiveMinimizingComponentFamily threshold_of
  minimal_element_of : DecisiveSpineConstructiveMinimalElementComponentFamily
  U_of : DecisiveSpineConstructiveTrajectoryComponentFamily
  t0_of : DecisiveSpineConstructiveTimeComponentFamily U_of
  lower_hypotheses_of :
    DecisiveSpineConstructiveLowerFluxHypothesisComponentFamily U_of t0_of
  upper_hypotheses_of :
    DecisiveSpineConstructiveUpperFluxHypothesisComponentFamily U_of t0_of

/-- Explicit per-instance data family that can generate threshold/minimal chains. -/
abbrev DecisiveSpineThresholdChainDataFamily : Prop :=
  ∀ H : ClayBHypotheses,
    ∀ M : DecisiveFaithfulPeriodicModel H,
      ∀ A : FaithfulAnalyticStack,
        ∀ _L : FaithfulMildLocalTheory H M.base A,
          ∃ threshold : DecisiveThresholdData,
            ∃ _minimizing : DecisiveMinimizingData threshold,
              ∃ _minimal_element : HardStepMinimalElement,
                ∀ _m : HardStepMinimalElement,
                  ∃ U : VelocityTrajectory .torus3,
                    ∃ t0 : ℝ,
                      DecisiveSpineLowerHypotheses U t0 ∧
                      DecisiveSpineUpperHypotheses U t0

/-- Build chain-data assumptions directly from explicit chain-output family witnesses. -/
theorem decisiveSpine_threshold_chain_data_family_of_chain_output_family
    (output_family : DecisiveSpineThresholdChainOutputFamily) :
    DecisiveSpineThresholdChainDataFamily := by
  intro H M A L
  rcases output_family H M A L with
    ⟨threshold, minimizing, minimal_element, flux_hypotheses⟩
  exact ⟨threshold, minimizing, minimal_element, flux_hypotheses⟩

/-- Build a chain-generator assumption from explicit per-instance chain data. -/
theorem decisiveSpine_threshold_chain_generator_of_data_family
    (data_family : DecisiveSpineThresholdChainDataFamily) :
    DecisiveSpineThresholdChainGenerator := by
  intro H M A L
  rcases data_family H M A L with
    ⟨threshold, minimizing, minimal_element, flux_hypotheses⟩
  exact decisiveSpine_threshold_minimal_flux_chain_nonempty_of_data
    threshold minimizing minimal_element flux_hypotheses

/-- Extract an explicit chain-output family from data-family assumptions. -/
theorem decisiveSpine_chain_output_family_of_data_family
    (data_family : DecisiveSpineThresholdChainDataFamily) :
    DecisiveSpineThresholdChainOutputFamily := by
  intro H M A L
  rcases data_family H M A L with
    ⟨threshold, minimizing, minimal_element, flux_hypotheses⟩
  exact ⟨threshold, minimizing, minimal_element, flux_hypotheses⟩

/-- Build nonempty threshold/minimal-flux chains directly from explicit chain outputs. -/
theorem decisiveSpine_threshold_minimal_flux_chain_nonempty_of_chain_output
    (output : DecisiveSpineThresholdMinimalFluxChain) :
    Nonempty DecisiveSpineThresholdMinimalFluxChain := by
  exact ⟨output⟩

/-- Build chain-data assumptions from chain-generator theorem outputs by witness extraction. -/
theorem decisiveSpine_threshold_chain_data_family_of_chain_generator
    (chain_generator : DecisiveSpineThresholdChainGenerator) :
    DecisiveSpineThresholdChainDataFamily := by
  exact decisiveSpine_threshold_chain_data_family_of_chain_output_family
    (decisiveSpine_chain_output_family_of_chain_generator chain_generator)

/-- Nonempty constructive component-package corollary from chain-output-family assumptions. -/
theorem decisiveSpine_constructive_component_package_exists_of_chain_output_family
    (output_family : DecisiveSpineThresholdChainOutputFamily) :
    Nonempty DecisiveSpineConstructiveComponentPackage := by
  classical
  refine ⟨{
    threshold_of := fun H M A L => Classical.choose (output_family H M A L)
    minimizing_of := fun H M A L =>
      Classical.choose (Classical.choose_spec (output_family H M A L))
    minimal_element_of := fun H M A L =>
      Classical.choose (Classical.choose_spec (Classical.choose_spec (output_family H M A L)))
    U_of := fun H M A L m =>
      let hflux :
          ∀ _m : HardStepMinimalElement,
            ∃ U : VelocityTrajectory .torus3,
              ∃ t0 : ℝ,
                DecisiveSpineLowerHypotheses U t0 ∧
                DecisiveSpineUpperHypotheses U t0 :=
        Classical.choose_spec
          (Classical.choose_spec (Classical.choose_spec (output_family H M A L)))
      Classical.choose (hflux m)
    t0_of := fun H M A L m =>
      let hflux :
          ∀ _m : HardStepMinimalElement,
            ∃ U : VelocityTrajectory .torus3,
              ∃ t0 : ℝ,
                DecisiveSpineLowerHypotheses U t0 ∧
                DecisiveSpineUpperHypotheses U t0 :=
        Classical.choose_spec
          (Classical.choose_spec (Classical.choose_spec (output_family H M A L)))
      Classical.choose (Classical.choose_spec (hflux m))
    lower_hypotheses_of := fun H M A L m =>
      let hflux :
          ∀ _m : HardStepMinimalElement,
            ∃ U : VelocityTrajectory .torus3,
              ∃ t0 : ℝ,
                DecisiveSpineLowerHypotheses U t0 ∧
                DecisiveSpineUpperHypotheses U t0 :=
        Classical.choose_spec
          (Classical.choose_spec (Classical.choose_spec (output_family H M A L)))
      (Classical.choose_spec (Classical.choose_spec (hflux m))).1
    upper_hypotheses_of := fun H M A L m =>
      let hflux :
          ∀ _m : HardStepMinimalElement,
            ∃ U : VelocityTrajectory .torus3,
              ∃ t0 : ℝ,
                DecisiveSpineLowerHypotheses U t0 ∧
                DecisiveSpineUpperHypotheses U t0 :=
        Classical.choose_spec
          (Classical.choose_spec (Classical.choose_spec (output_family H M A L)))
      (Classical.choose_spec (Classical.choose_spec (hflux m))).2
    }⟩

/-- Nonempty constructive component-package corollary from chain-data-family assumptions. -/
theorem decisiveSpine_constructive_component_package_exists_of_data_family
    (data_family : DecisiveSpineThresholdChainDataFamily) :
    Nonempty DecisiveSpineConstructiveComponentPackage := by
  exact decisiveSpine_constructive_component_package_exists_of_chain_output_family
    (decisiveSpine_chain_output_family_of_data_family data_family)

/-- Build chain-data families directly from constructive per-instance theorem components. -/
theorem decisiveSpine_threshold_chain_data_family_of_direct_constructive_components
    (threshold_of : DecisiveSpineConstructiveThresholdComponentFamily)
    (minimizing_of : DecisiveSpineConstructiveMinimizingComponentFamily threshold_of)
    (minimal_element_of : DecisiveSpineConstructiveMinimalElementComponentFamily)
    (U_of : DecisiveSpineConstructiveTrajectoryComponentFamily)
    (t0_of : DecisiveSpineConstructiveTimeComponentFamily U_of)
    (lower_hypotheses_of :
      DecisiveSpineConstructiveLowerFluxHypothesisComponentFamily U_of t0_of)
    (upper_hypotheses_of :
      DecisiveSpineConstructiveUpperFluxHypothesisComponentFamily U_of t0_of) :
    DecisiveSpineThresholdChainDataFamily := by
  intro H M A L
  refine ⟨threshold_of H M A L, minimizing_of H M A L, minimal_element_of H M A L, ?_⟩
  intro m
  refine ⟨(U_of H M A L) m, (t0_of H M A L m), ?_, ?_⟩
  · exact lower_hypotheses_of H M A L m
  · exact upper_hypotheses_of H M A L m

/-- Build explicit chain-output family directly from constructive per-instance theorem components. -/
theorem decisiveSpine_chain_output_family_of_direct_constructive_components
    (threshold_of : DecisiveSpineConstructiveThresholdComponentFamily)
    (minimizing_of : DecisiveSpineConstructiveMinimizingComponentFamily threshold_of)
    (minimal_element_of : DecisiveSpineConstructiveMinimalElementComponentFamily)
    (U_of : DecisiveSpineConstructiveTrajectoryComponentFamily)
    (t0_of : DecisiveSpineConstructiveTimeComponentFamily U_of)
    (lower_hypotheses_of :
      DecisiveSpineConstructiveLowerFluxHypothesisComponentFamily U_of t0_of)
    (upper_hypotheses_of :
      DecisiveSpineConstructiveUpperFluxHypothesisComponentFamily U_of t0_of) :
    DecisiveSpineThresholdChainOutputFamily := by
  intro H M A L
  refine ⟨threshold_of H M A L, minimizing_of H M A L, minimal_element_of H M A L, ?_⟩
  intro m
  refine ⟨(U_of H M A L) m, (t0_of H M A L m), ?_, ?_⟩
  · exact lower_hypotheses_of H M A L m
  · exact upper_hypotheses_of H M A L m

/-- Build chain generators directly from constructive per-instance theorem components. -/
theorem decisiveSpine_threshold_chain_generator_of_direct_constructive_components
    (threshold_of : DecisiveSpineConstructiveThresholdComponentFamily)
    (minimizing_of : DecisiveSpineConstructiveMinimizingComponentFamily threshold_of)
    (minimal_element_of : DecisiveSpineConstructiveMinimalElementComponentFamily)
    (U_of : DecisiveSpineConstructiveTrajectoryComponentFamily)
    (t0_of : DecisiveSpineConstructiveTimeComponentFamily U_of)
    (lower_hypotheses_of :
      DecisiveSpineConstructiveLowerFluxHypothesisComponentFamily U_of t0_of)
    (upper_hypotheses_of :
      DecisiveSpineConstructiveUpperFluxHypothesisComponentFamily U_of t0_of) :
    DecisiveSpineThresholdChainGenerator := by
  exact decisiveSpine_chain_generator_of_chain_output_family
    (decisiveSpine_chain_output_family_of_direct_constructive_components
      threshold_of minimizing_of minimal_element_of U_of t0_of
      lower_hypotheses_of upper_hypotheses_of)

/-- Build explicit chain-output family from a packaged constructive no-local-fallback route. -/
theorem decisiveSpine_chain_output_family_of_component_package
    (P : DecisiveSpineConstructiveComponentPackage) :
    DecisiveSpineThresholdChainOutputFamily := by
  exact decisiveSpine_chain_output_family_of_direct_constructive_components
    P.threshold_of P.minimizing_of P.minimal_element_of P.U_of P.t0_of
    P.lower_hypotheses_of P.upper_hypotheses_of

/-- Build chain generator from a packaged constructive no-local-fallback route. -/
theorem decisiveSpine_threshold_chain_generator_of_component_package
    (P : DecisiveSpineConstructiveComponentPackage) :
    DecisiveSpineThresholdChainGenerator := by
  exact decisiveSpine_chain_generator_of_chain_output_family
    (decisiveSpine_chain_output_family_of_component_package P)

/-! ## No-local-fallback closure -/

/-- No-local-fallback decisive global closure from explicit chain-output families. -/
def decisiveGlobalClosureTheorem_no_local_fallback_of_chain_output_family
    (output_family : DecisiveSpineThresholdChainOutputFamily) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ A : FaithfulAnalyticStack,
          ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True := by
  intro H M A L
  exact decisiveGlobalClosureTheorem_from_threshold_minimal_chain
    (output_family H M A L) H M A L

/-- No-local-fallback decisive global closure from explicit chain-generator hypotheses. -/
def decisiveGlobalClosureTheorem_no_local_fallback_of_chain_generator
    (chain_generator : DecisiveSpineThresholdChainGenerator) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ A : FaithfulAnalyticStack,
          ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True :=
  decisiveGlobalClosureTheorem_no_local_fallback_of_chain_output_family
    (decisiveSpine_chain_output_family_of_chain_generator chain_generator)

/-! ## Constructive closure route -/

/-- Constructive decisive global closure endpoint, routed through no-local-fallback chain generation. -/
def decisiveGlobalClosureTheorem_constructive
    (threshold_of : DecisiveSpineConstructiveThresholdComponentFamily)
    (minimizing_of : DecisiveSpineConstructiveMinimizingComponentFamily threshold_of)
    (minimal_element_of : DecisiveSpineConstructiveMinimalElementComponentFamily)
    (U_of : DecisiveSpineConstructiveTrajectoryComponentFamily)
    (t0_of : DecisiveSpineConstructiveTimeComponentFamily U_of)
    (lower_hypotheses_of :
      DecisiveSpineConstructiveLowerFluxHypothesisComponentFamily U_of t0_of)
    (upper_hypotheses_of :
      DecisiveSpineConstructiveUpperFluxHypothesisComponentFamily U_of t0_of) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ A : FaithfulAnalyticStack,
          ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True :=
  decisiveGlobalClosureTheorem_no_local_fallback_of_chain_output_family
    (decisiveSpine_chain_output_family_of_direct_constructive_components
      threshold_of minimizing_of minimal_element_of U_of t0_of
      lower_hypotheses_of upper_hypotheses_of)

/-- Constructive decisive global closure endpoint from a packaged component route. -/
def decisiveGlobalClosureTheorem_constructive_of_component_package
    (P : DecisiveSpineConstructiveComponentPackage) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ A : FaithfulAnalyticStack,
          ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True :=
  decisiveGlobalClosureTheorem_no_local_fallback_of_chain_output_family
    (decisiveSpine_chain_output_family_of_component_package P)

/-! ## Theorem interfaces -/

/-- Unconditional global closure theorem interface from decisive hard step. -/
theorem decisive_unconditional_global_closure
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ A : FaithfulAnalyticStack,
            ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ A : FaithfulAnalyticStack,
        ∀ L : FaithfulMildLocalTheory H M.base A,
            ∃ _Gd : FaithfulHardGlobalData H M.base A L, True :=
  global_closure

/-- Global strong-solution extension theorem interface in decisive faithful model. -/
theorem decisive_global_strong_solution_extension
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ A : FaithfulAnalyticStack,
            ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ A : FaithfulAnalyticStack,
          ∀ _L : FaithfulMildLocalTheory H M.base A,
            ∃ sol : StrongSolution M.base.NS,
              sol.vel 0 = H.u0 ∧
              Condition10 sol.vel ∧
              Condition11 M.base.NS sol := by
  intro H M A L
  rcases global_closure H M A L with ⟨Gd, _⟩
  exact Gd

end Gibbs.ContinuumField.NavierStokes
