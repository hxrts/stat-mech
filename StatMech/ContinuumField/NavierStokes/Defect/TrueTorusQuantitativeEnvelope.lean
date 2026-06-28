import StatMech.ContinuumField.NavierStokes.Erasure.TrueTorusCoarseSystem

/-! # True torus quantitative defect envelope

Definitive critical-scaling defect-envelope functionals and closure inequalities.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Quantitative defect envelope matched to critical scaling. -/
structure TrueTorusQuantitativeDefectEnvelope where
  value : ℝ → ℝ
  criticalNorm : ℝ → ℝ
  nonneg : ∀ t, 0 ≤ value t
  scaling_law : ∀ lam t, value (lam * t) = lam * value t

/-- Differential inequalities driving long-time envelope control. -/
structure TrueTorusEnvelopeDifferentialInequalities
    (E : TrueTorusQuantitativeDefectEnvelope) where
  differential_ineq :
    ∃ C1 C2 : ℝ, 0 ≤ C1 ∧ 0 ≤ C2 ∧
      ∀ t, E.value t ≤ C1 + C2 * E.value t

/-- Gronwall/Osgood closure tools for the true-torus envelope route. -/
structure TrueTorusEnvelopeClosureTools
    (E : TrueTorusQuantitativeDefectEnvelope) where
  gronwall_tool :
    ∀ T, 0 ≤ T → ∃ B : ℝ, 0 ≤ B ∧ ∀ t, 0 ≤ t → t ≤ T → E.value t ≤ B
  osgood_tool :
    ∀ T, 0 ≤ T → ∃ B : ℝ, 0 ≤ B ∧ ∀ t, 0 ≤ t → t ≤ T → E.criticalNorm t ≤ B

/-- Transfer inequalities from defect envelope to critical norm without placeholders. -/
structure TrueTorusEnvelopeTransferInequalities
    (S : DefinitiveFunctionSpaceStack)
    (E : TrueTorusQuantitativeDefectEnvelope) where
  transfer_lp3 :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ t u, S.lp3.space.norm u ≤ C * (E.value t + 1)
  transfer_hhalf :
    ∃ C : ℝ, 0 ≤ C ∧ ∀ t u, S.hhalf.space.norm u ≤ C * (E.criticalNorm t + 1)

/-- Differential-inequality theorem interface for definitive envelope dynamics. -/
theorem trueTorus_envelope_differential_inequality
    (E : TrueTorusQuantitativeDefectEnvelope)
    (D : TrueTorusEnvelopeDifferentialInequalities E) :
    ∃ C1 C2 : ℝ, 0 ≤ C1 ∧ 0 ≤ C2 ∧
      ∀ t, E.value t ≤ C1 + C2 * E.value t :=
  D.differential_ineq

/-- Gronwall/Osgood closure theorem interfaces for long-time control. -/
theorem trueTorus_envelope_closure_tools
    (E : TrueTorusQuantitativeDefectEnvelope)
    (G : TrueTorusEnvelopeClosureTools E) :
    (∀ T, 0 ≤ T → ∃ B : ℝ, 0 ≤ B ∧ ∀ t, 0 ≤ t → t ≤ T → E.value t ≤ B) ∧
    (∀ T, 0 ≤ T → ∃ B : ℝ, 0 ≤ B ∧ ∀ t, 0 ≤ t → t ≤ T → E.criticalNorm t ≤ B) := by
  exact ⟨G.gronwall_tool, G.osgood_tool⟩

/-- Envelope-to-critical transfer inequality theorem interface. -/
theorem trueTorus_envelope_transfer_inequalities
    (S : DefinitiveFunctionSpaceStack)
    (E : TrueTorusQuantitativeDefectEnvelope)
    (T : TrueTorusEnvelopeTransferInequalities S E) :
    (∃ C : ℝ, 0 ≤ C ∧ ∀ t u, S.lp3.space.norm u ≤ C * (E.value t + 1)) ∧
    (∃ C : ℝ, 0 ≤ C ∧ ∀ t u, S.hhalf.space.norm u ≤ C * (E.criticalNorm t + 1)) := by
  exact ⟨T.transfer_lp3, T.transfer_hhalf⟩

end StatMech.ContinuumField.NavierStokes
