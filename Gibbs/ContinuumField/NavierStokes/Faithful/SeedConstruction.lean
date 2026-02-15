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

/-- Explicit per-hypothesis existence of decisive seed triples. -/
abbrev ConstructiveDecisiveSeedTripleExistence : Prop :=
  ∀ H : ClayBHypotheses,
    ∃ M : DecisiveFaithfulPeriodicModel H,
      ∃ A : FaithfulAnalyticStack,
        ∃ _L : FaithfulMildLocalTheory H M.base A, True

/-- Nonempty constructive decisive seed-family corollary from explicit seed-triple existence. -/
theorem constructiveDecisiveSeedFamily_exists_of_seed_triple_existence
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    Nonempty ConstructiveDecisiveSeedFamily := by
  classical
  refine ⟨?_⟩
  intro H
  let M : DecisiveFaithfulPeriodicModel H := Classical.choose (seed_exists H)
  let hA :
      ∃ A : FaithfulAnalyticStack,
        ∃ _L : FaithfulMildLocalTheory H M.base A, True :=
    Classical.choose_spec (seed_exists H)
  let A : FaithfulAnalyticStack := Classical.choose hA
  let hL : ∃ _L : FaithfulMildLocalTheory H M.base A, True :=
    Classical.choose_spec hA
  let L : FaithfulMildLocalTheory H M.base A := Classical.choose hL
  exact ⟨M, A, L⟩

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
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_chain_output_family
    (decisiveSpine_chain_output_family_of_chain_generator chain_generator)
    build_seed

/-- Final endpoint route from chain-generator hypotheses and seed-triple existence. -/
theorem clayBStatement_from_no_local_fallback_seedwise_chain_generator_and_seed_triple_existence
    (chain_generator : DecisiveSpineThresholdChainGenerator)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  rcases constructiveDecisiveSeedFamily_exists_of_seed_triple_existence seed_exists with ⟨S⟩
  exact clayBStatement_from_no_local_fallback_seedwise_chain_generator_and_seed_construction
    chain_generator S

/-- Final endpoint route from chain-output-family hypotheses via seedwise no-fallback completion. -/
theorem clayBStatement_from_no_local_fallback_seedwise_chain_output_family_and_seed_construction
    (output_family : DecisiveSpineThresholdChainOutputFamily)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_chain_output_family
    output_family build_seed

/-- Final endpoint route from definitive chain-output theorem data via seedwise no-fallback completion. -/
theorem clayBStatement_from_definitive_chain_output_and_seed_construction
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_no_local_fallback_seedwise_chain_output_family_and_seed_construction
    (decisiveSpine_chain_output_family_of_definitive_chain_output definitive_output)
    build_seed

/-- Canonical no-local-fallback endpoint route from definitive chain-output theorem data and seed-triple existence. -/
theorem clayBStatement_from_definitive_chain_output_and_seed_triple_existence
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  rcases constructiveDecisiveSeedFamily_exists_of_seed_triple_existence seed_exists with ⟨S⟩
  exact clayBStatement_from_definitive_chain_output_and_seed_construction
    definitive_output S

/-- Canonical no-local-fallback endpoint route from chain-output-family assumptions and seed-triple existence. -/
theorem clayBStatement_from_no_local_fallback_chain_output_family_and_seed_triple_existence
    (output_family : DecisiveSpineThresholdChainOutputFamily)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  rcases constructiveDecisiveSeedFamily_exists_of_seed_triple_existence seed_exists with ⟨S⟩
  exact clayBStatement_from_no_local_fallback_seedwise_chain_output_family_and_seed_construction
    output_family S

/-- Canonical endpoint route from chain-output-family assumptions via constructed component package and seed-triple existence. -/
theorem clayBStatement_from_chain_output_family_via_constructive_component_package_and_seed_triple_existence
    (output_family : DecisiveSpineThresholdChainOutputFamily)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  rcases decisiveSpine_constructive_component_package_exists_of_chain_output_family output_family with ⟨P⟩
  rcases constructiveDecisiveSeedFamily_exists_of_seed_triple_existence seed_exists with ⟨S⟩
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_component_package P S

/-- Final endpoint route from seedwise chain nonemptiness on chosen seed triples. -/
theorem clayBStatement_from_no_local_fallback_seedwise_chain_on_seeds_and_seed_construction
    (build_seed : ConstructiveDecisiveSeedFamily)
    (seedwise_chain : DecisiveSeedwiseThresholdChainOnSeeds build_seed) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise
    build_seed seedwise_chain

/-- Canonical no-local-fallback endpoint route (chain-output-family + seed construction). -/
theorem clayBStatement_from_no_local_fallback_canonical_chain_output_route_and_seed_construction
    (output_family : DecisiveSpineThresholdChainOutputFamily)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_no_local_fallback_seedwise_chain_output_family_and_seed_construction
    output_family build_seed

/-- Final endpoint route from explicit per-instance chain data and constructive seeds. -/
theorem clayBStatement_from_no_local_fallback_data_family_and_seed_construction
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_no_local_fallback_canonical_chain_output_route_and_seed_construction
    (decisiveSpine_chain_output_family_of_data_family data_family)
    build_seed

/-- Final endpoint route from explicit per-instance chain data and seed-triple existence. -/
theorem clayBStatement_from_no_local_fallback_data_family_and_seed_triple_existence
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  rcases constructiveDecisiveSeedFamily_exists_of_seed_triple_existence seed_exists with ⟨S⟩
  exact clayBStatement_from_no_local_fallback_data_family_and_seed_construction
    data_family S

/-- Compatibility wrapper preserving the previous canonical data-route endpoint surface. -/
theorem clayBStatement_from_no_local_fallback_canonical_data_route_and_seed_construction
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_no_local_fallback_data_family_and_seed_construction
    data_family build_seed

/-- Canonical no-local-fallback endpoint route from a packaged component route. -/
theorem clayBStatement_from_no_local_fallback_component_package_and_seed_construction
    (P : DecisiveSpineConstructiveComponentPackage)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_no_local_fallback_canonical_chain_output_route_and_seed_construction
    (decisiveSpine_chain_output_family_of_component_package P)
    build_seed

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

/-- Compatibility wrapper: component-family route reduced to packaged-component route. -/
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
  exact clayBStatement_from_no_local_fallback_component_package_and_seed_construction
    { threshold_of := threshold_of
      minimizing_of := minimizing_of
      minimal_element_of := minimal_element_of
      U_of := U_of
      t0_of := t0_of
      lower_hypotheses_of := lower_hypotheses_of
      upper_hypotheses_of := upper_hypotheses_of }
    build_seed

end Gibbs.ContinuumField.NavierStokes
