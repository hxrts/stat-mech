import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveCompletion

/-! # Faithful decisive seed construction

Constructive seed-family interfaces removing endpoint dependence on
`Nonempty`/existential seed assumptions.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Constructive decisive seed family: one concrete seed for every hypothesis. -/
abbrev ConstructiveDecisiveSeedFamily : Type :=
  ∀ H : ClayBHypotheses, DecisiveCompletionSeed H

/-- Constructive seeds induce the legacy `Nonempty` seed family. -/
theorem constructiveSeedFamily_to_nonempty
    (S : ConstructiveDecisiveSeedFamily) :
    DecisiveCompletionSeedFamily := by
  intro H
  exact ⟨S H⟩

/-- Theorem package for constructive seed synthesis from analytic/PDE lemmas. -/
structure DecisiveSeedFromAnalysisTheorem where
  build_seed : ∀ H : ClayBHypotheses, DecisiveCompletionSeed H

/-- Concrete model/engine/local-theory triple exists for each hypothesis package. -/
theorem decisiveSeed_concrete_triple_exists
    (T : DecisiveSeedFromAnalysisTheorem) :
    ∀ H : ClayBHypotheses,
      ∃ M : DecisiveFaithfulPeriodicModel H,
        ∃ E : DecisiveCriticalAnalyticEngine H M,
          ∃ L : FaithfulMildLocalTheory H M.base E.analytic, True := by
  intro H
  let seed := T.build_seed H
  exact ⟨seed.model, seed.engine, seed.localTheory, trivial⟩

/-- Pipeline existence from decisive closure and constructive seed family. -/
theorem faithfulPipelineExists_from_constructive_seeds
    (D : DecisiveGlobalClosureTheorem)
    (S : ConstructiveDecisiveSeedFamily) :
    FaithfulPipelineExists := by
  exact faithfulPipelineExists_from_decisive_global_closure D
    (constructiveSeedFamily_to_nonempty S)

/-- Final Clay `(B)` endpoint with no `Nonempty` seed-family assumptions. -/
theorem clayBStatement_from_decisive_completion_no_nonempty
    (D : DecisiveGlobalClosureTheorem)
    (S : ConstructiveDecisiveSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_of_faithful_pipeline
    (faithfulPipelineExists_from_constructive_seeds D S)

/-- Final Clay `(B)` endpoint from seed-construction theorem package. -/
theorem clayBStatement_from_seed_construction
    (D : DecisiveGlobalClosureTheorem)
    (T : DecisiveSeedFromAnalysisTheorem) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion_no_nonempty D T.build_seed

/-- Final endpoint route using the constructive decisive global closure theorem. -/
theorem clayBStatement_from_constructive_global_closure_and_seed_construction
    (T : DecisiveSeedFromAnalysisTheorem) :
    ClayBStatement := by
  exact clayBStatement_from_seed_construction
    decisiveGlobalClosureTheorem_constructive T

end Gibbs.ContinuumField.NavierStokes
