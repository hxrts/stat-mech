import StatMech.ContinuumField.NavierStokes.Functional.TrueTorusFourierLP
import StatMech.ContinuumField.NavierStokes.Geometry.TorusCalculus

/-! # True torus Leray projector and pressure operators

Definitive Fourier-multiplier interfaces for the Leray projector and pressure
estimates on `(ℝ/ℤ)^3`.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Scalar fields embedded as first-component vector fields for shared norm APIs. -/
def trueTorusScalarToVector (f : TrueTorusScalarField) : TrueTorusVectorField :=
  fun x i => if i = 0 then f x else 0

/-- Scalar norm induced from a vector-field norm descriptor. -/
def trueTorusScalarNorm (X : TrueTorusFunctionSpace) (f : TrueTorusScalarField) : ℝ :=
  X.norm (trueTorusScalarToVector f)

/-- Fourier multiplier symbol for the Leray projector on `T^3`. -/
structure TrueTorusLerayMultiplier where
  symbol : TorusFrequency3 → Coord3 → Coord3
  symbol_zero_mode : symbol (fun _ => 0) = fun _ => 0

/-- Abstract Stokes-type semigroup used for commutation obligations. -/
structure TrueTorusStokesSemigroup where
  map : ℝ → TrueTorusVectorField → TrueTorusVectorField

/-- Leray projector represented by its Fourier multiplier action. -/
structure TrueTorusLerayProjector where
  multiplier : TrueTorusLerayMultiplier
  proj : TrueTorusVectorField → TrueTorusVectorField
  proj_via_multiplier : Prop

/-- Boundedness obligations for Leray on all spaces used downstream. -/
structure TrueTorusLerayBoundedness
    (S : DefinitiveFunctionSpaceStack)
    (P : TrueTorusLerayProjector) where
  lp3_bounded :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.lp3.space.norm (P.proj u) ≤ C * S.lp3.space.norm u
  sobolev_bounded :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.sobolev.space.norm (P.proj u) ≤ C * S.sobolev.space.norm u
  besov_bounded :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.besov.space.norm (P.proj u) ≤ C * S.besov.space.norm u
  hhalf_bounded :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.hhalf.space.norm (P.proj u) ≤ C * S.hhalf.space.norm u

/-- Commutation obligations with derivatives and Stokes semigroup. -/
structure TrueTorusLerayCommutation
    (C : TorusClassicalDerivativeOps)
    (P : TrueTorusLerayProjector)
    (G : TrueTorusStokesSemigroup) where
  commutes_with_derivatives :
    ∀ α u, P.proj (C.dVector α u) = C.dVector α (P.proj u)
  commutes_with_semigroup :
    ∀ t u, P.proj (G.map t u) = G.map t (P.proj u)

/-- Pressure operator package via Poisson solve and Riesz transforms. -/
structure TrueTorusPressureOperator where
  poissonSolve : TrueTorusScalarField → TrueTorusScalarField
  riesz : Fin 3 → TrueTorusScalarField → TrueTorusScalarField
  pressureOfVelocity : TrueTorusVectorField → TrueTorusScalarField
  pressure_via_poisson_or_riesz : Prop

/-- Calderon-Zygmund bounds for the definitive pressure operator in target norms. -/
structure TrueTorusPressureCalderonZygmund
    (S : DefinitiveFunctionSpaceStack)
    (PiOp : TrueTorusPressureOperator) where
  pressure_lp3_bound :
    ∃ C : ℝ, 0 ≤ C ∧
      ∀ u, trueTorusScalarNorm S.lp3.space (PiOp.pressureOfVelocity u) ≤ C * S.lp3.space.norm u
  pressure_hhalf_bound :
    ∃ C : ℝ, 0 ≤ C ∧
      ∀ u, trueTorusScalarNorm S.hhalf.space (PiOp.pressureOfVelocity u) ≤ C * S.hhalf.space.norm u

/-- Leray boundedness theorem interface on all selected spaces. -/
theorem trueTorus_leray_boundedness
    (S : DefinitiveFunctionSpaceStack)
    (P : TrueTorusLerayProjector)
    (B : TrueTorusLerayBoundedness S P) :
    (∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.lp3.space.norm (P.proj u) ≤ C * S.lp3.space.norm u) ∧
    (∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.sobolev.space.norm (P.proj u) ≤ C * S.sobolev.space.norm u) ∧
    (∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.besov.space.norm (P.proj u) ≤ C * S.besov.space.norm u) ∧
    (∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.hhalf.space.norm (P.proj u) ≤ C * S.hhalf.space.norm u) := by
  exact ⟨B.lp3_bounded, B.sobolev_bounded, B.besov_bounded, B.hhalf_bounded⟩

/-- Leray commutation theorem interface with derivatives and semigroup evolution. -/
theorem trueTorus_leray_commutation
    (C : TorusClassicalDerivativeOps)
    (P : TrueTorusLerayProjector)
    (G : TrueTorusStokesSemigroup)
    (K : TrueTorusLerayCommutation C P G) :
    (∀ α u, P.proj (C.dVector α u) = C.dVector α (P.proj u)) ∧
    (∀ t u, P.proj (G.map t u) = G.map t (P.proj u)) := by
  exact ⟨K.commutes_with_derivatives, K.commutes_with_semigroup⟩

/-- Pressure Calderon-Zygmund theorem interfaces in the selected critical framework. -/
theorem trueTorus_pressure_calderon_zygmund
    (S : DefinitiveFunctionSpaceStack)
    (PiOp : TrueTorusPressureOperator)
    (CZ : TrueTorusPressureCalderonZygmund S PiOp) :
    (∃ C : ℝ, 0 ≤ C ∧
      ∀ u, trueTorusScalarNorm S.lp3.space (PiOp.pressureOfVelocity u) ≤ C * S.lp3.space.norm u) ∧
    (∃ C : ℝ, 0 ≤ C ∧
      ∀ u, trueTorusScalarNorm S.hhalf.space (PiOp.pressureOfVelocity u) ≤ C * S.hhalf.space.norm u) := by
  exact ⟨CZ.pressure_lp3_bound, CZ.pressure_hhalf_bound⟩

end StatMech.ContinuumField.NavierStokes
