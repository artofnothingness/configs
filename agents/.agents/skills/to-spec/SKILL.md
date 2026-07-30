---
name: to-spec
description: Turn a conversation into a spec and shared-context — no interview, just synthesis
---

# To Spec

Turn the current conversation context and codebase understanding into a spec (PRD) and `shared-context.md`. Do NOT interview the user — just synthesize what you already know.

**Перед началом работы** загрузи навык `shared-context`.

## Process

1. Explore the repo to understand the current state of the codebase, if you haven't already. Use names consistent with the codebase throughout the spec, and don't break existing interfaces.

2. Decide the test surface — what interface will tests hit? Prefer existing interfaces over new ones. Use the highest-level interface possible. The fewer test entry points across the codebase, the better — the ideal number is one.

Check with the user that this matches their expectations.

3. Write `shared-context.md` — capture everything you learned about the codebase during exploration. Use the template from the `shared-context` skill. Save to `.scratch/<feature>/shared-context.md`.

4. Write the spec using the template below, then save it to `.scratch/<feature>/spec.md`.

## Spec Template

### Problem Statement

The problem that the user is facing, from the user's perspective.

### Solution

The solution to the problem, from the user's perspective.

### User Stories

A LONG, numbered list of user stories. Each user story should be in the format of:

1. As an <actor>, I want a <feature>, so that <benefit>
   - **Test:** <how to verify this story works — specific scenario, expected outcome>

Example:
1. As a mobile bank customer, I want to see balance on my accounts, so that I can make better informed decisions about my spending
   - **Test:** open accounts list → balance displayed for each account → matches backend data

This list of user stories should be extremely extensive and cover all aspects of the feature.

### Implementation Decisions

A list of implementation decisions that were made. This can include:
- The modules that will be built/modified
- The interfaces of those modules that will be modified
- Technical clarifications from the developer
- Architectural decisions
- Schema changes
- API contracts
- Specific interactions

Do NOT include specific file paths or code snippets. They may end up being outdated very quickly.

Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it within the relevant decision and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.

### Testing Decisions

A list of testing decisions that were made. Include:
- A description of what makes a good test (only test external behavior, not implementation details)
- Which modules will be tested
- Prior art for the tests (i.e. similar types of tests in the codebase)

### Out of Scope

A description of the things that are out of scope for this spec.

### Further Notes

Any further notes about the feature.
