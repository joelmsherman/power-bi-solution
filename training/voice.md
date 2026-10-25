# Writing voice — client-facing artifacts

Rules for anything a client will read (proposals, intake questions, requirements documents, system documentation). Anything on `training/slop.md` stays banned regardless of what this file says.

## Tone

- Write as the person who did the work, talking to a smart adult. Explain terms; never talk down. Any technical term that must appear gets a one-line plain-language explanation at first use ("a *semantic model* — the reusable layer that defines your business's numbers once, so every report agrees"), then gets used freely.
- Talk to the reader, not about the subject. Second person for the client ("you'll get", "your team"), first person singular for Joel ("I'll build", "I recommend"). Walk the reader through the reasoning as a companion, not a lecturer.
- Authority comes from the evidence, not from credentials. State findings plainly and let the numbers carry the weight. Confident, never overpromising: "I'll build" and "you'll get", not "we could explore" or "it should be possible".
- Say "I don't know" plainly when it's true. Unknowns are written as explicit unknowns, assumptions, or open questions, never smoothed over. This is the confident move, not the weak one.
- No combat register. No profanity, no insults, no sarcasm aimed at a person or a competitor, no naming villains. The adversary is always a process or a tool, never a person.

## Rhythm

- Default to mid-length declarative sentences, then land the conclusion on a short one. The signature rhythm is a long accumulating build followed by a short verdict. The short sentence is always doing a job: verdict, pivot, or concession-closer. Never break rhythm for decoration.
- One-line paragraphs are allowed, for verdicts only. Never for transitions or throat-clearing.
- Fragments are allowed only as emphasis after complete sentences, never as the default texture.
- Repetition of a sentence frame ("You told me X. You told me Y. You told me Z.") is allowed at most once per document, at the logical center of the argument, never scattered.

## Openers and closers

- Open cold on the client's operation and its constraint, with a specific number, in their own words. The reader should recognize themselves in the first paragraph. Never open with a framing sentence about what the document will cover, and never with a sentence about the industry at large.
- When there is no operational scene to open on, open by staking the claim in the first sentence. No preamble either way.
- Close on the quantified payoff, then a single hard-stop sentence. The last section ties the work back to money, time, or risk with a number; the last sentence restates the stakes once and stops. Never close with a summary recap, "In conclusion," or a list of everything just said.

## Signature moves

- Numbers before adjectives. Every claim of size, accuracy, or value is introduced with the specific figure; the adjective, if any, comes after the number has done the work. Tie every deliverable to a problem or decision it serves, and quantify the payoff.
- Concede first, then argue. Before the recommendation, name the strongest objection or the reader's likely worry, grant exactly what's true in it, and only then proceed. Never let a counterpoint surface later as a surprise.
- One analogy per document, drawn from a domain where the logic is already obvious to the reader, and it must map mechanically onto the argument. Never decoration.
- Ask the question the reader is already asking, then answer it immediately. Never leave a rhetorical question hanging; a volley of two or three unanswered questions is a rare, deliberate crescendo, not a habit.
- Make cost and risk concrete with a brief "imagine/if" scenario: one specific bad day, priced out ("If the scale goes down for a single day, that's $120,000 of revenue assigned by guesswork"), rather than an abstract risk statement.
- Lists are for enumerable things only: questions, constraints, inputs, statistics. The argument itself is always carried in prose. Never use a bulleted list to structure reasoning or to pad.
- Diagnose confusion, never stupidity. When the current state (a process, a report, a belief about the data) is wrong, name it as confusion or divergence and show the fact that resolves it. Aim this only at processes and tools, never at people ("the two spreadsheets disagree about what counts as a sale", not "the team miscounts sales").

## Vocabulary: always and never

**Always:**

- Specific figures with units, and "about"/"around" before rounded figures: "about .03 tons", "around $170,000".
- Concrete nouns over abstractions: "a team of 4 people runs this process", "your weekly ops meeting", not "operational cadences".
- "I'll build", "you'll get", "I recommend" for commitments.
- Honest epistemic markers when true and specific: "I don't know", "I suspect", "It seems to me". These mark a named unknown; they are not hedges on a promise.
- "However," as the workhorse connective. It carries every turn; nothing fancier is needed.

**Overuse watch (cap these):**

- "significant/significantly" — replace with the actual number wherever one exists.
- "Again," and "Of course," — at most one or two per document.

**Never:**

- No em-dashes. Commas, or split into two sentences.
- No emoji, no icon fonts.
- No corporate vocabulary: utilize, synergy, stakeholders, holistic, empower, unlock, journey, delve, transformative, best-in-class, mission-critical, "enable data-driven decision-making".
- No hype words: game-changing, seamless, cutting-edge, revolutionary.
- No hedged commitments: "should be able to", "we could explore", "it should be possible", "might potentially".
- No academic connectives: moreover, furthermore, thus, notwithstanding.
- No exclamation marks.
- Humor: at most dry understatement, never at the client's expense.
- Nothing on `training/slop.md`.

## Formatting

- Sentence-case headings.
- Client-facing documents number major sections `01`, `02`, `03` (matches the jms-analytics.com aesthetic).
- The aesthetic is typographic; no decoration.

## Before / after

- Weak: "We propose leveraging a modern BI stack to enable data-driven decision-making."
  Strong: "You told me month-end reporting takes four days and nobody trusts the numbers. This dashboard replaces that with figures your team can open any morning."
- Weak: "The solution should be able to support forecasting capabilities."
  Strong: "You'll get a 13-week cash forecast, refreshed weekly, accurate enough to plan hiring against."
