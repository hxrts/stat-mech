import StatMech.ContinuumField.NavierStokes.ProofB.Local.FunctionSpaceEstimates
import StatMech.ContinuumField.NavierStokes.ProofB.Local.LocalWellposedness

/-! # Faithful smoothness fidelity layer

Bridges model-level smoothness predicates to concrete regularity controls in
the faithful critical-space stack.
-/

namespace StatMech.ContinuumField.NavierStokes

open scoped Classical

/-- Euclidean velocity fields embedded into torus-vector representatives. -/
def euclideanVelocityToTorusRepresentative
    (u : VelocityField .euclidean3) : TrueTorusVectorField :=
  fun _ => u (fun _ => 0)

/-- Euclidean pressure fields embedded into torus-scalar representatives. -/
def euclideanPressureToTorusRepresentative
    (p : PressureField .euclidean3) : TrueTorusScalarField :=
  fun _ => p (fun _ => 0)

/-- Concrete faithful regularity proxy tied to Sobolev/critical norms. -/
def FaithfulVelocityRegularity
    (A : FaithfulAnalyticStack)
    (u : VelocityField .euclidean3) : Prop :=
  ∃ C : ℝ,
    0 ≤ C ∧
    A.spaces.sobolev.space.norm (euclideanVelocityToTorusRepresentative u) ≤ C ∧
    A.spaces.hhalf.space.norm (euclideanVelocityToTorusRepresentative u) ≤ C

/-- Concrete faithful pressure regularity proxy tied to critical-space norms. -/
def FaithfulPressureRegularity
    (A : FaithfulAnalyticStack)
    (p : PressureField .euclidean3) : Prop :=
  ∃ C : ℝ,
    0 ≤ C ∧
    trueTorusScalarNorm A.spaces.lp3.space (euclideanPressureToTorusRepresentative p) ≤ C

/-- Equivalence package between model smoothness and faithful concrete regularity. -/
structure FaithfulSmoothnessRegularityBridge
    (H : ClayBHypotheses)
    (M : FaithfulPeriodicModel H)
    (A : FaithfulAnalyticStack) where
  velocity_equiv :
    ∀ u : VelocityField .euclidean3,
      IsSmoothField M.NS u ↔ FaithfulVelocityRegularity A u
  pressure_equiv :
    ∀ p : PressureField .euclidean3,
      IsSmoothPressure M.NS p ↔ FaithfulPressureRegularity A p

/-- Model-level velocity smoothness is equivalent to faithful regularity control. -/
theorem faithful_velocity_smoothness_equiv
    {H : ClayBHypotheses}
    {M : FaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (B : FaithfulSmoothnessRegularityBridge H M A)
    (u : VelocityField .euclidean3) :
    IsSmoothField M.NS u ↔ FaithfulVelocityRegularity A u :=
  B.velocity_equiv u

/-- Model-level pressure smoothness is equivalent to faithful regularity control. -/
theorem faithful_pressure_smoothness_equiv
    {H : ClayBHypotheses}
    {M : FaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    (B : FaithfulSmoothnessRegularityBridge H M A)
    (p : PressureField .euclidean3) :
    IsSmoothPressure M.NS p ↔ FaithfulPressureRegularity A p :=
  B.pressure_equiv p

/-- Nontrivial smoothness certification for global strong solutions. -/
structure FaithfulNontrivialSmoothnessCertificate
    {H : ClayBHypotheses}
    (M : FaithfulPeriodicModel H)
    (A : FaithfulAnalyticStack)
    (sol : StrongSolution M.NS) where
  velocity_regular : ∀ t, FaithfulVelocityRegularity A (sol.vel t)
  pressure_regular : ∀ t, FaithfulPressureRegularity A (sol.press t)

/-- Global smoothness follows from faithful regularity certification plus equivalence link. -/
theorem condition11_of_faithful_regular_certification
    {H : ClayBHypotheses}
    {M : FaithfulPeriodicModel H}
    {A : FaithfulAnalyticStack}
    {sol : StrongSolution M.NS}
    (B : FaithfulSmoothnessRegularityBridge H M A)
    (C : FaithfulNontrivialSmoothnessCertificate M A sol) :
    Condition11 M.NS sol := by
  constructor
  · intro t
    exact (B.velocity_equiv (sol.vel t)).2 (C.velocity_regular t)
  · intro t
    exact (B.pressure_equiv (sol.press t)).2 (C.pressure_regular t)

end StatMech.ContinuumField.NavierStokes
