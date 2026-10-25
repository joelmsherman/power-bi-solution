# {{ProjectName}} - Power BI Solution

## Project Type

A **Power BI solution** authored as source in PBIP format. There are two layers, both under `src/`:

1. **Semantic model**: TMDL under `{{ProjectName}}.SemanticModel/`. It is built through the Tabular Editor CLI (`te`), gated by `scripts/validate.sh`, and deployed to a Fabric/Power BI workspace.
2. **Report**: PBIR under `{{ProjectName}}.Report/`, bound by path to that model. It is built through the `pbir` CLI and published to the same workspace.

Two PowerUI-authored themes ship in the report, Light (the default) and Dark, with a placeholder brand. `/report-theme` stamps the client's brand over them at step 2.

- `README.md` has the end-to-end workflow.
- `docs/stack-playbook.md` has the stack, the identifiers and who owns each account.
- `_project_/README.md` has the engagement phases.

## Project Structure

```
src/
  {{ProjectName}}.pbip                    # Project manifest; open this in Power BI Desktop
  {{ProjectName}}.SemanticModel/          # TMDL semantic model
    .platform                             # Fabric item identity (logicalId set by setup.sh)
    definition.pbism
    definition/
      database.tmdl
      model.tmdl                          # Model manifest (ref tables, roles, etc.)
      expressions.tmdl                    # Parameterized connections
      relationships.tmdl                  # All model relationships
      tables/                             # One .tmdl file per table
        Calendar.tmdl
  {{ProjectName}}.Report/                 # PBIR report (byPath to the model)
    .platform
    definition.pbir
    StaticResources/RegisteredResources/
      Light.json  Dark.json               # The two themes; brand stamped by /report-theme
  .bpa/bpa-rules-semanticmodel.json       # Model BPA rules (CRLF line endings)
.te-tests/                                # DAX regression tests (te test), created after first deploy
.report-theme                             # Which brand is stamped, the role map, contrast results
_project_/                                # The engagement. Deleted once the report ships
  0-intake/  1-discovery/  2-prd/  3-prototype/  4-milestones/
docs/                                     # Permanent reference: stack playbook, admin notes
training/                                 # Client-facing writing rules (voice.md, slop.md)
scripts/validate.sh                       # The pre-deploy gate: PBIP structure, te, pbir
.agents/skills/                           # Repo-scope skills (canonical; .claude/skills is a symlink)
.claude/rules/pbir-cli.md                 # Running log of pbir learnings
AGENTS.md                                 # This file (canonical; CLAUDE.md is a symlink to it)
```

Keep real content at the `.agents/` and `AGENTS.md` paths. Never create real files at `CLAUDE.md` or `.claude/skills`.

## Semantic Model Conventions

### Naming
- **Tables**: lowercase singular for dimensions (`customer`, `product`), plural for facts (`sales`, `purchases`)
- **Columns**: lowercase with spaces (`customer key`, `order date`, `total amount`)
- **Measures**: Title Case with spaces (`Total Sales`, `YTD Revenue`, `Customer Count`)
- **Keys**: suffix with `key` (`customer key`, `product key`), set `isHidden: true`
- **Parameters**: prefix with `Parameter_` in Title Case (`Parameter_Server`, `Parameter_Database`)
- **TMDL files**: lowercase matching table names (`customer.tmdl`, `sales.tmdl`)

These conventions **override** the Title Case column naming that `semantic-models:organize-semantic-model` proposes in its naming pass. Run that skill for everything else it does: display folders, descriptions, format strings, sort-by, hiding.

### Model Design
- Star schema: denormalized dimensions, normalized facts
- Import mode for all tables
- Parameterized SQL Server connections via `expressions.tmdl`
- Measures defined in their source fact table TMDL files
- Calendar table as the standard date dimension
- Single-direction, one-to-many relationships from dimensions to facts

### Documentation
- Triple-slash comments (`///`) on all tables, columns, and measures with business context
- Inline comments for complex DAX explaining business logic
- Every measure has a description, a format string and a display folder

### TMDL Formatting
- 2 spaces for TMDL properties, 4 spaces for DAX expressions within triple backticks
- Property order: declaration, documentation (///), properties (type, isKey, isHidden, formatString), source/partition last
- One table per `.tmdl` file in `/definition/tables/`

### How model changes are made
Use the tool order from `semantic-models:semantic-model`:

1. **The `te` CLI first.** Pass `--model src/{{ProjectName}}.SemanticModel` on every call. Every mutation is a dry run until `--save`, so run it bare, read the diff, then re-run with `--save`. Format DAX with `te`, not by hand.
2. **Hand-authored TMDL only as a fallback** (the `pbip:tmdl` skill). After any hand edit, run `te validate`. The pbip plugin's hook also validates `.tmdl` on save.
3. Add relationships **before** any measure that uses `RELATED`, or the save fails.
4. Reference columns as `'table'[column]` and measures as a bare `[Measure]`.
5. Gate every batch: `te validate --model … && te bpa run --rules src/.bpa/bpa-rules-semanticmodel.json --fail-on error --model …`, or just `scripts/validate.sh`.
6. Before renaming anything, check what references it: other measures, the report's visuals, and `.te-tests/`. Renames cascade into the report. `reports:pbir-cli`'s `te-cli-tandem` reference has the cross-layer recipe.

## Report Conventions

### How report changes are made
- **Every PBIR change goes through the `pbir` CLI**, per `reports:pbir-cli`. Never hand-edit the report's JSON. Build pages with the `reports:create-pbi-report` workflow, and make design decisions against `reports:pbi-report-design`: the 3-30-300 rule, the layout grid, colour discipline, the closing design gate.
- Run `pbir validate` after every change, and `scripts/validate.sh` before calling a milestone done.
- When `pbir` behaves differently from its docs, add a bullet to `.claude/rules/pbir-cli.md`.
- Page, visual and bookmark folder names must match `^[\w-]+$`, or Power BI silently ignores them.
- Formatting belongs in the theme first. Use visual-level overrides only where the theme cannot express it. Use extension measures for dynamic titles and theme colours (`good`, `bad`) for conditional formatting.

### Themes
- The report ships two themes, `Light.json` (the default) and `Dark.json`, under `{{ProjectName}}.Report/StaticResources/RegisteredResources/`.
- **The brand comes only from `/report-theme`**, which stamps both files and records what it did in `.report-theme`. Never hand-edit a hex code in a theme. The role map in `.report-theme` would go stale, and the next stamp would miss it.
- If `.report-theme` says `status = default (unbranded)`, the cyan in the themes is a placeholder, not a decision. Say so rather than building on it.
- **The template ships the report with only its binding (`definition.pbir`) and the staged themes, and no `definition/` yet.** Milestone 1 (the report foundation) creates it by opening `src/{{ProjectName}}.pbip` in Power BI Desktop and saving once; Desktop writes the default definition. It then registers both themes and makes Light active, replacing the default base theme:
  - `pbir theme create-template --new-template <path>/Light.json --name {{ProjectName}}-light`
  - `pbir theme apply-template "src/{{ProjectName}}.Report" {{ProjectName}}-light -f`
  - Register Dark the same way as `{{ProjectName}}-dark`.

  Do not run `pbir new report` over the existing folder.
- To switch themes, apply the other template. To change the brand, re-run `/report-theme` and then re-apply. Desktop reads custom themes when it opens a file, so close and reopen the `.pbip` to see a theme change.
- Do not author a third theme, or invoke `reports:modifying-theme-json` to generate one, unless the user explicitly asks. Use that skill for theme *audits*, style presets and promoting visual formatting into the theme.

### The approved prototype binds layout
When `_project_/3-prototype/mockset.html` exists, the client signed off on it before development. Its page structure, visual choices, content and states are therefore binding. Build what was approved, with the registered theme and Power BI's core visuals. That theme is where the prototype's colour and type came from anyway.

- If the mockset needs a visual that Power BI does not have natively, or conflicts with the theme, **stop and ask**. Propose a core-visual equivalent first. A `custom-visuals` skill (Deneb, SVG measure) is the fallback, and it needs a reason. Never deviate silently, and never redesign a page you were handed.
- **If the mockset changed after approval, reconcile before you build.** Check `git log -- _project_/3-prototype/mockset.html` against the dates in the milestone logs. If it moved, run `/reconcile-prototype`. Never re-run `/prd-creator` to absorb a prototype change.

**Precedence for anything visual:** the approved prototype > the report theme and `pbi-report-design` > plugin skill defaults > agent defaults.

## Validation before deploy

- **`scripts/validate.sh`** is the gate. It runs, in order:
  1. PBIP structure (the pbip plugin's validator)
  2. `te validate`
  3. `te bpa run` against `src/.bpa/bpa-rules-semanticmodel.json`
  4. `pbir validate`
  5. `pbir bpa run` (pbir's built-in report rules)

  It exits non-zero on a failure. A missing tool counts as a skip, not a pass.
- **Audit the model** after any structural change. Use the review phase of `semantic-models:semantic-model`, or dispatch the `semantic-model-auditor` agent for an independent read.
- **Test the DAX by running it.** After the first deploy, `te test init --from-model --model src/{{ProjectName}}.SemanticModel` scaffolds `.te-tests/`, and `te test run -s "<Workspace>" -d "{{ProjectName}}"` runs it. Add an assertion for every headline measure, using a number the client trusts. Run `te test run` after every deploy.
- **Check the render.** Open the `.pbip` in Desktop, or publish to the development workspace and look. A report that validates can still be squished, truncated or unreadable.

## Platform notes (WSL/Linux)

- `te` runs natively on Linux.
- **`pbir` has no Linux build.** On WSL, install it on Windows (`uv tool install pbir-cli` in PowerShell) and call `pbir.exe` from WSL. Interop puts it on `PATH`. Pass Windows paths (`wslpath -w src/{{ProjectName}}.Report`). `scripts/validate.sh` does this automatically.
- `pbir desktop …` (the Desktop Bridge: reload, screenshot) and `pbi-desktop:connect-pbid` need Windows. On native Linux or macOS, check the render by publishing to the development workspace instead.
- The pbip plugin's validate-on-save hooks need `jq` installed. They skip silently without it.

## Plugin Skills Reference

These come from the `data-goblin/power-bi-agentic-development` marketplace, enabled in `.claude/settings.json`:

| Skill / agent | Use it for |
|---|---|
| `semantic-models:semantic-model` | Model design, build, refresh and **review**. The audit step |
| `semantic-models:organize-semantic-model` | Display folders, descriptions, format strings, sort-by, hiding, perspectives. Keep this file's naming conventions |
| `semantic-models:dax` | DAX authoring and performance |
| `semantic-models:power-query` | Partition M expressions |
| `semantic-models:refresh-semantic-model` | Refresh, schedules, troubleshooting |
| `semantic-models:lineage-analysis` | Downstream report dependencies |
| `semantic-model-auditor` (agent) | Independent model audit |
| `tabular-editor:te-cli` | `te`: validate, BPA, deploy, query, `te test` |
| `tabular-editor:bpa-rules` | Authoring and tuning BPA rules in `src/.bpa/` |
| `pbip:pbip`, `pbip:tmdl`, `pbip:pbir-format` | Project structure, renames, TMDL syntax, PBIR schema reference |
| `pbip-validator` (agent) | Full project validation, including rename leftovers |
| `reports:create-pbi-report` | Building pages from scratch, step by step |
| `reports:pbir-cli` | Every report change |
| `reports:pbi-report-design` | Layout, KPI cards, chart choice, colour, accessibility |
| `reports:modifying-theme-json` | Theme audits, presets, promoting formatting into the theme |
| `reports:review-report` | Report review: design, performance, usage |
| `custom-visuals:*` | Deneb, SVG, Python and R visuals. Use only when no core visual fits |
| `fabric-cli:fabric-cli` | Workspaces, permissions, import, deploy |
| `pbi-desktop:connect-pbid` | Live Desktop model via TOM (Windows only) |

Repo-local skills, in `.agents/skills/` and symlinked from `.claude/skills`:

| Skill | Purpose |
|---|---|
| `/prd-creator` | Runs the interview, then writes the full and client PRDs (md, html, pdf), brand inputs, the Claude Design brief and the milestone prompts |
| `/report-theme` | Stamps the client's colours and fonts into Light.json and Dark.json, then into the design brief |
| `/reconcile-prototype` | Run when the client revises the approved prototype. It works out what changed and what that means for the PRD, the milestones and pages already built |

`/prd-creator` and `/reconcile-prototype` are shared with the sibling `fabric-data-app` and `next-supabase-app` templates, each adapted for its stack. When you edit one here, consider porting the change to the siblings.

## Engagement workflow (steps 0 to 3)

This repo is phase 2 of an engagement. Phase 1 (client request, intake meeting, approved proposal) happens upstream in the `project-intake` repo.

- **Step 0a: carry over.** The intake repo's `proposal/handoff.md` ends in a Graduation checklist naming what travels. Those files land in `_project_/0-intake/` with their names unchanged. Never edit them here; they are the record of what was agreed.
- **Step 0b: discovery.** One or more deep meetings with the client's stakeholders. `_project_/1-discovery/discovery-questions.md` is the question bank. Transcripts go to `_project_/1-discovery/NN-{topic}-transcript.md`. **Source data samples go to `_project_/1-discovery/data/`**, because `/prd-creator`'s semantic-data-model phase hard-stops without them.
- **Step 1: PRD.** `/prd-creator` writes `_project_/2-prd/`, the `3-prototype/handoff.md` stub and the milestone prompts in `4-milestones/`.
- **Step 2: report theme.** `/report-theme` stamps the brand into the themes and the design brief. It runs **before** the prototype so the prototype is drawn in the client's real brand.
- **Step 3: prototype.** Claude Design, from `_project_/2-prd/design-brief.md`: one standalone click-through HTML file of 1280 × 720 Power BI pages. On sign-off it is committed as `_project_/3-prototype/mockset.html`. Milestone agents read that committed file, never a share URL.
- **Steps 4 to 10.** Build the model, audit it, deploy it, build the report foundation, build the pages, then validate, review and publish, then document. See `README.md`.

**Precedence when sources disagree:**
1. The user's message in the session beats everything.
2. Discovery beats the handoff on detail.
3. The approved proposal beats discovery on scope. Anything outside `proposal.md` is a change order, not a PRD detail. Say so rather than absorbing it.

Nothing in `src/` may reference `_project_/`. Permanent material lives in `docs/`, `training/`, `.te-tests/` and `src/`.

## Training material (client-facing writing)

`training/voice.md` and `training/slop.md` govern the client-facing artifacts only: `_project_/2-prd/prd.html` and the `prd.pdf` rendered from it. Everything else is agent-facing.

These two files are **copies of the originals in the `project-intake` repo**. Keep every copy identical; when one changes, port the change to `project-intake` and the sibling templates. The exception is `slop.md`'s "Yours" section, a running list: add an offense the moment you catch it, then port the addition.

## Common tasks

- **Adding a table**: `te add` (or TMDL in `definition/tables/` plus a `ref table` in `model.tmdl`), then its relationships, then `te validate`
- **Adding measures**: in the source fact table, with a `///` description, a format string and a display folder. Add an assertion to `.te-tests/` if it is a headline number
- **Auditing the model**: the `semantic-models:semantic-model` review, then `scripts/validate.sh`
- **Deploying the model**: `te deploy --model src/{{ProjectName}}.SemanticModel --target-server "<Workspace>" --target-database "{{ProjectName}}"`. Run it once as a dry run, then add `--execute`. Afterwards run `te test run`
- **Adding a report page**: follow the milestone prompt; `reports:create-pbi-report` + `pbir`, then `scripts/validate.sh`
- **Switching theme**: `pbir theme apply-template "src/{{ProjectName}}.Report" {{ProjectName}}-dark -f` (or `-light`)
- **Changing the brand**: `/report-theme`, then re-apply the theme templates
- **Publishing the report**: `pbir publish "src/{{ProjectName}}.Report" "<Workspace>/{{ProjectName}}"`, or `fab import` plus a rebind (see `fabric-cli`'s import-download-deploy reference)
