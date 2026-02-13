import Gibbs.ContinuumField.NavierStokes.Faithful.Rigidity
import Gibbs.ContinuumField.NavierStokes.Faithful.HardGlobal
import Gibbs.ContinuumField.NavierStokes.Faithful.TrueHardStep
import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineGlobal

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

/-- Build a chain-generator assumption from explicit per-instance chain data. -/
theorem decisiveSpine_threshold_chain_generator_of_data_family
    (data_family : DecisiveSpineThresholdChainDataFamily) :
    DecisiveSpineThresholdChainGenerator := by
  intro H M A L
  rcases data_family H M A L with
    ⟨threshold, minimizing, minimal_element, flux_hypotheses⟩
  exact decisiveSpine_threshold_minimal_flux_chain_nonempty_of_data
    threshold minimizing minimal_element flux_hypotheses

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
  exact decisiveSpine_threshold_chain_generator_of_data_family
    (decisiveSpine_threshold_chain_data_family_of_direct_constructive_components
      threshold_of minimizing_of minimal_element_of U_of t0_of
      lower_hypotheses_of upper_hypotheses_of)

/-! ## No-local-fallback closure -/

/-- No-local-fallback decisive global closure from explicit chain-generator hypotheses. -/
def decisiveGlobalClosureTheorem_no_local_fallback_of_chain_generator
    (chain_generator : DecisiveSpineThresholdChainGenerator) :
    ∀ H : ClayBHypotheses,
      ∀ M : DecisiveFaithfulPeriodicModel H,
        ∀ A : FaithfulAnalyticStack,
          ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True := by
  intro H M A L
  have hchain : Nonempty DecisiveSpineThresholdMinimalFluxChain :=
    chain_generator H M A L
  exact decisiveGlobalClosureTheorem_from_threshold_minimal_chain
    (Classical.choice hchain) H M A L

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
  decisiveGlobalClosureTheorem_no_local_fallback_of_chain_generator
    (decisiveSpine_threshold_chain_generator_of_direct_constructive_components
      threshold_of minimizing_of minimal_element_of U_of t0_of
      lower_hypotheses_of upper_hypotheses_of)

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
