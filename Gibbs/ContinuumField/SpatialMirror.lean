import Gibbs.Session
import Protocol.Spatial

/-! # Spatial model bridge

`Gibbs.ContinuumField` now aliases Telltale's canonical `Protocol.Spatial`
definitions directly. This removes local drift and keeps Gibbs aligned with the
current spatial API (`SpatialReq`, `Topology`, `Satisfies`, and boolean
reflection).
-/

namespace Gibbs.ContinuumField

open scoped Classical

/-- Site alias from Telltale `Protocol.Spatial`. -/
abbrev Site := _root_.Site

/-- Role-name alias from Telltale `Protocol.Spatial`. -/
abbrev RoleName := _root_.RoleName

/-- Spatial requirements alias from Telltale `Protocol.Spatial`. -/
abbrev SpatialReq := _root_.SpatialReq

/-- Site-capability alias from Telltale `Protocol.Spatial`. -/
abbrev SiteCapabilities := _root_.SiteCapabilities

/-- Topology alias from Telltale `Protocol.Spatial`. -/
abbrev Topology := _root_.Topology

/-- Satisfaction judgment alias from Telltale `Protocol.Spatial`. -/
abbrev Satisfies (topo : Topology) : SpatialReq → Prop :=
  _root_.Satisfies topo

/-- Boolean satisfaction alias from Telltale `Protocol.Spatial`. -/
abbrev satisfiesBool (topo : Topology) : SpatialReq → Bool :=
  _root_.satisfiesBool topo

/-- Boolean satisfaction reflects propositional satisfaction. -/
theorem satisfiesBool_iff_Satisfies (topo : Topology) (req : SpatialReq) :
    satisfiesBool topo req = true ↔ Satisfies topo req := by
  simpa [satisfiesBool, Satisfies] using _root_.satisfiesBool_iff_Satisfies topo req

end Gibbs.ContinuumField
