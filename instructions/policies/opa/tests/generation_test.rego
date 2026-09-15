package agile.governance.generation_test

import rego.v1
import data.agile.governance.generation

# Test 1: Ready (SAVE_TO_BACKLOG)
test_ready if {
    res := generation.decision with input as {
        "phase": "generation_phase",
        "telemetry": {
            "inferred_elements_count": 2,
            "logical_conflict": false,
            "security_threat_detected": false,
            "acceptance_criteria_count": 2
        }
    }
    res.action == "SAVE_TO_BACKLOG"
    res.next_state == "READY_FOR_DEV"
    count(res.alerts) == 0
}

# Test 2: High Inference (PAUSE)
test_high_inference if {
    res := generation.decision with input as {
        "phase": "generation_phase",
        "telemetry": {
            "inferred_elements_count": 4,
            "logical_conflict": false,
            "security_threat_detected": false,
            "acceptance_criteria_count": 1
        }
    }
    res.action == "PAUSE_WORKFLOW"
    res.next_state == "PENDING_HUMAN_REVIEW"
    count(res.alerts) == 1
    some alert in res.alerts
    alert.rule_id == "GEN-01-HIGH-INFERENCE"
}

# Test 3: Security Threat (ABORT)
test_security_threat if {
    res := generation.decision with input as {
        "phase": "generation_phase",
        "telemetry": {
            "inferred_elements_count": 1,
            "logical_conflict": false,
            "security_threat_detected": true,
            "acceptance_criteria_count": 1
        }
    }
    res.action == "ABORT_WORKFLOW"
    res.next_state == "BLOCKED_SECURITY"
    count(res.alerts) == 1
    some alert in res.alerts
    alert.rule_id == "GEN-02-SECURITY-THREAT"
}

# Test 4: Conflict Priority (Security Threat > High Inference)
test_conflict_priority if {
    res := generation.decision with input as {
        "phase": "generation_phase",
        "telemetry": {
            "inferred_elements_count": 5, # High inference
            "logical_conflict": false,
            "security_threat_detected": true, # And security threat
            "acceptance_criteria_count": 1
        }
    }
    res.action == "ABORT_WORKFLOW"
    res.next_state == "BLOCKED_SECURITY"
    count(res.alerts) == 2 # Both rules trigger alerts, but action is driven by FATAL
}

# Test 5: Missing Acceptance Criteria (AUTO_COMPLETE)
test_missing_acceptance if {
    res := generation.decision with input as {
        "phase": "generation_phase",
        "telemetry": {
            "inferred_elements_count": 0,
            "security_threat_detected": false,
            "acceptance_criteria_count": 0
        }
    }
    res.action == "AUTO_COMPLETE"
    res.next_state == "AI_INFERENCE_IN_PROGRESS"
    count(res.alerts) == 1
    some alert in res.alerts
    alert.rule_id == "GEN-04-MISSING-ACCEPTANCE"
}
