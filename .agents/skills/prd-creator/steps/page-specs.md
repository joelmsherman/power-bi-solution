# Per-page specs

Now go back to each page in the inventory, one at a time, and lock its detailed spec. Focus on **user-facing, analytical decisions only**: what the page shows and what the user can slice and do. Do NOT discuss technical implementation (DAX expressions, PBIR JSON, visual container properties). Those are the agent's job to plan later.

For each page, lock:

1. **Name and why.** The page name the client will see as a tab, and one sentence on the decision or question it serves for the user it belongs to.
2. **Measures / KPIs shown.** The numbers on the page (for example Total Sales, YTD Revenue, Margin %), named in plain language. These should trace back to the key measures from the Semantic data model phase. A KPI is stronger with a comparison (target, prior period, or plan), so ask which one each headline number is judged against.
3. **Slice / filter by (dimensions).** What the user can break the numbers down by or filter on (for example by Region, Product, Date range). Say which slicers sit on the page and which filters apply to every page.
4. **Visuals.** Which visual presents each measure. Draw them from Power BI's core visuals: card / new card, KPI, clustered or stacked bar and column, line, area, line-and-column combo, scatter, donut, table, matrix, slicer, map and decomposition tree. Pair each measure or breakdown with a sensible visual. A custom visual (Deneb, an SVG measure) is an escape hatch, not a default: propose one only when no core visual can show what the page needs, and say why.
5. **Interactions.** Cross-filtering vs. highlighting between visuals, default slicer selections, sort order, drill-down on a hierarchy, drill-through to a detail page, and report-page tooltips.
6. **Out of scope for this page.** Things a more ambitious version would have but v1 won't (extra breakdowns, what-if inputs, secondary axes, a mobile layout, and so on).

An example at the right level of detail, for a "Sales Overview" page:
- In scope:
  - three KPI cards (Total Sales vs. plan, Orders, Avg Order Value)
  - a stacked column of Sales by Month split by Category
  - a bar of Top 10 Products by Sales
  - Region and Date-range slicers
  - clicking a Category highlights the other visuals
  - right-click drill-through to a Product Detail page
- Out of scope: a what-if discount slider, a map visual, a mobile layout.

Several things do NOT belong here: the DAX for "Total Sales", the visual's JSON, field wells and bookmark wiring. The agent decides all of that in plan mode.

Keep a page to the 3-30-300 rule (`reports:pbi-report-design`):
- **3 seconds**: the headline is clear
- **30 seconds**: the main breakdown is read
- **300 seconds**: the detail has been explored

A page that needs more than about eight visuals is usually two pages. Say so.

Move through pages one at a time. Don't batch.
