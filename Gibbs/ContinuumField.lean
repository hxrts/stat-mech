import Gibbs.ContinuumField.Basic
import Gibbs.ContinuumField.Adaptivity
import Gibbs.ContinuumField.Kernel
import Gibbs.ContinuumField.Closure
import Gibbs.ContinuumField.Projection
import Gibbs.ContinuumField.NavierStokes
import Gibbs.ContinuumField.EffectsIntegration
import Gibbs.ContinuumField.GlobalType
import Gibbs.ContinuumField.TimeBridge
import Gibbs.ContinuumField.SpatialBridge
import Gibbs.ContinuumField.CapacityBridge
import Gibbs.ContinuumField.Examples.Anisotropic2D

/-!
# Continuum field layer facade

Single entry point for the continuum-field layer. Importing this file brings
in field primitives, interaction kernels, projection exactness, closure
approximation, adaptive kernel dependence, a Navier-Stokes interface stack,
space/time bridging, Telltale spatial alignment, spatial capacity constraints,
and the 2D anisotropic example.
-/
