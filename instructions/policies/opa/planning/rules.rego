package agile.governance.planning.rules

import rego.v1

# Regla PLAN-01
# METADATA
# title: Scope Creep Detection
# description: Alerta si el documento genera más de 15 historias, arriesgando un enfoque Waterfall.
scope_creep := {
    "rule_id": "PLAN-01-SCOPE-CREEP",
    "level": "WARNING",
    "action": "PAUSE_WORKFLOW",
    "next_state": "PENDING_HUMAN_APPROVAL",
    "target": "Agile_Coach_Dashboard",
    "message": "Document exceeds 15 stories. Risk of 'Water-Scrum-Fall'. Epic promotion recommended."
} if input.telemetry.total_stories_identified > 15

# Regla PLAN-02
# METADATA
# title: High Document Noise
# description: Detecta secciones no funcionales sin mapear que requieren revisión del PO.
high_noise := {
    "rule_id": "PLAN-02-HIGH-NOISE",
    "level": "INFO",
    "action": "PAUSE_WORKFLOW",
    "next_state": "PENDING_HUMAN_APPROVAL",
    "target": "Product_Owner_UI",
    "message": "High amount of non-functional text detected. Review extracted snippets carefully."
} if input.telemetry.unmapped_sections_count >= 3

# Regla PLAN-03 (Clean Pass)
# METADATA
# title: Clean Pass Auto-Approval
# description: Si no requiere revisión humana ni hay alertas, avanza automáticamente.
clean_pass := {
    "rule_id": "PLAN-03-CLEAN-PASS",
    "level": "INFO",
    "action": "AUTO_APPROVE",
    "next_state": "INITIATE_MAP_REDUCE"
} if {
    input.telemetry.human_review_required == false
    not scope_creep
    not high_noise
}
