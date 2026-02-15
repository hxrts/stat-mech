import Gibbs.ContinuumField.NavierStokes.Faithful.SeedConstruction

/-! # Faithful decisive root-assumption discharge

Canonical root-assumption surface for the remaining hard step: constructive
chain-output witnesses plus constructive seed-triple existence.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Canonical remaining root assumptions for constructive decisive completion. -/
abbrev DecisiveRootAssumptions : Prop :=
  DecisiveSpineThresholdChainOutputFamily ∧
    ConstructiveDecisiveSeedTripleExistence

/-- Canonical root assumptions normalized to definitive hard-step chain-output theorem data. -/
abbrev DecisiveDefinitiveRootAssumptions : Prop :=
  DefinitiveThresholdMinimalFluxChainOutput ∧
    ConstructiveDecisiveSeedTripleExistence

/-- Canonical root assumptions normalized to constructive seed-family data. -/
abbrev DecisiveConstructiveRootAssumptions : Prop :=
  ∃ _S : ConstructiveDecisiveSeedFamily,
    DecisiveSpineThresholdChainOutputFamily

/-- Canonical definitive-root assumptions normalized to constructive seed-family data. -/
abbrev DecisiveDefinitiveConstructiveRootAssumptions : Prop :=
  ∃ _S : ConstructiveDecisiveSeedFamily,
    DefinitiveThresholdMinimalFluxChainOutput

/-- Chain-output assumptions with seed-family existence (no explicit seed argument). -/
abbrev DecisiveConstructiveSeedExistenceRootAssumptions : Prop :=
  DecisiveSpineThresholdChainOutputFamily ∧
    Nonempty ConstructiveDecisiveSeedFamily

/-- Definitive chain-output assumptions with seed-family existence (no explicit seed argument). -/
abbrev DecisiveDefinitiveConstructiveSeedExistenceRootAssumptions : Prop :=
  DefinitiveThresholdMinimalFluxChainOutput ∧
    Nonempty ConstructiveDecisiveSeedFamily

/-- Minimal seedwise hard-blocker goal: one constructive seed family with seedwise chain data. -/
abbrev DecisiveMinimalRootGoal : Prop :=
  ∃ S : ConstructiveDecisiveSeedFamily,
    DecisiveSeedwiseThresholdChainDataOnSeeds S

/-- Canonical remaining hard-blocker discharge goal. -/
def DecisiveRootDischargeGoal : Prop :=
  DecisiveRootAssumptions

/-- Root discharge goal is definitionally equivalent to the root assumptions. -/
theorem decisiveRootDischargeGoal_iff_root_assumptions :
    DecisiveRootDischargeGoal ↔ DecisiveRootAssumptions := by
  rfl

/-- Definitive-root assumptions imply canonical root assumptions. -/
theorem decisiveRootAssumptions_of_definitive_root_assumptions
    (hdef_root : DecisiveDefinitiveRootAssumptions) :
    DecisiveRootAssumptions := by
  exact ⟨decisiveSpine_chain_output_family_of_definitive_chain_output hdef_root.1, hdef_root.2⟩

/-- Definitive-root assumptions imply the periodic Clay `(B)` statement. -/
theorem clayBStatement_of_definitive_root_assumptions
    (hdef_root : DecisiveDefinitiveRootAssumptions) :
    ClayBStatement := by
  exact clayBStatement_from_no_local_fallback_chain_output_family_and_seed_triple_existence
    (decisiveSpine_chain_output_family_of_definitive_chain_output hdef_root.1)
    hdef_root.2

/-- Seed-existence root assumptions imply constructive root assumptions by witness extraction. -/
theorem decisiveConstructiveRootAssumptions_of_seed_existence_root_assumptions
    (hseed_root : DecisiveConstructiveSeedExistenceRootAssumptions) :
    DecisiveConstructiveRootAssumptions := by
  rcases hseed_root.2 with ⟨S⟩
  exact ⟨S, hseed_root.1⟩

/-- Definitive seed-existence root assumptions imply definitive constructive-root assumptions by witness extraction. -/
theorem decisiveDefinitiveConstructiveRootAssumptions_of_definitive_seed_existence_root_assumptions
    (hdef_seed_root : DecisiveDefinitiveConstructiveSeedExistenceRootAssumptions) :
    DecisiveDefinitiveConstructiveRootAssumptions := by
  rcases hdef_seed_root.2 with ⟨S⟩
  exact ⟨S, hdef_seed_root.1⟩

/-- Chain-output + seed-existence assumptions imply constructive root assumptions. -/
theorem decisiveConstructiveRootAssumptions_of_chain_output_family_and_seed_existence
    (output_family : DecisiveSpineThresholdChainOutputFamily)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    DecisiveConstructiveRootAssumptions := by
  exact decisiveConstructiveRootAssumptions_of_seed_existence_root_assumptions
    ⟨output_family, hseed_exists⟩

/-- Definitive chain-output + seed-existence assumptions imply definitive constructive-root assumptions. -/
theorem decisiveDefinitiveConstructiveRootAssumptions_of_definitive_chain_output_and_seed_existence
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    DecisiveDefinitiveConstructiveRootAssumptions := by
  exact decisiveDefinitiveConstructiveRootAssumptions_of_definitive_seed_existence_root_assumptions
    ⟨definitive_output, hseed_exists⟩

/-- Data-family + seed-existence assumptions imply constructive root assumptions. -/
theorem decisiveConstructiveRootAssumptions_of_data_family_and_seed_existence
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    DecisiveConstructiveRootAssumptions := by
  exact decisiveConstructiveRootAssumptions_of_chain_output_family_and_seed_existence
    (decisiveSpine_chain_output_family_of_data_family data_family) hseed_exists

/-- Chain-generator + seed-existence assumptions imply constructive root assumptions. -/
theorem decisiveConstructiveRootAssumptions_of_chain_generator_and_seed_existence
    (chain_generator : DecisiveSpineThresholdChainGenerator)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    DecisiveConstructiveRootAssumptions := by
  exact decisiveConstructiveRootAssumptions_of_chain_output_family_and_seed_existence
    (decisiveSpine_chain_output_family_of_chain_generator chain_generator) hseed_exists

/-- Component-package + seed-existence assumptions imply constructive root assumptions. -/
theorem decisiveConstructiveRootAssumptions_of_component_package_and_seed_existence
    (P : DecisiveSpineConstructiveComponentPackage)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    DecisiveConstructiveRootAssumptions := by
  exact decisiveConstructiveRootAssumptions_of_chain_output_family_and_seed_existence
    (decisiveSpine_chain_output_family_of_component_package P) hseed_exists

/-- Seed-existence root assumptions imply `Clay(B)` via constructive root assumptions. -/
theorem clayBStatement_of_seed_existence_root_assumptions
    (hseed_root : DecisiveConstructiveSeedExistenceRootAssumptions) :
    ClayBStatement := by
  rcases hseed_root.2 with ⟨S⟩
  exact clayBStatement_from_no_local_fallback_seedwise_chain_output_family_and_seed_construction
    hseed_root.1 S

/-- Definitive seed-existence root assumptions imply `Clay(B)` via definitive constructive-root assumptions. -/
theorem clayBStatement_of_definitive_seed_existence_root_assumptions
    (hdef_seed_root : DecisiveDefinitiveConstructiveSeedExistenceRootAssumptions) :
    ClayBStatement := by
  rcases hdef_seed_root.2 with ⟨S⟩
  exact clayBStatement_from_definitive_chain_output_and_seed_construction
    hdef_seed_root.1 S

/-- Root assumptions imply constructive root assumptions by canonical seed-family extraction. -/
theorem decisiveConstructiveRootAssumptions_of_root_assumptions
    (hroot : DecisiveRootAssumptions) :
    DecisiveConstructiveRootAssumptions := by
  rcases constructiveDecisiveSeedFamily_exists_of_seed_triple_existence hroot.2 with ⟨S⟩
  exact ⟨S, hroot.1⟩

/-- Definitive-root assumptions imply constructive root assumptions by canonical seed-family extraction. -/
theorem decisiveConstructiveRootAssumptions_of_definitive_root_assumptions
    (hdef_root : DecisiveDefinitiveRootAssumptions) :
    DecisiveConstructiveRootAssumptions := by
  rcases constructiveDecisiveSeedFamily_exists_of_seed_triple_existence hdef_root.2 with ⟨S⟩
  exact ⟨S, decisiveSpine_chain_output_family_of_definitive_chain_output hdef_root.1⟩

/-- Definitive-root assumptions imply definitive constructive-root assumptions by canonical seed-family extraction. -/
theorem decisiveDefinitiveConstructiveRootAssumptions_of_definitive_root_assumptions
    (hdef_root : DecisiveDefinitiveRootAssumptions) :
    DecisiveDefinitiveConstructiveRootAssumptions := by
  rcases constructiveDecisiveSeedFamily_exists_of_seed_triple_existence hdef_root.2 with ⟨S⟩
  exact ⟨S, hdef_root.1⟩

/-- Root assumptions imply seed-existence root assumptions by canonical seed-family extraction. -/
theorem decisiveConstructiveSeedExistenceRootAssumptions_of_root_assumptions
    (hroot : DecisiveRootAssumptions) :
    DecisiveConstructiveSeedExistenceRootAssumptions := by
  exact ⟨hroot.1, constructiveDecisiveSeedFamily_exists_of_seed_triple_existence hroot.2⟩

/-- Definitive-root assumptions imply definitive seed-existence root assumptions by canonical seed-family extraction. -/
theorem decisiveDefinitiveConstructiveSeedExistenceRootAssumptions_of_definitive_root_assumptions
    (hdef_root : DecisiveDefinitiveRootAssumptions) :
    DecisiveDefinitiveConstructiveSeedExistenceRootAssumptions := by
  exact ⟨hdef_root.1, constructiveDecisiveSeedFamily_exists_of_seed_triple_existence hdef_root.2⟩

/-- Constructive root assumptions imply the periodic Clay `(B)` statement. -/
theorem clayBStatement_of_constructive_root_assumptions
    (hrootc : DecisiveConstructiveRootAssumptions) :
    ClayBStatement := by
  rcases hrootc with ⟨S, output_family⟩
  exact clayBStatement_from_no_local_fallback_seedwise_chain_output_family_and_seed_construction
    output_family S

/-- Definitive constructive-root assumptions imply the periodic Clay `(B)` statement. -/
theorem clayBStatement_of_definitive_constructive_root_assumptions
    (hdef_rootc : DecisiveDefinitiveConstructiveRootAssumptions) :
    ClayBStatement := by
  rcases hdef_rootc with ⟨S, definitive_output⟩
  exact clayBStatement_from_definitive_chain_output_and_seed_construction
    definitive_output S

/-- Root assumptions imply the minimal seedwise hard-blocker goal. -/
theorem decisiveMinimalRootGoal_of_root_assumptions
    (hroot : DecisiveRootAssumptions) :
    DecisiveMinimalRootGoal := by
  rcases constructiveDecisiveSeedFamily_exists_of_seed_triple_existence hroot.2 with ⟨S⟩
  refine ⟨S, ?_⟩
  exact decisiveSeedwise_threshold_chain_data_on_seeds_of_data_family
    S
    (decisiveSpine_threshold_chain_data_family_of_chain_output_family hroot.1)

/-- Root assumptions imply the periodic Clay `(B)` statement. -/
theorem clayBStatement_of_decisive_root_assumptions
    (hroot : DecisiveRootAssumptions) :
    ClayBStatement := by
  exact clayBStatement_from_no_local_fallback_chain_output_family_and_seed_triple_existence
    hroot.1 hroot.2

/-- Root assumptions imply the periodic Clay `(B)` statement via seed-existence root assumptions. -/
theorem clayBStatement_of_decisive_root_assumptions_via_seed_existence_root_assumptions
    (hroot : DecisiveRootAssumptions) :
    ClayBStatement := by
  exact clayBStatement_of_seed_existence_root_assumptions
    (decisiveConstructiveSeedExistenceRootAssumptions_of_root_assumptions hroot)

/-- Definitive-root assumptions imply the periodic Clay `(B)` statement via definitive seed-existence root assumptions. -/
theorem clayBStatement_of_definitive_root_assumptions_via_seed_existence_root_assumptions
    (hdef_root : DecisiveDefinitiveRootAssumptions) :
    ClayBStatement := by
  exact clayBStatement_of_definitive_seed_existence_root_assumptions
    (decisiveDefinitiveConstructiveSeedExistenceRootAssumptions_of_definitive_root_assumptions hdef_root)

/-- Root discharge goal implies the periodic Clay `(B)` statement. -/
theorem clayBStatement_of_decisive_root_discharge_goal
    (hgoal : DecisiveRootDischargeGoal) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_root_assumptions hgoal

/-- Minimal seedwise hard-blocker goal implies the periodic Clay `(B)` statement. -/
theorem clayBStatement_of_decisive_minimal_root_goal
    (hminimal : DecisiveMinimalRootGoal) :
    ClayBStatement := by
  rcases hminimal with ⟨S, seedwise_data⟩
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise_of_data_on_seeds
    S seedwise_data

/-- Data-family plus seed-triple assumptions imply the root assumptions. -/
theorem decisiveRootAssumptions_of_data_family_and_seed_triple_existence
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveRootAssumptions := by
  refine ⟨decisiveSpine_chain_output_family_of_data_family data_family, seed_exists⟩

/-- Chain-generator plus seed-triple assumptions imply the root assumptions. -/
theorem decisiveRootAssumptions_of_chain_generator_and_seed_triple_existence
    (chain_generator : DecisiveSpineThresholdChainGenerator)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveRootAssumptions := by
  refine ⟨decisiveSpine_chain_output_family_of_chain_generator chain_generator, seed_exists⟩

/-- Component-package plus seed-triple assumptions imply the root assumptions. -/
theorem decisiveRootAssumptions_of_component_package_and_seed_triple_existence
    (P : DecisiveSpineConstructiveComponentPackage)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveRootAssumptions := by
  exact ⟨decisiveSpine_chain_output_family_of_component_package P, seed_exists⟩

/-- Definitive chain-output theorem plus seed-triple assumptions imply the root assumptions. -/
theorem decisiveRootAssumptions_of_definitive_chain_output_and_seed_triple_existence
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveRootAssumptions := by
  exact ⟨decisiveSpine_chain_output_family_of_definitive_chain_output definitive_output, seed_exists⟩

/-- Data-family plus seed-triple assumptions imply the root discharge goal. -/
theorem decisiveRootDischargeGoal_of_data_family_and_seed_triple_existence
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveRootDischargeGoal := by
  exact decisiveRootAssumptions_of_data_family_and_seed_triple_existence
    data_family seed_exists

/-- Chain-generator plus seed-triple assumptions imply the root discharge goal. -/
theorem decisiveRootDischargeGoal_of_chain_generator_and_seed_triple_existence
    (chain_generator : DecisiveSpineThresholdChainGenerator)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveRootDischargeGoal := by
  exact decisiveRootAssumptions_of_chain_generator_and_seed_triple_existence
    chain_generator seed_exists

/-- Component-package plus seed-triple assumptions imply the root discharge goal. -/
theorem decisiveRootDischargeGoal_of_component_package_and_seed_triple_existence
    (P : DecisiveSpineConstructiveComponentPackage)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveRootDischargeGoal := by
  exact decisiveRootAssumptions_of_component_package_and_seed_triple_existence
    P seed_exists

/-- Definitive chain-output theorem plus seed-triple assumptions imply the root discharge goal. -/
theorem decisiveRootDischargeGoal_of_definitive_chain_output_and_seed_triple_existence
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveRootDischargeGoal := by
  exact decisiveRootAssumptions_of_definitive_chain_output_and_seed_triple_existence
    definitive_output seed_exists

/-- Data-family plus seed-triple assumptions imply the minimal seedwise hard-blocker goal. -/
theorem decisiveMinimalRootGoal_of_data_family_and_seed_triple_existence
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveMinimalRootGoal := by
  exact decisiveMinimalRootGoal_of_root_assumptions
    (decisiveRootAssumptions_of_data_family_and_seed_triple_existence
      data_family seed_exists)

/-- Chain-generator plus seed-triple assumptions imply the minimal seedwise hard-blocker goal. -/
theorem decisiveMinimalRootGoal_of_chain_generator_and_seed_triple_existence
    (chain_generator : DecisiveSpineThresholdChainGenerator)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveMinimalRootGoal := by
  exact decisiveMinimalRootGoal_of_root_assumptions
    (decisiveRootAssumptions_of_chain_generator_and_seed_triple_existence
      chain_generator seed_exists)

/-- Component-package plus seed-triple assumptions imply the minimal seedwise hard-blocker goal. -/
theorem decisiveMinimalRootGoal_of_component_package_and_seed_triple_existence
    (P : DecisiveSpineConstructiveComponentPackage)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveMinimalRootGoal := by
  exact decisiveMinimalRootGoal_of_root_assumptions
    (decisiveRootAssumptions_of_component_package_and_seed_triple_existence
      P seed_exists)

/-- Definitive chain-output theorem plus seed-triple assumptions imply the minimal seedwise hard-blocker goal. -/
theorem decisiveMinimalRootGoal_of_definitive_chain_output_and_seed_triple_existence
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveMinimalRootGoal := by
  exact decisiveMinimalRootGoal_of_root_assumptions
    (decisiveRootAssumptions_of_definitive_chain_output_and_seed_triple_existence
      definitive_output seed_exists)

/-- Minimal seedwise-chain hard-blocker goal: one constructive seed family with seedwise chain nonemptiness. -/
abbrev DecisiveSeedwiseRootGoal : Prop :=
  ∃ S : ConstructiveDecisiveSeedFamily,
    DecisiveSeedwiseThresholdChainOnSeeds S

/-- Root assumptions imply the minimal seedwise-chain hard-blocker goal. -/
theorem decisiveSeedwiseRootGoal_of_root_assumptions
    (hroot : DecisiveRootAssumptions) :
    DecisiveSeedwiseRootGoal := by
  rcases constructiveDecisiveSeedFamily_exists_of_seed_triple_existence hroot.2 with ⟨S⟩
  refine ⟨S, ?_⟩
  exact decisiveSeedwise_threshold_chain_on_seeds_of_chain_output_family S hroot.1

/-- Minimal seedwise-data hard-blocker goal implies the minimal seedwise-chain hard-blocker goal. -/
theorem decisiveSeedwiseRootGoal_of_minimal_root_goal
    (hminimal : DecisiveMinimalRootGoal) :
    DecisiveSeedwiseRootGoal := by
  rcases hminimal with ⟨S, seedwise_data⟩
  exact ⟨S, decisiveSeedwise_threshold_chain_on_seeds_of_data S seedwise_data⟩

/-- Minimal seedwise-chain hard-blocker goal implies the periodic Clay `(B)` statement. -/
theorem clayBStatement_of_decisive_seedwise_root_goal
    (hseedwise : DecisiveSeedwiseRootGoal) :
    ClayBStatement := by
  rcases hseedwise with ⟨S, seedwise_chain⟩
  exact clayBStatement_from_decisive_completion_no_local_fallback_seedwise
    S seedwise_chain

/-- Data-family plus seed-triple assumptions imply the minimal seedwise-chain hard-blocker goal. -/
theorem decisiveSeedwiseRootGoal_of_data_family_and_seed_triple_existence
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveSeedwiseRootGoal := by
  exact decisiveSeedwiseRootGoal_of_root_assumptions
    (decisiveRootAssumptions_of_data_family_and_seed_triple_existence
      data_family seed_exists)

/-- Chain-generator plus seed-triple assumptions imply the minimal seedwise-chain hard-blocker goal. -/
theorem decisiveSeedwiseRootGoal_of_chain_generator_and_seed_triple_existence
    (chain_generator : DecisiveSpineThresholdChainGenerator)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveSeedwiseRootGoal := by
  exact decisiveSeedwiseRootGoal_of_root_assumptions
    (decisiveRootAssumptions_of_chain_generator_and_seed_triple_existence
      chain_generator seed_exists)

/-- Component-package plus seed-triple assumptions imply the minimal seedwise-chain hard-blocker goal. -/
theorem decisiveSeedwiseRootGoal_of_component_package_and_seed_triple_existence
    (P : DecisiveSpineConstructiveComponentPackage)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveSeedwiseRootGoal := by
  exact decisiveSeedwiseRootGoal_of_root_assumptions
    (decisiveRootAssumptions_of_component_package_and_seed_triple_existence
      P seed_exists)

/-- Definitive chain-output theorem plus seed-triple assumptions imply the minimal seedwise-chain hard-blocker goal. -/
theorem decisiveSeedwiseRootGoal_of_definitive_chain_output_and_seed_triple_existence
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    DecisiveSeedwiseRootGoal := by
  exact decisiveSeedwiseRootGoal_of_root_assumptions
    (decisiveRootAssumptions_of_definitive_chain_output_and_seed_triple_existence
      definitive_output seed_exists)

/-- Constructive root assumptions imply the minimal seedwise-chain hard-blocker goal. -/
theorem decisiveSeedwiseRootGoal_of_constructive_root_assumptions
    (hrootc : DecisiveConstructiveRootAssumptions) :
    DecisiveSeedwiseRootGoal := by
  rcases hrootc with ⟨S, output_family⟩
  exact ⟨S, decisiveSeedwise_threshold_chain_on_seeds_of_chain_output_family S output_family⟩

/-- Definitive constructive-root assumptions imply the minimal seedwise-chain hard-blocker goal. -/
theorem decisiveSeedwiseRootGoal_of_definitive_constructive_root_assumptions
    (hdef_rootc : DecisiveDefinitiveConstructiveRootAssumptions) :
    DecisiveSeedwiseRootGoal := by
  rcases hdef_rootc with ⟨S, definitive_output⟩
  exact ⟨S,
    decisiveSeedwise_threshold_chain_on_seeds_of_chain_output_family
      S
      (decisiveSpine_chain_output_family_of_definitive_chain_output definitive_output)⟩

/-- Definitive chain-output theorem plus constructive seeds imply the minimal seedwise-chain hard-blocker goal. -/
theorem decisiveSeedwiseRootGoal_of_definitive_chain_output_and_seed_construction
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    DecisiveSeedwiseRootGoal := by
  exact ⟨build_seed,
    decisiveSeedwise_threshold_chain_on_seeds_of_chain_output_family
      build_seed
      (decisiveSpine_chain_output_family_of_definitive_chain_output definitive_output)⟩

/-- Data-family no-local-fallback route, normalized through root assumptions. -/
theorem clayBStatement_from_data_family_and_seed_triple_existence_via_root_assumptions
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_root_assumptions
    (decisiveRootAssumptions_of_data_family_and_seed_triple_existence
      data_family seed_exists)

/-- Chain-generator no-local-fallback route, normalized through root assumptions. -/
theorem clayBStatement_from_chain_generator_and_seed_triple_existence_via_root_assumptions
    (chain_generator : DecisiveSpineThresholdChainGenerator)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_root_assumptions
    (decisiveRootAssumptions_of_chain_generator_and_seed_triple_existence
      chain_generator seed_exists)

/-- Component-package plus seed-triple route, normalized through root assumptions. -/
theorem clayBStatement_from_component_package_and_seed_triple_existence_via_root_assumptions
    (P : DecisiveSpineConstructiveComponentPackage)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_root_assumptions
    ⟨decisiveSpine_chain_output_family_of_component_package P, seed_exists⟩

/-- Root assumptions imply `Clay(B)` via the minimal seedwise-chain root goal route. -/
theorem clayBStatement_of_decisive_root_assumptions_via_seedwise_root_goal
    (hroot : DecisiveRootAssumptions) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_seedwise_root_goal
    (decisiveSeedwiseRootGoal_of_root_assumptions hroot)

/-- Data-family route to `Clay(B)`, normalized via the minimal seedwise-chain root goal. -/
theorem clayBStatement_from_data_family_and_seed_triple_existence_via_seedwise_root_goal
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_seedwise_root_goal
    (decisiveSeedwiseRootGoal_of_data_family_and_seed_triple_existence
      data_family seed_exists)

/-- Chain-generator route to `Clay(B)`, normalized via the minimal seedwise-chain root goal. -/
theorem clayBStatement_from_chain_generator_and_seed_triple_existence_via_seedwise_root_goal
    (chain_generator : DecisiveSpineThresholdChainGenerator)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_seedwise_root_goal
    (decisiveSeedwiseRootGoal_of_chain_generator_and_seed_triple_existence
      chain_generator seed_exists)

/-- Component-package route to `Clay(B)`, normalized via the minimal seedwise-chain root goal. -/
theorem clayBStatement_from_component_package_and_seed_triple_existence_via_seedwise_root_goal
    (P : DecisiveSpineConstructiveComponentPackage)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_seedwise_root_goal
    (decisiveSeedwiseRootGoal_of_component_package_and_seed_triple_existence
      P seed_exists)

/-- Root discharge goal implies the minimal seedwise-chain hard-blocker goal. -/
theorem decisiveSeedwiseRootGoal_of_root_discharge_goal
    (hgoal : DecisiveRootDischargeGoal) :
    DecisiveSeedwiseRootGoal := by
  exact decisiveSeedwiseRootGoal_of_root_assumptions hgoal

/-- Root discharge goal implies `Clay(B)` via the minimal seedwise-chain root goal route. -/
theorem clayBStatement_of_decisive_root_discharge_goal_via_seedwise_root_goal
    (hgoal : DecisiveRootDischargeGoal) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_seedwise_root_goal
    (decisiveSeedwiseRootGoal_of_root_discharge_goal hgoal)

/-- Minimal seedwise-data hard-blocker goal implies `Clay(B)` via the minimal seedwise-chain root goal route. -/
theorem clayBStatement_of_decisive_minimal_root_goal_via_seedwise_root_goal
    (hminimal : DecisiveMinimalRootGoal) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_seedwise_root_goal
    (decisiveSeedwiseRootGoal_of_minimal_root_goal hminimal)

/-- Split chain-output + seed-triple assumptions imply `Clay(B)` via the minimal seedwise-chain root goal route. -/
theorem clayBStatement_from_chain_output_family_and_seed_triple_existence_via_seedwise_root_goal
    (output_family : DecisiveSpineThresholdChainOutputFamily)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_seedwise_root_goal
    (decisiveSeedwiseRootGoal_of_root_assumptions ⟨output_family, seed_exists⟩)

/-- Constructive root assumptions imply `Clay(B)` via minimal seedwise-chain root goal. -/
theorem clayBStatement_of_constructive_root_assumptions_via_seedwise_root_goal
    (hrootc : DecisiveConstructiveRootAssumptions) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_seedwise_root_goal
    (decisiveSeedwiseRootGoal_of_constructive_root_assumptions hrootc)

/-- Definitive constructive-root assumptions imply `Clay(B)` via minimal seedwise-chain root goal. -/
theorem clayBStatement_of_definitive_constructive_root_assumptions_via_seedwise_root_goal
    (hdef_rootc : DecisiveDefinitiveConstructiveRootAssumptions) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_seedwise_root_goal
    (decisiveSeedwiseRootGoal_of_definitive_constructive_root_assumptions hdef_rootc)

/-- Definitive chain-output theorem + constructive seeds imply `Clay(B)` via minimal seedwise-chain root goal. -/
theorem clayBStatement_from_definitive_chain_output_and_seed_construction_via_seedwise_root_goal
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_seedwise_root_goal
    (decisiveSeedwiseRootGoal_of_definitive_chain_output_and_seed_construction
      definitive_output build_seed)

/-- Definitive chain-output theorem + seed-triple assumptions imply `Clay(B)` via minimal seedwise-chain root goal. -/
theorem clayBStatement_from_definitive_chain_output_and_seed_triple_existence_via_seedwise_root_goal
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  rcases constructiveDecisiveSeedFamily_exists_of_seed_triple_existence seed_exists with ⟨S⟩
  exact clayBStatement_from_definitive_chain_output_and_seed_construction_via_seedwise_root_goal
    definitive_output S

/-- Chain-output + seed-construction assumptions imply constructive root assumptions. -/
theorem decisiveConstructiveRootAssumptions_of_chain_output_and_seed_construction
    (output_family : DecisiveSpineThresholdChainOutputFamily)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    DecisiveConstructiveRootAssumptions := by
  exact ⟨build_seed, output_family⟩

/-- Definitive chain-output + seed-construction assumptions imply definitive constructive-root assumptions. -/
theorem decisiveDefinitiveConstructiveRootAssumptions_of_definitive_chain_output_and_seed_construction
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    DecisiveDefinitiveConstructiveRootAssumptions := by
  exact ⟨build_seed, definitive_output⟩

/-- Chain-output + seed-existence route to `Clay(B)`, normalized via constructive root assumptions. -/
theorem clayBStatement_from_chain_output_family_and_seed_existence_via_root_discharge
    (output_family : DecisiveSpineThresholdChainOutputFamily)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_of_seed_existence_root_assumptions
    ⟨output_family, hseed_exists⟩

/-- Definitive chain-output + seed-existence route to `Clay(B)`, normalized via definitive constructive-root assumptions. -/
theorem clayBStatement_from_definitive_chain_output_and_seed_existence_via_root_discharge
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_of_definitive_seed_existence_root_assumptions
    ⟨definitive_output, hseed_exists⟩

/-- Data-family + seed-existence route to `Clay(B)`, normalized via constructive root assumptions. -/
theorem clayBStatement_from_data_family_and_seed_existence_via_root_discharge
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_chain_output_family_and_seed_existence_via_root_discharge
    (decisiveSpine_chain_output_family_of_data_family data_family) hseed_exists

/-- Chain-generator + seed-existence route to `Clay(B)`, normalized via constructive root assumptions. -/
theorem clayBStatement_from_chain_generator_and_seed_existence_via_root_discharge
    (chain_generator : DecisiveSpineThresholdChainGenerator)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_chain_output_family_and_seed_existence_via_root_discharge
    (decisiveSpine_chain_output_family_of_chain_generator chain_generator) hseed_exists

/-- Component-package + seed-existence route to `Clay(B)`, normalized via constructive root assumptions. -/
theorem clayBStatement_from_component_package_and_seed_existence_via_root_discharge
    (P : DecisiveSpineConstructiveComponentPackage)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_chain_output_family_and_seed_existence_via_root_discharge
    (decisiveSpine_chain_output_family_of_component_package P) hseed_exists

/-- Chain-output + seed-construction route to `Clay(B)`, normalized via constructive root assumptions. -/
theorem clayBStatement_from_chain_output_family_and_seed_construction_via_root_discharge
    (output_family : DecisiveSpineThresholdChainOutputFamily)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_of_constructive_root_assumptions
    (decisiveConstructiveRootAssumptions_of_chain_output_and_seed_construction
      output_family build_seed)

/-- Definitive chain-output + seed-construction route to `Clay(B)`, normalized via definitive constructive-root assumptions. -/
theorem clayBStatement_from_definitive_chain_output_and_seed_construction_via_root_discharge
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (build_seed : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_of_definitive_constructive_root_assumptions
    (decisiveDefinitiveConstructiveRootAssumptions_of_definitive_chain_output_and_seed_construction
      definitive_output build_seed)

/-- Canonical endpoint from root assumptions, routed via minimal seedwise-chain root goal. -/
theorem clayBStatement_from_root_assumptions
    (hroot : DecisiveRootAssumptions) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_root_assumptions_via_seedwise_root_goal hroot

/-- Canonical endpoint from root discharge goal, routed via minimal seedwise-chain root goal. -/
theorem clayBStatement_from_root_discharge_goal
    (hgoal : DecisiveRootDischargeGoal) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_root_discharge_goal_via_seedwise_root_goal hgoal

/-- Canonical endpoint from minimal seedwise-chain root goal. -/
theorem clayBStatement_from_seedwise_root_goal
    (hseedwise : DecisiveSeedwiseRootGoal) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_seedwise_root_goal hseedwise

/-- Canonical endpoint from minimal seedwise-data root goal, routed via minimal seedwise-chain root goal. -/
theorem clayBStatement_from_minimal_root_goal
    (hminimal : DecisiveMinimalRootGoal) :
    ClayBStatement := by
  exact clayBStatement_of_decisive_minimal_root_goal_via_seedwise_root_goal hminimal

/-- Canonical split endpoint from chain-output + seed-existence assumptions. -/
theorem clayBStatement_from_chain_output_family_and_seed_existence
    (output_family : DecisiveSpineThresholdChainOutputFamily)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_chain_output_family_and_seed_existence_via_root_discharge
    output_family hseed_exists

/-- Canonical split endpoint from definitive chain-output theorem + seed-existence assumptions. -/
theorem clayBStatement_from_definitive_chain_output_and_seed_existence
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_definitive_chain_output_and_seed_existence_via_root_discharge
    definitive_output hseed_exists

/-- Canonical split endpoint from data-family + seed-existence assumptions. -/
theorem clayBStatement_from_data_family_and_seed_existence
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_data_family_and_seed_existence_via_root_discharge
    data_family hseed_exists

/-- Canonical split endpoint from chain-generator + seed-existence assumptions. -/
theorem clayBStatement_from_chain_generator_and_seed_existence
    (chain_generator : DecisiveSpineThresholdChainGenerator)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_chain_generator_and_seed_existence_via_root_discharge
    chain_generator hseed_exists

/-- Canonical split endpoint from component-package + seed-existence assumptions. -/
theorem clayBStatement_from_component_package_and_seed_existence
    (P : DecisiveSpineConstructiveComponentPackage)
    (hseed_exists : Nonempty ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_component_package_and_seed_existence_via_root_discharge
    P hseed_exists

/-- Canonical split endpoint from chain-output + seed-triple assumptions. -/
theorem clayBStatement_from_chain_output_family_and_seed_triple_existence
    (output_family : DecisiveSpineThresholdChainOutputFamily)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  exact clayBStatement_from_chain_output_family_and_seed_triple_existence_via_seedwise_root_goal
    output_family seed_exists

/-- Canonical split endpoint from definitive chain-output theorem + seed-triple assumptions. -/
theorem clayBStatement_from_definitive_chain_output_and_seed_triple_existence_via_root_discharge
    (definitive_output : DefinitiveThresholdMinimalFluxChainOutput)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  exact clayBStatement_from_definitive_chain_output_and_seed_triple_existence_via_seedwise_root_goal
    definitive_output seed_exists

/-- Canonical split endpoint from data-family + seed-triple assumptions. -/
theorem clayBStatement_from_data_family_and_seed_triple_existence
    (data_family : DecisiveSpineThresholdChainDataFamily)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  exact clayBStatement_from_data_family_and_seed_triple_existence_via_seedwise_root_goal
    data_family seed_exists

/-- Canonical split endpoint from chain-generator + seed-triple assumptions. -/
theorem clayBStatement_from_chain_generator_and_seed_triple_existence
    (chain_generator : DecisiveSpineThresholdChainGenerator)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  exact clayBStatement_from_chain_generator_and_seed_triple_existence_via_seedwise_root_goal
    chain_generator seed_exists

/-- Canonical split endpoint from component-package + seed-triple assumptions. -/
theorem clayBStatement_from_component_package_and_seed_triple_existence
    (P : DecisiveSpineConstructiveComponentPackage)
    (seed_exists : ConstructiveDecisiveSeedTripleExistence) :
    ClayBStatement := by
  exact clayBStatement_from_component_package_and_seed_triple_existence_via_seedwise_root_goal
    P seed_exists

end Gibbs.ContinuumField.NavierStokes
