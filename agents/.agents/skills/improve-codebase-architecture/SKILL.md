---
name: improve-codebase-architecture
description: Scan a codebase for composability violations, present them as a visual HTML report, then grill through whichever one you pick.
disable-model-invocation: true
---

# Improve Codebase Architecture

Surface architectural friction and propose **restructuring opportunities** — refactors that make code more composable and testable. The aim is code that's easy to change, easy to test through its interface, and easy to navigate.

This command is _informed_ by the project's domain model and the composability principles in `/codebase-design`:

- **Single Responsibility (SOLID-S)** — one reason to change, one stakeholder per module
- **Interface Segregation (SOLID-I)** — don't force callers to depend on methods they don't use
- **Dependency Inversion (SOLID-D)** — depend on abstractions, not concretions
- **Composability** — build from independent pieces, assembled at wiring points
- **Testability** — the interface is the test surface
- **YAGNI** — don't abstract until there's a real need



## Process

### 1. Explore

**Scope before you scan — YAGNI.** Focus on parts of the codebase that have recently changed or that the user named. Decide *where* to look before you look:

- If the user named a direction — a module, a subsystem, a pain point — take it, and skip the inference below.
- Otherwise, walk back a good stretch of the commit history (`git log --oneline`) to find the codebase's hot spots — the files and areas that keep coming up — and let those paths pull your attention first. If the changes are scattered with no clear hot spot, widen the net.

Then use the Agent tool with `subagent_type=Explore` to walk the codebase. Look for **composability violations**:

- **Hidden dependencies** — modules that reach into `this` from a parent class, use globals, or create their own dependencies internally instead of accepting them.
- **Large interfaces** — modules with more exports than callers import, or more methods than the module's purpose requires.
- **Duplicated logic across paths** — two paths (e.g. CLI and GUI) that manage the same state independently.
- **Shared mutable state** — modules coupled through module-level variables that another module mutates.
- **Horizontal layering** — splitting by technical layer when a change to one feature touches all three.
- **Hard-to-test interfaces** — modules that require heavy mocking or framework setup to test.
- **Mixed concerns** — a directory that mixes unrelated responsibilities (e.g. storage, UI, and config in one folder).

Apply the **testability check**: can you write a test for this module without bringing in its heavy dependencies? If not, the module needs explicit dependencies.

### 2. Present candidates as an HTML report

Write a self-contained HTML file to the OS temp directory so nothing lands in the repo. Resolve the temp dir from `$TMPDIR`, falling back to `/tmp` (or `%TEMP%` on Windows), and write to `<tmpdir>/architecture-review-<timestamp>.html` so each run gets a fresh file. Open it for the user — `xdg-open <path>` on Linux, `open <path>` on macOS, `start <path>` on Windows — and tell them the absolute path.

The report uses **Tailwind via CDN** for layout and styling, and **Mermaid via CDN** for diagrams where a graph/flow/sequence reliably communicates the structure. Mix Mermaid with hand-crafted CSS/SVG visuals — use Mermaid when relationships are graph-shaped (call graphs, dependencies, sequences), and hand-built divs/SVG when you want something more editorial (mass diagrams, cross-sections, collapse animations). Each candidate gets a **before/after visualisation**. Be visual.

For each candidate, render a card with:

- **Files** — which files/modules are involved
- **Problem** — why the current architecture is causing friction
- **Solution** — plain English description of what would change
- **Benefits** — how the change improves composability, testability, or interface size
- **Before / After diagram** — side-by-side, custom-drawn, illustrating the change
- **Recommendation strength** — one of `Strong`, `Worth exploring`, `Speculative`, rendered as a badge

End the report with a **Top recommendation** section: which candidate you'd tackle first and why.

See [HTML-REPORT.md](HTML-REPORT.md) for the full HTML scaffold, diagram patterns, and styling guidance.

Do NOT propose interfaces yet. After the file is written, ask the user: "Which of these would you like to explore?"

### 3. Grilling loop

Once the user picks a candidate, run the `/grilling` skill to walk the decision tree with them — constraints, dependencies, the shape of the restructured module, what the interface looks like, what tests survive.

Side effects happen inline as decisions crystallize:

- **Want to explore alternative interfaces?** Run the `/codebase-design` skill and use its design-it-twice parallel sub-agent pattern.
