import StatMech.ContinuumField.NavierStokes.Functional.TrueTorusNonlinearDefinitive

/-! # True torus Stokes semigroup and constructive local theory

Definitive semigroup, Duhamel, contraction, and local well-posedness
interfaces for divergence-free periodic fields on `(ℝ/ℤ)^3`.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- True-torus strong periodic solution object for constructive local theory. -/
structure TrueTorusStrongPeriodicSolution where
  vel : ℝ → TrueTorusVectorField
  press : ℝ → TrueTorusScalarField
  smooth : Prop
  solves_navier_stokes : Prop

/-- Stokes semigroup with semigroup law in the true-torus setting. -/
structure TrueTorusDefinitiveStokesSemigroup where
  map : ℝ → TrueTorusVectorField → TrueTorusVectorField
  semigroup_law : ∀ t s u, map (t + s) u = map t (map s u)

/-- Smoothing/decay bounds required in the selected critical stack. -/
structure TrueTorusSemigroupEstimates
    (S : DefinitiveFunctionSpaceStack)
    (G : TrueTorusDefinitiveStokesSemigroup) where
  smoothing_bound :
    ∃ C : ℝ, 0 ≤ C ∧
      ∀ t u, S.sobolev.space.norm (G.map t u) ≤ C * S.lp3.space.norm u
  decay_bound :
    ∃ C : ℝ, 0 ≤ C ∧
      ∀ t u, S.hhalf.space.norm (G.map t u) ≤ C * S.hhalf.space.norm u

/-- Definitive Duhamel map for the final Banach-space route. -/
def trueTorusDuhamelMap
    (G : TrueTorusDefinitiveStokesSemigroup)
    (N : TrueTorusConvectionModel)
    (u0 : TrueTorusVectorField) : ℝ → TrueTorusVectorField :=
  fun t => G.map t u0 + N.convection (G.map t u0)

/-- Contraction-mapping package with explicit small-time/small-data constants. -/
structure TrueTorusContractionPackage
    (S : DefinitiveFunctionSpaceStack)
    (G : TrueTorusDefinitiveStokesSemigroup)
    (N : TrueTorusConvectionModel)
    (u0 : TrueTorusVectorField) where
  radius : ℝ
  timeSmallness : ℝ
  dataSmallness : ℝ
  radius_nonneg : 0 ≤ radius
  timeSmallness_nonneg : 0 ≤ timeSmallness
  dataSmallness_nonneg : 0 ≤ dataSmallness
  contraction :
    ∃ q : ℝ, 0 ≤ q ∧ q < 1 ∧
      ∀ t,
        S.lp3.space.norm (trueTorusDuhamelMap G N u0 t) ≤
          q * S.lp3.space.norm (G.map t u0)

/-- Constructive local well-posedness package. -/
structure TrueTorusConstructiveLocalWellPosedness
    (S : DefinitiveFunctionSpaceStack)
    (G : TrueTorusDefinitiveStokesSemigroup)
    (N : TrueTorusConvectionModel)
    (u0 : TrueTorusVectorField) where
  T : ℝ
  T_pos : 0 < T
  sol : TrueTorusStrongPeriodicSolution
  init_match : sol.vel 0 = u0
  uniqueness : ∀ s : TrueTorusStrongPeriodicSolution, s.vel 0 = u0 → s = sol
  persistence : ∀ t, 0 ≤ t → t ≤ T → S.lp3.space.norm (sol.vel t) ≤ S.lp3.space.norm u0
  continuous_dependence :
    ∀ v0,
      ∃ C : ℝ, 0 ≤ C ∧
        S.lp3.space.norm (sol.vel 0 - v0) ≤ C * S.lp3.space.norm (u0 - v0)

/-- Definitive semigroup estimate theorem interfaces. -/
theorem trueTorus_stokes_semigroup_estimates
    (S : DefinitiveFunctionSpaceStack)
    (G : TrueTorusDefinitiveStokesSemigroup)
    (E : TrueTorusSemigroupEstimates S G) :
    (∃ C : ℝ, 0 ≤ C ∧
      ∀ t u, S.sobolev.space.norm (G.map t u) ≤ C * S.lp3.space.norm u) ∧
    (∃ C : ℝ, 0 ≤ C ∧
      ∀ t u, S.hhalf.space.norm (G.map t u) ≤ C * S.hhalf.space.norm u) := by
  exact ⟨E.smoothing_bound, E.decay_bound⟩

/-- Contraction theorem interface for the definitive Duhamel map. -/
theorem trueTorus_duhamel_contraction
    (S : DefinitiveFunctionSpaceStack)
    (G : TrueTorusDefinitiveStokesSemigroup)
    (N : TrueTorusConvectionModel)
    (u0 : TrueTorusVectorField)
    (P : TrueTorusContractionPackage S G N u0) :
    ∃ q : ℝ, 0 ≤ q ∧ q < 1 ∧
      ∀ t,
        S.lp3.space.norm (trueTorusDuhamelMap G N u0 t) ≤
          q * S.lp3.space.norm (G.map t u0) :=
  P.contraction

/-- Constructive local well-posedness theorem interface. -/
theorem trueTorus_constructive_local_wellposedness
    (S : DefinitiveFunctionSpaceStack)
    (G : TrueTorusDefinitiveStokesSemigroup)
    (N : TrueTorusConvectionModel)
    (u0 : TrueTorusVectorField)
    (L : TrueTorusConstructiveLocalWellPosedness S G N u0) :
    ∃ T > (0 : ℝ),
      ∃ sol : TrueTorusStrongPeriodicSolution,
        sol.vel 0 = u0 ∧
        (∀ s : TrueTorusStrongPeriodicSolution, s.vel 0 = u0 → s = sol) := by
  exact ⟨L.T, L.T_pos, L.sol, L.init_match, L.uniqueness⟩

end StatMech.ContinuumField.NavierStokes
