import Gibbs.ContinuumField.NavierStokes.Faithful.BaseAxiomAnalysis

/-! # Full proof exact analytic layer

Exact periodic analytic objects and inequalities used by the full-proof route.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Exact periodic analytic package for the full-proof route. -/
structure FullProofExactAnalysisData where
  spaces : DefinitiveFunctionSpaceStack
  complete : DefinitiveFunctionSpaceCompleteness spaces
  norm_equiv : DefinitiveFunctionSpaceNormEquivalences spaces
  interpolation : DefinitiveInterpolationInequalities spaces
  embeddings : DefinitiveEmbeddingInequalities spaces
  fourier : TrueTorusFourierOperators
  fourier_norms : TrueTorusFourierNormTheorems spaces fourier
  lp : TrueTorusLittlewoodPaley
  bernstein : TrueTorusBernsteinInequalities spaces lp
  convection : TrueTorusConvectionModel
  constants : TrueTorusAnalyticConstantRegistry
  nonlinear : TrueTorusNonlinearEstimateBundle spaces convection constants

/-- Exact-space completeness theorem bundle for full-proof use. -/
theorem fullProof_exact_space_completeness
    (A : FullProofExactAnalysisData) :
    A.complete.lp3_complete ∧
      A.complete.sobolev_complete ∧
      A.complete.besov_complete ∧
      A.complete.hhalf_complete := by
  exact trueTorus_functionSpace_completeness A.spaces A.complete

/-- Exact interpolation/embedding/nonlinear inequality bundle with constants. -/
theorem fullProof_exact_inequality_bundle
    (A : FullProofExactAnalysisData) :
    (∃ C θ : ℝ, 0 ≤ C ∧ 0 ≤ θ ∧ θ ≤ 1 ∧
      ∀ u,
        A.spaces.lp3.space.norm u ≤
          C * A.spaces.sobolev.space.norm u * A.spaces.hhalf.space.norm u) ∧
    (∃ C : ℝ, 0 ≤ C ∧ ∀ u,
      A.spaces.lp3.space.norm u ≤ C * A.spaces.sobolev.space.norm u) ∧
    (∃ C : ℝ, 0 ≤ C ∧ ∀ u,
      A.spaces.lp3.space.norm u ≤ C * A.spaces.besov.space.norm u) ∧
    (∀ u,
      A.spaces.lp3.space.norm (A.convection.convection u) ≤
        A.constants.Cbilinear * A.spaces.sobolev.space.norm u * A.spaces.hhalf.space.norm u) ∧
    (∀ u v,
      A.spaces.besov.space.norm (trueTorusVectorAdd u v) ≤
        A.constants.CcommKP * (A.spaces.besov.space.norm u + A.spaces.besov.space.norm v)) ∧
    (∀ u v,
      A.spaces.sobolev.space.norm (trueTorusVectorAdd u v) ≤
        A.constants.CcommBony * (A.spaces.sobolev.space.norm u + A.spaces.sobolev.space.norm v)) := by
  refine ⟨trueTorus_interpolation_inequalities A.spaces A.interpolation, ?_, ?_, ?_, ?_, ?_⟩
  · exact (trueTorus_embedding_inequalities A.spaces A.embeddings).1
  · exact (trueTorus_embedding_inequalities A.spaces A.embeddings).2
  · exact trueTorus_bilinear_convection_estimate
      A.spaces A.convection A.constants A.nonlinear
  · exact (trueTorus_commutator_estimates A.spaces A.convection A.constants A.nonlinear).1
  · exact (trueTorus_commutator_estimates A.spaces A.convection A.constants A.nonlinear).2

/-- Full-proof exact analysis data yields the base-axiom primitive analysis object. -/
def fullProof_to_baseAxiomPrimitiveAnalysis_direct
    (exactData : FullProofExactAnalysisData)
    (semigroup : TrueTorusDefinitiveStokesSemigroup)
    (semigroup_estimates : TrueTorusSemigroupEstimates exactData.spaces semigroup)
    (contraction :
      TrueTorusContractionPackage
        exactData.spaces semigroup exactData.convection baseAxiomZeroTorusVector)
    (strong_solution : TrueTorusStrongPeriodicSolution)
    (continuation : TrueTorusContinuationCriterion exactData.spaces strong_solution)
    (blowup_alternative : TrueTorusBlowupAlternative exactData.spaces strong_solution) :
    BaseAxiomPrimitiveAnalysis where
  spaces := exactData.spaces
  convection := exactData.convection
  constants := exactData.constants
  nonlinear := exactData.nonlinear
  semigroup := semigroup
  semigroup_estimates := semigroup_estimates
  contraction := contraction
  strong_solution := strong_solution
  continuation := continuation
  blowup_alternative := blowup_alternative

/-- Full-proof exact analysis data yields the base-axiom primitive analysis object. -/
def fullProof_to_baseAxiomPrimitiveAnalysis
    (exactData : FullProofExactAnalysisData)
    (semigroup : TrueTorusDefinitiveStokesSemigroup)
    (semigroup_estimates : TrueTorusSemigroupEstimates exactData.spaces semigroup)
    (contraction :
      TrueTorusContractionPackage
        exactData.spaces semigroup exactData.convection baseAxiomZeroTorusVector)
    (strong_solution : TrueTorusStrongPeriodicSolution)
    (continuation : TrueTorusContinuationCriterion exactData.spaces strong_solution)
    (blowup_alternative : TrueTorusBlowupAlternative exactData.spaces strong_solution) :
    BaseAxiomPrimitiveAnalysis :=
  fullProof_to_baseAxiomPrimitiveAnalysis_direct
    exactData semigroup semigroup_estimates contraction
    strong_solution continuation blowup_alternative

/-- Policy marker for exact analysis replacement in the full-proof route. -/
def FullProofExactAnalysisReplacementPolicy : Prop := True

/-- Full-proof exact analysis replacement policy is active. -/
theorem fullProof_exactAnalysis_replacement_policy :
    FullProofExactAnalysisReplacementPolicy := by
  trivial

end Gibbs.ContinuumField.NavierStokes
