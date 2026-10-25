---
name: report-theme
description: Stamps the client's brand (colours and fonts) into the Light.json and Dark.json report themes that ship with this template, so the Claude Design prototype and the built report are both in the client's brand. Run at step 2, after the PRD is written and before the prototype is drawn.
user_invocable: true
---

# Report theme

Step 2 of the workflow. Two complete report themes already exist in this template, authored in PowerUI and staged at `src/<Project>.Report/StaticResources/RegisteredResources/`: `Light.json` (the default) and `Dark.json`. They ship with PowerUI's "Metro" cyan as a placeholder brand. Your job is **not** to author a theme. It is to replace the placeholder brand with this client's, and to say so in the design brief so the prototype comes back in that brand rather than in cyan.

That ordering is the whole point of running here. The prototype is drawn at step 3 and the client signs off on it before development. If the brand lands after that, the prototype is in the wrong colours and every page has to be re-approved.

**Why this is not `reports:modifying-theme-json`:** that skill works on a report's *active* theme through `pbir theme …`, and at step 2 there is no report yet. Milestone 1 creates it. This skill edits the two staged theme files directly, as data, with `scripts/stamp-theme.py`. Once the report exists, `pbir theme validate` checks the result, and later theme work such as style presets or promoting visual formatting belongs to `modifying-theme-json`.

## What you touch

| File | What you change |
|---|---|
| `Light.json`, `Dark.json` | Only the brand literals named in the `.report-theme` role map, plus `dataColors`, `name`, and the font families. Always through `scripts/stamp-theme.py` |
| `RegisteredResources/` | The client's logo files, copied out of the intake or discovery attachments |
| `.report-theme` | The provenance record: the picks, the new role map, the date, the contrast results |
| `_project_/2-prd/design-brief.md` | Between `report-theme:brand-section:start` and `:end` |
| `_project_/2-prd/brand-inputs.md` | Only to fill in a value the user settled during this run |

**Never hand-edit the theme files, and never touch the neutrals** (`foreground`, `background`, `backgroundNeutral`, `foregroundNeutral*`, `tableAccent` and their copies in `visualStyles`). PowerUI bakes every colour into `visualStyles` as a literal: Light.json carries `#00adff` 18 times. Editing only the top-level keys leaves a half-branded report that looks right in a card and wrong in a slicer. The script swaps every occurrence in one pass, so a chained swap cannot cascade, and it keeps PowerUI's formatting so the diff shows only what changed.

## Phase 0: read what's already known

Before asking anything:

1. Read `.report-theme`. If `status = branded`, this is a re-run, so go to **Phase 3** first. Either way, its role map is the list of literals you are about to replace.
2. Read `_project_/2-prd/brand-inputs.md`, written by `/prd-creator`'s design-inputs phase. Every field there is a default you confirm, not a question you ask. If the file is missing, this skill is running outside the normal workflow. Say so in one line and ask the questions cold.
3. Look in `_project_/0-intake/attachments/` and `_project_/1-discovery/attachments/` for a brand PDF, a style guide or a logo pack. If you find one, use it rather than asking the user to retype hex codes.
4. Check whether `src/<Project>.Report/definition/report.json` exists. If it does, the report has been built (milestone 1 ran) and you can validate with `pbir` at the end.

State what you found in one or two lines, then move on.

## Phase 1: settle the brand

Ask only about what Phase 0 could not answer. Use `AskUserQuestion` for discrete choices, and plain chat for a hex code.

- **Brand colour.** Takes the `accent` role in both themes and leads `dataColors`.
- **Secondary colour.** Takes `accent_alt`. On dark, it carries accent text and links, because a deep brand colour loses contrast on `#111111`. Offer "derive one" first: the same hue, lightened until it clears 4.5:1 on the dark background.
- **Fonts.** **The font must render in the Power BI Service**, not just on the developer's machine. The Service renders only its built-in families: Segoe UI and its weights, Arial, Calibri, Candara, Cambria, Constantia, Corbel, Courier New, DIN, Georgia, Tahoma, Trebuchet MS and Verdana. If the client's brand font is not on that list, say so plainly and offer the closest built-in family. Use the brand font in the prototype only if the client accepts that the built report will differ. Never quietly pick a font for them. Map `font_semibold` to the family's semibold face if Power BI has one (`Segoe UI Semibold`); otherwise map it to the regular family, since the theme already carries `fontWeight`.

Do not ask about anything else. The neutrals, sizes and visual styles are PowerUI's and stay as they are.

## Phase 2: derive, stamp, check

Derive first, then write once.

**The accent family, per theme.** From the brand and secondary colours, derive a replacement for every role in `.report-theme`:

- `light.accent_deep`: brand darkened until it clears 4.5:1 on `#fcfcfc`. It is used for text.
- `light.accent_wash`: a pale tint of the brand, for selected states.
- `dark.accent_deep` and `dark.accent_mid`: deep shades of the brand, used as fills behind light text on dark.

Keep the hue and move lightness.

**`dataColors`.** Eight values in series order. Start with the brand and secondary colours, then spread around the colour wheel far enough that adjacent series don't vibrate. Each must clear 3:1 against its theme's background. One array can rarely do that for both themes, so derive one for each.

**Sentiment.** Keep `good`, `bad` and `neutral` unless the brand collides with one (for example, a green brand next to the success green). If it does, shift the sentiment colour, not the brand.

**Stamp.** Write one map file per theme in the scratchpad, using `{"name", "colors": {old: new}, "dataColors", "fonts": {old: new}}`, where each *old* value comes from the `.report-theme` role map. Run it dry first, then for real:

```bash
.agents/skills/report-theme/scripts/stamp-theme.py src/<Project>.Report/StaticResources/RegisteredResources/Light.json <light-map>.json --dry-run
.agents/skills/report-theme/scripts/stamp-theme.py src/<Project>.Report/StaticResources/RegisteredResources/Light.json <light-map>.json
```

Repeat for `Dark.json`. The counts should match the use counts in the role map. A `NOT FOUND` means the role map is stale (someone hand-edited a theme). Find the real literal before going on. Do not guess.

**Check contrast** in both themes, and record the ratios in `.report-theme`:

| Pair | Floor |
|---|---|
| `foreground` on `background` | 4.5:1 |
| `foregroundNeutralSecondary` on `background` | 4.5:1 |
| accent text (`light.accent_deep`, `dark.accent_alt`) on `background` | 4.5:1 |
| each `dataColors` value on `background` | 3:1 |

A derived value that fails is not a reason to stop. Move it until it passes and say what you changed. If the **client's own** brand colour is what fails, do not quietly darken their brand. Show the nearest passing value and let them choose.

**Validate.** Check that both files still parse (`python3 -m json.tool <file> >/dev/null`). If the report exists, also run `pbir theme validate "src/<Project>.Report"`.

**Rewrite the design brief.** Replace everything between `report-theme:brand-section:start` and `:end` in `_project_/2-prd/design-brief.md` with what you actually stamped:

- the brand and secondary hexes
- the eight data colours for the theme the prototype leads with
- the font families
- whether the prototype covers Light, Dark or both
- a line telling Claude Design to use these values and invent none

Keep the markers.

**Place the logo.** `_project_/` is deleted at the end of the engagement and takes the attachments with it. Copy the client's logo files into `src/<Project>.Report/StaticResources/RegisteredResources/` and record the filenames. The report foundation milestone registers them with `pbir` (images go in `resourcePackages`). Prefer SVG or a high-resolution PNG. If you were given only a small raster, say so now. If there are no files, record `logo_files = none supplied` rather than leaving the field blank.

**Then stamp `.report-theme`** with these values:

- `status = branded` and every pick
- the role map **rewritten to the new values**, so the next run can find them
- the logo filenames, today's date, and the contrast table

## Phase 3: re-run

If `.report-theme` says `status = branded`, show the current picks in a short table, then ask with `AskUserQuestion`:

- **Change one value**: redo only what depends on it. A new font does not touch the palette.
- **Full restamp**: back through Phase 1.
- **Cancel**: nothing written.

The stamp rewrites the role-map literals and nothing else, so other hand edits in the theme files survive.

## Phase 4: wrap up

Keep it short:

- The brand and secondary hexes, and the fonts (plus any Service-rendering caveat).
- Which logo files landed, or that none were supplied.
- The contrast result.
- That `_project_/2-prd/design-brief.md` is ready to paste into Claude Design.
- If the report already exists: Power BI Desktop reads custom themes when it opens a file, so close and reopen the `.pbip` to see the change.
