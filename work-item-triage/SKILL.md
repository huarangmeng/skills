---
name: work-item-triage
description: Triage local work items through a simple state machine stored in docs/ (no GitHub). Use when user wants an inbox, prioritization, or to prepare durable briefs for later implementation.
---

# Local Work Item Triage

Triage work items in the current repo using a small state machine. All artifacts live in `docs/` as Markdown files.

## Reference docs

- [AGENT-BRIEF.md](AGENT-BRIEF.md) — how to write durable implementation briefs
- [OUT-OF-SCOPE.md](OUT-OF-SCOPE.md) — how the `.out-of-scope/` knowledge base works

## Work Item Fields

Each work item should declare:

- **Category:** `bug` or `enhancement`
- **State:** `needs-triage` | `needs-info` | `ready-for-agent` | `ready-for-human` | `wontfix`

Represent these as a short header section near the top of the Markdown file, e.g.:

```md
**Category:** bug
**State:** needs-triage
```

If a work item has conflicting values, flag the conflict and ask which is correct before doing anything else. Provide a recommendation.

## State Machine

| Current State  | Can transition to | Who triggers it        | What happens                                                                                                         |
| -------------- | ----------------- | ---------------------- | -------------------------------------------------------------------------------------------------------------------- |
| `missing`      | `needs-triage`    | Skill (on first look)  | Work item needs evaluation. Skill proposes Category/State, then updates the file.                                    |
| `missing`      | `ready-for-agent` | User (via skill)       | Already well-specified. Skill writes an implementation brief section and updates the state.                          |
| `missing`      | `ready-for-human` | User (via skill)       | Requires human implementation. Skill writes a short handoff note and updates the state.                              |
| `missing`      | `wontfix`         | User (via skill)       | Out of scope. Skill writes to `docs/out-of-scope/` (enhancements only) and updates the state.                        |
| `needs-triage` | `needs-info`      | User (via skill)       | Underspecified. Skill appends triage notes + concrete questions to the work item.                                    |
| `needs-triage` | `ready-for-agent` | User (via skill)       | Grilling complete. Skill writes an implementation brief section and updates the state.                               |
| `needs-triage` | `ready-for-human` | User (via skill)       | Grilling complete. Skill writes a short handoff note and updates the state.                                          |
| `needs-triage` | `wontfix`         | User (via skill)       | Decision not to action. Skill writes `docs/out-of-scope/` for enhancements and updates the state.                    |
| `needs-info`   | `needs-triage`    | User                   | New info arrived (from chat, logs, repro). Skill updates the work item and moves state back for re-evaluation.       |

An issue can only move along these transitions. The maintainer can override any state directly (see Quick State Override below), but the skill should flag if the transition is unusual.

## Invocation

Invoke `/work-item-triage` then describe what you want in natural language. The skill interprets the request and updates local files.

Example requests:

- "Show me anything that needs my attention"
- "Let's look at `docs/issues/20260427-something.md`"
- "Move this work item to ready-for-agent"
- "What's ready for me/agents to pick up?"
- "Are there any work items missing Category/State?"

## Workflow: Show What Needs Attention

When the user asks for an overview, scan `docs/` and present a summary grouped into three buckets:

1. **Missing fields** — work items missing Category and/or State.
2. **`needs-triage`** — needs evaluation.
3. **`needs-info` with new evidence** — items where new repro steps/logs were added since the last triage notes section.

Display counts per group. Within each group, show issues oldest first (longest-waiting gets attention first). For each issue, show: number, title, age, and a one-line summary of the issue body.

Let the user pick which work item to dive into.

## Workflow: Triage a Specific Issue

### Step 1: Gather context

Before presenting anything to the maintainer:

- Read the full work item file: body, Category/State, any appended triage notes
- If there are prior triage notes sections, parse them to understand what has already been established
- Explore the codebase to build context — understand the domain, relevant interfaces, and existing behavior related to the issue
- Read `docs/out-of-scope/*.md` files and check if this issue matches or is similar to a previously rejected concept

### Step 2: Present a recommendation

Tell the maintainer:

- **Category recommendation:** bug or enhancement, with reasoning
- **State recommendation:** where this issue should go, with reasoning
- If it matches a prior out-of-scope rejection, surface that: "This is similar to `.out-of-scope/concept-name.md` — we rejected this before because X. Do you still feel the same way?"
- A brief summary of what you found in the codebase that's relevant

Then wait for the maintainer's direction. They may:

- Agree and ask you to apply labels → do it
- Want to flesh it out → start a /domain-model session
- Override with a different state → apply their choice
- Want to discuss → have a conversation

### Step 3: Bug reproduction (bugs only)

If the issue is categorized as a bug, attempt to reproduce it before starting a /domain-model session. This will vary by codebase, but do your best:

- Read the reporter's reproduction steps (if provided)
- Explore the codebase to understand the relevant code paths
- Try to reproduce the bug: run tests, execute commands, or trace the logic to confirm the reported behavior
- If reproduction succeeds, report what you found to the maintainer — include the specific behavior you observed and where in the code it originates
- If reproduction fails, report that too — the bug may be environment-specific, already fixed, or the report may be inaccurate
- If the report lacks enough detail to attempt reproduction, note that — this is a strong signal the issue should move to `needs-info`

The reproduction attempt informs the /domain-model session and the agent brief. A confirmed reproduction with a known code path makes for a much stronger brief.

### Step 4: /domain-model session (if needed)

If the issue needs to be fleshed out before it's ready for an agent, interview the maintainer to build a complete specification. Use the /domain-model skill.

### Step 5: Apply the outcome

Depending on the outcome:

- **ready-for-agent** — add an "Implementation Brief" section into the work item (see [AGENT-BRIEF.md](AGENT-BRIEF.md)), update State
- **ready-for-human** — add a short handoff section explaining why it needs human implementation, update State
- **needs-info** — append triage notes with progress so far and concrete questions (see Needs Info Output below), update State
- **wontfix (bug)** — record the reason in the work item, update State
- **wontfix (enhancement)** — write to `docs/out-of-scope/`, link it from the work item, update State (see [OUT-OF-SCOPE.md](OUT-OF-SCOPE.md))
- **needs-triage** — update State. Optionally append a short note if there's partial progress to capture.

## Workflow: Quick State Override

When the maintainer explicitly tells you to move an issue to a specific state (e.g. "move #42 to ready-for-agent"), trust their judgment and apply the label directly.

Still show a confirmation of what you're about to do: which labels will be added/removed, and whether you'll post a comment or close the issue. But skip the /domain-model session entirely.

If moving to `ready-for-agent` without a /domain-model session, ask the maintainer if they want to write a brief agent brief comment or skip it.

## Needs Info Output

When moving an issue to `needs-info`, post a comment that captures the interview progress and tells the reporter what's needed:

```markdown
## Triage Notes

**What we've established so far:**

- point 1
- point 2

**What we still need from you (@reporter):**

- question 1
- question 2
```

Include everything resolved during the /domain-model session in "established so far" — this work should not be lost. The questions should be specific and actionable, not vague ("please provide more info").

## Resuming Previous Sessions

When triaging an issue that already has triage notes from a previous session:

1. Read the work item to find prior triage notes
2. Parse what was already established
3. Check if new repro steps/logs answered any outstanding questions
4. Present the user with an updated picture: "Here's where we left off, and here's what's new"
5. Continue the /domain-model session from where it stopped — do not re-ask resolved questions
