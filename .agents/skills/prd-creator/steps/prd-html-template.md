# PRD HTML template

Write `_project_/2-prd/prd.html`, the client-facing copy of the PRD, using the scaffold and section snippets below. It covers the same locked scope as `prd.md` but leaves out builder-internal mechanics: the `_project_/` disclaimer, "Already provided by the Power BI template", milestone-log instructions, and anything else that only matters to the coding agent. The file must be fully self-contained. Google Fonts is its only network dependency, and there are no other files and no build step.

This file is also the source of `_project_/2-prd/prd.pdf` (see `steps/render-pdf.md`), which is what the client is actually sent, alongside the prototype. Two consequences follow. Keep the `@media print` block **verbatim**: it forces the light theme, opens every section on a new page so the hero stands alone as a title page, and keeps cards from splitting. And keep the `break-*` rules on the classes as written. Neither is decoration.

The styling is the JMS Analytics brand, the same system as the proposal the client already approved (`project-intake`'s `proposal-creator/templates/proposal-html.md` and `reference/brand.md`, which in turn follow the website). Hand-rolled CSS custom properties, no Tailwind, no icon library: the brand is typographic. If the brand sheet changes upstream, port the `:root` block and the font link here and to the sibling `fabric-data-app` and `next-supabase-app` templates.

## Section order

| No. | Section | Source in the interview | Omit when |
|---|---|---|---|
| (title page) | Hero: report name, core purpose, meta row, prototype banner | Core purpose | never |
| 01 | Users | Users | never |
| 02 | In-scope: dashboard pages, grouped by user | Page inventory + per-page specs | never |
| 03 | Out of scope | Out of scope | never |
| 04 | Milestones | Milestones | never |
| 05 | Semantic model | Semantic data model | never |
| 06 | Next steps | Next steps | never |
| A, B… | Appendix | anything product-specific | there is nothing product-specific |

Number the sections in the order they appear, so when one is omitted the numbers that follow close up. Appendices are lettered, not numbered.

## File scaffold

Start every `prd.html` from this scaffold. Fill in the `{{PLACEHOLDERS}}`, put the section snippets below where the comment says, and delete the comment. Don't rename CSS classes.

```html
<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<title>{{REPORT_NAME}} · Requirements · JMS Analytics</title>
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="https://fonts.googleapis.com/css2?family=Poppins:wght@500&family=Inter:wght@400;500;600&family=JetBrains+Mono:wght@400;500&family=Instrument+Serif:ital@0;1&display=swap" rel="stylesheet">
<style>
  :root {
    --brand-pink: #F288B8;
    --brand-pink-deep: #C45F94;
    --brand-pink-hot: #F9A6CB;
    --wash-07: rgba(242,136,184,0.07);
    --wash-14: rgba(242,136,184,0.14);
    --wash-45: rgba(242,136,184,0.45);
    --green: #2BD673;
    --amber: #FFB13C;

    --paper: #FCFCFD;
    --card: #FFFFFF;
    --ink: #34343F;
    --muted: #6E6E7E;
    --hairline: #E8E8EE;
    --accent: var(--brand-pink-deep);

    --display: "Poppins", ui-sans-serif, -apple-system, "Segoe UI", Helvetica, Arial, sans-serif;
    --sans: "Inter", ui-sans-serif, -apple-system, "Segoe UI", Helvetica, Arial, sans-serif;
    --mono: "JetBrains Mono", ui-monospace, "SF Mono", Menlo, Consolas, monospace;
    --serif: "Instrument Serif", "Times New Roman", Georgia, serif;
  }
  html[data-theme="dark"] {
    --paper: #1A1A1F;
    --card: #232329;
    --ink: #E8E8EE;
    --muted: #9A9AAA;
    --hairline: #34343F;
    --accent: var(--brand-pink);
  }

  * { box-sizing: border-box; margin: 0; }
  html { color-scheme: light; }
  html[data-theme="dark"] { color-scheme: dark; }
  body {
    background: var(--paper);
    color: var(--ink);
    font-family: var(--sans);
    font-size: 16px;
    line-height: 1.65;
    -webkit-font-smoothing: antialiased;
  }
  main { max-width: 44rem; margin: 0 auto; padding: 0 1.5rem 6rem; }

  header.site {
    position: sticky; top: 0; z-index: 10;
    background: color-mix(in srgb, var(--paper) 88%, transparent);
    backdrop-filter: blur(8px);
    border-bottom: 1px solid var(--hairline);
  }
  header.site .bar {
    max-width: 44rem; margin: 0 auto; padding: 0.75rem 1.5rem;
    display: flex; align-items: center; justify-content: space-between; gap: 1rem;
  }
  .wordmark { font-family: var(--mono); font-size: 0.8rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--muted); }
  .wordmark strong { color: var(--ink); font-weight: 500; }
  button.theme {
    font-family: var(--mono); font-size: 0.75rem; letter-spacing: 0.06em;
    background: none; border: 1px solid var(--hairline); border-radius: 999px;
    color: var(--muted); padding: 0.25rem 0.85rem; cursor: pointer;
  }
  button.theme:hover { border-color: var(--accent); color: var(--accent); }

  .hero { padding: 4.5rem 0 3rem; }
  h1 { font-family: var(--display); font-weight: 500; font-size: 2.6rem; line-height: 1.12; letter-spacing: -0.02em; margin: 0 0 1rem; }
  /* The accent word inside a heading, as the site's DisplayEm does. Never a whole heading. */
  em.accent { font-family: var(--serif); font-style: italic; font-weight: 400; color: var(--accent); }
  .hero .lede { font-size: 1.12rem; color: var(--muted); max-width: 38rem; }
  .meta { display: flex; flex-wrap: wrap; gap: 0.4rem 1.4rem; margin-top: 1.6rem; font-family: var(--mono); font-size: 0.8rem; color: var(--muted); }

  .companion {
    border-left: 2px solid var(--accent);
    background: var(--wash-07);
    border-radius: 0 8px 8px 0;
    padding: 0.8rem 1.1rem; margin-top: 1.6rem;
    font-size: 0.95rem; break-inside: avoid;
  }

  section { padding: 2.6rem 0 0.4rem; }
  .section-head { display: flex; align-items: baseline; gap: 0.9rem; margin-bottom: 1.1rem; }
  .section-no { font-family: var(--mono); font-size: 0.85rem; font-weight: 500; color: var(--accent); }
  h2 { font-family: var(--display); font-weight: 500; font-size: 1.75rem; letter-spacing: -0.02em; }
  .section-head::after { content: ""; flex: 1; height: 1px; background: var(--hairline); transform: translateY(-0.35rem); }
  section p { margin: 0 0 0.9rem; }
  section p, section li { color: var(--ink); }
  .muted { color: var(--muted); }

  /* Hierarchy inside the in-scope section, largest to smallest:
     user (h3.persona) > feature or page (h4.feat) > the h5 labels under it. */
  h3.persona {
    font-family: var(--display); font-size: 1.45rem; font-weight: 500; letter-spacing: -0.02em; color: var(--ink);
    margin: 2.4rem 0 0.9rem; padding-top: 0.85rem;
    border-top: 2px solid var(--accent);
    break-after: avoid; break-before: page;
  }
  section > h3.persona:first-of-type { margin-top: 0.6rem; break-before: auto; }

  h3.sub {
    font-family: var(--mono); font-size: 0.75rem; font-weight: 500;
    letter-spacing: 0.1em; text-transform: uppercase; color: var(--accent);
    margin: 2rem 0 0.1rem; break-after: avoid;
  }

  ul.deliver { list-style: none; padding: 0; margin: 0.3rem 0 1.2rem; }
  ul.deliver > li { padding: 1rem 0 1.1rem; border-bottom: 1px solid var(--hairline); break-inside: auto; }
  ul.deliver > li:last-child { border-bottom: none; }
  ul.deliver h4.feat {
    font-family: var(--display); font-size: 1.2rem; font-weight: 500; letter-spacing: -0.02em;
    margin: 0; break-after: avoid;
  }
  ul.deliver p.why { color: var(--muted); font-size: 0.95rem; margin: 0.25rem 0 0; break-inside: avoid; break-after: avoid; }

  ul.deliver .split { display: grid; grid-template-columns: 1fr 1fr; gap: 1.2rem; margin-top: 0.75rem; }
  ul.deliver .split > div { break-inside: avoid; }
  h5 {
    font-family: var(--mono); font-size: 0.72rem; font-weight: 500;
    letter-spacing: 0.08em; text-transform: uppercase; color: var(--muted);
    margin: 0 0 0.35rem; break-after: avoid;
  }
  ul.deliver ul { list-style: none; padding: 0; margin: 0; font-size: 0.95rem; }
  ul.deliver ul li { position: relative; padding: 0.2rem 0 0.2rem 1rem; break-inside: avoid; }
  ul.deliver ul li::before { content: "\2022"; position: absolute; left: 0; color: var(--accent); }
  ul.deliver ul.not li { color: var(--muted); }
  ul.deliver ul.not li::before { content: "\2013"; color: var(--muted); }

  ul.deliver p.ms {
    border-left: 2px solid var(--accent); background: var(--wash-07);
    border-radius: 0 8px 8px 0; padding: 0.4rem 0.9rem;
    margin: 0.9rem 0 0;
    font-family: var(--mono); font-size: 0.72rem; font-weight: 500;
    letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent);
    break-inside: avoid; break-before: avoid;
  }

  ul.plain { list-style: none; padding: 0; margin: 0.4rem 0 1rem; }
  ul.plain li { padding: 0.35rem 0; }
  ul.plain li::before { content: "\2014"; color: var(--accent); margin-right: 0.6rem; }
  ul.cut li { color: var(--muted); }
  ul.cut li strong { color: var(--ink); font-weight: 500; }

  .cards { display: grid; gap: 0.8rem; margin: 0.4rem 0 1rem; }
  .cards.two { grid-template-columns: 1fr 1fr; }
  .card {
    border: 1px solid var(--hairline); border-radius: 10px; background: var(--card);
    padding: 1rem 1.15rem; break-inside: avoid;
  }
  .card .tag { font-family: var(--mono); font-size: 0.72rem; letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent); }
  .card h3 { font-family: var(--display); font-weight: 500; font-size: 1.1rem; letter-spacing: -0.02em; margin: 0.25rem 0 0.35rem; }
  .card p { color: var(--muted); margin: 0; font-size: 0.95rem; }
  .card p.need { margin-top: 0.6rem; }
  .card p.need strong { color: var(--ink); font-weight: 600; }
  .card h5 { margin: 0.85rem 0 0.3rem; }
  .card p.rel { margin-top: 0.6rem; }

  ul.goals, ul.tight { list-style: none; padding: 0; margin: 0; font-size: 0.95rem; }
  ul.goals li, ul.tight li { position: relative; padding: 0.2rem 0 0.2rem 1rem; break-inside: avoid; }
  ul.goals li::before, ul.tight li::before { content: "\2022"; position: absolute; left: 0; color: var(--accent); }

  .ms-block { padding: 1.1rem 0 1.3rem; border-bottom: 1px solid var(--hairline); }
  .ms-block:last-child { border-bottom: none; }
  .ms-block .ms-no { font-family: var(--mono); font-size: 0.75rem; font-weight: 500; letter-spacing: 0.1em; text-transform: uppercase; color: var(--accent); }
  .ms-block h3 { font-family: var(--display); font-size: 1.3rem; font-weight: 500; letter-spacing: -0.02em; margin: 0.2rem 0 0.4rem; break-after: avoid; }
  .ms-block h5 { margin: 0.9rem 0 0.3rem; }

  p.done {
    border-left: 2px solid var(--green);
    background: color-mix(in srgb, var(--green) 7%, transparent);
    border-radius: 0 8px 8px 0; padding: 0.6rem 0.9rem;
    margin: 0.9rem 0 0; font-size: 0.95rem;
    break-inside: avoid; break-before: avoid;
  }
  p.done strong { font-weight: 600; }

  table { width: 100%; border-collapse: collapse; margin: 0.4rem 0 1rem; font-size: 0.95rem; break-inside: avoid; }
  th { text-align: left; font-family: var(--mono); font-size: 0.72rem; letter-spacing: 0.08em; text-transform: uppercase; font-weight: 500; color: var(--muted); padding: 0.5rem 0.75rem 0.5rem 0; border-bottom: 1px solid var(--hairline); }
  td { padding: 0.6rem 0.75rem 0.6rem 0; border-bottom: 1px solid var(--hairline); vertical-align: top; }
  tr:last-child td { border-bottom: none; }
  td.field { font-family: var(--mono); font-size: 0.85rem; white-space: nowrap; }

  /* Appendix flow diagrams. Boxes stack top to bottom; arms are the moves between them. */
  .flow { margin: 0.6rem 0 1.4rem; }
  .flow__box {
    border: 1px solid var(--hairline); border-radius: 10px; background: var(--card);
    padding: 0.8rem 1rem; break-inside: avoid;
  }
  .flow__box--list { border-left: 3px solid var(--accent); }
  .flow__box--end { border-style: dashed; }
  .flow__t { font-family: var(--display); font-weight: 500; font-size: 1rem; letter-spacing: -0.02em; }
  .flow__state {
    display: inline-block; font-family: var(--mono); font-size: 0.66rem;
    letter-spacing: 0.08em; text-transform: uppercase; color: var(--muted);
    border: 1px solid var(--hairline); border-radius: 4px;
    padding: 0.05rem 0.4rem; margin-top: 0.3rem;
  }
  .flow__d { color: var(--muted); font-size: 0.88rem; margin-top: 0.15rem; }
  .flow__arm {
    text-align: center; color: var(--muted); font-size: 0.78rem;
    font-family: var(--mono); letter-spacing: 0.06em; text-transform: uppercase;
    padding: 0.45rem 0; break-inside: avoid; break-after: avoid;
  }
  .flow__arm::before { content: "\2193"; display: block; font-size: 1rem; letter-spacing: 0; }
  .flow__split { display: grid; grid-template-columns: 1fr 1fr; gap: 0.8rem; break-inside: avoid; }
  .flow__split--3 { grid-template-columns: 1fr 1fr 1fr; }
  .flow__method {
    text-align: center; font-family: var(--mono); font-size: 0.7rem;
    letter-spacing: 0.08em; text-transform: uppercase; color: var(--accent);
    margin-bottom: 0.35rem;
  }
  .flow__gate {
    text-align: center; font-weight: 500; font-size: 0.82rem;
    font-family: var(--mono); letter-spacing: 0.1em; text-transform: uppercase;
    color: var(--accent); border-top: 1px solid var(--accent); border-bottom: 1px solid var(--accent);
    padding: 0.4rem 0; margin: 0.55rem 0; break-inside: avoid;
  }

  .note {
    border-left: 2px solid var(--amber);
    background: color-mix(in srgb, var(--amber) 6%, transparent);
    border-radius: 0 8px 8px 0;
    padding: 0.8rem 1.1rem; margin: 0.4rem 0 1rem;
    font-size: 0.95rem; break-inside: avoid;
  }

  footer { border-top: 1px solid var(--hairline); margin-top: 3.5rem; padding-top: 1.4rem; display: flex; flex-wrap: wrap; gap: 0.4rem 1.4rem; font-family: var(--mono); font-size: 0.78rem; color: var(--muted); }
  footer a { color: var(--accent); text-decoration: none; }

  @media (max-width: 560px) {
    h1 { font-size: 2rem; }
    .hero { padding-top: 3rem; }
    .cards.two, ul.deliver .split, .flow__split, .flow__split--3 { grid-template-columns: 1fr; }
  }

  @media print {
    :root, html[data-theme="dark"] {
      --paper: #FFFFFF; --card: #FFFFFF; --ink: #34343F; --muted: #6E6E7E;
      --hairline: #E8E8EE; --accent: #C45F94;
    }
    html, html[data-theme="dark"] { color-scheme: light; }
    header.site { position: static; backdrop-filter: none; background: none; }
    .no-print { display: none !important; }
    body { font-size: 12.5px; }
    .hero { padding: 1.5rem 0 1.2rem; }
    /* Every major section opens a page, so the hero stands alone as a title page. */
    section { padding-top: 0; break-inside: auto; break-before: page; }
    .ms-block, .card, table, .note { break-inside: avoid; }
    a { text-decoration: none; color: inherit; }
    @page { margin: 18mm 16mm; }
  }
</style>
</head>
<body>
<header class="site">
  <div class="bar">
    <span class="wordmark"><strong>JMS Analytics</strong> · Requirements</span>
    <button class="theme no-print" id="themeBtn" type="button">Dark</button>
  </div>
</header>
<main>

  <div class="hero">
    <h1>{{REPORT_NAME}}</h1>
    <p class="lede">{{CORE_PURPOSE}}</p>
    <div class="meta">
      <span>Prepared for {{CLIENT_CONTACT}}</span>
      <span>Joel Sherman · JMS Analytics</span>
      <span>{{DATE}}</span>
    </div>
    <p class="companion">A click-through prototype accompanies this document, and the two should be evaluated in tandem.</p>
  </div>

  <!-- Sections go here, in the order in the table above; snippets below. -->

  <footer>
    <span>Joel Sherman · JMS Analytics</span>
    <span><a href="https://www.jms-analytics.com">jms-analytics.com</a></span>
  </footer>
</main>
<script>
  (function () {
    var key = "prd-theme";
    var btn = document.getElementById("themeBtn");
    function apply(t) {
      if (t === "dark") { document.documentElement.setAttribute("data-theme", "dark"); btn.textContent = "Light"; }
      else { document.documentElement.removeAttribute("data-theme"); btn.textContent = "Dark"; }
    }
    var saved = null;
    try { saved = localStorage.getItem(key); } catch (e) {}
    apply(saved || (window.matchMedia && window.matchMedia("(prefers-color-scheme: dark)").matches ? "dark" : "light"));
    btn.addEventListener("click", function () {
      var next = document.documentElement.hasAttribute("data-theme") ? "light" : "dark";
      try { localStorage.setItem(key, next); } catch (e) {}
      apply(next);
    });
  })();
</script>
</body>
</html>
```

The title page is the header bar plus the hero, and nothing else. The wordmark already says whose document it is and what it is, so don't add a kicker or a byline above the h1. The banner text is fixed: keep it verbatim.

## Section snippets

Every section uses the shared head:

```html
<section>
  <div class="section-head"><span class="section-no">01</span><h2>Users</h2></div>
  ...
</section>
```

### 01 Users

The personas locked in the Users phase. Write one sentence saying how many groups use the report and that the next section is grouped under the same names, then add one card per persona. The `.tag` is the role in two or three words ("Applies and pays", "Runs the program"). The paragraph says who they are, how many there are if known, and how they reach the report. Write three to five goals in the persona's own terms.

```html
<p>{{N}} groups use this report, and nothing in it is built for anyone else. The pages in the next section are grouped under the same {{N}} names.</p>
<div class="cards">
  <div class="card">
    <span class="tag">{{ROLE_IN_A_FEW_WORDS}}</span>
    <h3>{{PERSONA_NAME}}</h3>
    <p>{{WHO_THEY_ARE}}</p>
    <h5>What they want</h5>
    <ul class="goals">
      <li>{{GOAL}}</li>
    </ul>
  </div>
</div>
```

### 02 In-scope

One `h3.persona` per persona, in the same order as section 01 and with **the name repeated verbatim**. Under each, a `ul.deliver` of the dashboard pages that persona mainly uses, as assigned in the page inventory, in priority order within the group. Each page has its name, a one-sentence why (the decision or question it serves), what the page shows and what it won't side by side, and a single line naming the milestone that builds it. The milestone line says which milestone and nothing else: no prototype page references, no status, no dates.

"What the page shows" covers, in plain language, the headline measures, the visuals presenting them, what the user can slice and filter by, and the interactions (cross-filtering or highlighting, drill-through, default selections). Use one bullet each, and name measures as section 05 names them. "What it won't" covers the per-page cuts: drill-through, extra breakdowns, what-if inputs, export.

```html
<h3 class="persona">{{PERSONA_NAME}}</h3>
<ul class="deliver">
  <li><h4 class="feat">{{PAGE_NAME}}</h4>
    <p class="why">{{DECISION_IT_SERVES}}</p>
    <div class="split">
      <div><h5>What the page shows</h5><ul>
        <li>{{MEASURE_VISUAL_SLICER_OR_INTERACTION}}</li>
      </ul></div><div><h5>What it won't</h5><ul class="not">
        <li>{{OUT_OF_SCOPE_ITEM}}</li>
      </ul></div>
    </div>
    <p class="ms">Built in milestone {{N}}</p>
  </li>
</ul>
```

When milestones follow the default of one per page, every line names a single milestone. If a foundation milestone or grouped pages changed that, the line still names whichever milestone builds the page. The hierarchy is deliberate: user name, then page name, then the small mono h5 labels. Never size an h5 or a list above the page name.

### 03 Out of scope

```html
<ul class="plain cut">
  <li><strong>{{ITEM}}</strong> {{REASON}}</li>
</ul>
```

The reason follows the bold item after a single space, with no dash and no colon, and reads as its own clause.

### 04 Milestones

Write one sentence on how many milestones there are and what each one ends with, then one block per milestone. The description is plain: what the milestone delivers and why it sits where it does in the priority order. "Page built here" uses the page names from section 02 verbatim. Use "Pages built here" when pages are grouped, and for a foundation milestone that builds no page, list what it builds instead (themes, navigation, shared slicers). The "Done when" text is the locked criterion.

```html
<p>The build runs in {{N}} milestones, one per page. Each one ends with a page that can be opened and judged against real data, rather than a status report.</p>
<div class="ms-block">
  <div class="ms-no">Milestone {{N}}</div>
  <h3>{{MILESTONE_NAME}}</h3>
  <p>{{MILESTONE_DESCRIPTION}}</p>
  <h5>Page built here</h5>
  <ul class="tight">
    <li>{{PAGE_NAME}}</li>
  </ul>
  <p class="done"><strong>Done when:</strong> {{DONE_WHEN}}</p>
</div>
```

### 05 Semantic model

The model the pages read from, as a star schema in plain language. Write one sentence on what it is: the facts are the numbers being measured, the dimensions are what the user slices by, and the measures are the calculations on the pages. Then add one card per table, tagged Fact or Dimension, with its fields described in plain language and never as column types. Close each card with a line naming what it relates to. After the cards come the relationships, one line each, and the key measures in a table with what each one means. Never include DAX.

```html
<p>{{ONE_SENTENCE_ON_THE_MODEL}}</p>
<div class="cards">
  <div class="card">
    <span class="tag">{{FACT_OR_DIMENSION}}</span>
    <h3>{{TABLE_NAME}}</h3>
    <table>
      <tbody>
        <tr><td class="field">{{FIELD_NAME}}</td><td>{{FIELD_DESCRIPTION}}</td></tr>
      </tbody>
    </table>
    <p class="rel">{{RELATIONSHIPS_AND_NOTES}}</p>
  </div>
</div>

<h3 class="sub">How the tables relate</h3>
<ul class="plain">
  <li>{{ONE}} (one) to {{MANY}} (many): {{WHAT_IT_MEANS}}</li>
</ul>

<h3 class="sub">Key measures</h3>
<table>
  <thead><tr><th>Measure</th><th>What it means</th></tr></thead>
  <tbody>
    <tr><td class="field">{{MEASURE_NAME}}</td><td>{{PLAIN_LANGUAGE_MEANING}}</td></tr>
  </tbody>
</table>
```

### 06 Next steps

Bullets only. No intro paragraph, no banner, no narrative mixed in. The first bullet is always the joint review: "Review these requirements alongside the prototype, before any page is built. What you approve is what we build." See `steps/next-steps.md` for where the rest come from.

```html
<ul class="plain">
  <li>{{NEXT_STEP}}</li>
</ul>
```

### Appendix A, B…

For material specific to this product that would distort a standard section if forced into it, such as how a headline measure is built up step by step, where the model's data comes from and when it refreshes, or a status classification the pages depend on. Most PRDs have none. Open with a short paragraph saying why the appendix exists, then use whichever of these patterns fit: a `.flow` diagram, a "who causes each move" table, and a "what each user sees" table.

**An appendix must be isomorphic to how the report will actually work.** Every step, every branch, every exclusion and every point where a person rather than the model decides, in the order they happen. The space is there so accuracy does not have to be traded for a tidy layout. If a box says nothing is owed yet, nothing is owed yet. Before writing it, trace each path through `prd.md`'s per-page specs and semantic data model, and if the diagram and the scope disagree, fix whichever is wrong and tell the user.

```html
<section>
  <div class="section-head"><span class="section-no">A</span><h2>Appendix: {{TOPIC}}</h2></div>
  <p>{{WHY_THIS_APPENDIX_EXISTS}}</p>

  <h3 class="sub">{{SUBHEAD}}</h3>
  <div class="flow">
    <div class="flow__box">
      <div class="flow__t">{{STEP_TITLE}}</div>
      <div class="flow__d">{{WHAT_HAPPENS_AND_WHO_DOES_IT}}</div>
      <span class="flow__state">{{STATE_NAME}}</span>
    </div>
    <div class="flow__arm">{{THE_MOVE}}</div>
    <!-- A fork: .flow__split (two) or .flow__split.flow__split--3 (three) of .flow__box.
         .flow__method labels a parallel option (e.g. a payment method).
         .flow__gate marks a condition every path must pass.
         .flow__box--list marks a step that waits on a person; .flow__box--end marks an end state. -->
  </div>

  <h3 class="sub">Who causes each move</h3>
  <table>
    <thead><tr><th>Move</th><th>Caused by</th><th>Can the report decide it?</th></tr></thead>
    <tbody>
      <tr><td>{{FROM}} to {{TO}}</td><td>{{ACTOR}}</td><td>{{YES_OR_NO_WITH_REASON}}</td></tr>
    </tbody>
  </table>
</section>
```

## Style and voice notes

- **Voice.** `training/voice.md` and `training/slop.md` govern every word in this file. Sweep against the slop list before rendering.
- **No emoji, no icons.** The structure comes from type, rules and the accent colour.
- **Don't add scope.** The HTML is presentation. Never invent pages, measures, fields, goals or milestones to fill a layout. A short section stays short.
- **Omit empty sections** entirely and renumber the ones after. Never render an empty shell.
- **No section IDs, no table of contents.** The document is read top to bottom and on paper.
- **Same content as `prd.md`.** The HTML is a different presentation of the same locked decisions, never a different plan. Persona names, page names, measure names and milestone names match `prd.md` exactly.
