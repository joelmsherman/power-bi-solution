# Render the PDF

`prd.html` is the browser copy. `prd.pdf` is the file you actually send, together with the prototype — it opens the same on every machine, survives being forwarded, and does not depend on a CDN being reachable months from now. Render it as the last act of the run.

## 1. Render

From the repo root:

```bash
.agents/skills/prd-creator/scripts/render-pdf.sh _project_/2-prd/prd.html
```

It writes `_project_/2-prd/prd.pdf`. The script finds the puppeteer-cached headless Chrome under `~/.cache/puppeteer/` and prints to PDF with no browser header or footer.

The PDF always comes out in the light theme. `prd.html` has a dark-mode toggle, but the toggle state lives in `localStorage`, which a headless render starts empty, and the template's `@media print` block forces the light tokens regardless. It also opens every section on a new page, so the hero stands alone as a title page. Do not remove that print block from the template — it is what makes the PDF legible and paginated.

## 2. If there is no cached Chrome

The script exits with a message naming the fallback. Relay it to the user as written: open `_project_/2-prd/prd.html` in a browser, switch to the light theme, and use Print → Save as PDF, saving to `_project_/2-prd/prd.pdf`.

Then continue and finish the run. A missing PDF is a gap to flag, not a failed run — the HTML and markdown are both complete and the client can still review from the HTML.

## 3. Check the result

Confirm `_project_/2-prd/prd.pdf` exists and is non-empty. Two caveats worth passing on to the user, once, in a sentence:

- The HTML fetches Poppins, Inter, JetBrains Mono and Instrument Serif from Google Fonts at render time. On an offline machine the PDF still renders, but in system fonts — worth eyeballing the title page before sending.
- Cards, milestone blocks and tables are kept whole across page breaks by the print block. One longer than a page will still split; that is expected and not worth fighting.

## 4. Tell the user what to send

Close the run by naming the three PRD files and who each is for:

- `_project_/2-prd/prd.pdf` — send this to the client with the prototype, once step 3 has produced it, for one joint sign-off
- `_project_/2-prd/prd.html` — the same document in a browser, if they would rather scroll than page
- `_project_/2-prd/prd.md` — the full version, for you and the milestone coding agents; not for the client
