package agile.governance.generation.rules

import rego.v1

# Regla GEN-01
# METADATA
# title: High AI Inference
# description: High AI inference detected. Story lacks explicit business rules.
high_inference := {
    "rule_id": "GEN-01-HIGH-INFERENCE",
    "level": "CRITICAL",
    "action": "PAUSE_WORKFLOW",
    "next_state": "PENDING_HUMAN_REVIEW",
    "target": "Product_Owner_UI",
    "message": "High AI inference detected. Story lacks explicit business rules."
} if input.telemetry.inferred_elements_count >= 3

# Regla GEN-02
# METADATA
# title: Security Threat Detected
# description: Destructive or insecure action requested.
security_threat := {
    "rule_id": "GEN-02-SECURITY-THREAT",
    "level": "FATAL",
    "action": "ABORT_WORKFLOW",
    "next_state": "BLOCKED_SECURITY",
    "target": "DevSecOps_Channel",
    "message": "Destructive or insecure action requested."
} if input.telemetry.security_threat_detected == true

# Regla GEN-03 (Ready)
# METADATA
# title: Ready for Dev
# description: Story is clean and ready.
ready := {
    "rule_id": "GEN-03-READY",
    "level": "INFO",
    "action": "SAVE_TO_BACKLOG",
    "next_state": "READY_FOR_DEV"
} if {
    input.telemetry.inferred_elements_count < 3
    input.telemetry.logical_conflict == false
    not security_threat
}
