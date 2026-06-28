import StatMech.ContinuumField.NavierStokes.Functional.HelmholtzLeray

/-! # Linear semigroup layer

Heat/Stokes semigroup interfaces and norm bounds in critical spaces.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Abstract heat/Stokes semigroup acting on velocity fields. -/
structure StokesSemigroup (D : SpatialDomain3) where
  /-- Semigroup action at time `t`. -/
  apply : ℝ → VelocityField D → VelocityField D
  /-- Time-zero identity law. -/
  at_zero : ∀ u, apply 0 u = u
  /-- Semigroup composition law. -/
  semigroup : ∀ t s u, apply (t + s) u = apply t (apply s u)

/-- Semigroup estimates in a chosen critical space. -/
structure SemigroupEstimatePackage {D : SpatialDomain3}
    (S : StokesSemigroup D)
    (X : CriticalSpace D) where
  /-- Decay/smoothing constant. -/
  Csem : ℝ
  /-- Nonnegativity. -/
  Csem_nonneg : 0 ≤ Csem
  /-- Abstract bound valid for nonnegative times. -/
  estimate : ∀ t u, 0 ≤ t → X.norm (S.apply t u) ≤ Csem * X.norm u

/-- Semigroup estimate theorem in reusable form. -/
theorem heat_stokes_semigroup_estimate {D : SpatialDomain3}
    (S : StokesSemigroup D)
    (X : CriticalSpace D)
    (E : SemigroupEstimatePackage S X)
    (t : ℝ)
    (u : VelocityField D)
    (ht : 0 ≤ t) :
    X.norm (S.apply t u) ≤ E.Csem * X.norm u :=
  E.estimate t u ht

end StatMech.ContinuumField.NavierStokes
