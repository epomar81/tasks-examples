package agile.governance.generation

import rego.v1
import data.agile.governance.generation.rules
import data.agile.governance.generation.metrics

# Agrupa las alertas activas
alerts contains rules.high_inference if rules.high_inference
alerts contains rules.security_threat if rules.security_threat
alerts contains rules.missing_acceptance if rules.missing_acceptance

# Contrato de decisión de esta política
decision := {
    "policy_id": "POL-GENERATION-PHASE",
    "action": resolved_action,
    "next_state": resolved_next_state,
    "alerts": alerts,
    "metrics": metrics.values
}

# Resolución de acción (FATAL > CRITICAL > AUTO_COMPLETE > SAVE_TO_BACKLOG)
resolved_action := "ABORT_WORKFLOW" if rules.security_threat
else := "PAUSE_WORKFLOW" if rules.high_inference
else := "AUTO_COMPLETE" if rules.missing_acceptance
else := "SAVE_TO_BACKLOG" if rules.ready
else := "PAUSE_WORKFLOW"

# Resolución de next state
resolved_next_state := "BLOCKED_SECURITY" if rules.security_threat
else := "PENDING_HUMAN_REVIEW" if rules.high_inference
else := "AI_INFERENCE_IN_PROGRESS" if rules.missing_acceptance
else := "READY_FOR_DEV" if rules.ready
else := "PENDING_HUMAN_REVIEW"
