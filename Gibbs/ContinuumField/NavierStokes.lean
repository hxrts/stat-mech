import Gibbs.ContinuumField.NavierStokes.Core
import Gibbs.ContinuumField.NavierStokes.Domain
import Gibbs.ContinuumField.NavierStokes.Equation
import Gibbs.ContinuumField.NavierStokes.Projector
import Gibbs.ContinuumField.NavierStokes.SolutionNotions
import Gibbs.ContinuumField.NavierStokes.LocalTheory
import Gibbs.ContinuumField.NavierStokes.Erasure.Operators
import Gibbs.ContinuumField.NavierStokes.Erasure.ExactIdentities
import Gibbs.ContinuumField.NavierStokes.Erasure.EnergyFlux
import Gibbs.ContinuumField.NavierStokes.Defect.Envelope
import Gibbs.ContinuumField.NavierStokes.Defect.Estimates
import Gibbs.ContinuumField.NavierStokes.Defect.Continuation
import Gibbs.ContinuumField.NavierStokes.Global.ClosureAttempt
import Gibbs.ContinuumField.NavierStokes.Global.NoBlowup
import Gibbs.ContinuumField.NavierStokes.Blowup.Extraction
import Gibbs.ContinuumField.NavierStokes.Blowup.Compactness
import Gibbs.ContinuumField.NavierStokes.Blowup.Rigidity

/-!
# Navier-Stokes facade

Single entry point for the Navier-Stokes program in the continuum-field layer.
This facade re-exports the core interface, domain setup, solution notions,
erasure/defect machinery, and global/blow-up strategy scaffolding.
-/
