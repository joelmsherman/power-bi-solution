# Write files

Once everything is locked, generate the files. **Just write them.** Don't show a draft for approval first — the user already approved each piece during the interview.

## What to write

Always write **all three** PRD artifacts — they serve different audiences from the same locked scope:

- `_project_/2-prd/prd.md` — the **full PRD**, the source of truth. The builder and the milestone coding agents consume this one. Use the markdown template below, complete with the project-files note and milestone-log mechanics.
- `_project_/2-prd/prd.html` — the **client-friendly PRD**, reviewed by the client alongside the prototype. Use the scaffold and section snippets in `steps/prd-html-template.md`. Same locked scope, but omit builder-internal mechanics: the "About these project files" agent note, "Already provided by the Power BI template", milestone-log instructions, and anything else that only matters to the coding agent.
- `_project_/2-prd/prd.pdf` — `prd.html` rendered to PDF. Not written by hand; produced in the next phase (`steps/render-pdf.md`) by running `scripts/render-pdf.sh` over the HTML. This is the artifact the client is sent, together with the prototype.

Also write:

- `_project_/2-prd/design-brief.md` — a paste-ready brief for Claude Design (template below), built from the locked scope plus the **Design inputs** phase. It carries a `report-theme:brand-section` marker pair that `/report-theme` rewrites at step 2, so keep the markers exactly as the template has them.
- `_project_/2-prd/brand-inputs.md` — the brand answers from the **Design inputs** phase, recorded as fields rather than prose (template below). `/report-theme` reads this at step 2 so it confirms the client's colours and fonts instead of asking again.
- `_project_/3-prototype/handoff.md` — an approval stub (template below). The approved `mockset.html` lands beside it at sign-off.
- `_project_/4-milestones/{N}-{slug}/prompt.md` — one per milestone, always markdown; consumed by the coding agent in plan mode, not by the user.

Create this exact structure in the codebase root:

```
_project_/
  2-prd/
    prd.md             # full PRD — builder + coding agents
    prd.html           # client-friendly PRD — reviewed with the prototype
    prd.pdf            # rendered from prd.html — sent to the client with the prototype
    design-brief.md    # paste into Claude Design to generate the prototype
    brand-inputs.md    # the brand answers, for /report-theme at step 2
  3-prototype/
    handoff.md         # stub — who approved the mockset and when
  4-milestones/
    1-{milestone-slug}/
      prompt.md
    2-{milestone-slug}/
      prompt.md
    ...
```

The directories already exist in the template, each holding a `.gitkeep`. Write into them; don't recreate the tree.

`{milestone-slug}` is a short kebab-case name derived from the milestone — usually the page (e.g., `report-foundation`, `sales-overview`, `product-detail`).

`_project_/README.md` already documents what each phase holds and when the whole directory gets deleted, and `AGENTS.md` carries the same contract, so there is no agent-instructions note to append. Don't add one.

After writing, briefly tell the user the files are ready and how to use them, in workflow order. The PRD is **not** sent on its own: its title page says a click-through prototype accompanies it, so it goes to the client together with the prototype for one sign-off.

1. Run **`/report-theme`** (step 2). It confirms the brand from `_project_/2-prd/brand-inputs.md`, stamps the client's colours and fonts into the report's `Light.json` and `Dark.json`, places the logo files, and rewrites the brand section of `design-brief.md` with what it actually stamped.
2. Paste `_project_/2-prd/design-brief.md` into [Claude Design](https://claude.ai/design) and build the prototype (step 3). Because step 2 ran first, the brief names the real palette and the prototype comes back already in the client's brand.
3. Send `_project_/2-prd/prd.pdf` and the prototype to the client together, to be evaluated in tandem. `prd.html` is the same document in a browser if they'd rather scroll; `prd.md` is the full version for you and the coding agents. If the review changes scope, edit `prd.md`, `prd.html` and the affected milestone prompts by hand and re-render the PDF — don't re-run this skill.
4. When the client approves both, save the prototype's single HTML file as `_project_/3-prototype/mockset.html`, **commit it**, and fill in `handoff.md`. The milestone prompts read that committed file, so what gets built is exactly what was signed off. If the client later revises the prototype, replace the file, commit, and run `/reconcile-prototype` — never re-run this skill to absorb the change.
5. Then build the semantic model, audit it, and deploy it (workflow steps 4 to 6 in `README.md`) before handing the agent the milestone-1 `prompt.md`, which builds the report foundation. Mention that after each milestone the agent writes a `milestone-log.md` in that milestone's folder to record what was done.

## File templates

### prd.html structure

See `steps/prd-html-template.md` for the complete scaffold, the section order and the per-section snippets. Read that file in full when generating `prd.html` and follow it closely. Remember the audience: this is the client's copy — same locked scope as `prd.md`, but leave out the agent-facing project-files note, the starter inventory and the milestone-log mechanics.

### prd.md structure

Mirror the structure of a high-quality real PRD. Use these sections in order:

```markdown
# {Report name}

> **About these project files:** Everything in `_project_/` (this PRD, the prototype and the per-milestone folders) is a **temporary documentation and guidance artifact** for the initial build-out of this codebase. These files are not functional — no code, configuration, runtime logic, tests, or deployment process should import, read, reference, or depend on anything in `_project_/`. Once the initial milestones are built and shipped, the entire `_project_/` folder is deleted. Do not treat it as long-living documentation. See `_project_/README.md` for the pre-delete checklist.

## What we're building

{1–3 sentence core purpose, expanded with a paragraph or two of context. End with a sentence noting it's a Power BI report over a Power BI semantic model, both authored as PBIP source, and that the build is a report-foundation milestone followed by one milestone per page.}

---

### Users

{One block per locked user, in the locked order:}

#### {User name, verbatim}

*{Role tag}* — {who they are, how many, how often they open the report}

- {goal}

---

### Report pages

{Grouped by user, in the same order as Users, with the user name repeated verbatim as the heading. Within each group, pages in priority order. One block per page:}

#### {User name}

##### {Page name}

{One-sentence why: the decision or question it serves.}

- **Built in:** milestone {N}

{The full per-page spec (measures, slicers, visuals, interactions, cuts) lives in that milestone below.}

---

### Already provided by the Power BI template

{Bulleted list of what the template and Power BI already give you and that the PRD does not re-spec, from the Tech stack phase: the Calendar dimension, the branded Light and Dark themes, the core visual set, cross-filtering and highlighting, drill-down and drill-through, report-page tooltips, per-column format strings, row-level security through roles, and Service export and subscriptions.}

---

### Out of scope

{Top-level out-of-scope list with brief reasoning for each item. Each bullet is one line.}

---

### Semantic data model

{The conceptual Power BI semantic model behind the pages, as a star schema. Use sub-headings: **Facts** (the numeric tables and what measures they feed), **Dimensions** (the things users slice by, including a Date dimension), **Relationships** (one line each, e.g. "Product (1) → (many) Sales"), and **Key measures** (each headline calculation named with a one-line plain-language meaning). Conceptual only — name the measure ("Total Sales — sum of line-item revenue"), never the DAX.}

---

## Milestone 1 — {Name}

{1–2 sentence framing of what this milestone delivers.}

### What gets built

{The page this milestone delivers, from the per-page spec: the measures/KPIs shown, the visuals presenting them, the dimensions the user can slice/filter by, and the interactions (cross-filtering or highlighting, slicers, drill-through, tooltips). Describe what the user sees and does on the page — not the DAX, the visual JSON, or field-well wiring. For the report-foundation milestone: the themes, logo, page size, the header and navigation pattern, and the report-level filters. The agent figures those out in plan mode.}

### What milestone {N} explicitly does NOT include

{Bulleted list of things a coder might assume should be in this milestone but aren't — drill-through, extra breakdowns, other pages, etc.}

### Done when

{1–2 sentences describing the verification criteria — what the user should see and be able to do on this page when the `.pbip` is opened in Power BI Desktop, or the report is published to the development workspace, against real data.}

---

{Repeat for each milestone}

---

## Next steps

{The locked next-steps bullets, first one always the joint review of the PRD and the prototype.}

---

## Appendix A — {Topic}

{Optional. Only for product-specific material, such as how a headline measure is built up or where the data comes from and when it refreshes, that would distort a standard section. Must match the per-page specs and semantic model above exactly. Omit the heading entirely if there is none.}
```

### 4-milestones/N-{slug}/prompt.md structure

Keep this lean. The prompt.md is a thin trigger file — it does NOT re-summarize what's in the PRD.

```markdown
# Milestone {N} — {Name}

You are entering plan mode to plan and then build milestone {N} of this project.

## Context

- Read `@_project_/2-prd/prd.md` for the full project context, scope, semantic data model, and the per-page spec for this milestone's page.
- Read `@_project_/3-prototype/mockset.html`, the prototype the client approved before development started. Find the screen for this milestone's page and build **what was approved**. Its page structure, visual choices, content and states are binding, and redesigning a page you were handed is not your call. Build it in Power BI with the report's registered theme (`Light.json` by default) and core visuals. Never copy raw colours out of the mockset: they came from the same theme in the first place. If the mockset needs a visual that Power BI does not have natively, or conflicts with the theme, **stop and ask** rather than deciding on your own. If `mockset.html` is missing, ask the user for it before building.
- Check whether the prototype moved after this prompt was written: `git log -- _project_/3-prototype/mockset.html`. If it changed more recently than the milestone logs, stop and tell the user to run `/reconcile-prototype` first. A prompt written against the old screen is not authority to ignore the new one.
- The report is `src/<Project>.Report/`, a report bound by path to `src/<Project>.SemanticModel/`. Make every report change through the `pbir` CLI, following the `reports:create-pbi-report` and `reports:pbir-cli` skills, with the design rules in `reports:pbi-report-design`. Never hand-edit PBIR JSON. Log anything you learn about `pbir` in `.claude/rules/pbir-cli.md`.
- If the page needs a measure the model does not have yet, add it to the model first (the `semantic-models:semantic-model` skill, through the `te` CLI) with its description and format string, and say so in the plan. That is a model change, so it needs `scripts/validate.sh` and a redeploy before the published report can use it.
- {Milestone 1 only:} The template ships `src/<Project>.Report/` with only its binding and the staged themes. Create its definition by opening `src/<Project>.pbip` in Power BI Desktop and saving once; do not run `pbir new report` over the folder. Then register `Light.json` and `Dark.json` from `StaticResources/RegisteredResources/` as theme templates and apply Light, as `AGENTS.md` > Themes describes. Register the logo files `/report-theme` placed there, and set up the page size, the header and navigation pattern, and the report-level filters.
- Read previous milestone folders (`@_project_/4-milestones/1-*/milestone-log.md`, etc.) to reuse the measures, page template and navigation already built. If this is milestone 1, there is no prior milestone to read.

## Your task

1. Plan the implementation for **only** milestone {N} as defined in the PRD. Do not plan or build anything from later milestones.
2. After the user confirms the plan, build only what is in milestone {N}'s scope.
3. Run `scripts/validate.sh` and fix everything it reports. Then verify your work against the "Done when" criteria for milestone {N} in the PRD: either the user opens the `.pbip` in Power BI Desktop, or you publish to the development workspace and check the page renders against real data.
4. When complete, write a `milestone-log.md` in this folder (`_project_/4-milestones/{N}-{slug}/milestone-log.md`). Structure it as follows:
   - **Start with a `## What's new in the report` section at the very top.** This is a short, human-readable, bulleted list of the main user-facing additions in this milestone, written so a non-technical reviewer can see at a glance what to expect now that this milestone is done. Frame each bullet as something the user will now see or be able to do, not as a technical artifact. Keep it short and scannable.
   - Then include the implementation detail sections below for the next milestone's agent to reference:
     - What was built (pages, visuals, measures added to the model, bookmarks, etc.)
     - Any decisions made during implementation that weren't pre-specified in the PRD
     - Anything the next milestone will need to know
     - Any deviations from the PRD and why

Ask me any clarifying questions using AskUserQuestion tool to lock in the implementation plan for this milestone.
```

### design-brief.md structure

A self-contained packet the builder pastes into Claude Design to generate the prototype. It must stand alone, because Claude Design won't see the PRD or this repo. Keep it in the same plain, non-technical voice as the PRD: what each page shows, never how it's built.

```markdown
# Design brief — {Report name}

You are designing a high-fidelity, interactive prototype of a **Power BI report**. Produce **one standalone HTML file holding every page below**, click-through browsable with working page navigation, so the client can open it by double-clicking and browse the whole report themselves.

This prototype will be rebuilt in Power BI, so draw only what Power BI can draw:

- Every page is a **1280 × 720 canvas** (16:9), with no scrolling. A page that will not fit is two pages.
- Use only Power BI's core visuals: card, KPI, bar/column (clustered or stacked), line, area, line-and-column combo, scatter, donut, table, matrix, slicer (dropdown, list, tile or date range), map and decomposition tree. Plain text boxes, shapes, images and buttons are fine.
- Visuals are rectangular tiles on a grid with consistent gaps. The page title and navigation sit in a header band. Slicers sit together, either in the header or in a left rail.
- Show interactions as states you can click into, not as animation: a selected bar with the rest dimmed (highlighting), a drill-through page reached from a right-click on a data point, a report-page tooltip shown on hover.

## What the report is

{The locked core purpose, 1–3 sentences, plus one line of business context.}

<!-- report-theme:brand-section:start -->
## Theme & brand

{The Design inputs captured earlier: brand colours, fonts and logo, reference reports they like or want to avoid, and Light/Dark preference. Mark anything not yet known as **TBD — /report-theme will settle this at step 2**.}

{Leave the markers around this section exactly as they are. `/report-theme` runs before this brief is pasted into Claude Design. It replaces everything between the markers with the palette, data colours and fonts it actually stamped into the report themes, so the prototype comes back in the client's real brand rather than in placeholders.}
<!-- report-theme:brand-section:end -->

## Pages to design

{One subsection per report page, in priority order, including drill-through and tooltip pages. For each, give:
- the page name and the decision or question it serves
- the headline KPIs and measures, and what each is compared against
- the visuals presenting them, from the list above
- what the user can slice and filter by
- the key interactions

Condense this from the per-page specs: enough for a designer to lay out the page, with no DAX and no implementation detail.}

Use plausible placeholder numbers. The prototype is static HTML with no data behind it, and that is expected. What is being approved is structure, not values.

## Out of scope

{The locked out-of-scope list, so the prototype doesn't invent features that were cut.}
```

### brand-inputs.md structure

The **Design inputs** phase collected the client's brand material. Record it as fields rather than prose, because `/report-theme` reads this file at step 2 and uses each value as the default for a confirmation question. Prose gets skimmed; a field that says `TBD` gets asked about. Write every line, even the empty ones.

```markdown
# Brand inputs — {Report name}

Collected during the PRD interview. `/report-theme` reads this at step 2 and
confirms each value before stamping it into the report's Light.json and
Dark.json themes. Anything marked TBD becomes a question there.

| Input | Value |
|---|---|
| Brand (primary) colour | {hex, or `TBD`} |
| Secondary colour | {hex, or `TBD — derive one`} |
| Heading font | {family name, or `TBD`} |
| Body font | {family name, `same as heading`, or `TBD`} |
| Logo files | {where they are, or `none yet`} |
| Light, Dark or both | {which theme leads, and whether the other ships too} |
| Reference reports they like | {names or screenshots, or `none given`} |
| Anything to avoid | {what they reacted badly to, or `nothing noted`} |

## Notes

{Anything that doesn't fit a field: an existing style guide, a brand PDF in
`_project_/0-intake/attachments/`, a colour they insisted on and why.}
```

### 3-prototype/handoff.md structure

An approval stub. The builder fills it in when the client signs off on the prototype, and `/reconcile-prototype` appends to it afterwards. Write it exactly like this:

```markdown
# Prototype handoff

The approved prototype is `mockset.html` in this directory: one standalone
file holding every screen, committed so the milestone agents build against
exactly what was signed off.

| | |
|---|---|
| Approved by | <!-- name and role --> |
| Approved on | <!-- date --> |

## Changes after approval

<!-- One dated line per revision, added by /reconcile-prototype. Git holds
     the old mockset; only this log records that the change was agreed. -->

None yet.
```

## Style notes for the PRD output

**Two registers.** `prd.html` — and so the `prd.pdf` rendered from it — is the only client-facing artifact here, and it is written against `training/voice.md` and `training/slop.md`. Sweep it against the slop list before moving to the render phase. `prd.md`, `design-brief.md`, and the milestone prompts are agent-facing: `prd.md` is what the milestone coding agents read, so it stays in the sharp product-spec register described below, and the voice rules do not apply to it. Same locked scope in both registers, never a different plan.


- Mirror the voice of a sharp product spec: concrete, specific, opinionated. Not "the page should probably show X" but "the page shows X."
- Per-page specs are specific about analytical behavior: the measures shown, what the user can slice by, the visuals, the interactions. They are NOT specific about technical implementation (DAX, visual JSON, field-well wiring) — that's the agent's job in plan mode.
- The "Out of scope" lists are valuable — never skip them, never make them generic.
- The semantic data model is described in plain language (facts, dimensions, relationships, and measures with their meaning), never as DAX or TMDL.
- Refer to the deliverable as "the Power BI report" and the data source as "the Power BI semantic model."
- These style notes apply to all three PRD artifacts. The HTML uses the same locked scope as the markdown — a different presentation (minus the builder-internal mechanics), not a different plan — and the PDF is that HTML rendered, so it inherits both.
