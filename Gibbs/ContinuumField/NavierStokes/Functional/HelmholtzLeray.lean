import Gibbs.ContinuumField.NavierStokes.Functional.CriticalSpace
import Gibbs.ContinuumField.NavierStokes.Projector

/-!
# Helmholtz-Leray projection properties

Interface-level properties of Leray projection on selected critical spaces.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Helmholtz-Leray property package at a critical space. -/
structure HelmholtzLerayPackage {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D)
    (P : LerayProjector D)
    (X : CriticalSpace D) where
  /-- Projection boundedness in the selected critical norm. -/
  bounded : ∃ C : ℝ, 0 ≤ C ∧ ∀ u, X.norm (P.proj u) ≤ C * X.norm u
  /-- Projection commutes with model Laplacian (for pressure elimination path). -/
  commutes_laplace : ∀ u, P.proj (NS.ops.laplace u) = NS.ops.laplace (P.proj u)

/-- Projected velocity is divergence-free for the model divergence operator. -/
theorem helmholtz_projected_divfree {D : SpatialDomain3}
    (NS : IncompressibleNavierStokes D)
    (P : LerayProjector D)
    (u : VelocityField D) :
    IsDivergenceFreeWith NS.ops.div (P.proj u) := by
  exact P.divergenceFree_proj NS.ops.div u

/-- Projection boundedness can be used pointwise once a package is provided. -/
theorem helmholtz_norm_bound {D : SpatialDomain3}
    {NS : IncompressibleNavierStokes D}
    {P : LerayProjector D}
    {X : CriticalSpace D}
    (H : HelmholtzLerayPackage NS P X) :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ u, X.norm (P.proj u) ≤ C * X.norm u :=
  H.bounded

end Gibbs.ContinuumField.NavierStokes
