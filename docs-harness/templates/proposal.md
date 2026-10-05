# Proposal Resource

ID: #<next-sequence>_<RISK|PROPOSAL>_<MMDD>
TAG: [RISK]
PRIORITY: [<CRITIAL|MEDIUM|NORMAL>]
TITLE: <title>
CREATED: <YYYY-MM-DD>
STATUS: <status>
REFERENCES:
- [#<risk-resource-id> <risk-title>](../risks/<MMDD>-<risk-slug>.md)

<!-- Paired with a risk: creation kind RISK, keep TAG: [RISK] and the risk
link. Not paired with a risk: creation kind PROPOSAL, delete the TAG line, the
risk link and the Related Risks section (templates/README.md). Remove this
comment. -->

## Problem

<Describe the problem or opportunity.>

## Context

<Describe relevant repository and domain context.>

## Related Risks

<List the same canonical risk Markdown links as REFERENCES. Every relationship
must be reciprocal and every risk must be listed on both sides.>

## Options

<List viable options and tradeoffs.>

## Recommendation

<State the recommended option and why.>

## Decision

<Record the decision or the User decision still required.>

## Consequences

<Describe expected consequences.>

## Residual Risk

<Record remaining exposure, uncertainty, conditions, and any evidence gap. If
no safe mitigation is known, state that explicitly and record the investigation
or escalation path instead of inventing a solution.>

## Rollback

<Describe recovery or rollback steps.>
