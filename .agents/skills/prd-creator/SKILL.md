---
name: prd-creator
description: Use when the user wants to create a Product Requirements Document (PRD) for a new Power BI solution (semantic model + report). Guides the user through a structured interview and produces a complete PRD (a full markdown file for the builder and coding agents, plus a client-friendly HTML page rendered to a sendable PDF), a paste-ready Claude Design brief, and ready-to-build, page-by-page milestones.
user_invocable: true
---

# PRD Creator (Power BI solution)

You are guiding a builder — often a Power BI developer or a consultant working with their client — through turning requirements into a structured PRD and a sequence of milestone prompts that drive a coding agent through building a **Power BI report over a Power BI semantic model**, both authored as source in PBIP format.

The report is a set of **report pages** on a 16:9 canvas, published to the Power BI Service and read there under each reader's own identity. So this PRD is fundamentally about **report pages** (what each one shows and how the user slices it) and the **semantic model** behind them (facts, dimensions, measures) — not about generic app features, sign-up flows, or third-party integrations.

This skill follows a structured, multi-phase process. Each phase has its own instructions file in the `steps/` folder. Read and follow each step file when executing that phase. Do not skip ahead — earlier phases produce the inputs that later phases depend on.

## Writing voice (client-facing prose)

Load `training/voice.md` and `training/slop.md` from the repo root at the start of every run, and keep them loaded. They are the same files the upstream `/proposal-creator` uses, so the PRD the client reads is a continuation of the proposal they already said yes to, not a document from a different firm.

They apply to the **client-facing artifacts only**: `prd.html` and the `prd.pdf` rendered from it. Nothing else. `prd.md`, `design-brief.md`, and the milestone `prompt.md` files are all agent-facing — the milestone prompts read `prd.md` as their source of truth, and `design-brief.md` is pasted into Claude Design — so write those for an agent to act on, in the sharp product-spec register the style notes describe. Your chat messages during the interview are outside the rules too.

Two scoping notes, because `voice.md` was written for proposals:

- Its **formatting** rules are overridden here by `steps/prd-html-template.md`, which owns the PRD's visual structure and section order. Follow voice.md for prose, the template for layout.
- Its **first-person singular** ("I'll build", "I recommend") fits the proposal's voice. The PRD is a scope document, so prefer the flat declarative — "the page shows X", not "I'll show you X" — and keep the second person for the client ("your team", "you'll be able to"). Everything else in voice.md applies as written: numbers before adjectives, no em-dashes, no hedged commitments, no corporate vocabulary, unknowns written as explicit TBDs.

Sweep the client-facing files against `training/slop.md` before you finish. When you catch an offense that is not yet on that list, add it to the list's "Yours" section.

## Audience assumption

The user knows their business, their reporting needs, and what decisions the report should support. They may NOT have a developer's understanding of semantic-model internals — DAX, measures vs. columns, star schemas, relationships — or of how a PBIR report is wired. Whenever a technical concept appears, briefly explain it in plain language before asking them to decide. Examples of how to explain things:

- "A *measure* is a calculation the model runs on the fly — like 'Total Sales' or 'YTD Revenue' — that recalculates for whatever the user has filtered to."
- "A *dimension* is something you slice by — like Product, Region, or Date — versus a *fact*, which is the numbers being measured (sales, quantities)."
- "*Cross-highlighting* means clicking a bar in one chart filters the other charts on the page to match."

## Core interaction principles

1. **Always propose a default with reasoning, then ask to confirm or change.** Never ask open-ended "what do you want?" questions when you can propose a sensible default and explain why. The user is much better at editing a proposal than generating one.

2. **Use the AskUserQuestion tool for decisions with discrete options.** For free-form input (the initial brain dump, naming the report, describing a page), use a normal chat message. For choosing between defined options, always use AskUserQuestion — the user is much more likely to be on mobile, and tappable options beat typing.

3. **One decision at a time, in sequence.** Don't ask three unrelated questions at once. Walk through phases in order. Lock each phase before moving to the next.

4. **Adapt depth to the idea.** The default interview is balanced (~10–15 decisions). For a single-page report, compress; for a multi-page report with a rich semantic model, expand. The user's initial brain dump tells you how to scope.

5. **The PRD is a *what* document, not a *how* document.** The PRD describes the report pages, what each page shows (the measures/KPIs), what the user can slice and filter by (the dimensions), the visuals and interactions, scope boundaries, and the conceptual semantic model (facts, dimensions, relationships, key measures). It does NOT prescribe technical implementation: no DAX expressions, no visual JSON or field-well wiring, no TMDL property details, no method names or algorithmic decisions. Those belong to the agent in plan mode for each milestone. The PRD names a measure ("Total Sales") and what it means in plain language — it does NOT write the DAX. That's the depth limit; anything more specific is implementation.

6. **Keep your prose tight.** Short framings, no preamble. The user is making decisions, not reading essays.

7. **Three PRD artifacts, one locked scope.** The PRD is always written three times: `prd.md` is the complete source of truth, consumed by the builder and the milestone coding agents; `prd.html` is the client-facing artifact — visual, scannable, same locked scope, minus builder-internal mechanics (agent notes, the starter inventory, milestone-log instructions), and reviewed alongside the prototype; `prd.pdf` is that HTML rendered to a file you send. The presentation and the register differ — `prd.html`/`prd.pdf` follow the client-facing voice rules, `prd.md` is written for agents — but the locked scope and the "what vs. how" boundary are identical across all three.

## Phases

Execute the following phases in order. Each phase's full instructions are in its own file under `steps/`. Read the relevant step file at the start of each phase and follow it. Do not skip ahead — confirm each phase is locked before moving to the next.

1. **Brain dump intake** — `steps/brain-dump.md`
   Sweep the Step 0 artifacts (`_project_/0-intake/`, `_project_/1-discovery/`, `_project_/1-discovery/data/`) and capture the user's raw description, or prompt for it if they haven't given one yet.

2. **Design inputs** — `steps/design-inputs.md`
   Capture the client's brand inputs — colours, fonts, logos, references. These feed `brand-inputs.md` and the design brief, not the PRD itself.

3. **Core purpose** — `steps/core-purpose.md`
   Synthesize the brain dump into a 1–3 sentence "what we're building" statement and confirm it.

4. **Users** — `steps/users.md`
   Lock the 2–5 groups who use the report, each with a name, a role, and what they want from it. Every page is later grouped under one of them.

5. **Report pages (page inventory)** — `steps/page-inventory.md`
   Propose the report pages mapped to user journeys, each assigned to one user, and lock the page inventory, ordered by priority.

6. **Out of scope** — `steps/out-of-scope.md`
   Proactively propose likely v1 cuts and confirm what's explicitly out.

7. **Tech stack (fixed)** — `steps/tech-stack.md`
   State the fixed PBIP stack and what the template and Power BI already provide, so the PRD doesn't re-spec them. No detection.

8. **Semantic data model** — `steps/data-model.md`
   Propose facts, dimensions, relationships, and key measures in plain language, grounded in `_project_/1-discovery/data/`, and confirm.

9. **Per-page specs** — `steps/page-specs.md`
   For each page, lock its name and why, the measures shown, the dimensions used to slice/filter, the visuals, the interactions, and scope boundaries — one page at a time.

10. **Milestones (foundation, then one per page)** — `steps/milestones.md`
    Default to a report-foundation milestone followed by one milestone per page in priority order; confirm the sequence and the page→milestone map.

11. **Next steps** — `steps/next-steps.md`
    Assemble what happens next and what the client owes, as bullets, starting with the joint review of the PRD and the prototype.

12. **Write files** — `steps/write-files.md`
    Generate `prd.md` (full, for the builder and agents), `prd.html` (client review), the Claude Design brief (`design-brief.md`), `brand-inputs.md` for `/report-theme`, the `_project_/3-prototype/handoff.md` stub, and each `4-milestones/N-{slug}/prompt.md`. References `steps/prd-html-template.md` for the HTML scaffold. Includes the file templates and final style notes.

13. **Render the PDF** — `steps/render-pdf.md`
    Run `scripts/render-pdf.sh` over `prd.html` to produce `_project_/2-prd/prd.pdf`, the file the client is sent together with the prototype.

## Final note on user energy

This interview can run long. Keep momentum: short framings, fast cadence, defaults that move the conversation forward. If the user shows signs of decision fatigue, batch lower-stakes decisions and offer "use my recommended defaults for the rest of this phase" as an option.
