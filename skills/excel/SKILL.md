---
name: excel
description: "Master Excel for BA work — build models, structure data, write formulas, design dashboards, and create business-ready outputs. Use when analyzing data, building financial models, creating trackers, or preparing Excel-based deliverables."
allowed-tools: Write
metadata:
  version: "1.0"
  claude-code:
    context: fork
    agent: Explore
    user-invocable: true
---

# Excel Skill for BA

Excel is still where business decisions get made. Know it like a professional.

## What is Excel for BA?

**Definition**: Using Excel as a professional-grade analysis and communication tool — not just a spreadsheet, but a structured, auditable, presentation-ready business instrument.

**Why it matters**:
- Poorly structured Excel = errors that kill business cases
- No documentation = nobody trusts your model
- Bad formatting = executives won't engage with the data
- Wrong formula choice = analysis that misleads

**When to Use**:
- ✅ Financial models (cost-benefit, ROI, breakeven)
- ✅ Data analysis (pivot tables, trend analysis)
- ✅ Project trackers and RAID logs
- ✅ Requirement traceability matrices
- ✅ Stakeholder and decision registers
- ✅ Dashboard-style reports

---

## Excel File Structure

### **The Golden Rule: Separate Inputs, Calculations, and Outputs**

```
TAB STRUCTURE:
📋 README       → Purpose, owner, version, how to use
📥 INPUTS       → All assumptions and variables (clearly labeled)
⚙️ CALC_[Name]  → Calculations only (reference inputs, never hard-code here)
📊 OUTPUT       → Summary, charts, results formatted for audience
🗂️ RAW_DATA    → Source data (do not modify, treat as locked)
```

**Why**:
- Change one input → everything updates
- Auditors and reviewers can trace every number
- Reduces error surface dramatically

---

## BA Formula Toolkit

### **Lookup & Reference**

```excel
# Find value in table by key
=VLOOKUP(lookup_value, table_range, col_index, FALSE)

# Preferred modern alternative (works left-to-right)
=INDEX(return_range, MATCH(lookup_value, search_range, 0))

# Multi-condition lookup (Excel 365)
=XLOOKUP(lookup_value, lookup_array, return_array, "Not found")

# Multiple condition lookup
=INDEX(C:C, MATCH(1, (A:A="criteria1")*(B:B="criteria2"), 0))
```

### **Conditional Logic**

```excel
# Basic if
=IF(A1>100, "Above target", "Below target")

# Nested conditions (use IFS for clarity)
=IFS(A1>=90, "Excellent", A1>=70, "Good", A1>=50, "Average", TRUE, "Below")

# Count with condition
=COUNTIF(range, "criteria")
=COUNTIFS(range1, "crit1", range2, "crit2")

# Sum with condition
=SUMIF(condition_range, "criteria", sum_range)
=SUMIFS(sum_range, range1, "crit1", range2, "crit2")
```

### **Date & Time**

```excel
# Days between dates
=NETWORKDAYS(start_date, end_date)          # Excludes weekends
=DATEDIF(start, end, "D")                  # Calendar days

# Add business days
=WORKDAY(start_date, num_days)

# Extract parts
=YEAR(date), =MONTH(date), =WEEKDAY(date)

# Date text to date value
=DATEVALUE("2026-03-15")
```

### **Financial**

```excel
# Net Present Value
=NPV(discount_rate, cashflow_year1:cashflow_yearN) + initial_investment

# Internal Rate of Return
=IRR(cashflows_range)

# Present Value of single amount
=PV(rate, nper, pmt, fv)

# Payback period (not built-in — see model below)
```

### **Text Manipulation**

```excel
=TRIM(A1)                          # Remove extra spaces
=UPPER(A1), =LOWER(A1), =PROPER(A1)
=LEFT(A1, 5), =RIGHT(A1, 3), =MID(A1, 3, 4)
=LEN(A1)
=CONCATENATE(A1, " ", B1)          # or =A1&" "&B1
=TEXT(A1, "$#,##0")               # Format number as text
=SUBSTITUTE(A1, "old", "new")      # Replace text
=FIND("text", A1)                  # Position of string
```

---

## Business Models in Excel

### **Model 1: Cost-Benefit Analysis**

```
INPUTS tab:
  Project cost (one-time):         $500,000
  Ongoing cost (annual):            $50,000
  Labour savings (annual):         $200,000
  Error reduction savings (annual): $80,000
  Discount rate:                       8%
  Horizon (years):                      5

CALCULATIONS tab:
  Year 0: -$500,000 (initial investment)
  Year 1-5: +$230,000 - $50,000 = +$180,000 net annual benefit
  NPV = =NPV(8%, B3:B7) + B2   → should be positive
  IRR = =IRR(B2:B7)             → should exceed discount rate
  Payback = Year when cumulative cashflow turns positive

OUTPUT tab:
  Summary table + NPV/IRR/Payback + recommendation
```

### **Model 2: Effort Estimation Tracker**

```
Columns: | ID | Feature | Size (S/M/L/XL) | Hours | Resource | Sprint | Status |

Size → Hours mapping (INPUTS tab):
  S = 4 hrs
  M = 16 hrs
  L = 40 hrs
  XL = 80 hrs

Formula: =VLOOKUP(C2, SizeTable, 2, FALSE)

Auto-sum by sprint: =SUMIF(F:F, "Sprint 1", E:E)
Auto-sum by resource: =SUMIF(G:G, "Dev A", E:E)
```

### **Model 3: RAID Log**

```
Tabs: Risks | Actions | Issues | Decisions

Risk columns: ID | Category | Description | Probability | Impact | Score |
  Owner | Mitigation | Status | Due Date | Last Updated

Score formula: =IF(D2="High",3,IF(D2="Medium",2,1)) * IF(E2="High",3,IF(E2="Medium",2,1))

Conditional formatting: Score ≥6 = Red, Score 3-5 = Amber, Score ≤2 = Green
```

---

## Pivot Tables: The BA Superpower

### **When to use**:
- Summarizing large datasets fast
- Cross-tabulating (rows by columns)
- Finding patterns by category or time period

### **Pivot Table best practice**:

```
BEFORE building:
- [ ] Data is in a table format (Ctrl+T)
- [ ] Every column has a header
- [ ] No merged cells in source data
- [ ] Dates are actual date values (not text)
- [ ] No blank rows in data

BUILD:
1. Insert → PivotTable → New worksheet
2. Drag dimensions to Rows/Columns
3. Drag measures to Values (set aggregation: Sum/Count/Average)
4. Add Filters/Slicers for interactivity

CALCULATED FIELDS:
  Insert → PivotTable → Calculated Field
  Formula: = Revenue / Units    (creates derived metric)
```

---

## Excel Dashboard Design

### **Dashboard Rules**:
1. One page. One screen. No scrolling.
2. Three sections: Status summary (top), Charts (middle), Details (bottom if needed)
3. Use slicers/dropdowns for interactivity — not multiple tabs
4. Traffic light colours: Red (problem), Amber (watch), Green (on track)
5. Charts above data tables — insights before evidence

### **Chart best practices in Excel**:
```
- Remove gridlines (Format gridlines → None)
- Remove legend if only one series; label directly instead
- Title = insight, not label
- Use Excel's "Add Data Labels" and position inside/outside end
- Set axis min/max manually to control zoom
- Use consistent colour palette (define as Theme Colours)
```

---

## Data Cleaning Checklist

Before analyzing any dataset:

- [ ] Check for duplicates: Data → Remove Duplicates
- [ ] Trim whitespace: =TRIM() on text columns
- [ ] Check date formats: Format Cells → Date → confirm Excel recognizes as date
- [ ] Find blanks: Ctrl+G → Special → Blanks
- [ ] Check for text numbers: Columns showing left-alignment when should be right-aligned
- [ ] Freeze header row: View → Freeze Panes → Freeze Top Row
- [ ] Convert to Table: Ctrl+T (enables structured references and auto-expansion)

---

## Excel as a Communication Tool

### **Formatting for Executives**:
- Font: Calibri 11pt (body) / 14pt (headers)
- Colour palette: 2–3 max, from your org's brand
- Borders: Minimal — outer border only, or top/bottom of data sections
- Numbers: Use comma format (#,##0) and currency ($#,##0)
- Percentages: One decimal place (0.0%) unless whole numbers suffice
- Highlight key cells: Light yellow fill for inputs; light blue for outputs

### **Protecting Your Model**:
- Lock input cells: Review → Protect Sheet → allow only unlocked cells
- Mark inputs clearly: Named ranges, coloured headers
- Add data validation: Data → Data Validation (dropdown lists, number limits)
- Version control: Save as v1, v2 etc. or use SharePoint version history

---

## Excel Shortcuts for BA Efficiency

```
Navigation:
Ctrl+End           → Last used cell in sheet
Ctrl+Home          → Cell A1
Ctrl+Arrow         → Jump to last non-empty cell
Ctrl+Shift+Arrow   → Select to last non-empty cell

Editing:
F2                 → Edit cell
F4                 → Repeat last action / toggle absolute reference ($)
Ctrl+D             → Fill Down
Ctrl+R             → Fill Right
Alt+Enter          → New line within cell
Ctrl+;             → Insert today's date

Formatting:
Ctrl+1             → Format Cells dialog
Ctrl+Shift+$       → Currency format
Ctrl+Shift+%       → Percent format
Ctrl+Shift+#       → Date format
Alt+H+H            → Highlight/fill color

Analysis:
Alt+D+P            → PivotTable wizard (older shortcut)
Alt+F1             → Create chart from selection
F11                → Chart in new sheet
```

---

## Usage Examples

```
/excel "Build a cost-benefit model for a $300K project with 3-year horizon"
/excel "Structure a RAID log template for an enterprise migration project"
/excel "What pivot table setup would show monthly revenue by product and region"
/excel "How do I calculate payback period in Excel for an NPV model"
/excel "Design an effort estimation tracker for a sprint-based delivery team"
```

---

## Standards Applied

- **Financial Modelling Best Practices** (FAST Standard)
- **Excel Best Practices** (ICAEW Financial Modelling Code)
- **Data Analysis**: Descriptive and inferential statistics fundamentals
- **PMBOK**: Project tracking and reporting standards
