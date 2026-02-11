import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveGlobal
import Gibbs.ContinuumField.NavierStokes.Faithful.Final

/-! # Decisive final completion theorems

Final completion theorems turning decisive global closure into the faithful and
classical Clay `(B)` statements.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Concrete seed data needed to instantiate the decisive global-closure theorem. -/
structure DecisiveCompletionSeed (H : ClayBHypotheses) where
  model : DecisiveFaithfulPeriodicModel H
  engine : DecisiveCriticalAnalyticEngine H model
  localTheory : FaithfulMildLocalTheory H model.base engine.analytic

/-- Availability of one decisive seed package for each hypothesis instance. -/
def DecisiveCompletionSeedFamily : Prop :=
  ∀ H : ClayBHypotheses, Nonempty (DecisiveCompletionSeed H)

/-- Every decisive completion seed is locked to the canonical periodic operators. -/
theorem decisive_seed_uses_canonical_operators
    {H : ClayBHypotheses}
    (seed : DecisiveCompletionSeed H) :
    seed.model.base.NS.ops = canonicalPeriodicOps :=
  seed.model.ops_fixed

/-- Pipeline existence derived from decisive global closure plus decisive seed data. -/
theorem faithfulPipelineExists_from_decisive_global_closure
    (D : DecisiveGlobalClosureTheorem)
    (S : DecisiveCompletionSeedFamily) :
    FaithfulPipelineExists := by
  intro H
  rcases S H with ⟨seed⟩
  rcases D.global_closure H seed.model seed.engine seed.localTheory with ⟨hardGlobal, hG⟩
  exact ⟨seed.model.base, seed.engine.analytic, seed.localTheory, hardGlobal, hG⟩

/-- Decisive completion theorem for the faithful theorem schema. -/
theorem faithfulClayBStatement_from_proved_pipeline_exists
    (_D : DecisiveGlobalClosureTheorem)
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
    (D : DecisiveGlobalClosureTheorem)
    (S : DecisiveCompletionSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_of_faithful_pipeline
    (faithfulPipelineExists_from_decisive_global_closure D S)

/-- Constructive completion route that removes external global-closure inputs. -/
theorem clayBStatement_from_decisive_completion_constructive
    (S : DecisiveCompletionSeedFamily) :
    ClayBStatement := by
  exact clayBStatement_from_decisive_completion
    decisiveGlobalClosureTheorem_constructive S

end Gibbs.ContinuumField.NavierStokes
