package agile.governance.planning.metrics

import rego.v1

values := {
    "document_noise_ratio": input.telemetry.unmapped_sections_count,
    "planned_backlog_volume": input.telemetry.total_stories_identified
}
