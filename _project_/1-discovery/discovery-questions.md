# Discovery meeting questions

A question bank for the discovery meetings (Step 0b). The intake meeting upstream was problem-space only; these go deeper, toward what `/prd-creator` needs: users, pages, measures, data and rollout.

Treat this as a **reference**, not a script. Adapt, reorder and skip based on what `_project_/0-intake/handoff.md` already settled. Ask for sample data *before* the meeting and walk through it during, and ask for the client's brand material (colours, fonts, logo files) now rather than after the PRD.

## Introductions & Roles

Establish who's in the room, who the product is for, and who owns what.

- Who is the executive sponsor for this product, and what outcome are they accountable for?
- Who are the primary users — what's their role, and how technical are they?
- Are there secondary audiences (e.g., leadership viewers, analysts who'll extend the model)?
- Who owns the underlying data systems, and who should we talk to if we hit data questions?
- Who needs to sign off before the product goes live?

## Business Context

Understand the organization and why this product matters now.

- What does your team/organization do, and where does this product fit in your operations?
- What prompted this project now — an incident, a new initiative, a leadership ask, a compliance requirement?
- What's the broader program or roadmap this sits inside, if any?
- Has this been attempted before? If so, what happened?

## Problems & Current State

Surface the pain points and how they're being worked around today.

- What are the top 2–5 problems this product needs to solve?
- How do people get this information today — spreadsheets, emails, another tool, asking around?
- What's the cost of the current situation — time wasted, bad decisions, missed opportunities?
- What have prior attempts looked like, and why didn't they stick?
- What would happen if we did nothing?

## Desired Outcomes

Define what success looks like.

- Six months after launch, what's different for the users of this product?
- What specific decisions should this product enable or accelerate?
- How will you know the product is working — adoption, specific behaviors, downstream metrics?
- Are there any explicit outcomes we should NOT optimize for?

## Key Business Questions & Metrics

Extract the questions the report must answer — these become measures and KPIs.

- What are the top questions users need answered every time they open this report?
- What metrics or KPIs will they want to see, and how are those currently defined?
- For each metric, what's the grain — per transaction, per customer, per day, per region?
- What time horizon matters — today, week-to-date, month-over-month, trailing 12 months, multi-year?
- Are there thresholds, targets, or benchmarks that trigger action?
- Which metrics have contested or inconsistent definitions across teams?

## User Journeys

Walk through how the product will actually be used.

- Walk me through a typical day or week for the primary user — when would they open this report?
- What triggers them to look at it — a meeting, an alert, a question from leadership?
- Once they see the data, what's the next action or decision they make?
- Are there distinct modes of use (e.g., a daily check vs. a monthly deep dive)?
- What filters, slices, or drill-downs matter most in their flow?

## Data Sources

Map the data landscape. Cross-reference answers with the samples in `_project_/1-discovery/data/`.

- Which systems or sources hold the data we need — databases, warehouses, SaaS APIs, flat files?
- For each source: who owns it, how often is it refreshed, and what's the freshness requirement for this product?
- Are there known data quality issues, gaps, or historical discontinuities?
- Any fields that are sensitive, restricted, or require special handling (PII, financial, regulated)?
- Is there a canonical dimension (calendar, customer, product, org unit) we should align to?

## Constraints & Non-Goals

Set the edges of the project.

- What's the target launch date, and is there a hard external deadline behind it?
- Are there budget, licensing, or infrastructure constraints we should know about (Fabric capacity, Premium features, row-level security)?
- What's explicitly **out of scope** for this version?
- Are there existing reports or products this should integrate with, replace, or avoid overlapping?

## Delivery & Rollout

Plan the handoff and adoption.

- Where will the report live — which workspace, app, or portal?
- Who needs access and at what level (viewer, contributor, row-level filtered)?
- Will users need training or documentation, and who will deliver it?
- How will feedback be collected after launch, and who will act on it?
- What's the cadence for updates and enhancements once it's live?
