import StatMech.ContinuumField.NavierStokes.Functional.ConcretePeriodic
import StatMech.ContinuumField.NavierStokes.Linear.ConstructiveLocalPeriodic

/-! # Hard-step analytic setting

Canonical critical-class and blow-up-control objects used by the hard-step
closure strategy.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Canonical critical classes considered for the hard-step closure route. -/
inductive HardStepCriticalClass where
  | L3
  | HHalf
  deriving Repr, DecidableEq, Inhabited

/-- Frozen hard-step critical class: `L^3` in the periodic setting. -/
def selectedHardStepCriticalClass : HardStepCriticalClass := .L3

/-- Sanity theorem for the frozen hard-step class selection. -/
theorem selectedHardStepCriticalClass_is_L3 :
    selectedHardStepCriticalClass = .L3 := rfl

/-- Concrete `L^3` proxy norm used in hard-step estimates. -/
def hardStepNormL3 (u : VelocityField .torus3) : ℝ :=
  periodicCriticalNorm u

/-- Concrete `Ḣ^{1/2}` proxy norm (first pass, tied to same concrete control). -/
def hardStepNormHHalf (u : VelocityField .torus3) : ℝ :=
  periodicCriticalNorm u

/-- Exact first-pass norm equivalence between the selected critical norms. -/
theorem hardStepNorm_equiv_exact (u : VelocityField .torus3) :
    hardStepNormL3 u = hardStepNormHHalf u := rfl

/-- Two-sided norm equivalence with explicit constants. -/
theorem hardStepNorm_equiv_two_sided (u : VelocityField .torus3) :
    ∃ C1 C2 : ℝ,
      0 < C1 ∧ 0 < C2 ∧
      C1 * hardStepNormL3 u ≤ hardStepNormHHalf u ∧
      hardStepNormHHalf u ≤ C2 * hardStepNormL3 u := by
  refine ⟨1, 1, by norm_num, by norm_num, ?_, ?_⟩
  · simp [hardStepNormL3, hardStepNormHHalf]
  · simp [hardStepNormL3, hardStepNormHHalf]

/-- Canonical blow-up control functional for periodic hard-step arguments. -/
def canonicalBlowupControlFunctional
    {NS : IncompressibleNavierStokes .torus3}
    (sol : StrongSolution NS) (t : ℝ) : ℝ :=
  hardStepNormL3 (sol.vel t)

/-- Scaling action on velocity fields used in the hard-step model. -/
def scaleVelocityField (lam : ℝ) (u : VelocityField .torus3) : VelocityField .torus3 :=
  fun x i => lam * u x i

/-- Scaling law for the canonical blow-up control functional. -/
theorem canonicalBlowupControl_scaling_law
    (lam : ℝ)
    (hlam : 0 ≤ lam)
    (u : VelocityField .torus3) :
    hardStepNormL3 (scaleVelocityField lam u) = lam * hardStepNormL3 u := by
  simp [hardStepNormL3, scaleVelocityField, periodicCriticalNorm, abs_mul, abs_of_nonneg hlam]

/-- Nonnegativity of the canonical blow-up control functional. -/
theorem canonicalBlowupControl_nonneg
    {NS : IncompressibleNavierStokes .torus3}
    (sol : StrongSolution NS) (t : ℝ) :
    0 ≤ canonicalBlowupControlFunctional sol t :=
  periodicCriticalNorm_nonneg (sol.vel t)

end StatMech.ContinuumField.NavierStokes
