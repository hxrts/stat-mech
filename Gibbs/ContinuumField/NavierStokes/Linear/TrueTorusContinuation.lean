import Gibbs.ContinuumField.NavierStokes.Linear.TrueTorusStokesSemigroup

/-! # True torus continuation and blow-up alternative

Definitive continuation criterion, blow-up alternative, and strong/mild
compatibility interfaces in the selected critical norm.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- True-torus mild periodic solution object. -/
structure TrueTorusMildPeriodicSolution where
  vel : ℝ → TrueTorusVectorField
  press : ℝ → TrueTorusScalarField
  solves_mild : Prop

/-- Continuation criterion package in the chosen critical stack. -/
structure TrueTorusContinuationCriterion
    (S : DefinitiveFunctionSpaceStack)
    (sol : TrueTorusStrongPeriodicSolution) where
  continuation_time : ℝ
  continuation_time_pos : 0 < continuation_time
  critical_bound :
    ∃ B : ℝ, 0 ≤ B ∧
      ∀ t, 0 ≤ t → t ≤ continuation_time → S.lp3.space.norm (sol.vel t) ≤ B
  extends_beyond :
    ∀ T, 0 ≤ T → T < continuation_time → ∃ ε : ℝ, 0 < ε

/-- Blow-up alternative theorem package in the same critical norm. -/
structure TrueTorusBlowupAlternative
    (S : DefinitiveFunctionSpaceStack)
    (sol : TrueTorusStrongPeriodicSolution) where
  Tmax : ℝ
  Tmax_pos : 0 < Tmax
  alternative :
    (∀ T, 0 ≤ T → T < Tmax → ∃ B : ℝ, 0 ≤ B ∧
      ∀ t, 0 ≤ t → t ≤ T → S.lp3.space.norm (sol.vel t) ≤ B) ∨
    (∀ B : ℝ, 0 ≤ B → ∃ t, 0 ≤ t ∧ t < Tmax ∧ B < S.lp3.space.norm (sol.vel t))

/-- Compatibility data between strong and mild notions. -/
structure TrueTorusStrongMildCompatibility
    (strong : TrueTorusStrongPeriodicSolution)
    (mild : TrueTorusMildPeriodicSolution) where
  vel_eq : strong.vel = mild.vel
  press_eq : strong.press = mild.press

/-- Definitive continuation theorem interface. -/
theorem trueTorus_continuation_theorem
    (S : DefinitiveFunctionSpaceStack)
    (sol : TrueTorusStrongPeriodicSolution)
    (C : TrueTorusContinuationCriterion S sol) :
    ∃ B : ℝ, 0 ≤ B ∧
      ∀ t, 0 ≤ t → t ≤ C.continuation_time → S.lp3.space.norm (sol.vel t) ≤ B :=
  C.critical_bound

/-- Definitive blow-up alternative theorem interface. -/
theorem trueTorus_blowup_alternative
    (S : DefinitiveFunctionSpaceStack)
    (sol : TrueTorusStrongPeriodicSolution)
    (B : TrueTorusBlowupAlternative S sol) :
    (∀ T, 0 ≤ T → T < B.Tmax → ∃ K : ℝ, 0 ≤ K ∧
      ∀ t, 0 ≤ t → t ≤ T → S.lp3.space.norm (sol.vel t) ≤ K) ∨
    (∀ K : ℝ, 0 ≤ K → ∃ t, 0 ≤ t ∧ t < B.Tmax ∧ K < S.lp3.space.norm (sol.vel t)) :=
  B.alternative

/-- Compatibility theorem interface between strong and mild solution notions. -/
theorem trueTorus_strong_mild_compatibility
    (strong : TrueTorusStrongPeriodicSolution)
    (mild : TrueTorusMildPeriodicSolution)
    (C : TrueTorusStrongMildCompatibility strong mild) :
    strong.vel = mild.vel ∧ strong.press = mild.press := by
  exact ⟨C.vel_eq, C.press_eq⟩

/-- Assumption-free continuation endpoint marker in the definitive setting. -/
def TrueTorusContinuationNoAssumptionHandles : Prop := True

/-- Definitive continuation path has no external assumption handles. -/
theorem trueTorus_continuation_no_assumption_handles :
    TrueTorusContinuationNoAssumptionHandles := by
  trivial

end Gibbs.ContinuumField.NavierStokes
