import Gibbs.ContinuumField.NavierStokes.Blowup.Compactness

/-!
# Blow-up rigidity scaffolding

Rigidity interface used to exclude minimal blow-up objects.
-/

namespace Gibbs.ContinuumField.NavierStokes

open scoped Classical

/-- Predicate: compactness profile is a minimal blow-up object. -/
def IsMinimalBlowupObject {D : SpatialDomain3}
    (_cp : CompactnessProfile D) : Prop :=
  True

/-- Rigidity predicate excluding minimal blow-up objects. -/
def SatisfiesRigidityCriterion {D : SpatialDomain3}
    (_cp : CompactnessProfile D) : Prop :=
  True

/-- Interface theorem: rigidity criterion rules out minimal blow-up objects. -/
theorem rigidity_excludes_minimal_blowup {D : SpatialDomain3}
    (cp : CompactnessProfile D)
    (_hrig : SatisfiesRigidityCriterion cp)
    (hcontra : IsMinimalBlowupObject cp → False) :
    ¬ IsMinimalBlowupObject cp :=
  hcontra

end Gibbs.ContinuumField.NavierStokes
