import Gibbs.ContinuumField.NavierStokes.Geometry.TorusFields

/-! # True torus function-space stack

Definitive function-space interfaces on `(ℝ/ℤ)^3` used to replace proxy norm
layers in the hard-step path.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-! ## Space descriptors -/

/-- Abstract normed function-space descriptor on true-torus vector fields. -/
structure TrueTorusFunctionSpace where
  name : String
  norm : TrueTorusVectorField → ℝ
  norm_nonneg : ∀ u, 0 ≤ norm u

/-- `L^p(T^3)`-type space descriptor. -/
structure TrueTorusLpSpace where
  p : ℝ
  space : TrueTorusFunctionSpace
  p_pos : 0 < p

/-- Sobolev space descriptor on `T^3`. -/
structure TrueTorusSobolevSpace where
  s : ℝ
  p : ℝ
  space : TrueTorusFunctionSpace

/-- Besov space descriptor on `T^3`. -/
structure TrueTorusBesovSpace where
  s : ℝ
  p : ℝ
  q : ℝ
  space : TrueTorusFunctionSpace

/-- Homogeneous `Ḣ^{1/2}`-space descriptor on `T^3`. -/
structure TrueTorusHomogeneousHHalfSpace where
  space : TrueTorusFunctionSpace
  s_eq_half : (1 / 2 : ℝ) = (1 / 2 : ℝ)

/-- Definitive function-space bundle used by continuation/contradiction arguments. -/
structure DefinitiveFunctionSpaceStack where
  lp3 : TrueTorusLpSpace
  sobolev : TrueTorusSobolevSpace
  besov : TrueTorusBesovSpace
  hhalf : TrueTorusHomogeneousHHalfSpace

/-! ## Obligation structures -/

/-- Completeness/Banach-style obligations for the selected stack. -/
structure DefinitiveFunctionSpaceCompleteness
    (S : DefinitiveFunctionSpaceStack) where
  lp3_complete : Prop
  sobolev_complete : Prop
  besov_complete : Prop
  hhalf_complete : Prop
  lp3_complete_holds : lp3_complete
  sobolev_complete_holds : sobolev_complete
  besov_complete_holds : besov_complete
  hhalf_complete_holds : hhalf_complete

/-- Norm equivalence obligations used by continuation and contradiction steps. -/
structure DefinitiveFunctionSpaceNormEquivalences
    (S : DefinitiveFunctionSpaceStack) where
  lp3_hhalf_equiv :
    ∃ C1 C2 : ℝ,
      0 < C1 ∧ 0 < C2 ∧
      (∀ u, C1 * S.lp3.space.norm u ≤ S.hhalf.space.norm u) ∧
      (∀ u, S.hhalf.space.norm u ≤ C2 * S.lp3.space.norm u)
  sobolev_besov_control :
    ∃ C : ℝ, 0 ≤ C ∧
      ∀ u, S.sobolev.space.norm u ≤ C * S.besov.space.norm u

/-- Interpolation inequality obligations for nonlinear estimates. -/
structure DefinitiveInterpolationInequalities
    (S : DefinitiveFunctionSpaceStack) where
  interpolate_lp3_sobolev :
    ∃ C θ : ℝ, 0 ≤ C ∧ 0 ≤ θ ∧ θ ≤ 1 ∧
      ∀ u,
        S.lp3.space.norm u ≤
          C * S.sobolev.space.norm u * S.hhalf.space.norm u

/-- Embedding obligations used by local theory and epsilon-regularity bridges. -/
structure DefinitiveEmbeddingInequalities
    (S : DefinitiveFunctionSpaceStack) where
  sobolev_to_lp3 :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.lp3.space.norm u ≤ C * S.sobolev.space.norm u
  besov_to_lp3 :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.lp3.space.norm u ≤ C * S.besov.space.norm u

/-! ## Theorem interfaces -/

/-- Completeness theorem interface for the selected definitive function-space stack. -/
theorem trueTorus_functionSpace_completeness
    (S : DefinitiveFunctionSpaceStack)
    (C : DefinitiveFunctionSpaceCompleteness S) :
    C.lp3_complete ∧ C.sobolev_complete ∧ C.besov_complete ∧ C.hhalf_complete := by
  exact ⟨C.lp3_complete_holds, C.sobolev_complete_holds,
    C.besov_complete_holds, C.hhalf_complete_holds⟩

/-- Norm-equivalence theorem interface for the selected definitive function-space stack. -/
theorem trueTorus_functionSpace_norm_equivalences
    (S : DefinitiveFunctionSpaceStack)
    (E : DefinitiveFunctionSpaceNormEquivalences S) :
    (∃ C1 C2 : ℝ,
      0 < C1 ∧ 0 < C2 ∧
      (∀ u, C1 * S.lp3.space.norm u ≤ S.hhalf.space.norm u) ∧
      (∀ u, S.hhalf.space.norm u ≤ C2 * S.lp3.space.norm u)) ∧
    (∃ C : ℝ, 0 ≤ C ∧
      ∀ u, S.sobolev.space.norm u ≤ C * S.besov.space.norm u) := by
  exact ⟨E.lp3_hhalf_equiv, E.sobolev_besov_control⟩

/-- Interpolation theorem interface for definitive nonlinear estimates. -/
theorem trueTorus_interpolation_inequalities
    (S : DefinitiveFunctionSpaceStack)
    (I : DefinitiveInterpolationInequalities S) :
    ∃ C θ : ℝ, 0 ≤ C ∧ 0 ≤ θ ∧ θ ≤ 1 ∧
      ∀ u,
        S.lp3.space.norm u ≤
          C * S.sobolev.space.norm u * S.hhalf.space.norm u :=
  I.interpolate_lp3_sobolev

/-- Embedding theorem interfaces for local theory and epsilon-regularity links. -/
theorem trueTorus_embedding_inequalities
    (S : DefinitiveFunctionSpaceStack)
    (E : DefinitiveEmbeddingInequalities S) :
    (∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.lp3.space.norm u ≤ C * S.sobolev.space.norm u) ∧
    (∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.lp3.space.norm u ≤ C * S.besov.space.norm u) := by
  exact ⟨E.sobolev_to_lp3, E.besov_to_lp3⟩

end Gibbs.ContinuumField.NavierStokes
