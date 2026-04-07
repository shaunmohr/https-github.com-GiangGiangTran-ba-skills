---
name: powerpoint
description: "Design compelling PowerPoint decks — structure slides, write slide headlines, build narrative flow, choose the right chart type, and create speaker notes. Use when building any slide deck for stakeholders, executives, or clients."
allowed-tools: Write
metadata:
  version: "1.0"
  claude-code:
    context: fork
    agent: Explore
    user-invocable: true
---

# PowerPoint Skill for BA

A deck that needs explaining has already failed. Build one that speaks for itself.

## What is Deck Design?

**Definition**: Structuring ideas visually so an audience grasps the point on each slide before the presenter speaks — and reads through independently when sent as a document.

**Why it matters**:
- Executives read decks in 30 seconds before deciding whether to engage
- Weak structure = presenter carries the weight; strong structure = deck carries itself
- One bad slide kills credibility on the rest
- Slide headlines are the real story — bullets are evidence

**When to Use**:
- ✅ Business case presentations
- ✅ Executive briefings and project updates
- ✅ Requirement walkthrough with stakeholders
- ✅ Strategy and roadmap communications
- ✅ Discovery readout / findings presentation

---

## The Deck Architecture

### **Three Deck Types**

**Type 1: Decision Deck** (most common in BA work)
```
Slide 1: Situation + Recommendation (what you want approved)
Slide 2: Why now (context + urgency)
Slide 3: Options considered
Slide 4: Recommended option + rationale
Slide 5: Investment & Return
Slide 6: Risk & Mitigation
Slide 7: Next Steps + Ask
[Appendix: supporting data, methodology]
```

**Type 2: Update Deck**
```
Slide 1: Status (Red / Amber / Green) + headline
Slide 2: Milestone progress
Slide 3: Issues / Decisions needed
Slide 4: Next period plan
```

**Type 3: Discovery / Findings Deck**
```
Slide 1: What we set out to learn
Slide 2: What we did (methodology)
Slide 3-N: What we found (one key insight per slide)
Slide N+1: What it means (implications)
Slide N+2: Recommendations
```

---

## The Slide Formula

### **Every Slide = Headline + Evidence**

**The headline is the conclusion, not the topic.**

```
❌ Topic title: "Customer Feedback"
✅ Insight headline: "8 of 10 customers abandon checkout due to payment friction"

❌ Topic title: "Q3 Revenue"
✅ Insight headline: "Q3 revenue missed target by 12% — three fixable root causes identified"

❌ Topic title: "Proposed Solution"
✅ Insight headline: "Replacing legacy form with API integration saves 40 hrs/week and $180K annually"
```

**Rule**: Cover the headline of every slide with your hand. Read the body. If the body alone tells the story — rewrite the headline to carry the insight instead.

---

## Slide Types & When to Use Them

### **Slide Type 1: The Single Insight**
One chart or data point. One headline. One takeaway.
- Use for: Key findings, important metrics, critical risks
- Resist: Adding a second chart "since you have the space"

### **Slide Type 2: The Comparison**
Side-by-side options or before/after.
- Use for: Option analysis, change impact, competitive positioning
- Format: 2–3 columns max. Label the winner clearly.

### **Slide Type 3: The Process**
Left-to-right flow diagram or numbered steps.
- Use for: Workflows, implementation phases, decision process
- Rule: 5 steps max per diagram. More → split into two slides.

### **Slide Type 4: The Matrix**
2x2 or table comparing multiple dimensions.
- Use for: Risk assessment, prioritization, stakeholder mapping
- Rule: Highlight the cells that matter. Don't make audience find them.

### **Slide Type 5: The Timeline**
Horizontal bar (Gantt-style) or milestone line.
- Use for: Project phases, roadmap, delivery milestones
- Rule: Label milestones with dates AND owners.

### **Slide Type 6: The Evidence Stack**
3–5 bullets with supporting stats.
- Use for: Backing up a recommendation, summarizing research
- Rule: Each bullet = one claim + one piece of evidence. Not two claims.

---

## Chart Chooser

Choose the right chart for your data:

| Question | Chart Type |
|----------|-----------|
| How do parts compare to a whole? | Donut / Stacked bar |
| How does something change over time? | Line chart |
| Which category is biggest? | Horizontal bar (sorted) |
| How do two variables relate? | Scatter plot |
| What's the distribution? | Histogram / Box plot |
| How does a process flow? | Funnel / Waterfall |
| Where are we vs target? | Bullet chart / Gauge |

**Chart rules**:
- Title the chart with the insight, not the label ("Revenue grew 35% YoY" not "Revenue")
- Use color to highlight what matters — grey everything else
- Label data directly on chart (not a legend requiring eye travel)
- Remove gridlines unless they aid reading (most of the time: remove)

---

## Slide Writing Rules

### **Headlines**
- Max 12 words
- State the conclusion, not the category
- One per slide
- Verb-led where possible: "X drives Y", "We recommend Z", "Risk is High"

### **Bullets**
- Max 5 per slide
- Max 10 words per bullet
- Parallel structure (all start with noun, or all start with verb — not mixed)
- Each bullet stands alone — no "see above"

### **Numbers on Slides**
- Round to significant figures (don't say $2,847,392 — say "$2.8M")
- Put units in the label, not every data point
- Call out the number that matters (bold it, colour it, or annotate it)

### **Text to Avoid**
- Anything that requires a 9pt font to fit
- Paragraph prose (use headlines + bullets)
- "As you can see from the chart..." (they can see it — state the insight)
- "This slide shows..." (start with what it shows, not that it shows it)

---

## Speaker Notes Structure

Write speaker notes as a script for the presenter:

```
[Transition in]: How you get to this slide
  "Coming out of the financials, I want to show you what's driving the gap..."

[Headline expansion]: 2–3 sentences that expand the headline
  "The 12% miss isn't uniform — it's almost entirely driven by the enterprise segment..."

[Key proof points]: Walk through the evidence
  "The data on the left shows... The key number here is..."

[Anticipated question]: Address the objection they're thinking
  "You might be wondering why X — the answer is..."

[Transition out]: Bridge to next slide
  "Which brings me to how we're going to fix this..."
```

---

## Slide Deck Checklist

**Structure**:
- [ ] Does the deck work if you only read headlines? (Slide Story Test)
- [ ] Is the recommendation/ask clear before slide 4?
- [ ] Is every slide earning its place — or could it move to appendix?
- [ ] Does the flow answer: Situation → Complication → Resolution?

**Each Slide**:
- [ ] One clear insight headline?
- [ ] Maximum 5 bullets or one chart?
- [ ] Data labelled and annotated (not left for audience to interpret)?
- [ ] No orphaned text or floating call-outs?

**Visual**:
- [ ] Consistent font sizing (Title: 28–36pt, Body: 18–24pt, Notes: 14–16pt)?
- [ ] Colour used to direct attention, not decorate?
- [ ] No more than 3 colours from palette?
- [ ] Logos and page numbers on every slide?

**Audience Test**:
- [ ] Could an exec grasp the point of each slide in 10 seconds?
- [ ] If emailed without a presenter, would it still make sense?
- [ ] Have you removed every slide that exists "just in case"?

---

## Slide Outline Template

```
DECK: [Title]
AUDIENCE: [Who + their role in decision]
OBJECTIVE: [What you want them to do/decide/understand]

SLIDE 1 - TITLE
Headline: [Your deck's core message in one sentence]

SLIDE 2 - SITUATION
Headline: [Context that makes this conversation necessary]
Evidence: [2–3 bullets grounding the audience]

SLIDE 3 - COMPLICATION
Headline: [The problem/opportunity/decision that exists]
Evidence: [Data showing the gap or tension]

SLIDE 4 - RECOMMENDATION
Headline: [What you are recommending]
Evidence: [Key rationale, 3 reasons max]

SLIDE 5 - OPTIONS
Headline: [Why this option beats alternatives]
Visual: Comparison table (Option A / B / C vs criteria)

SLIDE 6 - INVESTMENT & RETURN
Headline: [Cost/effort vs value returned]
Visual: Summary table or waterfall

SLIDE 7 - RISKS
Headline: [Key risks are manageable]
Visual: Risk matrix or mitigation table

SLIDE 8 - NEXT STEPS
Headline: [Here's what happens if you say yes today]
Visual: Timeline with owners

APPENDIX
- Supporting data
- Methodology
- Definitions
- Additional analysis
```

---

## Usage Examples

```
/powerpoint "Build a 7-slide executive deck for a $500K platform migration business case"
/powerpoint "Outline a findings presentation from user research — 12 interviews, 4 themes"
/powerpoint "Write slide headlines for a project status update — Amber status, 2 issues"
/powerpoint "What chart should I use to show market share across 5 competitors over 3 years"
```

---

## Standards Applied

- **McKinsey / BCG deck principles** (Situation-Complication-Resolution)
- **Barbara Minto's Pyramid Principle** (insight-first structure)
- **Edward Tufte** (data-ink ratio, chartjunk elimination)
- **Duarte Design** (visual storytelling principles)
