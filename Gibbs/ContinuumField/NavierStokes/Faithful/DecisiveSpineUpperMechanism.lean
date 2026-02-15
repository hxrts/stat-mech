import Gibbs.ContinuumField.NavierStokes.Faithful.DecisiveSpineLowerMechanism

/-! # Decisive contradiction-spine upper mechanism

Quantitative tail-vanishing mechanism and limit-exchange theorem package.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Direct upper-flux hypothesis shape for the decisive crux step. -/
abbrev DecisiveSpineUpperFluxHypotheses
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  TendsToZeroNat (fun N => scaleFlux N t0 U)

/-- Dyadic upper-flux hypothesis shape for the decisive crux step. -/
abbrev DecisiveSpineUpperFluxHypothesesDyadic
    (F : DyadicErasureFamily .torus3)
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) : Prop :=
  TendsToZeroNat (fun N => scaleFluxDyadic F N t0 U)

/-- Quantitative upper mechanism theorem for decisive spine. -/
theorem decisiveSpine_upper_mechanism_quantitative
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    {t0 : ℝ}
    (upper_tail : TailVanishingWitness E U t0) :
    DecisiveSpineUpperFluxHypotheses U t0 ∧
    TendsToZeroNat upper_tail.integratedDefect := by
  exact baseAxiom_upper_tail_vanishing upper_tail

/-- Dyadic quantitative upper mechanism theorem for decisive spine. -/
theorem decisiveSpine_upper_mechanism_quantitative_dyadic
    {F : DyadicErasureFamily .torus3}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    {t0 : ℝ}
    (upper_tail : TailVanishingWitnessDyadic F E U t0) :
    DecisiveSpineUpperFluxHypothesesDyadic F U t0 ∧
    TendsToZeroNat upper_tail.integratedDefect := by
  exact ⟨scaleFluxDyadic_tail_vanishes upper_tail,
    integratedDefect_tail_vanishes_dyadic upper_tail⟩

/-- Identity-family compatibility for decisive upper hypotheses. -/
theorem decisiveSpineUpperFluxHypotheses_iff_dyadic_identity
    (U : VelocityTrajectory .torus3)
    (t0 : ℝ) :
    DecisiveSpineUpperFluxHypotheses U t0 ↔
      DecisiveSpineUpperFluxHypothesesDyadic periodicCanonicalDyadicErasureFamily U t0 :=
  Iff.rfl

/-- Theorem interface for required upper-route limit exchanges. -/
theorem decisiveSpine_upper_limit_exchanges
    (limsup_exchange_valid : Prop)
    (integral_exchange_valid : Prop)
    (series_exchange_valid : Prop)
    (limsup_exchange_holds : limsup_exchange_valid)
    (integral_exchange_holds : integral_exchange_valid)
    (series_exchange_holds : series_exchange_valid) :
    limsup_exchange_valid ∧ integral_exchange_valid ∧ series_exchange_valid := by
  exact ⟨limsup_exchange_holds, integral_exchange_holds, series_exchange_holds⟩

/-- Upper-mechanism policy marker for decisive spine. -/
def DecisiveSpineUpperMechanismPolicy : Prop :=
  ∀ {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    {t0 : ℝ},
      (upper_tail : TailVanishingWitness E U t0) →
        DecisiveSpineUpperFluxHypotheses U t0

/-- Dyadic upper-mechanism policy marker for decisive spine. -/
def DecisiveSpineUpperMechanismPolicyDyadic : Prop :=
  ∀ {F : DyadicErasureFamily .torus3}
    {U : VelocityTrajectory .torus3}
    {E : DefectEnvelope .torus3}
    {t0 : ℝ},
      (upper_tail : TailVanishingWitnessDyadic F E U t0) →
        DecisiveSpineUpperFluxHypothesesDyadic F U t0

/-- Upper-mechanism policy theorem for decisive spine. -/
theorem decisiveSpine_upper_mechanism_policy :
    DecisiveSpineUpperMechanismPolicy := by
  intro U E t0 upper_tail
  exact (decisiveSpine_upper_mechanism_quantitative upper_tail).1

/-- Dyadic upper-mechanism policy theorem for decisive spine. -/
theorem decisiveSpine_upper_mechanism_policy_dyadic :
    DecisiveSpineUpperMechanismPolicyDyadic := by
  intro F U E t0 upper_tail
  exact (decisiveSpine_upper_mechanism_quantitative_dyadic upper_tail).1

end Gibbs.ContinuumField.NavierStokes
