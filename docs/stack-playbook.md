# Stack playbook

This is the permanent record of what the solution runs on:
- what each component is
- who owns the account
- which identifiers the work needs
- what the per-project setup is

It lives in `docs/` rather than `_project_/` because it outlives the build. `_project_/` is deleted when the report ships, and this file still applies afterwards.

`README.md` covers the one-time local setup. This file covers the accounts, the identifiers and the decisions.

## The stack at a glance

| # | Component | What runs it | Needed by |
|---|---|---|---|
| 01 | The data, the measures and row-level security | A Power BI semantic model, authored as TMDL and published to a workspace | Every project |
| 02 | The report | A PBIR report bound to that model, published to the same workspace | Every project |
| 03 | Model tooling: validate, BPA, deploy, DAX tests | The Tabular Editor CLI (`te`) | Every project |
| 04 | Report tooling: author, validate, BPA, publish | The `pbir` CLI | Every project |
| 05 | Workspace operations | The Fabric CLI (`fab`) | Every project |
| 06 | Upstream source data | Whatever feeds the model, usually SQL Server | Every project |
| 07 | PDF rendering | Puppeteer-cached headless Chrome, local | `/prd-creator` |

There is no separate database, no hosting provider and no build server. The report is read-only against the model and runs in the Power BI Service. Each reader signs in with their own Entra identity, so the Service handles access.

## What the work needs, and where each value comes from

There is no `.env` file here, and there should not be one.

| Value | Looks like | Where it comes from | Where it ends up |
|---|---|---|---|
| Workspace name | `Client Analytics` | You create it, or the client names an existing one | `te deploy --target-server`, `pbir publish`, `fab` paths |
| Workspace ID | a GUID | `fab ls`, or the workspace URL | Your notes; the URL carries it anyway |
| Semantic model ID / report ID | GUIDs | The Service URL after the first deploy | Your notes |
| SQL server and database | `sql.example.com`, `Sales` | The client's data owner | `./setup.sh` writes them into `expressions.tmdl` |
| Development workspace | `Client Analytics [Dev]` | You create it | Where milestones are published for review |

**Credentials never enter this repo.** Workspace, model and report identifiers are fine: they are not secrets. Database passwords, service principal secrets and API keys are not fine. `_project_/README.md` says the same thing, because discovery is where someone is most likely to paste one.

## 01 · The semantic model

**What it is.** A Power BI semantic model, authored as TMDL source under `src/<ProjectName>.SemanticModel/`. It carries the star schema, the relationships, the measures, the format strings and any row-level security roles.

**Who owns it.** The client's tenant, in a workspace where you are a member. Create it in the client's tenant rather than your own. The data is theirs, row-level security has to resolve against their directory, and a model in the wrong tenant has to be migrated; a setting won't fix it.

**Per-project setup.**

1. `./setup.sh "<ProjectName>" "<DatabaseName>" "<ServerName>"` renames the scaffold and writes the connection parameters into `expressions.tmdl`.
2. Build the model against the discovery data samples (step 4), then audit it (step 5): run the `semantic-models:semantic-model` review, then `scripts/validate.sh`.
3. Deploy it (step 6) with `te deploy --model … --target-server "<Workspace>" --target-database "<ModelName>"`. Run it once without `--execute` to see the TMSL, then again with `--execute`. Or publish it through `fab` (the `fabric-cli` skill).
4. Supply the data source credentials in the workspace's semantic model settings, then refresh (the `semantic-models:refresh-semantic-model` skill).
5. Scaffold the DAX regression tests: `te test init --from-model --model src/<ProjectName>.SemanticModel` writes `.te-tests/` (one stub per measure). Run `te test run -s "<Workspace>" -d "<ProjectName>"` after every deploy.

## 02 · The report

**What it is.** A PBIR report under `src/<ProjectName>.Report/`, bound by path to the model in the same project. Every change goes through the `pbir` CLI. Desktop opens the whole thing from `src/<ProjectName>.pbip`.

**Who owns it.** The same workspace as the model. Publish it with `pbir publish "src/<ProjectName>.Report" "<Workspace>/<ReportName>"`, which rebinds it to the published model, or from Desktop. During milestones, publish to the development workspace. Publish to the client's workspace once the milestone is approved.

**Readers need** a Pro or PPU licence, or the workspace on a Fabric/Premium capacity (F64 or above for free viewers). Settle this in discovery. Licensing is how a "finished" report ends up unopenable.

**Previewing on WSL/Linux.** `pbir desktop …` and the Desktop Bridge are Windows-only. Either open `src/<ProjectName>.pbip` in Power BI Desktop on the Windows side (`\\wsl$\…` paths work), or publish to the development workspace and check in the browser.

## 03 · Tabular Editor CLI (`te`)

**What it is.** The cross-platform Tabular Editor CLI. It runs on Linux, WSL, macOS and Windows, and validates, runs BPA, queries, deploys, refreshes and tests the model. It is driven through the `tabular-editor:te-cli` and `semantic-models:semantic-model` skills. It replaces the TabularEditor.exe portable that this template used to download.

**Install.** Download the binary for your platform from the CDN (`https://cdn.tabulareditor.com/files/cli/latest/te-<os>-<arch>.tar.gz`), put it on `PATH`, then run `te auth login`. The `te-cli` skill's `references/get-te-cli.md` has the one-liner.

**It is a preview.** Preview builds expire, so re-download from the CDN when `te` says its build has expired.

## 04 · `pbir` CLI

**What it is.** The PBIR report CLI. It creates, edits, formats, validates, runs BPA on and publishes reports, driven through the `reports:pbir-cli` and `reports:create-pbi-report` skills. Agents never hand-edit PBIR JSON. They log what they learn about `pbir` in `.claude/rules/pbir-cli.md`.

```bash
uv tool install pbir-cli
uv tool upgrade pbir-cli
```

## 05 · Fabric CLI (`fab`)

**What it is.** Workspace discovery, permissions, item operations and refreshes, driven through the `fabric-cli` skill.

```bash
uv tool install ms-fabric-cli
fab auth login
```

A bare `pip install` fails on Ubuntu 24.04 and other PEP 668 "externally managed" Pythons. Use `uv tool` or `pipx`.

**Your access, not a service principal.** Everything in this workflow runs under your own Entra identity, so your workspace role is the ceiling. You need Contributor or Admin on the workspace. If a deploy fails, check the role before debugging the command. To set up CI/CD with a service principal, see `te-cli/references/config-cicd-env.md`.

## 06 · Upstream source data

**What it is.** Whatever feeds the model, usually SQL Server, reached through the parameterised connection in `expressions.tmdl`. All tables are in Import mode, so the model holds a copy and refreshes on a schedule.

**Who owns it.** The client's data team. They own the schedule the source lands on, and that schedule limits how fresh the report can be. Get that number during discovery, and show the data-as-of date on every page. A reader who doesn't know how old the numbers are will assume they are live.

**Credentials.** Credentials go into the workspace's data source settings, or a gateway if the source is on-premises. They never go into this repo.

## 07 · PDF rendering

**What it is.** A puppeteer-cached headless Chrome under `~/.cache/puppeteer/`. `/prd-creator`'s `scripts/render-pdf.sh` uses it to turn `prd.html` into the PDF the client receives.

```bash
npx puppeteer browsers install chrome-headless-shell
```

**If it is missing,** `/prd-creator` still writes `prd.html` and tells you to print it to PDF from a browser.

## When the client takes ownership

1. **Workspace roles.** Move yourself from Admin to whatever the client wants afterwards, or off the workspace entirely. Do this last: once you are out, you cannot deploy a fix.
2. **The repo.** Transfer it, or hand over a copy. Everything the solution needs is in it, since `_project_/` has been deleted.
3. **Data source credentials.** Confirm they belong to a service account, not a person who might leave.
4. **Refresh ownership.** Someone on the client's side must be told when a refresh fails. Name that person before you leave.
5. **Report distribution.** Decide whether readers use the workspace or a Power BI app, and who maintains the app's audience.
