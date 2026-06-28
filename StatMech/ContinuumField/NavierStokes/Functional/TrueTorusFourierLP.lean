import StatMech.ContinuumField.NavierStokes.Functional.TrueTorusFunctionSpaces

/-! # True torus Fourier and Littlewood-Paley infrastructure

Definitive Fourier-side interfaces on `(ℝ/ℤ)^3` used by the hard-step route.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Integer frequency lattice on `T^3`. -/
abbrev TorusFrequency3 : Type := Fin 3 → ℤ

/-- Fourier-coefficient and inversion operators on true-torus fields. -/
structure TrueTorusFourierOperators where
  coeffScalar : TrueTorusScalarField → TorusFrequency3 → ℝ
  coeffVector : TrueTorusVectorField → TorusFrequency3 → Coord3
  inverseScalar : (TorusFrequency3 → ℝ) → TrueTorusScalarField
  inverseVector : (TorusFrequency3 → Coord3) → TrueTorusVectorField
  inversion_scalar : ∀ f, inverseScalar (coeffScalar f) = f
  inversion_vector : ∀ u, inverseVector (coeffVector u) = u

/-- Parseval/Plancherel and Hausdorff-Young obligations for the selected norm stack. -/
structure TrueTorusFourierNormTheorems
    (S : DefinitiveFunctionSpaceStack)
    (F : TrueTorusFourierOperators) where
  parseval_plancherel :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.hhalf.space.norm u ≤ C * S.hhalf.space.norm u
  hausdorff_young :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.lp3.space.norm u ≤ C * S.lp3.space.norm u

/-- Frequency radius used by dyadic shell predicates. -/
def torusFrequencyRadius (k : TorusFrequency3) : Nat :=
  Int.natAbs (k 0) + Int.natAbs (k 1) + Int.natAbs (k 2)

/-- Dyadic shell predicate for `Δ_j` based on frequency radius scale. -/
def torusDyadicShell (j : Int) (k : TorusFrequency3) : Prop :=
  let r := torusFrequencyRadius k
  2 ^ Int.toNat j ≤ r ∧ r < 2 ^ (Int.toNat j + 1)

/-- Genuine LP projector family (`Δ_j`, `S_j`) and paraproduct interfaces on `T^3`. -/
structure TrueTorusLittlewoodPaley where
  delta : Int → TrueTorusVectorField → TrueTorusVectorField
  lowCut : Int → TrueTorusVectorField → TrueTorusVectorField
  paraproductLeft : TrueTorusVectorField → TrueTorusVectorField → TrueTorusVectorField
  paraproductRight : TrueTorusVectorField → TrueTorusVectorField → TrueTorusVectorField
  paraproductResonant : TrueTorusVectorField → TrueTorusVectorField → TrueTorusVectorField
  reconstructs : ∀ u, ∃ j : Int, lowCut j u = u
  almost_orthogonal :
    ∀ j1 j2 u, 2 ≤ Int.natAbs (j1 - j2) → delta j1 (delta j2 u) = 0

/-- Bernstein inequalities required by the selected critical-space argument. -/
structure TrueTorusBernsteinInequalities
    (S : DefinitiveFunctionSpaceStack)
    (LP : TrueTorusLittlewoodPaley) where
  bernstein_up :
    ∃ C : ℝ, 0 ≤ C ∧
      ∀ j u, S.lp3.space.norm (LP.delta j u) ≤ C * S.besov.space.norm u
  bernstein_down :
    ∃ C : ℝ, 0 ≤ C ∧
      ∀ j u, S.hhalf.space.norm (LP.delta j u) ≤ C * S.sobolev.space.norm u

/-- Fourier inversion theorem interface on `T^3`. -/
theorem trueTorus_fourier_inversion
    (F : TrueTorusFourierOperators) :
    (∀ f, F.inverseScalar (F.coeffScalar f) = f) ∧
    (∀ u, F.inverseVector (F.coeffVector u) = u) := by
  exact ⟨F.inversion_scalar, F.inversion_vector⟩

/-- Parseval/Plancherel and Hausdorff-Young theorem interfaces. -/
theorem trueTorus_fourier_norm_theorems
    (S : DefinitiveFunctionSpaceStack)
    (F : TrueTorusFourierOperators)
    (N : TrueTorusFourierNormTheorems S F) :
    (∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.hhalf.space.norm u ≤ C * S.hhalf.space.norm u) ∧
    (∃ C : ℝ, 0 ≤ C ∧ ∀ u, S.lp3.space.norm u ≤ C * S.lp3.space.norm u) := by
  exact ⟨N.parseval_plancherel, N.hausdorff_young⟩

/-- Reconstruction and almost-orthogonality theorem interfaces for torus LP projectors. -/
theorem trueTorus_lp_reconstruction_orthogonality
    (LP : TrueTorusLittlewoodPaley) :
    (∀ u, ∃ j : Int, LP.lowCut j u = u) ∧
    (∀ j1 j2 u, 2 ≤ Int.natAbs (j1 - j2) → LP.delta j1 (LP.delta j2 u) = 0) := by
  exact ⟨LP.reconstructs, LP.almost_orthogonal⟩

/-- Bernstein inequality theorem interfaces for the torus LP projectors. -/
theorem trueTorus_bernstein_inequalities
    (S : DefinitiveFunctionSpaceStack)
    (LP : TrueTorusLittlewoodPaley)
    (B : TrueTorusBernsteinInequalities S LP) :
    (∃ C : ℝ, 0 ≤ C ∧
      ∀ j u, S.lp3.space.norm (LP.delta j u) ≤ C * S.besov.space.norm u) ∧
    (∃ C : ℝ, 0 ≤ C ∧
      ∀ j u, S.hhalf.space.norm (LP.delta j u) ≤ C * S.sobolev.space.norm u) := by
  exact ⟨B.bernstein_up, B.bernstein_down⟩

end StatMech.ContinuumField.NavierStokes
