import StatMech.ContinuumField.Basic
import StatMech.ContinuumField.Adaptivity
import StatMech.ContinuumField.Kernel
import StatMech.ContinuumField.Closure
import StatMech.ContinuumField.Projection
import StatMech.ContinuumField.NavierStokes
import StatMech.ContinuumField.EffectsIntegration
import StatMech.ContinuumField.GlobalType
import StatMech.ContinuumField.TimeBridge
import StatMech.ContinuumField.SpatialBridge
import StatMech.ContinuumField.CapacityBridge
import StatMech.ContinuumField.Examples.Anisotropic2D

/-! # Continuum field layer facade

Single entry point for the continuum-field layer. Importing this file brings
in field primitives, interaction kernels, projection exactness, closure
approximation, adaptive kernel dependence, a Navier-Stokes interface stack,
space/time bridging, Telltale spatial alignment, spatial capacity constraints,
and the 2D anisotropic example.
-/
