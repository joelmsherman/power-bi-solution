---
name: reconcile-prototype
description: Run after the client revises an already-approved prototype. Works out what changed in mockset.html, decides what each change means for the PRD, the milestone prompts and screens already built, and records that it was agreed.
user_invocable: true
---

# Reconcile prototype

The client changed the prototype after signing off on it. This happens, usually after building has started.

Replacing `_project_/3-prototype/mockset.html` is not enough on its own. The PRD and the milestone prompts were written **before** the prototype was approved, so a new mockset can leave them stale, and a milestone prompt telling an agent to build the old screen is not authority to ignore the new one. That is what this skill is for.

**Do not re-run `/prd-creator` for this.** It is a linear interview with no update mode: it would redo every phase and overwrite milestone prompts that have already been built against. Edit the affected sections in place.

## Before you start

The new `mockset.html` must be committed. If `git status` shows it dirty or untracked, stop and ask the user to commit it first — the whole method below rests on `git diff` being able to show what moved, which is why the prototype is committed rather than linked.

## 1. Find what moved

```bash
git log --oneline -- _project_/3-prototype/mockset.html
git diff <previous-commit> HEAD -- _project_/3-prototype/mockset.html
```

If `_project_/3-prototype/handoff.md` has entries under "Changes after approval", the last one names the revision you reconciled previously; diff from there rather than from the original approval, or you will re-triage changes that were already handled.

A raw diff of a single-file mockset is long and mostly noise. Read it for **what the screens now do differently**, not for markup churn: a reordered attribute is nothing, a new `<section>` is something. If the diff is too tangled to read, open both versions in the headless Chrome that renders the PRD PDF and compare the screens directly.

List what you found in plain language, one line per change, before triaging anything. Let the user correct the list — they were in the room when it was agreed and you were not.

## 2. Triage each change

Three kinds, and they route differently. Decide the kind first, then act.

| Kind | Looks like | What it touches |
|---|---|---|
| **Visual** | Spacing, ordering, wording, a different visual doing the same job | Nothing in the PRD. The prototype is authoritative for visuals. A page already built gets a rework item |
| **Behavioural** | A new state, an extra breakdown, a changed filter or interaction rule | `_project_/2-prd/prd.md`: the per-page spec, and the semantic data model if a measure or dimension appeared |
| **Scope** | A whole new page or a new measure | Check `_project_/0-intake/proposal.md` **first** |

**On a behavioural change,** edit the affected per-page spec in `prd.md`, and the semantic data model if a measure or dimension appeared. If the change is big enough that the client should re-approve the PRD, re-render `prd.html` and `prd.pdf` (`steps/render-pdf.md` in `/prd-creator` has the command) and say so; if it is small, say that too rather than re-sending a document over a renamed column.

**On this stack a behavioural change can reach further than the report.** A new measure or a new dimension is a semantic-model change: the model edited under `src/<Project>.SemanticModel/` (through `te`, per `semantic-models:semantic-model`), `scripts/validate.sh` re-run over it, and the model redeployed before the published report can use it. If the `te` test suite in `.te-tests/` covers the affected measures, update it too. That is a deploy, not an edit, so call it out as its own item rather than folding it into "update the milestone prompt".

**On a scope change,** check it against the approved `proposal.md` before anything else. If it falls outside what the client agreed to, it is a **change order, not a PRD detail**. Say so plainly, name what is outside and why, and do not absorb it into the milestones because it arrived inside a prototype. Absorbing scope silently is how a fixed-price engagement goes wrong. If the user tells you it has been agreed commercially, proceed and note that in the handoff log.

## 3. Fan out to the milestones

For every change that survived triage, work out which milestone owns the page, then:

- **Not built yet** → edit that milestone's `_project_/4-milestones/N-{slug}/prompt.md` so it builds the new version. This is the cheap case, and most changes should land here.
- **Already built** → add a rework item to `_project_/4-milestones/N-{slug}/milestone-log.md` saying what changed and what needs revisiting. Append it; **never rewrite what the log already says was built.** The log is a record, not a plan.

A milestone is "already built" if its `milestone-log.md` exists. If one exists but the work was never finished, ask rather than guessing.

## 4. Record that it was agreed

Append a dated line to `_project_/3-prototype/handoff.md` under `## Changes after approval`: the date, what changed, and who agreed to it. Git holds every old mockset; only this log records that the change was *agreed* rather than merely made.

If a scope change was called out as a change order, record that here too, including whether it was accepted.

## 5. Report

Short and specific:

- What changed, by kind: visual, behavioural, scope.
- Whether anything reaches the semantic model, and so needs a redeploy before the published report can read it.
- Which PRD sections you edited, and whether the PRD needs re-approving.
- Which milestone prompts you updated, and which built milestones now carry a rework item.
- Anything you flagged as a change order and what the user decided.

If nothing needed changing beyond the visual — which is common — say that in one line rather than manufacturing work.
