# Design inputs

Right after the brain dump, capture the client's brand. Two things read what you collect here: **`/report-theme`** at step 2, which stamps the brand into the report's `Light.json` and `Dark.json` themes, and the **design brief** (written in the final phase) that the builder pastes into [Claude Design](https://claude.ai/design) to produce the prototype at step 3.

Because `/report-theme` runs before the prototype, the prototype comes back in the client's real brand and never has to be re-approved over a colour change. That only works if this phase collects enough for step 2 to confirm rather than re-ask.

Explain in one short framing message that these inputs feed the report themes and the design brief, **not** the PRD itself — the PRD stays a scope document; look-and-feel lives in the prototype.

**Look before you ask.** Brand material often arrives in the intake or discovery attachments and nobody remembers it is there. Check `_project_/0-intake/attachments/` and `_project_/1-discovery/attachments/` for a brand PDF, a style guide, a logo pack. If you find one, read it and use it rather than asking the user to retype hex codes.

Then ask about what is still missing (free-form chat, not AskUserQuestion — the answers are open-ended):

- **Brand guidelines** — a doc, a site, a style guide URL, or a PDF you should be looking at?
- **Brand colour** (a 6-digit hex if they have one), and a **secondary colour** if they have one. The secondary leads as the action colour in the dark theme, so it is worth naming; "derive one" is a fine answer.
- **Fonts** — a heading family and a body family, or one family for both. Warn early: the Power BI Service renders only its built-in families (Segoe UI, Arial, Calibri, DIN, Georgia, Tahoma, Trebuchet MS, Verdana and a few more), so a custom brand font gets its closest built-in match in the report.
- **Logo files** — where are they, and are they SVG or high-resolution PNG? A small raster-only logo is worth knowing about now rather than after the prototype is approved.
- Any **reference reports or dashboards** whose look the client likes or wants to avoid.
- Theme preference (Light, Dark, or both shipped with a default) and density (executive-sparse vs. analyst-dense).

Capture whatever the user has — a pasted brand summary, a couple of hex codes, a logo pack, or nothing at all. **Don't block on gaps.** Anything unknown is recorded as `TBD` in `brand-inputs.md`, and `/report-theme` turns each TBD into a question at step 2. That is the designed path, not a failure.

Summarize what you captured in two or three bullets, confirm, and move on to **Core purpose**.
