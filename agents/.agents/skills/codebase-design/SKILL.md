---
name: codebase-design
description: Principles for composable, testable code + architecture review workflow. Use when designing or improving code structure, or when scanning a codebase for structural problems.
---

# Codebase Design

Design code that is **composable** — built from independent pieces with clear contracts, assembled at wiring points. Each piece is testable through its interface, and nothing is abstracted before it's needed.

## Principles

### 1. Single Responsibility (SOLID-S)

A module should have one reason to change — it serves a single actor or purpose. When a module accumulates responsibilities, callers that only need one of them are forced to depend on (and re-test when) the others change.

### 2. Interface Segregation (SOLID-I)

Don't force callers to depend on methods they don't use. Split large interfaces into role-specific ones — but only when there's a real caller that needs a subset. A 3-method interface with one caller does not need splitting. Test mocks become simpler, and callers only depend on the contract they actually need.

```typescript
// Instead of one catch-all interface:
interface IStore {
  getCard(id: string): Card;
  upsertCard(card: Card): void;
  getAnalytics(): Analytics;
  updateSettings(s: Settings): void;
  // … 20 more methods
}

// Split by role:
interface ICardReader { getCard(id: string): Card; }
interface ICardWriter { upsertCard(card: Card): void; }
interface IAnalyticsReader { getAnalytics(): Analytics; }
interface ISettingsWriter { updateSettings(s: Settings): void; }
```

### 3. Dependency Inversion (SOLID-D)

Depend on abstractions, not concretions. High-level modules should not depend on low-level modules — both should depend on abstractions.

```typescript
// Instead of depending on a concrete driver directly:
class PaymentProcessor {
  constructor(private db: Database) {}  // ← abstraction
}
```

Only introduce the abstraction when you actually need it — a single concrete implementation with no plan for a second one isn't worth an interface.

### 4. Composability

Build the system from independent pieces (functions, classes, modules) that snap together. Each piece can be tested in isolation, wired together at composition points — function calls, constructors, parameter passing. 

A composable system is split **vertically** (by domain/feature), not **horizontally** (by technical layer). One feature = one directory with everything it needs, sharing only common abstractions (e.g. database client, config) across features.

Signs of poor composability: a feature change touches files in 3+ unrelated directories; two code paths duplicate the same logic; pieces can't be tested without bringing in unrelated dependencies.

### 5. Testability

The interface is the test surface. If you want to test *past* the interface, the module is probably the wrong shape.

- **Accept dependencies, don't create them.**
  ```typescript
  // Testable
  function processOrder(order, paymentGateway) {}
  // Hard to test
  function processOrder(order) {
    const gateway = new StripeGateway();
  }
  ```

- **Return results, don't produce side effects.**
  ```typescript
  // Testable
  function calculateDiscount(cart): Discount {}
  // Hard to test
  function applyDiscount(cart): void {
    cart.total -= discount;
  }
  ```

- **Small surface area.** Fewer methods = fewer tests needed.

### 6. YAGNI (You Aren't Gonna Need It)

Don't abstract before you need to. Apply the other principles only when there's a real problem:

- Don't introduce an abstraction without a second use case. A single implementation isn't worth an interface.
- **No smell** = don't refactor. A module being small isn't a problem.
- **"I might need this later"** is not a reason.

## Anti-patterns

- **Hidden dependencies** — `this.store` from a parent class, globals, ambient context. Dependencies should be visible in the constructor or function signature.
- **Large interfaces** — a single contract with methods that different callers use disjoint subsets of. Split by role only when multiple callers demonstrate the need.
- **Premature abstraction** — interface with one implementation, factory for a single use case.
- **Shared mutable state** — two composable pieces that mutate the same state outside their interface.
- **Inheritance for code reuse** — prefer composition: pass the behaviour as a parameter rather than inheriting from it.
- **Horizontal layering** — splitting by "views / logic / data" instead of by feature. Each feature change touches 3+ directories.

## When to use which principle

| Smell | Apply |
|---|---|
| Module serves multiple unrelated actors | Single Responsibility — split by stakeholder |
| Interface forces callers to depend on unused methods | Interface Segregation |
| Need to test without a heavy dependency | Dependency Inversion + Composability |
| Module exports more than any single caller imports | Composability — reorganize by domain |
| Two paths duplicate the same logic | Composability — extract shared piece |
| Can't tell where a file belongs | Organize by domain, not layer |
| No concrete problem | YAGNI — don't touch |

## Architecture Review

Surface architectural friction and propose **restructuring opportunities**. The aim is code that's easy to change, easy to test through its interface, and easy to navigate.

### 1. Explore

**Scope before you scan — YAGNI.** Focus on parts of the codebase that have recently changed or that the user named. Decide *where* to look before you look:

- If the user named a direction — a module, a subsystem, a pain point — take it, and skip the inference below.
- Otherwise, walk back a good stretch of the commit history (`git log --oneline`) to find the codebase's hot spots — the files and areas that keep coming up — and let those paths pull your attention first. If the changes are scattered with no clear hot spot, widen the net.

Then use the Agent tool to walk the codebase. Look for **composability violations**:

- **Hidden dependencies** — modules that reach into `this` from a parent class, use globals, or create their own dependencies internally instead of accepting them.
- **Large interfaces** — modules with more exports than callers import, or more methods than the module's purpose requires.
- **Duplicated logic across paths** — two paths (e.g. CLI and GUI) that manage the same state independently.
- **Shared mutable state** — modules coupled through module-level variables that another module mutates.
- **Horizontal layering** — splitting by technical layer when a change to one feature touches all three.
- **Hard-to-test interfaces** — modules that require heavy mocking or framework setup to test.
- **Mixed concerns** — a directory that mixes unrelated responsibilities (e.g. storage, UI, and config in one folder).

#### Gate (mandatory — testability + composability)

Before adding a candidate to the report, run it through both dimensions.

**Testability:**

1. **Can you test the module's core behavior without its heaviest dependency?**
   "Core behavior" means what the module *does* — not how it renders or persists. For example: grading logic, scoring algorithm, sync orchestration — not "renders a button" or "writes a file." If the module's purpose *is* rendering or I/O, test the logic behind it, not the side effect.

2. **Can you instantiate the module without the framework?**
   You should be able to write `new Thing()` or `functionUnderTest(args)` without standing up a web framework, a plugin host, a global singleton, or a UI runtime. If you can't, the module has hidden dependencies.

3. **Is there an abstraction boundary that would make testing trivial?**
   If changing one import (e.g. `database` → `IDatabase`) would suddenly let you test the module in isolation — that's a candidate. The abstraction doesn't exist yet; the point is that it *should*.

**Composability:**

4. **Does the same logic exist in two independent places?**
   Two paths (CLI and GUI, import and export, sync and manual) that manage the same state, call the same APIs, or implement the same algorithm independently. They share nothing — each is its own copy.

5. **Does a change to one behavior touch files in 3+ unrelated directories?**
   One feature spread across technical layers (views / engine / core) instead of living in one place. If renaming a field or adding a step to a workflow forces you to edit 3+ files in different directories, the module is split horizontally, not vertically.

6. **Are two modules coupled through shared mutable state outside both?**
   Module-level variables, globals, ambient context that one module sets and another reads — neither owns the state, both depend on it.

Apply the gate:

- **No to #1 or #2, and yes to #3** → Strong testability candidate. Lead with testability.
- **Yes to #4 or #5 or #6** → Strong composability candidate. Lead with composability.
- **Yes to testability questions AND no to composability questions AND no other principle violated** → **drop it**. YAGNI.

When spawning exploration sub-agents, include:

```
For every significant module you report, answer both sets of questions:
Testability:
- Can its core behavior be tested without [the framework/global]?
- If not, what one thing blocks testability? (singleton? concrete class? constructor that creates its own dependencies?)
Composability:
- Does the same logic exist in two independent places?
- Does changing one behavior touch files in 3+ unrelated directories?
Report testability and composability failures first, then structural issues.
```

### 2. Present candidates as an HTML report

**Before writing the report:** re-apply the gate (both testability and composability) to every candidate. Drop any that pass both dimensions AND violate no other principle. Testability and composability drive the report — structural issues are supporting evidence, not the primary lens.

Write a self-contained HTML file to the OS temp directory so nothing lands in the repo. Resolve the temp dir from `$TMPDIR`, falling back to `/tmp` (or `%TEMP%` on Windows), and write to `<tmpdir>/architecture-review-<timestamp>.html`.

The report uses **Tailwind via CDN** for layout and styling, and **Mermaid via CDN** for diagrams. Each candidate gets a **before/after visualisation**. Be visual.

For each candidate, render a card with:

- **Files** — which files/modules are involved
- **Problem** — why the current architecture is causing friction
- **Solution** — plain English description of what would change
- **Benefits** — how the change improves composability, testability, or interface size
- **Before / After diagram** — side-by-side, custom-drawn, illustrating the change
- **Recommendation strength** — one of `Strong`, `Worth exploring`, `Speculative`, rendered as a badge

End the report with a **Top recommendation** section.

See [HTML-REPORT.md](HTML-REPORT.md) for the full scaffold, diagram patterns, and styling guidance.

Do NOT propose interfaces yet. After the file is written, ask the user: "Which of these would you like to explore?"

### 3. Grilling loop

Once the user picks a candidate, run the `/grilling` skill to walk the decision tree with them — constraints, dependencies, the shape of the restructured module, what the interface looks like, what tests survive.

- **Want to explore alternative interfaces?** Use the design-it-twice parallel sub-agent pattern described in [DESIGN-IT-TWICE.md](DESIGN-IT-TWICE.md).
