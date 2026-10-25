# Milestones (foundation, then one per page)

For a Power BI report, milestones follow the **page inventory**, with one fixed step at the front. The semantic model is not a milestone. It is built, audited and deployed in workflow steps 4 to 6, before any milestone starts, because every page reads from it.

Propose the default sequence plus two alternatives, and let the user pick via AskUserQuestion:

- **Default (recommended): foundation, then one milestone per page.** Milestone 1 is the **report foundation**, which builds no analytical page. It covers:
  - creating the report, bound to the local model
  - registering the branded Light and Dark themes and the logo
  - the page size and background
  - the shared header and navigation pattern
  - the report-level filters every page carries

  Milestone 2 is the first page, Milestone 3 the second, and so on.
- **Alternative A: fold the foundation into the first page.** For a one- or two-page report with no navigation, Milestone 1 builds the foundation and the first page together.
- **Alternative B: group small pages.** Combine two closely related, lightweight pages (for example a detail page that exists only as a drill-through target) into a single milestone.

Each milestone must:
- Deliver something that can be **opened and judged against real data**: in Power BI Desktop from the `.pbip`, or published to a development workspace
- Be a self-contained working session for a coding agent
- Build on earlier milestones. Measures added to the model in one milestone are reused later, never redefined

Explain the trade-off in plain language. One page per milestone gives the most checkpoints and the tightest feedback loop. Grouping pages means fewer, larger sessions with more risk per session.

After the user picks, restate the final milestone list, each milestone named for its page with a one-line scope, and confirm. The per-page spec from the previous phase becomes that milestone's detailed scope.

Then write out the page→milestone map: each page names the milestone that builds it, and each milestone names the page (or pages) it builds. For the foundation milestone, which builds no page, list what it builds instead. Confirm the map. It produces the "Built in milestone N" line under each page and the "Page built here" list under each milestone in the client copy, so the two must agree exactly.
