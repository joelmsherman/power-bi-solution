# Power BI Solution Template

A GitHub template for full-lifecycle development of **Power BI semantic models and reports** with Claude Code. It uses the Tabular Editor CLI, the [`pbir` CLI](https://github.com/maxanatsko/pbir.tools), and the [Power BI plugins](https://github.com/data-goblin/power-bi-agentic-development) by [Kurt Buhler](https://github.com/data-goblin) and [Max Anatsko](https://github.com/maxanatsko).

## Introduction

The solution is a **PBIP project**: a TMDL semantic model and a PBIR report, under source control, reviewed and diffed like any other code. Claude Code does the heavy lifting on model authoring, DAX, report layout, themes and deployment, through domain-specific plugin skills and three repo-local skills that run the engagement:

0. **Prepare** the project. Carry the approved proposal and intake material over from the [`project-intake`](https://github.com/joelmsherman/project-intake) repo into `_project_/0-intake/`. Then run discovery meetings with the client's stakeholders and file what they produce in `_project_/1-discovery/`.
1. **Plan** the product with `/prd-creator`. It produces:
   - a full PRD for you and the agents
   - a client-facing PRD as HTML and PDF
   - a design brief for the prototype
   - one build prompt per milestone
2. **Brand** the report themes with `/report-theme`. Two PowerUI themes, Light and Dark, ship in the template. The skill stamps the client's colours and fonts into both before anything is drawn.
3. **Design** the prototype in [Claude Design](https://claude.ai/design) from that brief, as 1280 × 720 Power BI pages in the client's brand, and iterate until the client approves it. The approved mockset is committed and becomes the visual source of truth.
4. **Build, audit and deploy the semantic model.** It is authored through `te`, gated by `scripts/validate.sh`, and given DAX regression tests.
5. **Build the report** milestone by milestone through `pbir`: a report foundation first, then one milestone per page.
6. **Validate, review and publish**, then document.

The development model is **source-first, agent-assisted and gated**. Nothing ships until `scripts/validate.sh` passes. It checks the PBIP structure, then runs `te validate` and `te bpa` on the model and `pbir validate` and `pbir bpa` on the report.

## Requirements

### Claude Code

Install Claude Code per the [official instructions](https://docs.claude.com/en/docs/claude-code/overview).

### Power BI Desktop (Windows)

Used to preview the model and report, and to create the report's definition at milestone 1. Turn on the PBIP preview features: **File** > **Options and settings** > **Options** > **Preview features**, then enable **Power BI Project (.pbip) save option**, **Store semantic model using TMDL format** and **Store reports using enhanced metadata format (PBIR)**.

### Tabular Editor CLI (`te`)

The cross-platform Tabular Editor CLI validates the model, runs BPA, deploys, queries and runs tests. It runs natively on Linux, WSL, macOS and Windows. Download it from the CDN:

```bash
# Linux / WSL x64 (see the te-cli skill's get-te-cli.md for other platforms)
mkdir -p ~/.local/bin
curl -fsSL https://cdn.tabulareditor.com/files/cli/latest/te-linux-x64.tar.gz | tar xz -C ~/.local/bin te
chmod +x ~/.local/bin/te
te --version
te auth login
```

> **`te` is in preview, and preview builds expire.** When `te` says its build has expired, re-run the download above to get the current build.

### `pbir` CLI

```bash
uv tool install pbir-cli
pbir --version
```

**`pbir` publishes builds for Windows and macOS only, not Linux.** On WSL, install it on the **Windows** side (`uv tool install pbir-cli` in PowerShell). Then call it from WSL as `pbir.exe`, which WSL interop puts on `PATH`, and pass Windows paths (`wslpath -w <path>`). `scripts/validate.sh` falls back to `pbir.exe` on its own. Install [`uv`](https://docs.astral.sh/uv/) first if you don't have it.

### Fabric CLI (`fab`)

Used for workspaces, permissions and deployment:

```bash
uv tool install ms-fabric-cli   # or: pipx install ms-fabric-cli
fab auth login
```

A bare `pip install` fails on Ubuntu 24.04 and other PEP 668 "externally managed" Pythons. Use `uv tool` or `pipx`.

### `jq` and Python 3

The pbip plugin's validate-on-save hooks need `jq` (`sudo apt install jq`) and skip silently without it. `scripts/validate.sh` and the `/report-theme` stamp script need Python 3.

### Headless Chrome (for the PRD PDF)

`/prd-creator` renders `_project_/2-prd/prd.pdf` with a puppeteer-cached headless Chrome. If you don't have it, install it once:

```bash
npx puppeteer browsers install chrome-headless-shell
```

Without it, the skill still writes `prd.html` and tells you to print it to PDF from a browser.

### Claude Code plugins

`.claude/settings.json` points to the [`data-goblin/power-bi-agentic-development`](https://github.com/data-goblin/power-bi-agentic-development) marketplace and pre-enables:

| Plugin | What it brings |
|---|---|
| `semantic-models` | Model lifecycle and review, organizing, DAX, Power Query, refresh, lineage, the `semantic-model-auditor` agent |
| `tabular-editor` | The `te` CLI skill, BPA rule authoring, C# scripting |
| `pbip` | Project structure, TMDL and PBIR references, the `pbip-validator` agent, **validate-on-save hooks** for TMDL and PBIR |
| `reports` | `create-pbi-report`, `pbir-cli`, report design, themes, report review |
| `custom-visuals` | Deneb, SVG, Python, R and `.pbiviz` visuals, for when no core visual fits |
| `fabric-cli` | Workspaces, import, deployment, Fabric REST APIs |
| `pbi-desktop` | Live Desktop model via TOM (Windows only) |

Worth adding yourself when you need them:
- **`goblin-mode`**: `/improve-my-agent-setup` audits your Claude Code setup.
- **`paginated-reports`**: print-ready RDL reports.
- **`fabric-admin`**: tenant settings and capacity audits.

On your first `claude` launch in the cloned project, accept the marketplace trust prompt. The plugins install, and auto-update, from there.

### Fabric / Power BI prerequisites

- **Contributor or Admin** on the target workspace, in the client's tenant.
- A plan for readers: Pro or PPU licences, or the workspace on a capacity.
- XMLA read-write enabled on the capacity, if you deploy with `te deploy`.

`docs/stack-playbook.md` has the full picture: what each component is, who owns it, and which identifiers you need.

## Getting Started

1. **Create your repo from this template.** On this repo in GitHub, click **Use this template → Create a new repository**. Use the template button rather than cloning and re-pointing the remote: you get a fresh history and the correct origin from the start.

2. **Clone it and initialize the scaffold.** This step:
   - renames the `{{ProjectName}}` tokens across `src/` and `AGENTS.md`
   - gives the report and model fresh Fabric logical IDs
   - sets the SQL connection parameters

   It runs once and refuses a second run.

```bash
git clone https://github.com/<you>/<your-repo>.git
cd <your-repo>
./setup.sh "ProjectName" "DatabaseName" "ServerName"
```

3. **Launch Claude Code**, and accept the marketplace trust prompt on first run.

```bash
claude
```

`./setup.sh` arguments:
- `ProjectName` (required): letters, digits, `_` and `-` only, because PBIP folder names must match `^[\w-]+$`
- `DatabaseName` (optional, defaults to `ProjectName`): SQL Server database name
- `ServerName` (optional, defaults to `localhost`): SQL Server instance

## Workflow

This repo is phase 2 of the engagement. Phase 1 happened upstream in the [`project-intake`](https://github.com/joelmsherman/project-intake) repo: the client request, the 30-minute intake meeting, and the proposal the client approved.

### 0. Prepare the project

#### 0a. Carry over the intake artifacts

The intake repo's `/proposal-creator` wrote a **Graduation checklist** at the bottom of `proposal/handoff.md`. That checklist is the authority on what travels. Copy those files into `_project_/0-intake/`, names unchanged:

```bash
INTAKE=../<the-intake-repo-for-this-engagement>

cp "$INTAKE"/intake/request.md        _project_/0-intake/
cp "$INTAKE"/intake/transcript.md     _project_/0-intake/
cp "$INTAKE"/proposal/proposal.md     _project_/0-intake/
cp "$INTAKE"/proposal/handoff.md      _project_/0-intake/
cp -r "$INTAKE"/intake/attachments/.  _project_/0-intake/attachments/
```

Skip whatever is missing rather than creating an empty stub: `/prd-creator` asks about a gap, but trusts an empty file. If there was no upstream intake, skip 0a.

#### 0b. Run discovery meetings

Discovery is where you get the detail the PRD needs. `_project_/1-discovery/discovery-questions.md` is a question bank to work from. Cover:
- the decision each page has to support
- the measures they already use, and what "correct" means to the person who checks them
- where the data lives and how often it lands
- who reads the report, and on what licence
- the reports and spreadsheets this replaces (ask for screenshots)
- the client's brand material (colours, fonts, logo files)
- **sample data**: ask for it before the meeting

| Artifact | Where it goes |
|----------|---------------|
| Meeting transcripts | `_project_/1-discovery/NN-{topic}-transcript.md`, numbered in the order held |
| Your notes, open questions | `_project_/1-discovery/` |
| Screenshots, process docs, brand material | `_project_/1-discovery/attachments/` |
| **Source data samples** | **`_project_/1-discovery/data/`**, described in `metadata-template.md` |

Data samples are the one hard requirement: `/prd-creator`'s data-model phase stops without them.

### 1. Plan the product

```
/prd-creator
```

It reads `_project_/0-intake/` and `_project_/1-discovery/` on its own, interviews you, and writes:

| File | What it is |
|---|---|
| `_project_/2-prd/prd.md` | The full PRD, consumed by you and the milestone coding agents |
| `_project_/2-prd/prd.html` | The client-friendly PRD |
| `_project_/2-prd/prd.pdf` | The same document as a PDF. **This is what you send the client, together with the prototype from step 3** |
| `_project_/2-prd/design-brief.md` | A paste-ready brief for Claude Design |
| `_project_/2-prd/brand-inputs.md` | The brand answers, read by `/report-theme` |

It also writes the `_project_/3-prototype/handoff.md` stub, and one `N-{slug}/prompt.md` per milestone in `_project_/4-milestones/`: a report foundation, then one per page.

### 2. Stamp the client's brand into the report themes

```
/report-theme
```

The skill:
1. reads `brand-inputs.md` and confirms the client's colours and fonts
2. derives the accent shades and an eight-colour data palette for each theme
3. checks contrast against WCAG AA
4. stamps the result into `Light.json` and `Dark.json`
5. places the logo files
6. rewrites the brand section of the design brief

Power BI can only render its built-in fonts in the Service, so a custom brand font gets its closest built-in match, and the skill says so.

**This runs before the prototype on purpose.** The client signs off on the prototype, so it has to be in their real brand. What was stamped is recorded in `.report-theme`.

### 3. Design and approve the prototype

Paste `_project_/2-prd/design-brief.md` into [Claude Design](https://claude.ai/design). The brief asks for **one standalone HTML file holding every page**, drawn as 1280 × 720 Power BI pages from core visuals only, with click-through navigation. Send it together with `prd.pdf`, and iterate until the client approves both.

When approved, **commit the file as `_project_/3-prototype/mockset.html`**, and record who approved it and when in `_project_/3-prototype/handoff.md`. If the client revises it later, replace the file, commit, and run **`/reconcile-prototype`**.

### 4. Build the semantic model

Ask Claude to build the model from `prd.md` and `_project_/1-discovery/data/`: facts, dimensions, relationships and the key measures. It works through `semantic-models:semantic-model` and the `te` CLI. Each measure gets a description, a format string and a display folder. Then ask it to run `semantic-models:organize-semantic-model` for display folders, sort-by columns, hiding and descriptions. The naming conventions in `AGENTS.md` win over that skill's defaults.

### 5. Audit the model

Ask Claude for a model review (the review phase of `semantic-models:semantic-model`, or the `semantic-model-auditor` agent), fix what it finds, then run the gate:

```bash
scripts/validate.sh
```

### 6. Deploy the model and add DAX tests

```bash
fab auth login
te deploy --model src/<ProjectName>.SemanticModel --target-server "<Workspace>" --target-database "<ProjectName>"            # dry run
te deploy --model src/<ProjectName>.SemanticModel --target-server "<Workspace>" --target-database "<ProjectName>" --execute
```

Or ask Claude to deploy with the `fabric-cli` skill. Set the data source credentials in the workspace, then refresh (`semantic-models:refresh-semantic-model`). Then scaffold regression tests and add an assertion for every headline measure, using a number the client trusts:

```bash
te test init --from-model --model src/<ProjectName>.SemanticModel   # one stub per measure; keep the ones worth asserting
te test run -s "<Workspace>" -d "<ProjectName>"
```

### 7. Build the report foundation (milestone 1)

Hand Claude `_project_/4-milestones/1-report-foundation/prompt.md` in Plan Mode. The foundation milestone:
- creates the report's definition: open `src/<ProjectName>.pbip` in Desktop and save once
- registers the branded Light and Dark themes through `pbir` and makes Light active
- registers the logo
- sets up the page size, the header and navigation pattern, and the report-level filters

### 8. Build the pages, milestone by milestone

Hand Claude each remaining `prompt.md` in order. The approved mockset is binding: the agent builds what was approved with the theme and Power BI's core visuals, and stops to ask rather than redesign. Every change goes through `pbir`, and each milestone ends with:
- `scripts/validate.sh`
- a check of the render: open the `.pbip` in Desktop, or publish to a development workspace
- a `milestone-log.md`

### 9. Review and publish

Ask Claude for a report review (`reports:review-report`), run `scripts/validate.sh` and `te test run` one last time, then publish:

```bash
pbir publish "src/<ProjectName>.Report" "<Workspace>/<ProjectName>"
```

### 10. Document

Overwrite the template language in this `README.md` with language specific to the solution. Walk the pre-delete checklist at the bottom of `_project_/README.md`, then remove the engagement directory:

```bash
git rm -r _project_
```

## Folder Structure

```
.agents/skills/                # Repo-scope skills (canonical)
  prd-creator/                 # /prd-creator: interview, then PRDs (md, html, pdf), brand inputs, design brief, milestone prompts
  report-theme/                # /report-theme: the client's colours and fonts, stamped into Light.json and Dark.json
  reconcile-prototype/         # /reconcile-prototype: the client revised the approved mockset; work out what that means
.claude/
  settings.json                # Marketplace + plugin configuration
  skills -> ../.agents/skills  # Symlink so Claude Code discovers the canonical skills
  rules/pbir-cli.md            # Running log of pbir learnings
AGENTS.md                      # Conventions, tool order, precedence rules
CLAUDE.md -> AGENTS.md         # Symlink so Claude Code reads them
.report-theme                  # Which brand is stamped, the role map, the contrast results
.te-tests/                     # DAX regression tests (created at step 6)
scripts/validate.sh            # The gate: PBIP structure, te validate + BPA, pbir validate + BPA
setup.sh                       # Initializes the {{ProjectName}} scaffold
src/
  {{ProjectName}}.pbip
  {{ProjectName}}.Report/      # PBIR report, byPath to the model; themes in StaticResources/RegisteredResources/
  {{ProjectName}}.SemanticModel/  # TMDL semantic model
  .bpa/bpa-rules-semanticmodel.json
_project_/                     # The engagement. DELETED once the report ships
  0-intake/  1-discovery/  2-prd/  3-prototype/  4-milestones/
docs/
  stack-playbook.md            # Components, owners, identifiers, per-project setup
training/
  voice.md  slop.md            # Client-facing writing rules (shared with project-intake)
```

## Themes

Two themes ship with the template, authored in [PowerUI](https://powerui.com/): `Light.json` (the default) and `Dark.json`. They live in `src/{{ProjectName}}.Report/StaticResources/RegisteredResources/`.

- **Brand** comes from `/report-theme` at step 2. It swaps every brand literal PowerUI baked into the files, which is why you shouldn't hand-edit a hex code.
- **Registration** happens at milestone 1, through `pbir theme create-template` and `pbir theme apply-template`.
- **Switching** to Dark means applying the other template.
- **Theme audits, style presets and promoting visual formatting into the theme** go through `reports:modifying-theme-json`.
