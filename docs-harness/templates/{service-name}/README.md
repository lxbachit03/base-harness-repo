# Service E2E Flow Template

This scaffold supports a canonical
docs-harness/domain/<MMDD>-<name>/README.md; it is not domain truth.
Follow docs-harness/domain/README.md for capture, tracing, confirmation, and
freshness, and templates/README.md for identity.

Use one data-flows/<flow-name>/ child per relevant E2E journey:

- apis.md: participating APIs, inputs/context/outputs, behavior and source evidence;
- entities.md: relevant persistence, fields, relationships, and enums;
- prerequisite.md: ordered setup options, isolation, and recovery;
- data-flow.md: the overall E2E diagram first, then a separate diagram for each API.

Schema evidence under schemas/ uses templates/domain-entity.md. Supporting
flow/schema files are linked from the canonical README and do not automatically
receive independent IDs. Keep unrelated detail out of the selected flow.
Configuration names can be documented; secret values must not be copied.
