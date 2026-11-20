# Agent Instructions

<!-- HARNESS:BEGIN -->
At every session start, including worker sessions, read
[docs-harness/INDEX.md](docs-harness/INDEX.md) before task work or other
repository documentation. Complete its mandatory session retrieval.
If INDEX cannot be read, report the gap and pause task work.
<!-- HARNESS:END -->

## Repeated User requests

When the User asks for the same action a second time in a session, ask whether
to add it as a rule in this file. After a yes, write the rule with
`improve-harness`; after a no, the question for that action is closed. A
delegated worker reports the repeat to its coordinator instead of asking.

## Length of this file

When this file is longer than 50 lines, ask whether to move its rules into
`docs-harness/project-constraints/`. After a yes, add each rule there as a
constraint and cut this file to the harness block; after a no, the question is
closed.
