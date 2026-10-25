# Brain dump intake

The brain dump is the union of two things: what Step 0 already put in the repo, and whatever the user says now. Read the repo **first** — most of the answer is usually already sitting there, and reading it before asking keeps the interview short.

## 1. Sweep the Step 0 artifacts

Read these in order. Every one is optional; a fresh repo may have none of them, and that is fine.

**`_project_/0-intake/`** — carried over from the upstream `project-intake` repo (Step 0a). See `_project_/README.md` for what each file is.

- `handoff.md` is the highest-value file in the repo. Read it in full. It carries a problem statement, a locked core purpose, users and stakeholders, candidate scope, data sources, design inputs, out-of-scope items, and open questions — each one written as a default for a specific later phase of this interview. Treat it as the starting proposal for those phases, not as gospel: it was written before discovery, and discovery may have moved it.
- `proposal.md` is what the client approved and paid for. It is the scope boundary. If something surfaces in this interview that is outside it, say so plainly rather than absorbing it — that is a change order, not a PRD detail.
- `transcript.md` and `request.md` carry the client's own words and the original pain points. Mine them for verbatim phrases; using the client's vocabulary in the PRD is worth more than a cleaner synonym.
- `attachments/` — skim for anything that describes the business or the current reporting.

**`_project_/1-discovery/`** — produced in this repo (Step 0b). See `_project_/README.md`.

- Read the numbered transcripts in order. Later meetings revise earlier ones, and they revise `handoff.md` too. Where discovery and the handoff disagree, **discovery wins on detail** and the proposal still wins on scope.
- Read `open-questions.md` if it exists. Those questions are this interview's agenda — carry them forward and close each one in the phase it belongs to.
- Skim `attachments/` for screenshots of the reports the client uses today. They are the best available evidence of what the report has to replace.

**`_project_/1-discovery/data/`** — source data samples plus a metadata description. Skim them now; they tell you which facts and dimensions actually exist, which grounds the page inventory and the semantic model later. Don't block here if they're missing — the Semantic data model phase has a hard stop for that.

## 2. Report what you found, then fill the gaps

If the sweep found material, give the user a short synthesis — five or six bullets, no more — covering the problem, who it's for, what the proposal locked, and what discovery added or changed. Name any contradiction you found between the handoff and discovery explicitly; don't quietly pick a side. Then ask them to confirm or correct it in free-form chat.

If the sweep found nothing, or the user is working without an upstream intake, ask them to describe in their own words: what business questions the report should answer, who uses it, and what decisions it should support. Free-form text response, no AskUserQuestion needed here.

Either way, the user's message in this session is the tiebreaker. If they say something that contradicts a file, they are right and the file is stale — note it and move on.

Then proceed to the Design inputs phase.
