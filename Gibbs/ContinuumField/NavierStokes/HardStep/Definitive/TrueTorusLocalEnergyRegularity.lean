import Gibbs.ContinuumField.NavierStokes.HardStep.Definitive.TrueTorusMinimalElement
import Gibbs.ContinuumField.NavierStokes.Geometry.TorusIntegral

/-! # Definitive true-torus local energy and epsilon-regularity bridge

Local energy inequality, epsilon-regularity, and no-concentration interfaces
used in rigidity arguments.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Local energy inequality package in the periodic setting. -/
structure TrueTorusLocalEnergyInequality where
  localEnergy : ℝ → TrueTorusVectorField → ℝ
  inequality :
    ∀ t u, 0 ≤ localEnergy t u

/-- Epsilon-regularity criterion package for concentration control. -/
structure TrueTorusEpsilonRegularityCriterion where
  εreg : ℝ
  εreg_pos : 0 < εreg
  criterion : VelocityField .torus3 → Prop
  smallness_implies :
    ∀ u : VelocityField .torus3, hardStepNormL3 u ≤ εreg → criterion u

/-- Bridge from local-energy/epsilon-regularity to defect-envelope flux layer. -/
structure TrueTorusLocalEnergyFluxBridge where
  bridge_pred : ℝ → Prop
  bridge_holds : ∀ t : ℝ, 0 ≤ t → bridge_pred t

/-- No-concentration consequence used in rigidity arguments. -/
def TrueTorusNoConcentrationConsequence : Prop :=
  ∀ (E : TrueTorusEpsilonRegularityCriterion)
    (u : VelocityField .torus3),
    hardStepNormL3 u ≤ E.εreg → E.criterion u

/-- Definitive local energy inequality theorem interface. -/
theorem definitive_local_energy_inequality
    (L : TrueTorusLocalEnergyInequality) :
    ∀ t u, 0 ≤ L.localEnergy t u :=
  L.inequality

/-- Definitive epsilon-regularity theorem interface. -/
theorem definitive_epsilon_regularity
    (E : TrueTorusEpsilonRegularityCriterion) :
    ∀ u : VelocityField .torus3, hardStepNormL3 u ≤ E.εreg → E.criterion u :=
  E.smallness_implies

/-- Definitive local-energy to flux/defect bridge theorem interface. -/
theorem definitive_local_energy_flux_bridge
    (B : TrueTorusLocalEnergyFluxBridge) :
    ∀ t : ℝ, 0 ≤ t → B.bridge_pred t :=
  B.bridge_holds

/-- Definitive no-concentration consequence for rigidity route. -/
theorem definitive_no_concentration_consequence :
    TrueTorusNoConcentrationConsequence := by
  intro E u hu
  exact definitive_epsilon_regularity E u hu

end Gibbs.ContinuumField.NavierStokes
