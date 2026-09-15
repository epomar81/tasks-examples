package agile.governance.planning

import rego.v1
import data.agile.governance.planning.rules
import data.agile.governance.planning.metrics

# Agrupa las alertas activas
alerts contains rules.scope_creep if rules.scope_creep
alerts contains rules.high_noise if rules.high_noise

# Contrato de decisión de esta política
decision := {
    "policy_id": "POL-PLANNING-PHASE",
    "action": resolved_action,
    "next_state": resolved_next_state,
    "alerts": alerts,
    "metrics": metrics.values
}

resolved_action := "AUTO_APPROVE" if rules.clean_pass
else := "PAUSE_WORKFLOW" if count(alerts) > 0
else := "PAUSE_WORKFLOW"

resolved_next_state := "INITIATE_MAP_REDUCE" if rules.clean_pass
else := "PENDING_HUMAN_APPROVAL" if count(alerts) > 0
else := "PENDING_HUMAN_APPROVAL"
