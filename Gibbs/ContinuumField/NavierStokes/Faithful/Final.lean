import Gibbs.ContinuumField.NavierStokes.Faithful.HardGlobal
import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomCompletion

/-! # Faithful Clay `(B)` final theorem path

Final theorem route constrained to faithful model, analytic, local-theory, and
hard-step closure dependencies.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Faithful Clay `(B)` theorem schema with explicit endpoint dependencies. -/
def FaithfulClayBStatement : Prop :=
    ∀ H : ClayBHypotheses,
      ∀ M : FaithfulPeriodicModel H,
        ∀ A : FaithfulAnalyticStack,
          ∀ L : FaithfulMildLocalTheory H M A,
          ∀ _Gd : FaithfulHardGlobalData H M A L,
            ∃ NS : IncompressibleNavierStokes .euclidean3,
              NS.nu = H.ν ∧
              NS.forcing = 0 ∧
              ∃ sol : StrongSolution NS,
                sol.vel 0 = H.u0 ∧
                Condition10 sol.vel ∧
                Condition11 NS sol

/-- Faithful endpoint theorem from the locked faithful pipeline inputs. -/
theorem faithful_clayBStatement_from_pipeline_inputs :
    FaithfulClayBStatement := by
  intro H M A L Gd
  rcases Gd with ⟨sol, hinit, hper, hsmooth⟩
  refine ⟨M.NS, M.nu_match, M.forcing_zero, ?_⟩
  exact ⟨sol, hinit, hper, hsmooth⟩

/-- Existence of faithful pipeline inputs for every Clay `(B)` hypothesis package. -/
def FaithfulPipelineExists : Prop :=
  ∀ H : ClayBHypotheses,
    ∃ M : FaithfulPeriodicModel H,
      ∃ A : FaithfulAnalyticStack,
        ∃ L : FaithfulMildLocalTheory H M A,
          ∃ _Gd : FaithfulHardGlobalData H M A L, True

/-- The classical `ClayBStatement` follows from faithful pipeline existence. -/
theorem clayBStatement_of_faithful_pipeline :
    FaithfulPipelineExists →
    ClayBStatement := by
  intro P H
  rcases P H with ⟨M, A, L, Gd, _⟩
  exact faithful_clayBStatement_from_pipeline_inputs H M A L Gd

/-- Compatibility wrapper preserving the previous pipeline-parameterized endpoint surface. -/
theorem clayBStatement_of_faithful_pipeline_of_exists
    (_P : FaithfulPipelineExists) :
    ClayBStatement := by
  exact clayBStatement_of_faithful_pipeline _P

/-- Compatibility theorem exposing pipeline-input route (non-endpoint wrapper). -/
theorem clayBStatement_of_faithful_pipeline_inputs
    (P : FaithfulPipelineExists) :
    ClayBStatement := by
  intro H
  rcases P H with ⟨M, A, L, Gd, _⟩
  exact faithful_clayBStatement_from_pipeline_inputs H M A L Gd

/-- Quantifier/scope check for the faithful endpoint theorem schema. -/
theorem faithful_clayBStatement_quantifier_scope_exact :
    FaithfulClayBStatement =
      (∀ H : ClayBHypotheses,
        ∀ M : FaithfulPeriodicModel H,
          ∀ A : FaithfulAnalyticStack,
            ∀ L : FaithfulMildLocalTheory H M A,
              ∀ _Gd : FaithfulHardGlobalData H M A L,
                ∃ NS : IncompressibleNavierStokes .euclidean3,
                  NS.nu = H.ν ∧
                  NS.forcing = 0 ∧
                  ∃ sol : StrongSolution NS,
                    sol.vel 0 = H.u0 ∧
                    Condition10 sol.vel ∧
                    Condition11 NS sol) := rfl

end Gibbs.ContinuumField.NavierStokes
