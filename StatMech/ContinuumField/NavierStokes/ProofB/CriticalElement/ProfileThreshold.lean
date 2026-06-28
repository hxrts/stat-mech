import StatMech.ContinuumField.NavierStokes.ProofB.CriticalElement.PerturbationStability
import StatMech.ContinuumField.NavierStokes.Blowup.Compactness

/-! # Hard-step profile decomposition and threshold layer

Profile decomposition scaffolding, critical-threshold definition, and minimizing
sequence extraction for the hard-step contradiction route.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Profile decomposition data in the selected periodic critical topology. -/
structure ProfileDecompositionData where
  sequence : Nat → VelocityField .torus3
  profile : Nat → VelocityField .torus3
  remainder : Nat → VelocityField .torus3
  decomposition : ∀ n, sequence n = profile n + remainder n
  /-- Orthogonality proxy between distinct profile modes. -/
  orthogonality :
    ∀ j k, j ≠ k →
      (profile j originCoord3 0) * (profile k originCoord3 0) = 0
  /-- Remainder decay in the concrete hard-step norm. -/
  remainder_decay :
    ∀ ε : ℝ, 0 < ε →
      ∃ N0 : Nat, ∀ n ≥ N0, hardStepNormL3 (remainder n) ≤ ε

/-- Critical-threshold package for global-closure failure. -/
structure CriticalThresholdData where
  Astar : ℝ
  Astar_nonneg : 0 ≤ Astar
  /-- Closure holds strictly below the threshold. -/
  closure_below : ∀ A : ℝ, 0 ≤ A → A < Astar → Prop
  /-- Failure is realized at the threshold scale. -/
  failure_at_threshold : Prop

/-- Canonical notation for the hard-step critical threshold value. -/
def criticalThresholdValue (T : CriticalThresholdData) : ℝ := T.Astar

/-- A minimizing sequence approaching `A*` from above. -/
structure MinimizingSequenceAtThreshold (T : CriticalThresholdData) where
  seq : Nat → ℝ
  lower_bound : ∀ n, T.Astar ≤ seq n
  tends_to_Astar :
    ∀ ε : ℝ, 0 < ε →
      ∃ N0 : Nat, ∀ n ≥ N0, seq n ≤ T.Astar + ε

/-- Existence theorem interface for minimizing sequences at the critical threshold. -/
theorem exists_minimizing_sequence_at_threshold
    (T : CriticalThresholdData)
    (W : MinimizingSequenceAtThreshold T) :
    ∃ seq : Nat → ℝ,
      (∀ n, T.Astar ≤ seq n) ∧
      (∀ ε : ℝ, 0 < ε →
        ∃ N0 : Nat, ∀ n ≥ N0, seq n ≤ T.Astar + ε) := by
  refine ⟨W.seq, W.lower_bound, W.tends_to_Astar⟩

/-- A minimizing profile sequence couples threshold minimization with decomposition data. -/
structure MinimizingProfileSequence (T : CriticalThresholdData) where
  profileData : ProfileDecompositionData
  values : Nat → ℝ
  values_lower : ∀ n, T.Astar ≤ values n
  values_to_Astar :
    ∀ ε : ℝ, 0 < ε →
      ∃ N0 : Nat, ∀ n ≥ N0, values n ≤ T.Astar + ε

/-- Any minimizing-profile witness yields a threshold minimizing sequence. -/
def minimizing_profile_yields_minimizing_sequence
    (T : CriticalThresholdData)
    (M : MinimizingProfileSequence T) :
    MinimizingSequenceAtThreshold T where
  seq := M.values
  lower_bound := M.values_lower
  tends_to_Astar := M.values_to_Astar

end StatMech.ContinuumField.NavierStokes
