# Project artifacts (temporary)

> **This whole directory gets deleted.** Once the report is built and documented, `_project_/` is scrapped. Nothing in here may be something the solution needs afterward.

The underscores are the reminder. Everything here exists to get the solution built: the request, the discovery record, the source data samples, the PRD, the approved prototype and the milestone prompts. Once the report ships and the root `README.md` documents it, this directory has served its purpose and goes.

**What that means in practice.** Nothing here is read by the model, the report, a deploy or a test. No themes, no images, no config, no DAX, no fixtures. If you find yourself wanting to reference `_project_/` from `src/`, the thing you want belongs in `src/` instead. The permanent counterparts live elsewhere on purpose:

| Not here | It lives in |
|---|---|
| The report themes (Light, Dark) | `src/<ProjectName>.Report/StaticResources/RegisteredResources/` |
| The client's logo files | The same `RegisteredResources/` folder, placed by `/report-theme` |
| Which brand is stamped | `.report-theme` at the repo root |
| DAX regression tests | `.te-tests/` |
| Writing rules (`voice.md`, `slop.md`) | `training/` |
| The semantic model and the report | `src/<ProjectName>.SemanticModel/`, `src/<ProjectName>.Report/` |
| The stack: accounts, identifiers, per-project setup | `docs/stack-playbook.md` |
| Operational notes, tenant settings, admin briefs | `docs/` |
| What the solution is and how to open and deploy it | `README.md` at the root |

The source data samples are the case people get wrong. They are an **engagement artifact**, not permanent reference: the semantic model under `src/` is the durable codification of that data, so once it exists the samples have done their job. See "Before you delete".

## The phases

In the order they happen.

| Phase | Directory | Produced by |
|---|---|---|
| 0 | `0-intake/` | Upstream, in the `project-intake` repo |
| 1 | `1-discovery/` | You, in meetings with the client |
| 2 | `2-prd/` | `/prd-creator` |
| 3 | `3-prototype/` | Claude Design, committed here after sign-off |
| 4 | `4-milestones/` | `/prd-creator`, then the coding agents |

Phases 0 through 3 are the record of what was agreed. Treat them as append-only once their phase closes. Phase 4 is working material.

The report theme is deliberately absent from this list. `/report-theme` runs between the PRD and the prototype (workflow step 2) and writes into the report's themes and `.report-theme`, not here, because the brand outlives the build.

## 0-intake

Produced **upstream**, before this repo existed, and copied here once at graduation. Nothing here is generated locally, and the originals stay in `project-intake`, which is why deleting these copies later loses nothing.

What travels is named by the **Graduation checklist** at the bottom of the intake repo's `proposal/handoff.md`. That checklist is the authority; this file just names the home.

| File | Written upstream by | Why it travels |
|---|---|---|
| `request.md` | The client, in their own words | The original ask, unfiltered |
| `transcript.md` | The intake meeting record | Business context, pain points, goals |
| `proposal.md` | `/proposal-creator` | The scope, timeline and price the client approved |
| `handoff.md` | `/proposal-creator` | Structured PRD inputs: problem statement, core purpose, users, candidate scope, data sources, design inputs, out of scope, open questions |
| `attachments/` | Whatever the client sent along | Existing docs, prior transcripts, exports |

`handoff.md` matters most. `/prd-creator` reads it during brain dump and uses it as the default for core purpose, scope, design inputs and out of scope, so the interview starts from what was already agreed rather than a blank page.

Copy files in with their names unchanged. If something does not exist upstream (no transcript, say), leave it out rather than creating an empty stub: `/prd-creator` handles a gap by asking, but it will trust an empty file.

**Do not edit anything here.** It is the record of what was agreed. Corrections and additions belong in `1-discovery/`.

If there was no upstream intake, skip this phase and start at discovery.

## 1-discovery

The intake meeting was 30 minutes and deliberately problem space only. It was enough to price the work, not enough to build it. Discovery is where you go deep with the client's stakeholders on what the PRD actually needs: which decisions each page has to support, who looks at what, where the numbers come from, and what "correct" means to the people who will be checking. `discovery-questions.md` is a question bank to work from.

| File | What it is |
|---|---|
| `NN-{topic}-transcript.md` | One per meeting, numbered in the order held (`01-ops-team-transcript.md`, `02-finance-metrics-transcript.md`) |
| `NN-{topic}-notes.md` | Optional. Your own notes when no recording exists or the transcript needs correcting |
| `open-questions.md` | Optional. A running list of what is unresolved, so the PRD interview can close it |
| `attachments/` | Screenshots of the reports they use today, existing dashboards, definition docs, org charts, brand material |
| `data/` | Source data samples, described in `data/metadata-template.md` |
| `discovery-questions.md` | Ships with the template. A question bank for the meetings, not something to fill in |

Number the transcripts. `/prd-creator` reads them in order, and later meetings usually revise earlier ones.

**`data/` is a hard requirement, not a preference.** `/prd-creator`'s semantic-data-model phase stops and asks for the samples if they are missing, because a star schema proposed without real records is guesswork. If a stakeholder emails a CSV during discovery, the CSV goes in `data/` and gets described in the metadata file; the email thread goes in `attachments/` if it explains anything.

One meeting is often enough for a single-page report. Two or three is normal for a multi-page report with several stakeholder groups. Hold them all before running `/prd-creator`; the interview is much shorter when the answers already exist here.

**Credentials and API keys never go in this repo.** Workspace, model and report identifiers are fine; secrets are not.

> Discovery is the one phase whose only copy is here. If the client wants these transcripts as a record, copy them out before deleting `_project_/`. See "Before you delete" below.

## 2-prd

Written by `/prd-creator`, which sweeps `0-intake/` and `1-discovery/` before asking you anything.

| File | Audience |
|---|---|
| `prd.md` | You and the milestone coding agents. The source of truth |
| `prd.html` | The client, for reading in a browser |
| `prd.pdf` | The client. **This is what you send** |
| `design-brief.md` | Paste into Claude Design to generate the prototype |
| `brand-inputs.md` | `/report-theme`. The brand answers the interview collected, so step 2 confirms rather than re-asks |

`prd.html` and `prd.pdf` are written against `training/voice.md` and `training/slop.md`, the same writing rules the upstream proposal used, so what the client reads continues the document they already approved. Everything else stays in a plain spec register.

`design-brief.md` carries a `report-theme:brand-section` marker pair. `/report-theme` rewrites what is between those markers with the palette it actually stamped, so the brief you paste into Claude Design describes the client's real brand rather than the placeholders.

## 3-prototype

Two files.

| Path | What it is |
|---|---|
| `mockset.html` | The approved prototype: **one standalone file holding every page**, click-through browsable, straight from Claude Design |
| `handoff.md` | Who approved it and when, plus a log of anything that changed after |

The design brief tells Claude Design to produce exactly one self-contained file, drawn as 1280 × 720 Power BI pages from core visuals only, so the client can open it by double-clicking and browse the whole report themselves, with working navigation and every key state reachable. That is what makes sign-off meaningful, and it is why there is no per-page bookkeeping here.

The client signs off **before** development, so the mockset is binding for anything visual: page structure, visual choices, content, copy and states. It is committed rather than linked for three reasons:

- **Versioned.** You know exactly what was approved, not whatever the Claude Design project looks like after someone iterated on it later.
- **Exact.** The agent reads real markup rather than a re-render or a screenshot.
- **Offline.** No auth, no connector to be broken on the day you build.

Colour and type still come from the report theme, which is where the mockset got them anyway (`/report-theme` ran at step 2, before the prototype was drawn), so agents build with the registered theme and core visuals rather than copying raw colours out of the mockset. If the mockset needs a visual Power BI does not have natively, or conflicts with the theme, the agent stops and asks. It never deviates silently and never redesigns a page it was handed. See `## Report conventions` in `AGENTS.md`.

The mockset is static HTML with no data in it. Expect differences from real query results, real number formats and real row counts; those are not defects. Structural differences are.

### When the client changes the prototype

This happens, and often after building has started. The PRD and the milestone prompts were written **before** the prototype was approved, so a changed mockset can leave them stale. Reconcile deliberately rather than just dropping the new file in.

Replace `mockset.html`, commit it, then run **`/reconcile-prototype`**, which walks the steps below. Because the mockset is committed, `git diff` shows exactly what moved, which is the whole point of committing it.

Triage every change into one of three kinds, because they route differently:

| Kind of change | Example | What it touches |
|---|---|---|
| **Visual** | Spacing, ordering, wording, a different visual for the same job | Nothing. The prototype is authoritative for visuals, so no PRD edit. Built pages get a rework item |
| **Behavioural** | A new state, an extra field, a changed flow or filter rule | `2-prd/prd.md`: the per-page spec, and the semantic data model if a field appeared. On this stack it can also reach the semantic model, which is a validate and redeploy, not just an edit |
| **Scope** | A whole new page or measure | Check `0-intake/proposal.md` first. If it is outside what was approved, it is a **change order, not a PRD detail**: say so rather than absorbing it |

Then fan the surviving changes out to the milestones:

- **Milestone not built yet** → update its `prompt.md` so it builds the new version.
- **Milestone already built** → add a rework item to its `milestone-log.md` saying what changed and what needs revisiting. Do not silently rewrite history.

Finally, add a dated line to `handoff.md` under "Changes after approval" recording what changed and that it was agreed. Git holds the old mockset; only that log records the agreement.

Do not re-run `/prd-creator` for this. It is a linear interview with no update mode: it would redo every phase and overwrite milestone prompts you have already built against. Edit the affected PRD sections in place instead.

## 4-milestones

One directory per milestone, `N-{slug}/`:

| File | What it is |
|---|---|
| `prompt.md` | The build prompt, written by `/prd-creator`. Points at `2-prd/prd.md` and the prototype page it builds |
| `milestone-log.md` | What was built, what deviated and why, what is left |

Hand each prompt to Claude in Plan Mode, review the plan, approve, run `scripts/validate.sh`, publish to the development workspace for review, then move to the next.

A deviation worth remembering belongs in the codebase, not in a log that gets deleted: put it in a `///` description on the model object, the root `README.md`, or `AGENTS.md`.

## Before you delete

Deleting is the plan, not an accident. Check these first:

- [ ] The root `README.md` documents what the solution is, how to open it and how it is deployed. That is what replaces this directory.
- [ ] Anything a future maintainer needs is in the codebase, `docs/`, `training/` or `AGENTS.md`, not here.
- [ ] **Brand assets are out.** Any logo files the client supplied arrived in `0-intake/attachments/` or `1-discovery/attachments/`, which go with this directory. `/report-theme` should have copied them into the report's `RegisteredResources/` at step 2. Check that it did, and that `.report-theme` names the files, because this is the one deletion that loses a file the report itself needs.
- [ ] `1-discovery/` transcripts are copied out if the client wants them as a record. They exist nowhere else.
- [ ] `1-discovery/data/` samples are no longer needed. The semantic model under `src/` is the durable record of that data's shape; if a source column's meaning is worth keeping, it belongs in a `///` comment on the model, not in a CSV here.
- [ ] `0-intake/` needs no rescue. The originals are upstream in `project-intake`.
- [ ] The final `prd.pdf` has been sent, and is on the client's side of the fence.

Then:

```bash
git rm -r _project_
```
