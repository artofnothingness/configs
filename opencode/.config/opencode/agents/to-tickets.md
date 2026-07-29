---
description: Break a plan or spec into tracer-bullet tickets with blocking edges
mode: subagent
permission:
  edit: allow
  bash: deny
  read: allow
  question: allow
  skill: allow
---

# To Tickets

Break a plan, spec, or conversation into a set of **tickets** — tracer-bullet vertical slices, each declaring the tickets that **block** it.

**Перед началом работы** загрузи навык `shared-context`.

## Process

### 1. Gather context

Work from whatever is already in the conversation context. If the user passes a reference (a spec path, an issue number or URL) as an argument, fetch it and read its full body and comments.

**Read `shared-context.md`** (см. навык `shared-context`) — используй codebase map, conventions и shared types при построении структуры файлов. Обнаружил новое — дополни файл и сообщи оркестратору.

### 2. Explore the codebase (optional)

If you have not already explored the codebase, do so to understand the current state of the code. Ticket titles and descriptions should use names consistent with the codebase.

Look for opportunities to prefactor the code to make the implementation easier. "Make the change easy, then make the easy change."

### 3. Map file structure

Before defining tasks, map out which files will be created or modified and what each one is responsible for:
- Each file should have one clear responsibility
- Files that change together should live together
- Prefer smaller, focused files over large ones
- In existing codebases, follow established patterns

### 4. Draft vertical slices

Break the work into **tracer bullet** tickets.

- Each slice cuts a narrow but COMPLETE path through every layer (schema, API, UI, tests) — vertical, NOT a horizontal slice of one layer
- A completed slice is demoable or verifiable on its own
- Each slice is sized to fit in a single fresh context window
- Any prefactoring should be done first
- **Every ticket must include TDD** — write failing test first, pass it, refactor
- **YAGNI ruthlessly** — no features, abstractions, or flexibility beyond what the spec asks

Give each ticket its **blocking edges** — the other tickets that must complete before it can start. A ticket with no blockers can start immediately.

**Wide refactors are the exception to vertical slicing.** A **wide refactor** is one mechanical change — rename a column, retype a shared symbol — whose **blast radius** fans across the whole codebase, so a single edit breaks thousands of call sites at once and no vertical slice can land green. Don't force it into a tracer bullet; sequence it as **expand–contract**. First expand: add the new form beside the old so nothing breaks. Then migrate the call sites over in batches sized by blast radius (per package, per directory), each batch its own ticket blocked by the expand, keeping CI green batch to batch because the old form still exists. Finally contract: delete the old form once no caller remains, in a ticket blocked by every migrate batch. When even the batches can't stay green alone, keep the sequence but let them share an integration branch that all block a final integrate-and-verify ticket — green is promised only there.

### 5. Quiz the user

Present the proposed breakdown as a numbered list. For each ticket, show:
- **Title**: short descriptive name
- **Relevant files**: which files this ticket creates or modifies
- **Blocked by**: which other tickets (if any) must complete first
- **What it delivers**: the end-to-end behaviour this ticket makes work

Ask the user:
- Does the granularity feel right? (too coarse / too fine)
- Are the blocking edges correct — does each ticket only depend on tickets that genuinely gate it?
- Should any tickets be merged or split further?

Iterate until the user approves the breakdown.

### 6. Save tickets

Write one file per ticket under `.scratch/<feature-slug>/tickets/<NN>-<slug>.md`, numbered from `01` in dependency order (blockers first). Use the template below.

Work the **frontier**: any ticket whose blockers are all done. For a purely linear chain that means top to bottom.

## Ticket Template

```
# <NN> — <Ticket title>

**What to build:** the end-to-end behaviour this ticket makes work, from the user's perspective — not a layer-by-layer implementation list.

**Relevant files:** the files/modules this ticket touches — specific enough that the implementer opens the right code from the first turn. List files that will be created, modified, or referenced. This is the map from step 3, sliced per ticket.

**Blocked by:** the numbers/titles of the tickets that gate this one, or "None — can start immediately".

**Status:** ready

- [ ] Acceptance criterion 1
- [ ] Acceptance criterion 2
```

Avoid code snippets — they go stale fast. Exception: if a prototype produced a snippet that encodes a decision more precisely than prose can (state machine, reducer, schema, type shape), inline it and note briefly that it came from a prototype. Trim to the decision-rich parts — not a working demo, just the important bits.
