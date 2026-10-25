# Tech stack (fixed)

For a Power BI solution the stack is **already determined**, so there is nothing to detect or choose. State it plainly so the user knows it's settled, then move on. Don't offer stack alternatives.

The stack:

- **Semantic model:** a Power BI semantic model authored as TMDL source under `src/<Project>.SemanticModel/`. All tables are in Import mode, with parameterised SQL Server connections. It is deployed to a Fabric or Power BI workspace.
- **Report:** a PBIR report under `src/<Project>.Report/`, bound to that model and authored through the `pbir` CLI. It is published to the same workspace, and readers open it in the Power BI Service under their own identity.

**Then lock what's already provided** so the PRD doesn't re-spec it. The template and Power BI give you all of this out of the box:

- A standard Calendar (date) dimension, marked as the date table
- Two report themes, Light (the default) and Dark, which `/report-theme` brands with the client's colours and fonts at step 2
- The core visual set: cards, KPI, bar/column, line, area, combo, scatter, donut, table, matrix, slicers, maps and the decomposition tree
- Cross-filtering and highlighting between visuals, drill-down on hierarchies, drill-through pages, report-page tooltips and bookmarks
- Format strings set once per column and measure in the model, and applied everywhere the field appears
- Row-level security through model roles, if the data needs it
- Export to Excel and PDF from the Service, and subscriptions, all governed by tenant settings

Briefly confirm with the user that the client has (or will create) a workspace for this, on a capacity or with Pro/PPU licences for the people who will read it. Licensing decides who can open a published report, so it is the one "setup" fact worth recording here. Everything else is fixed.
