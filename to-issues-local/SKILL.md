---
name: to-issues-local
description: Break a plan/spec/PRD into independently-grabbable local work items (Markdown files) using tracer-bullet vertical slices (no GitHub). Use when user wants actionable slices they can execute solo.
---

# To Issues (Local)

Break a plan into independently-grabbable local work items using vertical slices (tracer bullets).

## Process

### 1. Gather context

Work from whatever is already in the conversation context.
If the user passes an existing local work item path (like `docs/prd/...`), read it and use it as the source.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code.

### 3. Draft vertical slices

Break the plan into **tracer bullet** issues. Each issue is a thin vertical slice that cuts through ALL integration layers end-to-end, NOT a horizontal slice of one layer.

Slices may be 'HITL' or 'AFK'. HITL slices require human interaction, such as an architectural decision or a design review. AFK slices can be implemented and merged without human interaction. Prefer AFK over HITL where possible.

<vertical-slice-rules>
- Each slice delivers a narrow but COMPLETE path through every layer (schema, API, UI, tests)
- A completed slice is demoable or verifiable on its own
- Prefer many thin slices over few thick ones
</vertical-slice-rules>

### 4. Quiz the user

Present the proposed breakdown as a numbered list. For each slice, show:

- **Title**: short descriptive name
- **Type**: HITL / AFK
- **Blocked by**: which other slices (if any) must complete first
- **User stories covered**: which user stories this addresses (if the source material has them)

Ask the user:

- Does the granularity feel right? (too coarse / too fine)
- Are the dependency relationships correct?
- Should any slices be merged or split further?
- Are the correct slices marked as HITL and AFK?

Iterate until the user approves the breakdown.

### 5. Create the local work items

For each approved slice, create a Markdown file under `docs/issues/` using the template below.

Create work items in dependency order (blockers first) so you can reference real file paths in the "Blocked by" field.

<issue-template>
## Parent

Path to the parent PRD/work item (if any), e.g. `docs/prd/YYYYMMDD-some-feature.md`

## What to build

A concise description of this vertical slice. Describe the end-to-end behavior, not layer-by-layer implementation.

## Acceptance criteria

- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Blocked by

- Blocked by `docs/issues/<file>.md` (if any)

Or "None - can start immediately" if no blockers.

</issue-template>

Do NOT delete or rewrite the parent PRD; only link to it.
