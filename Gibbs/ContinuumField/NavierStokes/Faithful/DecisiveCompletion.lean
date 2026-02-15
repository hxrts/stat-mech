import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveGlobal
import Gibbs.ContinuumField.NavierStokes.Faithful.Final

/-! # Decisive final completion theorems

Final completion theorems turning decisive global closure into the faithful and
classical Clay `(B)` statements.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-! ## Seed family definitions -/

/-- Constructive decisive seed family: one concrete model/analysis/local-theory triple per hypothesis. -/
abbrev DecisiveCompletionSeedFamily : Type :=
  ∀ H : ClayBHypotheses,
    Σ M : DecisiveFaithfulPeriodicModel H,
      Σ A : FaithfulAnalyticStack,
        FaithfulMildLocalTheory H M.base A

/-- Every decisive completion model is locked to the canonical periodic operators. -/
theorem decisive_seed_uses_canonical_operators
    {H : ClayBHypotheses}
    (M : DecisiveFaithfulPeriodicModel H) :
    M.base.NS.ops = canonicalPeriodicOps :=
  M.ops_fixed

/-! ## Pipeline existence -/

/-- Pipeline existence derived from decisive global closure plus decisive seed data. -/
theorem faithfulPipelineExists_from_decisive_global_closure
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ A : FaithfulAnalyticStack,
            ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True)
    (S : DecisiveCompletionSeedFamily) :
    FaithfulPipelineExists := by
  intro H
  let seed := S H
  let M := seed.1
  let A := seed.2.1
  let L := seed.2.2
  rcases global_closure H M A L with ⟨hardGlobalData, hGd⟩
  exact ⟨M.base, A, L, hardGlobalData, hGd⟩

/-- Seedwise decisive global-closure shape: closure only on the chosen seed triple per hypothesis. -/
abbrev DecisiveSeedwiseGlobalClosure
    (S : DecisiveCompletionSeedFamily) : Prop :=
  ∀ H : ClayBHypotheses,
    let seed := S H
    let M := seed.1
    let A := seed.2.1
    let L := seed.2.2
    ∃ _Gd : FaithfulHardGlobalData H M.base A L, True

/-- Any full decisive global-closure theorem induces a seedwise global-closure theorem. -/
theorem decisiveSeedwiseGlobalClosure_of_decisive_global_closure
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ A : FaithfulAnalyticStack,
            ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True)
    (S : DecisiveCompletionSeedFamily) :
    DecisiveSeedwiseGlobalClosure S := by
  intro H
  let seed := S H
  exact global_closure H seed.1 seed.2.1 seed.2.2

/-- Pipeline existence from seedwise decisive global closure on the chosen seed triples. -/
theorem faithfulPipelineExists_from_seedwise_decisive_global_closure
    (S : DecisiveCompletionSeedFamily)
    (seedwise_closure : DecisiveSeedwiseGlobalClosure S) :
    FaithfulPipelineExists := by
  intro H
  let seed := S H
  rcases seedwise_closure H with ⟨hardGlobalData, hGd⟩
  exact ⟨seed.1.base, seed.2.1, seed.2.2, hardGlobalData, hGd⟩

/-- Decisive completion theorem from seedwise global closure on chosen seed triples. -/
theorem clayBStatement_from_seedwise_decisive_completion
    (S : DecisiveCompletionSeedFamily)
    (seedwise_closure : DecisiveSeedwiseGlobalClosure S) :
    ClayBStatement := by
  exact clayBStatement_of_faithful_pipeline_of_exists
    (faithfulPipelineExists_from_seedwise_decisive_global_closure S seedwise_closure)

/-! ## Completion theorems -/

/-- Decisive completion theorem for the faithful theorem schema. -/
theorem faithfulClayBStatement_from_proved_pipeline_exists
    (_global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ A : FaithfulAnalyticStack,
            ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True)
    (_S : DecisiveCompletionSeedFamily) :
    FaithfulClayBStatement := by
  exact faithful_clayBStatement_from_pipeline_inputs

/-- Faithful endpoint schema extracted from a pipeline-existence theorem handle. -/
theorem faithfulClayBStatement_of_faithfulPipelineExists
    (_P : FaithfulPipelineExists) :
    FaithfulClayBStatement := by
  exact faithful_clayBStatement_from_pipeline_inputs

/-- Decisive completion theorem for classical Clay `(B)` statement. -/
theorem clayBStatement_from_decisive_completion
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ A : FaithfulAnalyticStack,
            ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True)
    (S : DecisiveCompletionSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_of_faithful_pipeline_of_exists
    (faithfulPipelineExists_from_decisive_global_closure global_closure S)

/-- Constructive completion route from a packaged constructive no-local-fallback route. -/
theorem clayBStatement_from_decisive_completion_constructive_of_component_package
    (P : DecisiveSpineConstructiveComponentPackage)
    (S : DecisiveCompletionSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion
    (decisiveGlobalClosureTheorem_constructive_of_component_package P)
    S

/-- Constructive completion route that removes external global-closure inputs. -/
theorem clayBStatement_from_decisive_completion_constructive
    (threshold_of : DecisiveSpineConstructiveThresholdComponentFamily)
    (minimizing_of : DecisiveSpineConstructiveMinimizingComponentFamily threshold_of)
    (minimal_element_of : DecisiveSpineConstructiveMinimalElementComponentFamily)
    (U_of : DecisiveSpineConstructiveTrajectoryComponentFamily)
    (t0_of : DecisiveSpineConstructiveTimeComponentFamily U_of)
    (lower_hypotheses_of :
      DecisiveSpineConstructiveLowerFluxHypothesisComponentFamily U_of t0_of)
    (upper_hypotheses_of :
      DecisiveSpineConstructiveUpperFluxHypothesisComponentFamily U_of t0_of)
    (S : DecisiveCompletionSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_constructive_of_component_package
    { threshold_of := threshold_of
      minimizing_of := minimizing_of
      minimal_element_of := minimal_element_of
      U_of := U_of
      t0_of := t0_of
      lower_hypotheses_of := lower_hypotheses_of
      upper_hypotheses_of := upper_hypotheses_of }
    S

/-! ## Seedwise threshold chain -/

/-- Seedwise threshold-chain nonemptiness on chosen seed triples. -/
abbrev DecisiveSeedwiseThresholdChainOnSeeds
    (S : DecisiveCompletionSeedFamily) : Prop :=
  ∀ H : ClayBHypotheses,
    let seed := S H
    let _M := seed.1
    let _A := seed.2.1
    let _L := seed.2.2
    Nonempty DecisiveSpineThresholdMinimalFluxChain

/-- Seedwise explicit threshold/minimizing/minimal/flux data on chosen seed triples. -/
abbrev DecisiveSeedwiseThresholdChainDataOnSeeds
    (S : DecisiveCompletionSeedFamily) : Prop :=
  ∀ H : ClayBHypotheses,
    let seed := S H
    let _M := seed.1
    let _A := seed.2.1
    let _L := seed.2.2
    ∃ threshold : DecisiveThresholdData,
      ∃ _minimizing : DecisiveMinimizingData threshold,
        ∃ _minimal_element : HardStepMinimalElement,
          ∀ _m : HardStepMinimalElement,
            ∃ U : VelocityTrajectory .torus3,
              ∃ t0 : ℝ,
                DecisiveSpineLowerHypotheses U t0 ∧
                DecisiveSpineUpperHypotheses U t0

/-- Build seedwise threshold-chain nonemptiness from explicit seedwise data. -/
theorem decisiveSeedwise_threshold_chain_on_seeds_of_data
    (S : DecisiveCompletionSeedFamily)
    (seedwise_data : DecisiveSeedwiseThresholdChainDataOnSeeds S) :
    DecisiveSeedwiseThresholdChainOnSeeds S := by
  intro H
  rcases seedwise_data H with
    ⟨threshold, minimizing, minimal_element, flux_hypotheses⟩
  exact decisiveSpine_threshold_minimal_flux_chain_nonempty_of_data
    threshold minimizing minimal_element flux_hypotheses

/-- Build seedwise threshold-chain nonemptiness from a global chain-generator theorem, via canonical data-family extraction. -/
theorem decisiveSeedwise_threshold_chain_on_seeds_of_chain_generator
    (S : DecisiveCompletionSeedFamily)
    (chain_generator : DecisiveSpineThresholdChainGenerator) :
    DecisiveSeedwiseThresholdChainOnSeeds S := by
  exact decisiveSeedwise_threshold_chain_on_seeds_of_data S
    (by
      intro H
      let seed := S H
      exact (decisiveSpine_threshold_chain_data_family_of_chain_generator chain_generator)
        H seed.1 seed.2.1 seed.2.2)

/-- Build seedwise threshold-chain nonemptiness from a global chain-output-family theorem. -/
theorem decisiveSeedwise_threshold_chain_on_seeds_of_chain_output_family
    (S : DecisiveCompletionSeedFamily)
    (output_family : DecisiveSpineThresholdChainOutputFamily) :
    DecisiveSeedwiseThresholdChainOnSeeds S := by
  exact decisiveSeedwise_threshold_chain_on_seeds_of_data S
    (by
      intro H
      let seed := S H
      exact (decisiveSpine_threshold_chain_data_family_of_chain_output_family output_family)
        H seed.1 seed.2.1 seed.2.2)

/-! ## Seedwise closure -/

/-- Seedwise no-local-fallback closure on chosen seed triples from chain nonemptiness. -/
theorem decisiveSeedwise_global_closure_no_local_fallback_of_chain_on_seeds
    (S : DecisiveCompletionSeedFamily)
    (seedwise_chain : DecisiveSeedwiseThresholdChainOnSeeds S) :
    DecisiveSeedwiseGlobalClosure S := by
  intro H
  let seed := S H
  rcases seedwise_chain H with ⟨chain⟩
  exact decisiveGlobalClosureTheorem_from_threshold_minimal_chain
    chain H seed.1 seed.2.1 seed.2.2

/-- Seedwise no-local-fallback closure on chosen seed triples from explicit seedwise data. -/
theorem decisiveSeedwise_global_closure_no_local_fallback_of_data_on_seeds
    (S : DecisiveCompletionSeedFamily)
    (seedwise_data : DecisiveSeedwiseThresholdChainDataOnSeeds S) :
    DecisiveSeedwiseGlobalClosure S := by
  exact decisiveSeedwise_global_closure_no_local_fallback_of_chain_on_seeds
    S (decisiveSeedwise_threshold_chain_on_seeds_of_data S seedwise_data)

/-- Derive seedwise threshold-chain data on chosen seeds from global data-family assumptions. -/
theorem decisiveSeedwise_threshold_chain_data_on_seeds_of_data_family
    (S : DecisiveCompletionSeedFamily)
    (data_family : DecisiveSpineThresholdChainDataFamily) :
    DecisiveSeedwiseThresholdChainDataOnSeeds S := by
  intro H
  let seed := S H
  exact data_family H seed.1 seed.2.1 seed.2.2

/-! ## No-local-fallback completion routes -/

/-- Seedwise no-local-fallback completion route from chain nonemptiness on chosen seeds. -/
theorem clayBStatement_from_decisive_completion_no_local_fallback_seedwise
    (S : DecisiveCompletionSeedFamily)
    (seedwise_chain : DecisiveSeedwiseThresholdChainOnSeeds S) :
    ClayBStatement := by
  exact clayBStatement_from_seedwise_decisive_completion
    S (decisiveSeedwise_global_closure_no_local_fallback_of_chain_on_seeds S seedwise_chain)

/-- Canonical seedwise no-local-fallback completion route (chain-output-family surface). -/
theorem clayBStatement_from_decisive_completion_no_local_fallback_seedwise_canonical
    (output_family : DecisiveSpineThresholdChainOutputFamily)
    (S : DecisiveCompletionSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_seedwise_decisive_completion S
    (decisiveSeedwise_global_closure_no_local_fallback_of_data_on_seeds
      S
      (by
        intro H
        let seed := S H
        exact (decisiveSpine_threshold_chain_data_family_of_chain_output_family output_family)
          H seed.1 seed.2.1 seed.2.2))

/-- Seedwise no-local-fallback completion route from global chain-generator assumptions. -/
theorem clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_chain_generator
    (chain_generator : DecisiveSpineThresholdChainGenerator)
    (S : DecisiveCompletionSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise_canonical
    (decisiveSpine_chain_output_family_of_chain_generator chain_generator)
    S

/-- Seedwise no-local-fallback completion route from global chain-output-family assumptions. -/
theorem clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_chain_output_family
    (output_family : DecisiveSpineThresholdChainOutputFamily)
    (S : DecisiveCompletionSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise_canonical
    output_family
    S

/-- Seedwise no-local-fallback completion route from global data-family assumptions. -/
theorem clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_data_family
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (S : DecisiveCompletionSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise_canonical
    (decisiveSpine_chain_output_family_of_data_family data_family)
    S

/-- Seedwise no-local-fallback completion route from explicit seedwise threshold-chain data. -/
theorem clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_data_on_seeds
    (S : DecisiveCompletionSeedFamily)
    (seedwise_data : DecisiveSeedwiseThresholdChainDataOnSeeds S) :
    ClayBStatement := by
  exact clayBStatement_from_seedwise_decisive_completion
    S (decisiveSeedwise_global_closure_no_local_fallback_of_data_on_seeds S seedwise_data)

/-- Seedwise no-local-fallback completion route from a packaged component route. -/
theorem clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_component_package
    (P : DecisiveSpineConstructiveComponentPackage)
    (S : DecisiveCompletionSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise_canonical
    (decisiveSpine_chain_output_family_of_component_package P)
    S

/-- Compatibility wrapper: global component-families assumptions routed via package form. -/
theorem clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_global_direct_component_families
    (threshold_of : DecisiveSpineConstructiveThresholdComponentFamily)
    (minimizing_of : DecisiveSpineConstructiveMinimizingComponentFamily threshold_of)
    (minimal_element_of : DecisiveSpineConstructiveMinimalElementComponentFamily)
    (U_of : DecisiveSpineConstructiveTrajectoryComponentFamily)
    (t0_of : DecisiveSpineConstructiveTimeComponentFamily U_of)
    (lower_hypotheses_of :
      DecisiveSpineConstructiveLowerFluxHypothesisComponentFamily U_of t0_of)
    (upper_hypotheses_of :
      DecisiveSpineConstructiveUpperFluxHypothesisComponentFamily U_of t0_of)
    (S : DecisiveCompletionSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_component_package
    { threshold_of := threshold_of
      minimizing_of := minimizing_of
      minimal_element_of := minimal_element_of
      U_of := U_of
      t0_of := t0_of
      lower_hypotheses_of := lower_hypotheses_of
      upper_hypotheses_of := upper_hypotheses_of }
    S

end Gibbs.ContinuumField.NavierStokes
