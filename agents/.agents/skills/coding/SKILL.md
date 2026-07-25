---
name: coding
description: ALWAYS use when writing or editing code. Think Before Coding, Simplicity First, Surgical Changes, Goal-Driven Execution. Ensures minimal, correct, well-reasoned code.
---

# Engineering Principles

## 1. Think Before Coding

- State assumptions explicitly — If uncertain, ask rather than guess
- Present multiple interpretations — Don't pick silently when ambiguity exists
- Push back when warranted — If a simpler approach exists, say so
- Stop when confused — Name what's unclear and ask for clarification

## 2. Simplicity First

- No features beyond what was asked
- No abstractions for single-use code
- No "flexibility" or "configurability" that wasn't requested
- No error handling for impossible scenarios
- If 200 lines could be 50, rewrite it

**The test:** Would a senior engineer say this is overcomplicated? If yes, simplify.

## 3. Surgical Changes

- Don't "improve" adjacent code, comments, or formatting
- Don't refactor things that aren't broken
- Match existing style, even if you'd do it differently
- If you notice unrelated dead code, mention it — don't delete it
- Remove imports/variables/functions that YOUR changes made unused
- Don't remove pre-existing dead code unless asked

**The test:** Every changed line should trace directly to the user's request.

## 4. Goal-Driven Execution

Transform imperative tasks into verifiable goals:

| Instead of... | Transform to... |
|--------------|-----------------|
| "Add validation" | "Write tests for invalid inputs, then make them pass" |
| "Fix the bug" | "Write a test that reproduces it, then make it pass" |
| "Refactor X" | "Ensure tests pass before and after" |

For multi-step tasks: `1. [Step] → verify: [check]`
