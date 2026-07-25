# Design It Twice

When the user wants to explore alternative interfaces for a chosen restructuring candidate, use this parallel sub-agent pattern. Your first idea is unlikely to be the best.

See [RESTRUCTURING.md](RESTRUCTURING.md) for dependency categories used in the brief.

## Process

### 1. Frame the problem space

Before spawning sub-agents, write a user-facing explanation of the problem space for the chosen candidate:

- The constraints any new interface would need to satisfy
- The dependencies it would rely on, and which category they fall into (see [RESTRUCTURING.md](RESTRUCTURING.md))
- A rough illustrative code sketch to ground the constraints — not a proposal, just a way to make the constraints concrete

Show this to the user, then immediately proceed to Step 2. The user reads and thinks while the sub-agents work in parallel.

### 2. Spawn sub-agents

Spawn 3+ sub-agents in parallel using the Agent tool. Each must produce a **radically different** interface for the module.

Prompt each sub-agent with a separate technical brief (file paths, coupling details, dependency category from [RESTRUCTURING.md](RESTRUCTURING.md), what the implementation should hide). The brief is independent of the user-facing problem-space explanation in Step 1. Give each agent a different design constraint:

- Agent 1: "Minimise the interface — aim for 1–3 entry points max. Make the default case trivial."
- Agent 2: "Maximise flexibility — support many use cases and extension."
- Agent 3: "Optimise for composability — fit cleanly into a pipeline of other modules."
- Agent 4 (if applicable): "Design around injected implementations for cross-module dependencies."

Include both [SKILL.md](SKILL.md) principles and the project's naming conventions in the brief so each sub-agent names things consistently.

Each sub-agent outputs:

1. Interface (types, methods, params — plus invariants, ordering, error modes)
2. Usage example showing how callers use it
3. What the implementation hides
4. Dependency strategy
5. Trade-offs — where the design is clean, where it's awkward

### 3. Present and compare

Present designs sequentially so the user can absorb each one, then compare them in prose. Contrast by **composability** (how well the interface fits with other modules), **testability** (can you test it without heavy mocks?), and **interface placement** (is it in the right place?).

After comparing, give your own recommendation: which design you think is strongest and why. If elements from different designs would combine well, propose a hybrid. Be opinionated — the user wants a strong read, not a menu.
