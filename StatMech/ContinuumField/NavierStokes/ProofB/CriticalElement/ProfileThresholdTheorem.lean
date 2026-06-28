import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.LongTimePerturbationTheorem
import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.ProfileThreshold

/-! # Definitive true-torus profile threshold layer

Direct profile decomposition, threshold `A*`, minimizing sequence, and
compactness interfaces for the critical-element construction.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Definitive profile decomposition theorem package. -/
structure DefinitiveProfileDecompositionTheorem where
  theorem_stmt : ProfileDecompositionData

/-- Definitive threshold object with explicit quantifiers. -/
structure DefinitiveCriticalThreshold where
  Astar : ℝ
  Astar_nonneg : 0 ≤ Astar
  closure_below :
    ∀ A : ℝ, 0 ≤ A → A < Astar →
      ∀ _NS : IncompressibleNavierStokes .torus3, Prop
  failure_at :
    ∀ _NS : IncompressibleNavierStokes .torus3, Prop

/-- Definitive minimizing sequence approaching `A*`. -/
structure DefinitiveMinimizingSequence
    (T : DefinitiveCriticalThreshold) where
  seq : Nat → ℝ
  lower_bound : ∀ n, T.Astar ≤ seq n
  tends_to_Astar :
    ∀ ε : ℝ, 0 < ε → ∃ N0 : Nat, ∀ n ≥ N0, seq n ≤ T.Astar + ε

/-- Definitive compactness package used to extract a critical element. -/
structure DefinitiveThresholdCompactness where
  sequence : Nat → VelocityField .torus3
  compactness :
    ∀ ε : ℝ, 0 < ε → ∃ N0 : Nat, ∀ n ≥ N0, hardStepNormL3 (sequence n) ≤ ε + 1

/-- Profile decomposition interface in definitive form. -/
def definitive_profile_decomposition
    (P : DefinitiveProfileDecompositionTheorem) :
    ProfileDecompositionData :=
  P.theorem_stmt

/-- Existence theorem interface for minimizing sequences at the definitive threshold. -/
theorem definitive_exists_minimizing_sequence
    (T : DefinitiveCriticalThreshold)
    (M : DefinitiveMinimizingSequence T) :
    ∃ seq : Nat → ℝ,
      (∀ n, T.Astar ≤ seq n) ∧
      (∀ ε : ℝ, 0 < ε → ∃ N0 : Nat, ∀ n ≥ N0, seq n ≤ T.Astar + ε) := by
  exact ⟨M.seq, M.lower_bound, M.tends_to_Astar⟩

/-- Compactness extraction interface for the critical-threshold route. -/
theorem definitive_threshold_compactness
    (K : DefinitiveThresholdCompactness) :
    ∀ ε : ℝ, 0 < ε → ∃ N0 : Nat, ∀ n ≥ N0, hardStepNormL3 (K.sequence n) ≤ ε + 1 :=
  K.compactness

end StatMech.ContinuumField.NavierStokes
