import StatMech.ContinuumField.NavierStokes.Geometry.TorusFields

/-! # True torus calculus layer

Classical and distributional derivative interfaces on `(ℝ/ℤ)^3`, together with
agreement statements on smooth fields.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Multi-index for torus derivatives in three spatial coordinates. -/
abbrev TorusMultiIndex : Type := Fin 3 → Nat

/-- Classical derivative operator bundle on true-torus fields. -/
structure TorusClassicalDerivativeOps where
  dScalar : TorusMultiIndex → TrueTorusScalarField → TrueTorusScalarField
  dVector : TorusMultiIndex → TrueTorusVectorField → TrueTorusVectorField
  grad : TrueTorusScalarField → TrueTorusVectorField
  div : TrueTorusVectorField → TrueTorusScalarField
  laplaceScalar : TrueTorusScalarField → TrueTorusScalarField
  laplaceVector : TrueTorusVectorField → TrueTorusVectorField

/-- Scalar test functions for torus distributions. -/
abbrev TorusScalarTestFunction : Type := TrueTorusScalarField

/-- Vector test functions for torus distributions. -/
abbrev TorusVectorTestFunction : Type := TrueTorusVectorField

/-- Scalar distribution on the torus. -/
structure TorusScalarDistribution where
  eval : TorusScalarTestFunction → ℝ

/-- Vector distribution on the torus. -/
structure TorusVectorDistribution where
  eval : TorusVectorTestFunction → ℝ

/-- Distributional derivative operator bundle on true-torus fields. -/
structure TorusDistributionalDerivativeOps where
  dScalar : TorusMultiIndex → TrueTorusScalarField → TorusScalarDistribution
  dVector : TorusMultiIndex → TrueTorusVectorField → TorusVectorDistribution

/-- Embedding from classical fields into torus distributions. -/
structure TorusDistributionEmbedding where
  scalar : TrueTorusScalarField → TorusScalarDistribution
  vector : TrueTorusVectorField → TorusVectorDistribution

/-- Agreement package: distributional derivatives match classical derivatives on smooth fields. -/
structure TorusDerivativeAgreementPackage
    (C : TorusClassicalDerivativeOps)
    (D : TorusDistributionalDerivativeOps)
    (E : TorusDistributionEmbedding) where
  scalar_agree :
    ∀ α f, IsSmoothTrueTorusScalarField f →
      D.dScalar α f = E.scalar (C.dScalar α f)
  vector_agree :
    ∀ α u, IsSmoothTrueTorusVectorField u →
      D.dVector α u = E.vector (C.dVector α u)

/-- Distributional/classical scalar derivative agreement on smooth fields. -/
theorem distributional_agrees_with_classical_scalar
    (C : TorusClassicalDerivativeOps)
    (D : TorusDistributionalDerivativeOps)
    (E : TorusDistributionEmbedding)
    (A : TorusDerivativeAgreementPackage C D E) :
    ∀ α f, IsSmoothTrueTorusScalarField f →
      D.dScalar α f = E.scalar (C.dScalar α f) :=
  A.scalar_agree

/-- Distributional/classical vector derivative agreement on smooth fields. -/
theorem distributional_agrees_with_classical_vector
    (C : TorusClassicalDerivativeOps)
    (D : TorusDistributionalDerivativeOps)
    (E : TorusDistributionEmbedding)
    (A : TorusDerivativeAgreementPackage C D E) :
    ∀ α u, IsSmoothTrueTorusVectorField u →
      D.dVector α u = E.vector (C.dVector α u) :=
  A.vector_agree

end StatMech.ContinuumField.NavierStokes
