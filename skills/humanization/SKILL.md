---
name: humanization
description: "Transform AI-generated or corporate-speak content into warm, natural human writing. Remove robotic phrasing, add personality, match tone to audience. Use when output sounds stiff, generic, or obviously AI-written."
allowed-tools: Write, Edit
metadata:
  version: "1.0"
  claude-code:
    context: fork
    agent: Explore
    user-invocable: true
---

# Humanization Skill

AI writes to inform. Humans write to connect. This skill closes that gap.

## What is Humanization?

**Definition**: Rewriting content so it sounds like a real person wrote it — with natural rhythm, appropriate emotion, and authentic voice — while preserving accuracy and intent.

**Why it matters**:
- AI-sounding content erodes trust with readers
- Corporate jargon disengages stakeholders
- Robotic prose loses people before they reach the point
- Human writing creates psychological safety for difficult messages

**When to Use**:
- ✅ Polishing AI-drafted emails, reports, or messages
- ✅ Converting technical analysis into exec-friendly narrative
- ✅ Making requirement docs readable by non-technical stakeholders
- ✅ Softening difficult feedback or change communications
- ✅ Writing comms that need warmth (all-hands, user announcements)

---

## The 5 Signals of Robotic Writing

Identify these patterns and eliminate them:

### **Signal 1: Over-formal openers**
❌ "I hope this message finds you well."
❌ "As per our previous discussion..."
❌ "Please be advised that..."
✅ Just start with the point. Or a human observation.

### **Signal 2: Passive voice overload**
❌ "The analysis was conducted and findings were identified..."
✅ "We analyzed the data and found three clear patterns..."

### **Signal 3: Hedge stacking**
❌ "It might potentially be considered that this could possibly..."
✅ "This will likely..." or just commit: "This will..."

### **Signal 4: Unnaturally balanced structure**
❌ Every bullet the same length. Every paragraph the same shape.
✅ Let some points breathe. Let one idea dominate when it should.

### **Signal 5: Missing the human stakes**
❌ "This initiative will improve operational efficiency by 12%."
✅ "This means the team stops doing 3 hours of manual work every week."

---

## Humanization Frameworks

### **Framework 1: The VOICE Method**

Apply in order:

```
V - Verb-first sentences (active voice)
O - Omit throat-clearing (cut first sentence if it explains you're about to write)
I - Insert one human moment (an observation, analogy, or acknowledgment)
C - Concrete nouns (replace "solution" with what the solution actually is)
E - End with momentum (what happens next, not just what was said)
```

**Example**:

❌ Before:
"In light of the recent feedback that has been received from stakeholders,
it has been determined that a reconsideration of the current approach
may be warranted. The team has been engaged in discussions regarding
potential alternative pathways forward."

✅ After:
"Stakeholder feedback was blunt: the current approach isn't working.
We've spent the last week stress-testing alternatives. Here's what we found."

---

### **Framework 2: Tone Calibration**

Match tone to audience and moment:

| Situation | Tone Target | Avoid |
|-----------|-------------|-------|
| Executive briefing | Confident, direct, no fluff | Apology, hedging |
| Team update | Clear, collegial, energizing | Overly formal, distant |
| Bad news comm | Honest, empathetic, forward-looking | Defensive, minimizing |
| User announcement | Warm, benefit-led, simple | Technical, feature-dump |
| Peer request | Collaborative, respectful | Demanding, robotic |

**Tone dial**:
```
FORMAL ←————————————————————→ CASUAL
   Corporate speak | BA writing | Team Slack | Text
                   ↑ aim here for most BA work
```

---

### **Framework 3: The Human Paragraph Model**

Each paragraph should contain:
1. **One clear claim** (what you're saying)
2. **The human consequence** (why it matters to the reader)
3. **An anchor** (example, number, or image that makes it real)

**Example**:

"The requirements doc has 47 open items. That's not a documentation problem — that's a scoping problem. Until we resolve the 6 blockers flagged in Section 3, engineering can't estimate the work and we're running blind on timeline."

Three sentences. Claim → Consequence → Anchor.

---

### **Framework 4: Sentence Rhythm**

Natural writing varies sentence length. Monotony kills engagement.

**Rhythm pattern** (mix short and long):
- Short punch. (3–8 words)
- Medium sentence with context or explanation. (10–18 words)
- Longer sentence that builds a complete picture, shows nuance, or walks the reader through complexity. (20–30 words)
- Then short again.

**Test**: Read your writing aloud. If you never need to pause, it's too flat. If you lose breath mid-sentence, it's too long.

---

## Rewriting Checklist

Before delivering humanized content:

**Voice**:
- [ ] Active verbs lead sentences?
- [ ] First-person used appropriately ("we" for team, "I" for direct asks)?
- [ ] No "it has been noted that..." or "one might suggest that..."?

**Clarity**:
- [ ] Jargon replaced with plain meaning?
- [ ] Every acronym spelled out on first use?
- [ ] Point clear in first 2 sentences?

**Warmth**:
- [ ] At least one human acknowledgment (a challenge, a win, the reader's reality)?
- [ ] Stakes clear for the reader — not just what happened, but why it matters to them?
- [ ] Appropriate empathy in sensitive messages?

**Rhythm**:
- [ ] Sentence length varies?
- [ ] No paragraph over 5 sentences?
- [ ] Read aloud — does it sound like a person?

---

## Humanization by Document Type

### **Email**
```
Subject: [Clear, specific — not "FYI" or "Following up"]
Line 1: One sentence stating the point.
Body: 2–4 short paragraphs. One idea each.
Close: Specific ask or next step. Not "please let me know your thoughts."
```

### **Exec Summary**
```
Para 1: Situation + So what (3 sentences max)
Para 2: What we found / what we recommend (3–5 bullets if needed)
Para 3: Decision needed / next step
[No intro. No "The purpose of this document is to..."]
```

### **Stakeholder Update**
```
[Project Name] — [Date]
Status: Green / Amber / Red
1 sentence: Where we are
1 sentence: What changed since last update
1 sentence: What we need (if anything)
Next check-in: [Date]
```

### **Requirement Statement**
```
❌ "The system shall provide functionality to enable users to..."
✅ "Users can [action] from [where], so that [outcome]."
```

---

## Common AI Phrases to Eliminate

| AI phrase | Human replacement |
|-----------|------------------|
| "Certainly!" / "Absolutely!" | (Delete. Just respond.) |
| "It's worth noting that..." | Just say the thing |
| "In order to..." | "To..." |
| "Utilize" | "Use" |
| "Leverage" (non-financial) | "Use" / "Apply" |
| "At this point in time" | "Now" |
| "Due to the fact that" | "Because" |
| "In the event that" | "If" |
| "Moving forward" | "Next" / (delete) |
| "Touch base" | "Talk" / "Meet" |
| "Synergize" | Describe the actual collaboration |
| "Circle back" | Give a specific time |
| "Per my last email" | (Restate the point, don't passive-aggress) |
| "Please find attached" | "Attached: [filename]" |
| "I hope this helps!" | (Delete — let the content speak) |

---

## Usage Examples

```
/humanization "Rewrite this stakeholder email to sound less formal"
/humanization "Make this exec summary less AI-generated"
/humanization "Convert this technical finding into plain language for end users"
/humanization "Soften this change communication without losing the message"
```

---

## Standards Applied

- **Plain Language** (Federal Plain Language Guidelines)
- **Readability**: Hemingway principles — short words, short sentences
- **Empathy**: Change management communication best practices
- **Storytelling**: Barbara Minto's Pyramid Principle (adapted for warmth)
