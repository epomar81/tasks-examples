package agile.governance

import rego.v1
import data.agile.governance.planning
import data.agile.governance.generation

# Despacha según la fase indicada en input.phase
decision := planning.decision if input.phase == "planning_phase"
decision := generation.decision if input.phase == "generation_phase"

# Fallback si llega una fase desconocida
default decision := {
    "action": "ABORT_WORKFLOW",
    "next_state": "INVALID_PHASE",
    "alerts": [{"level": "FATAL", "message": "Unknown workflow phase"}]
}
