import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveCompletion

/-! # Faithful decisive seed construction

Constructive seed-family interfaces for endpoint theorems.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-! ## Seed family definition -/

/-- Constructive decisive seed family: one concrete seed for every hypothesis. -/
abbrev ConstructiveDecisiveSeedFamily : Type :=
  DecisiveCompletionSeedFamily

/-- Concrete model/analysis/local-theory triple exists for each hypothesis package. -/
theorem decisiveSeed_concrete_triple_exists
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ∀ H : ClayBHypotheses,
      ∃ M : DecisiveFaithfulPeriodicModel H,
        ∃ A : FaithfulAnalyticStack,
          ∃ _L : FaithfulMildLocalTheory H M.base A, True := by
  intro H
  let seed := build_seed H
  exact ⟨seed.1, seed.2.1, seed.2.2, trivial⟩

/-! ## Pipeline existence and completion -/

/-- Pipeline existence from decisive closure and constructive seed family. -/
theorem faithfulPipelineExists_from_constructive_seeds
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ A : FaithfulAnalyticStack,
            ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True)
    (S : ConstructiveDecisiveSeedFamily) :
    FaithfulPipelineExists := by
  exact faithfulPipelineExists_from_decisive_global_closure global_closure S

/-- Final Clay `(B)` endpoint with no `Nonempty` seed-family assumptions. -/
theorem clayBStatement_from_decisive_completion_no_nonempty
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ A : FaithfulAnalyticStack,
            ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True)
    (S : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_of_faithful_pipeline_of_exists
    (faithfulPipelineExists_from_constructive_seeds global_closure S)

/-- Final Clay `(B)` endpoint from seed-construction theorem package. -/
theorem clayBStatement_from_seed_construction
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ A : FaithfulAnalyticStack,
            ∀ L : FaithfulMildLocalTheory H M.base A,
              ∃ _Gd : FaithfulHardGlobalData H M.base A L, True)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_nonempty global_closure build_seed

/-! ## Final endpoint routes (chain-based) -/

/-- Final endpoint route using the constructive decisive global closure theorem. -/
theorem clayBStatement_from_constructive_global_closure_and_seed_construction
    (threshold_of : DecisiveSpineConstructiveThresholdComponentFamily)
    (minimizing_of : DecisiveSpineConstructiveMinimizingComponentFamily threshold_of)
    (minimal_element_of : DecisiveSpineConstructiveMinimalElementComponentFamily)
    (U_of : DecisiveSpineConstructiveTrajectoryComponentFamily)
    (t0_of : DecisiveSpineConstructiveTimeComponentFamily U_of)
    (lower_hypotheses_of :
      DecisiveSpineConstructiveLowerFluxHypothesisComponentFamily U_of t0_of)
    (upper_hypotheses_of :
      DecisiveSpineConstructiveUpperFluxHypothesisComponentFamily U_of t0_of)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_seed_construction
    (decisiveGlobalClosureTheorem_constructive
      threshold_of minimizing_of minimal_element_of U_of t0_of
      lower_hypotheses_of upper_hypotheses_of)
    build_seed

/-- Final endpoint route from chain-generator hypotheses via seedwise no-fallback completion. -/
theorem clayBStatement_from_no_local_fallback_seedwise_chain_generator_and_seed_construction
    (chain_generator : DecisiveSpineThresholdChainGenerator)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_chain_generator
    chain_generator build_seed

/-- Final endpoint route from seedwise chain nonemptiness on chosen seed triples. -/
theorem clayBStatement_from_no_local_fallback_seedwise_chain_on_seeds_and_seed_construction
    (build_seed : ConstructiveDecisiveSeedFamily)
    (seedwise_chain : DecisiveSeedwiseThresholdChainOnSeeds build_seed) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise
    build_seed seedwise_chain

/-- Final endpoint route from explicit per-instance chain data and constructive seeds. -/
theorem clayBStatement_from_no_local_fallback_data_family_and_seed_construction
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_data_family
    data_family build_seed

/-- Final endpoint route from explicit seedwise chain data on chosen seed triples. -/
theorem clayBStatement_from_no_local_fallback_seedwise_data_on_seeds_and_seed_construction
    (build_seed : ConstructiveDecisiveSeedFamily)
    (seedwise_data : DecisiveSeedwiseThresholdChainDataOnSeeds build_seed) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_data_on_seeds
    build_seed seedwise_data

/-! ## Final endpoint routes (component families) -/

/-- Final endpoint route from seedwise per-hypothesis component families and constructive seeds. -/
theorem clayBStatement_from_no_local_fallback_seedwise_component_families_and_seed_construction
    (build_seed : ConstructiveDecisiveSeedFamily)
    (threshold_on_seeds : ∀ _H : ClayBHypotheses, DecisiveThresholdData)
    (minimizing_on_seeds :
      ∀ H : ClayBHypotheses,
        DecisiveMinimizingData (threshold_on_seeds H))
    (minimal_element_on_seeds :
      ∀ _H : ClayBHypotheses, HardStepMinimalElement)
    (flux_hypotheses_on_seeds :
      ∀ _H : ClayBHypotheses,
        ∀ _m : HardStepMinimalElement,
          ∃ U : VelocityTrajectory .torus3,
            ∃ t0 : ℝ,
              DecisiveSpineLowerHypotheses U t0 ∧
              DecisiveSpineUpperHypotheses U t0) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_data_on_seeds
    build_seed
    (by
      intro H
      exact ⟨threshold_on_seeds H, minimizing_on_seeds H, minimal_element_on_seeds H,
        flux_hypotheses_on_seeds H⟩)

/-- Final endpoint route from explicit component theorem families and constructive seeds. -/
theorem clayBStatement_from_no_local_fallback_component_families_and_seed_construction
    (threshold_of : DecisiveSpineConstructiveThresholdComponentFamily)
    (minimizing_of : DecisiveSpineConstructiveMinimizingComponentFamily threshold_of)
    (minimal_element_of : DecisiveSpineConstructiveMinimalElementComponentFamily)
    (U_of : DecisiveSpineConstructiveTrajectoryComponentFamily)
    (t0_of : DecisiveSpineConstructiveTimeComponentFamily U_of)
    (lower_hypotheses_of :
      DecisiveSpineConstructiveLowerFluxHypothesisComponentFamily U_of t0_of)
    (upper_hypotheses_of :
      DecisiveSpineConstructiveUpperFluxHypothesisComponentFamily U_of t0_of)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_global_direct_component_families
    threshold_of minimizing_of minimal_element_of U_of t0_of
    lower_hypotheses_of upper_hypotheses_of build_seed

end Gibbs.ContinuumField.NavierStokes
