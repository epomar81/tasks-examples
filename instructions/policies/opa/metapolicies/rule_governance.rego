package agile.governance.metapolicies

import rego.v1

# Validación 1: Toda regla que bloquee o pause debe tener target de notificación
violations contains sprintf("Planning Rule %v has action '%v' but lacks a target notification", [rule.rule_id, rule.action]) if {
    some rule in data.agile.governance.planning.rules
    rule.action in ["PAUSE_WORKFLOW", "ABORT_WORKFLOW"]
    not rule.target
}

violations contains sprintf("Generation Rule %v has action '%v' but lacks a target notification", [rule.rule_id, rule.action]) if {
    some rule in data.agile.governance.generation.rules
    rule.action in ["PAUSE_WORKFLOW", "ABORT_WORKFLOW"]
    not rule.target
}

# Validación 2: Reglas CRITICAL o FATAL deben requerir aprobación de un rol específico (representado por target por ahora)
violations contains sprintf("Generation Rule %v is %v but has no target role assigned", [rule.rule_id, rule.level]) if {
    some rule in data.agile.governance.generation.rules
    rule.level in ["CRITICAL", "FATAL"]
    not rule.target
}
