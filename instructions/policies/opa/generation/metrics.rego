package agile.governance.generation.metrics

import rego.v1

values := {
    "ai_hallucination_index": input.telemetry.inferred_elements_count
}
