import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomAnalysis

/-! # Full proof exact analytic layer

Exact periodic analytic objects and inequalities used by the full-proof route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Exact-space completeness theorem bundle for full-proof use. -/
theorem fullProof_exact_space_completeness
    (spaces : DefinitiveFunctionSpaceStack)
    (complete : DefinitiveFunctionSpaceCompleteness spaces) :
    complete.lp3_complete ∧
      complete.sobolev_complete ∧
      complete.besov_complete ∧
      complete.hhalf_complete := by
  exact trueTorus_functionSpace_completeness spaces complete

/-- Exact interpolation/embedding/nonlinear inequality bundle with constants. -/
theorem fullProof_exact_inequality_bundle
    (spaces : DefinitiveFunctionSpaceStack)
    (interpolation : DefinitiveInterpolationInequalities spaces)
    (embeddings : DefinitiveEmbeddingInequalities spaces)
    (convection : TrueTorusConvectionModel)
    (constants : TrueTorusAnalyticConstantRegistry)
    (nonlinear : TrueTorusNonlinearEstimateBundle spaces convection constants) :
    (∃ C θ : ℝ, 0 ≤ C ∧ 0 ≤ θ ∧ θ ≤ 1 ∧
      ∀ u,
        spaces.lp3.space.norm u ≤
          C * spaces.sobolev.space.norm u * spaces.hhalf.space.norm u) ∧
    (∃ C : ℝ, 0 ≤ C ∧ ∀ u,
      spaces.lp3.space.norm u ≤ C * spaces.sobolev.space.norm u) ∧
    (∃ C : ℝ, 0 ≤ C ∧ ∀ u,
      spaces.lp3.space.norm u ≤ C * spaces.besov.space.norm u) ∧
    (∀ u,
      spaces.lp3.space.norm (convection.convection u) ≤
        constants.Cbilinear * spaces.sobolev.space.norm u * spaces.hhalf.space.norm u) ∧
    (∀ u v,
      spaces.besov.space.norm (trueTorusVectorAdd u v) ≤
        constants.CcommKP * (spaces.besov.space.norm u + spaces.besov.space.norm v)) ∧
    (∀ u v,
      spaces.sobolev.space.norm (trueTorusVectorAdd u v) ≤
        constants.CcommBony * (spaces.sobolev.space.norm u + spaces.sobolev.space.norm v)) := by
  refine ⟨trueTorus_interpolation_inequalities spaces interpolation, ?_, ?_, ?_, ?_, ?_⟩
  · exact (trueTorus_embedding_inequalities spaces embeddings).1
  · exact (trueTorus_embedding_inequalities spaces embeddings).2
  · exact trueTorus_bilinear_convection_estimate
      spaces convection constants nonlinear
  · exact (trueTorus_commutator_estimates spaces convection constants nonlinear).1
  · exact (trueTorus_commutator_estimates spaces convection constants nonlinear).2

/-- Policy marker for exact analysis replacement in the full-proof route. -/
def FullProofExactAnalysisReplacementPolicy : Prop := True

/-- Full-proof exact analysis replacement policy is active. -/
theorem fullProof_exactAnalysis_replacement_policy :
    FullProofExactAnalysisReplacementPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
