---
name: business-case-building
description: "Build complete, credible business cases — problem statement, options analysis, cost-benefit, risk assessment, and executive recommendation. Use when you need to secure funding, approval, or resource commitment for an initiative."
allowed-tools: Write
metadata:
  version: "1.0"
  claude-code:
    context: fork
    agent: Explore
    user-invocable: true
---

# Business Case Building Skill for BA

A business case is not a document. It is a decision-making instrument. Build it like one.

## What is a Business Case?

**Definition**: A structured argument — backed by data, options analysis, and financial justification — that enables decision-makers to allocate resources with confidence.

**Why it matters**:
- Without a business case, you're asking for money on faith
- A weak business case gets rejected or endlessly deferred
- A strong business case survives scrutiny, challenge, and stakeholder politics
- The process of building one often reveals whether the initiative is worth doing

**When to Use**:
- ✅ Securing budget approval for a new initiative
- ✅ Justifying a build vs buy vs partner decision
- ✅ Competing for resource allocation in a planning cycle
- ✅ Getting executive sign-off on a major project
- ✅ Responding to "show me the business case for this"

---

## Business Case Architecture

### **The 7-Section Structure**

```
1. EXECUTIVE SUMMARY         → 1 page. The entire case in miniature.
2. PROBLEM STATEMENT         → What pain exists and who feels it
3. STRATEGIC CONTEXT         → Why this matters to the organization now
4. OPTIONS ANALYSIS          → What we considered and why we chose this
5. FINANCIAL ANALYSIS        → Costs, benefits, NPV, ROI, payback
6. RISK ASSESSMENT           → What could go wrong and how we'll handle it
7. RECOMMENDATION & ASK      → What you want approved, by whom, by when
```

---

## Section 1: Executive Summary

Write this last. It should work as a standalone document.

**Format**:
```
SITUATION:
[2-3 sentences. What is happening that created this need?]

OPPORTUNITY:
[1-2 sentences. What value exists if we act?]

RECOMMENDATION:
[1 sentence. What you are proposing, at what investment.]

FINANCIAL SUMMARY:
  Investment:    $[Amount]
  Annual benefit: $[Amount]
  NPV (3-year):  $[Amount]
  Payback:       [X months]
  IRR:           [X%]

KEY RISKS:
[2-3 bullet points. Top risks and mitigation approach.]

ASK:
[Specific approval requested, from whom, by when.]
```

---

## Section 2: Problem Statement

### **The Problem Statement Formula**:

```
CURRENT STATE:
[What is happening today? Describe the pain with specifics.]

EVIDENCE:
[Data that proves the problem is real and significant.]

AFFECTED PARTIES:
[Who experiences this problem? At what scale?]

COST OF PROBLEM:
[Quantified impact: time, money, risk, customer impact.]

ROOT CAUSE:
[Why does this problem exist? (not symptoms)]
```

### **Problem Validation Test**:

Before writing the section, confirm:
- [ ] You've spoken to the people experiencing the problem (not just about them)
- [ ] You have at least 2 data points supporting the scale
- [ ] The problem statement has been reviewed by a stakeholder who agreed it's accurate
- [ ] The root cause is one level deeper than the obvious symptom

---

## Section 3: Strategic Context

### **Link the Initiative to Strategy**:

```
ORGANIZATIONAL PRIORITY:     [Named strategic goal / pillar]
HOW THIS CONTRIBUTES:        [Direct connection]
WHAT WE LOSE WITHOUT IT:     [Strategic cost of not acting]
MARKET / COMPETITIVE CONTEXT: [External driver if relevant]
TIMING:                       [Why this planning cycle?]
```

### **Strategic Alignment Table**:

| Company Goal | Initiative Contribution | Evidence |
|-------------|------------------------|----------|
| [Goal 1]    | [Direct link]          | [Metric] |
| [Goal 2]    | [Direct link]          | [Metric] |

---

## Section 4: Options Analysis

Never present only one option. Decision-makers distrust single-option cases.

### **Standard Options Structure**:

```
OPTION 0: Do Nothing (always include this)
  Description: Continue current state
  Pros: No investment, no disruption
  Cons: [Cost of inaction — specific and quantified]
  Risk: [What compounds over time]

OPTION 1: [Minimal viable approach]
  Description: [What it is]
  Investment: $[Cost]
  Benefits: [What it delivers]
  Pros: [Why someone might choose this]
  Cons: [What it doesn't solve]
  Risk: [Key risks]

OPTION 2: [Recommended approach]
  Description: [What it is]
  Investment: $[Cost]
  Benefits: [What it delivers]
  Pros: [Why this is recommended]
  Cons: [What it doesn't solve]
  Risk: [Key risks]

OPTION 3: [Full / maximal approach]
  Description: [What it is]
  Investment: $[Cost]
  Benefits: [What it delivers]
  Pros: [Maximum value]
  Cons: [Cost, risk, complexity]
  Risk: [Key risks]
```

### **Options Comparison Matrix**:

| Criteria | Weight | Option 0 | Option 1 | Option 2* | Option 3 |
|----------|--------|----------|----------|-----------|----------|
| Financial return | 30% | 0/5 | 2/5 | 4/5 | 5/5 |
| Implementation risk | 25% | 5/5 | 4/5 | 4/5 | 2/5 |
| Strategic alignment | 20% | 0/5 | 3/5 | 5/5 | 5/5 |
| Time to value | 15% | 0/5 | 5/5 | 4/5 | 2/5 |
| Operational impact | 10% | 0/5 | 3/5 | 4/5 | 4/5 |
| **WEIGHTED SCORE** | | 0.75 | 3.35 | **4.30** | 3.80 |

*Recommended option

---

## Section 5: Financial Analysis

### **Cost Identification Framework**

```
ONE-TIME COSTS:
  Software / licenses:           $[Amount]
  Implementation / professional: $[Amount]
  Hardware / infrastructure:     $[Amount]
  Internal labour (project):     $[Amount]
  Training and change management:$[Amount]
  Data migration:                $[Amount]
  Testing and quality assurance: $[Amount]

ONGOING COSTS (annual):
  Licence / subscription:        $[Amount]
  Maintenance and support:       $[Amount]
  Internal labour (run):         $[Amount]
  Training (new joiners):        $[Amount]

CONTINGENCY:                     [15-20% of total for new tech, 10% for known solutions]

TOTAL INVESTMENT:                $[Sum]
```

### **Benefit Identification Framework**

```
HARD BENEFITS (directly measurable):
  Labour savings: [N hrs/month × $rate × 12]           = $[Amount]
  Error/rework reduction: [N errors × $cost × 12]      = $[Amount]
  Infrastructure savings: [Current cost - new cost]     = $[Amount]
  Revenue enabled: [New capability × conversion × ASP]  = $[Amount]

SOFT BENEFITS (harder to quantify — include but flag as directional):
  Faster decision-making: [Reduced reporting lag → estimate value]
  Employee satisfaction: [Reduced attrition proxy]
  Customer experience: [NPS improvement → revenue model]
  Risk reduction: [Probability × impact reduction]

TOTAL ANNUAL BENEFIT: $[Sum]
```

### **Key Financial Metrics**

```excel
# Net Present Value (using 8% discount rate as default, adjust for your org)
NPV = Σ [Annual_Benefit / (1 + rate)^year] - Initial_Investment

# Payback Period
Payback = Initial_Investment / Annual_Net_Benefit
(or find the year when cumulative cashflow turns positive)

# Return on Investment
ROI = (Total_Benefits - Total_Costs) / Total_Costs × 100%

# Internal Rate of Return
IRR = the discount rate at which NPV = 0
(should exceed your org's hurdle rate, typically 8-15%)
```

### **3-Year Financial Summary Table**:

| | Year 0 | Year 1 | Year 2 | Year 3 | Total |
|--|--------|--------|--------|--------|-------|
| One-time costs | ($X) | - | - | - | ($X) |
| Ongoing costs | - | ($Y) | ($Y) | ($Y) | ($3Y) |
| Benefits | - | $Z | $Z | $Z | $3Z |
| Net cashflow | ($X) | $Z-Y | $Z-Y | $Z-Y | |
| Cumulative | ($X) | | | | |
| **NPV** | | | | | **$[NPV]** |
| **Payback** | | **Month X** | | | |
| **IRR** | | | | | **X%** |

---

## Section 6: Risk Assessment

### **Risk Register**:

| ID | Risk | Probability | Impact | Score | Mitigation | Owner | Residual |
|----|------|------------|--------|-------|-----------|-------|---------|
| R1 | [Risk] | H/M/L | H/M/L | H×H=9 | [Action] | [Name] | M |

**Risk categories for business cases**:
- Financial: Cost overrun, benefit shortfall, FX/inflation
- Delivery: Scope creep, resource availability, vendor delivery
- Technical: Integration complexity, data quality, scalability
- Adoption: Change resistance, training gaps, stakeholder engagement
- Regulatory: Compliance, legal, audit
- Strategic: Priority shift, competing initiative, org change

### **Risk Scoring**:
```
Probability: High=3, Medium=2, Low=1
Impact:      High=3, Medium=2, Low=1
Score = P × I: 7-9=Red, 4-6=Amber, 1-3=Green
```

### **Risk Mitigation Strategies**:
```
AVOID:    Eliminate the risk by changing approach
REDUCE:   Lower probability or impact through action
TRANSFER: Shift risk to vendor, insurer, or partner
ACCEPT:   Acknowledge and monitor — with contingency ready
```

---

## Section 7: Recommendation & Ask

### **The Recommendation Statement**:

```
RECOMMENDED: [Option X]

BECAUSE:
1. [Primary financial reason — with number]
2. [Strategic alignment reason]
3. [Risk/timing reason]

INVESTMENT REQUIRED:
  Total: $[Amount]
  Phase 1: $[Amount] by [Date]

EXPECTED RETURN:
  Annual benefit: $[Amount]
  Payback: [X months]
  3-year NPV: $[Amount]

ASK:
  FROM: [Decision-maker name/role]
  APPROVE: [Specific approval — budget, headcount, vendor contract]
  BY: [Decision date — with rationale for urgency]

NEXT STEPS IF APPROVED:
  [Date]: [Owner] kicks off [Action]
  [Date]: [Owner] completes [Action]
  [Date]: First milestone / go-live
```

---

## Business Case Quality Checklist

**Completeness**:
- [ ] Executive summary stands alone?
- [ ] Problem quantified (not just described)?
- [ ] Minimum 3 options (including do-nothing)?
- [ ] Both costs AND benefits identified?
- [ ] Risks have mitigations (not just identification)?
- [ ] Explicit ask with owner and date?

**Credibility**:
- [ ] Data sources cited?
- [ ] Assumptions documented and defensible?
- [ ] Sensitivity analysis for key assumptions?
- [ ] Benefits conservatively estimated (not best-case)?
- [ ] Reviewed by a skeptic before submission?

**Persuasiveness**:
- [ ] Problem is real and felt by the approver?
- [ ] Strategic connection is explicit?
- [ ] Cost of inaction is clear?
- [ ] Recommended option is unambiguously preferred?
- [ ] Ask is specific and actionable?

---

## Sensitivity Analysis

Test how robust your case is to assumption changes:

```
BASE CASE: Benefits at 100%, Costs at 100% → NPV = $X

CONSERVATIVE: Benefits at 70%, Costs at 120% → NPV = $Y
(If still positive, your case is robust)

OPTIMISTIC: Benefits at 120%, Costs at 90% → NPV = $Z

BREAK-EVEN: At what benefit level does NPV = 0?
  → If break-even is at 45% of benefits, very robust
  → If break-even is at 85% of benefits, highly sensitive — flag this
```

---

## Usage Examples

```
/business-case-building "Build a business case for replacing our manual reporting process — $150K estimated cost"
/business-case-building "What sections does a board-level business case need?"
/business-case-building "Create an options analysis for build vs buy vs partner for a new CRM"
/business-case-building "Write the financial summary section for a platform migration with $500K investment"
/business-case-building "How do I build a sensitivity analysis for my NPV model"
```

---

## Standards Applied

- **HM Treasury Green Book** (UK government business case standard — the gold standard)
- **BABOK v3** (Needs Assessment, Business Case knowledge area)
- **PMBOK** (Project justification and charter)
- **McKinsey** (Options analysis, pyramid principle)
- **FAST Financial Modelling Standard** (Excel model structure)
- **ISO 31000** (Risk management)
