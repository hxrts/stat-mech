import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveGlobal
import Gibbs.ContinuumField.NavierStokes.Faithful.Final

/-! # Decisive final completion theorems

Final completion theorems turning decisive global closure into the faithful and
classical Clay `(B)` statements.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Constructive decisive seed family: one concrete model/engine/local-theory triple per hypothesis. -/
abbrev DecisiveCompletionSeedFamily : Type :=
  ∀ H : ClayBHypotheses,
    Σ M : DecisiveFaithfulPeriodicModel H,
      Σ E : DecisiveCriticalAnalyticEngine H M,
        FaithfulMildLocalTheory H M.base E.analytic

/-- Every decisive completion model is locked to the canonical periodic operators. -/
theorem decisive_seed_uses_canonical_operators
    {H : ClayBHypotheses}
    (M : DecisiveFaithfulPeriodicModel H) :
    M.base.NS.ops = canonicalPeriodicOps :=
  M.ops_fixed

/-- Pipeline existence derived from decisive global closure plus decisive seed data. -/
theorem faithfulPipelineExists_from_decisive_global_closure
    (global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ E : DecisiveCriticalAnalyticEngine H M,
            ∀ L : FaithfulMildLocalTheory H M.base E.analytic,
              ∃ _G : FaithfulHardGlobalClosure H M.base E.analytic L, True)
    (S : DecisiveCompletionSeedFamily) :
    FaithfulPipelineExists := by
  intro H
  let seed := S H
  let M := seed.1
  let E := seed.2.1
  let L := seed.2.2
  rcases global_closure H M E L with ⟨hardGlobal, hG⟩
  exact ⟨M.base, E.analytic, L, hardGlobal, hG⟩

/-- Decisive completion theorem for the faithful theorem schema. -/
theorem faithfulClayBStatement_from_proved_pipeline_exists
    (_global_closure :
      ∀ H : ClayBHypotheses,
        ∀ M : DecisiveFaithfulPeriodicModel H,
          ∀ E : DecisiveCriticalAnalyticEngine H M,
            ∀ L : FaithfulMildLocalTheory H M.base E.analytic,
              ∃ _G : FaithfulHardGlobalClosure H M.base E.analytic L, True)
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
          ∀ E : DecisiveCriticalAnalyticEngine H M,
            ∀ L : FaithfulMildLocalTheory H M.base E.analytic,
              ∃ _G : FaithfulHardGlobalClosure H M.base E.analytic L, True)
    (S : DecisiveCompletionSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_of_faithful_pipeline
    (faithfulPipelineExists_from_decisive_global_closure global_closure S)

/-- Constructive completion route that removes external global-closure inputs. -/
theorem clayBStatement_from_decisive_completion_constructive
    (S : DecisiveCompletionSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion
    decisiveGlobalClosureTheorem_constructive S

end Gibbs.ContinuumField.NavierStokes
