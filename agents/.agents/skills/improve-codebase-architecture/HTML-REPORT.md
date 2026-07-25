# HTML Report Format

The architectural review is rendered as a single self-contained HTML file in the OS temp directory. Tailwind and Mermaid both come from CDNs. Mermaid handles graph-shaped diagrams reliably; hand-built divs and inline SVG handle the more editorial visuals (mass diagrams, cross-sections). Mix the two — don't lean on Mermaid for everything, it'll start to look generic.

## Scaffold

```html
<!doctype html>
<html lang="en">
  <head>
    <meta charset="utf-8" />
    <title>Architecture review — {{repo name}}</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <script type="module">
      import mermaid from "https://cdn.jsdelivr.net/npm/mermaid@11/dist/mermaid.esm.min.mjs";
      mermaid.initialize({ startOnLoad: true, theme: "neutral", securityLevel: "loose" });
    </script>
    <style>
      .seam { stroke-dasharray: 4 4; }
      .leak { stroke: #dc2626; }
    </style>
  </head>
  <body class="bg-stone-50 text-slate-900 font-sans">
    <main class="max-w-5xl mx-auto px-6 py-12 space-y-12">
      <header>...</header>
      <section id="candidates" class="space-y-10">...</section>
      <section id="top-recommendation">...</section>
    </main>
  </body>
</html>
```

## Header

Repo name, date, and a compact legend: solid box = module, dashed line = interface, red arrow = leakage. No introduction paragraph — straight into the candidates.

## Candidate card

The diagrams carry the weight. Prose is sparse and plain.

Each candidate is one `<article>`:

- **Title** — short, names the structural issue (e.g. "Hidden dependencies in the plugin mixin chain").
- **Badge row** — recommendation strength (`Strong` = emerald, `Worth exploring` = amber, `Speculative` = slate), plus a tag for the kind of violation (`hidden deps`, `large interface`, `duplicated logic`, `shared mutable state`, `mixed concerns`).
- **Files** — monospaced list, `font-mono text-sm`.
- **Before / After diagram** — the centrepiece. Two columns, side by side. See patterns below.
- **Problem** — one sentence. What hurts.
- **Solution** — one sentence. What changes.
- **Wins** — bullets, ≤6 words each. e.g. "Each piece testable in isolation", "Duplicated logic consolidated".

No paragraphs of explanation. If the diagram needs a paragraph to be understood, redraw the diagram.

## Diagram patterns

Pick the pattern that fits the candidate. Mix them. Don't make every diagram look the same — variety is part of the point.

### Mermaid graph (the workhorse for dependencies / call flow)

Use a Mermaid `flowchart` or `graph` when the point is "X calls Y calls Z, and look at the mess." Wrap it in a Tailwind-styled card so it doesn't feel parachuted in. Style with classDef to colour leakage edges red and highlight the composable module.

```html
<div class="rounded-lg border border-slate-200 bg-white p-4">
  <pre class="mermaid">
    flowchart LR
      A[OrderHandler] --> B[OrderValidator]
      B --> C[OrderRepo]
      C -.leak.-> D[PricingClient]
      classDef leak stroke:#dc2626,stroke-width:2px;
      class C,D leak
  </pre>
</div>
```

### Hand-built boxes-and-arrows (when Mermaid's layout fights you)

Modules as `<div>`s with borders and labels. Arrows as inline SVG `<line>` or `<path>` elements positioned absolutely over a relative container. Reach for this when you want the "after" diagram to show independent composable pieces with explicit wiring.

### Cross-section (good for layered concerns)

Stack horizontal bands (`h-12 border-l-4`) to show layers a call passes through. Before: feature change touches 3 layers (views, platform, engine). After: 1 thick band labelled with the feature module.

### Composition diagram (good for "before: everything coupled, after: independent pieces")

Before: one big box with many internal connections. After: several smaller boxes with clear arrows showing explicit dependency flow (injected, not inherited).

## Style guidance

- Lean editorial, not corporate-dashboard. Generous whitespace.
- Colour sparingly: one accent (emerald or indigo) plus red for leakage/coupling and amber for warnings.
- Keep diagrams ~320px tall so before/after sits comfortably side by side without scrolling.
- Use `text-xs uppercase tracking-wider` for module labels inside diagrams.
- The only scripts are the Tailwind CDN and the Mermaid ESM import. The report is otherwise static — no app code, no interactivity beyond Mermaid's own rendering.

## Top recommendation section

One larger card. Candidate name, one sentence on why, anchor link to its card. That's it.

## Tone

Plain English, concise. Write clear, direct sentences.

**Good phrasings:**

- "Inheritance chain hides dependencies — every method reaches into `this`."
- "CLI and GUI duplicate the same state management logic."
- "This directory mixes store access, config, and UI helpers — organize by domain."
- "12+ exports suggest this module violates Interface Segregation."

**No phrasings to avoid** — just write clear, direct sentences. If a term from the glossary doesn't fit, don't use it.
