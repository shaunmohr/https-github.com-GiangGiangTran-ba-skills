# Document 1: System Overview and Architecture

---

## 1.1 The Business Problem

Mine site operations across departments like **Load & Haul**, **Drill & Blast**, **Dragline**, **Mine Planning**, and **Mine Services** involve dozens of daily work tasks. Without a structured system:

- Tasks are communicated verbally or via paper, leading to missed handovers
- Supervisors don't have visibility of what is planned for their shift
- There is no audit trail of who approved, scheduled, or executed a task
- Management have no live view of task completion across departments

This Power Platform solution solves all of these problems.

---

## 1.2 End-to-End Process Map

```
STAGE 1: INITIATION
━━━━━━━━━━━━━━━━━━
Planner/Scheduler opens Power Apps form
  ↓
Enters task details: title, department, description, priority, 
                     supervisor, safety requirements
  ↓
Submits form → Task saved to SharePoint [WorkTasks] list
  ↓
Status set to: INITIATED
  ↓
[FLOW 1 TRIGGERS] → Teams card + Email sent to assigned Supervisor

──────────────────────────────────────────────────────────────────

STAGE 2: SCOPING
━━━━━━━━━━━━━━━━
Supervisor receives Teams notification
  ↓
Opens task in Power Apps
  ↓
Reviews task, adds:
  - Crew members required
  - Equipment required
  - Permits/SWMS required
  - Estimated duration
  - Scope notes
  - Confirms risk rating
  ↓
Clicks "Submit Scope" → Status updated to: SCOPED
  ↓
[FLOW 2 TRIGGERS] → Teams card + Email sent to Task Scheduler

──────────────────────────────────────────────────────────────────

STAGE 3: SCHEDULING
━━━━━━━━━━━━━━━━━━━
Task Scheduler receives notification
  ↓
Opens task in SharePoint or Power Apps
  ↓
Sets:
  - Scheduled Date
  - Scheduled Start Time
  - Crew shift (Day / Afternoon / Night)
  ↓
Clicks "Confirm Schedule" → Status updated to: SCHEDULED
  ↓
[FLOW 3 TRIGGERS at 4 PM the day before] → 
    Reminder sent to Supervisor (tomorrow's tasks briefing)

──────────────────────────────────────────────────────────────────

STAGE 4: EXECUTION (Day Of)
━━━━━━━━━━━━━━━━━━━━━━━━━━━
[FLOW 4 TRIGGERS at 6 AM on scheduled date] →
    Morning briefing card sent to Supervisor via Teams
    Card shows: all tasks for today, crew, equipment, permits
  ↓
Supervisor executes task with crew on site
  ↓
Opens Power Apps on tablet/phone
  ↓
Records:
  - Actual start time
  - Completion time
  - Crew who executed
  - Any issues encountered
  - Completion photo (optional)
  ↓
Clicks "Mark Complete" → Status updated to: COMPLETED

──────────────────────────────────────────────────────────────────

STAGE 5: COMPLETION REPORTING
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
[FLOW 5 TRIGGERS] →
    - Teams message posted to Management channel
    - Email sent to Department Manager
    - Record written to [CompletionRegister] list
    - If task was Critical: escalation email to Mine Manager
```

---

## 1.3 Role Definitions

| Role | Responsibility in This System | Typical Person |
|------|------------------------------|----------------|
| **Planner / Scheduler** | Creates tasks, assigns to supervisor, sets priority | Mine Planner, Short-Term Planner |
| **Supervisor** | Scopes task (crew/equipment/permits), executes and signs off | Shift Supervisor, Crew Boss |
| **Task Scheduler** | Locks in date, time, and shift for approved tasks | Production Scheduler |
| **Department Manager** | Receives completion summaries, views dashboard | Superintendent, Manager |
| **System Admin** | Maintains SharePoint lists, manages flow errors | IT / Power Platform Admin |

---

## 1.4 SharePoint Data Architecture

```
SharePoint Site: "MineSiteTasks"
https://[yourcompany].sharepoint.com/sites/MineSiteTasks

├── Lists
│   ├── WorkTasks          ← Main task register (all stages)
│   ├── CompletionRegister ← Completed task audit log
│   └── DepartmentContacts ← Supervisor & manager email lookup
│
└── Document Library
    └── TaskAttachments    ← SWMS, permits, completion photos
```

---

## 1.5 Status Lifecycle

```
[INITIATED] → [SCOPED] → [SCHEDULED] → [IN PROGRESS] → [COMPLETED]
                                                              ↑
                                                         or [CANCELLED]
```

| Status | Set By | Meaning |
|--------|--------|---------|
| INITIATED | Power Apps (auto) | Task created by planner, awaiting supervisor scoping |
| SCOPED | Supervisor | Crew, equipment, permits defined |
| SCHEDULED | Task Scheduler | Date and time locked in |
| IN PROGRESS | Flow 4 (auto, 6 AM) | Execution day has arrived |
| COMPLETED | Supervisor (Power Apps) | Task done, signed off |
| CANCELLED | Supervisor or Planner | Task not proceeding |

---

## 1.6 Notifications Summary

| Event | Who Gets Notified | Channel |
|-------|------------------|---------|
| Task Created | Assigned Supervisor | Teams + Email |
| Task Scoped | Task Scheduler + department channel | Teams + Email |
| Day Before Execution | Assigned Supervisor | Teams + Email |
| Execution Day (6 AM) | Assigned Supervisor | Teams Adaptive Card |
| Task Completed | Department Manager + Management Teams channel | Teams + Email |
| Critical Task Completed | Mine Manager | Email escalation |

---

## 1.7 Microsoft Licencing Requirements

| Feature Used | Licence Required |
|-------------|-----------------|
| Power Automate flows (standard connectors) | Power Automate (included in M365 Business Standard) |
| SharePoint Online | Microsoft 365 Business Standard or higher |
| Power Apps Canvas App | Power Apps (included in M365 Business Standard) |
| Teams integration | Microsoft Teams (included in M365) |
| Outlook connector | Microsoft 365 |

> **Note:** All connectors used in this solution (SharePoint, Teams, Outlook, Office 365 Users) are **standard connectors** — no premium licence is required.

---

## 1.8 Flow Trigger Strategy

| Flow | Trigger Type | Why |
|------|-------------|-----|
| Flow 1 | SharePoint "When item created" | Fires immediately when planner submits |
| Flow 2 | SharePoint "When item modified" | Fires when supervisor updates status to SCOPED |
| Flow 3 | Scheduled recurrence (daily 4 PM) | Queries tomorrow's tasks each afternoon |
| Flow 4 | Scheduled recurrence (daily 6 AM) | Queries today's tasks each morning |
| Flow 5 | SharePoint "When item modified" | Fires when supervisor marks COMPLETED |

---

## 1.9 Beginner Tips Before You Start

1. **Use a test SharePoint site first** — Don't build on a live production site until you have tested everything
2. **Name your flows clearly** — e.g., `MineTasks_Flow1_TaskInitiated` makes them easy to find later
3. **Always save after each action** — Power Automate auto-saves but clicking Save manually is good practice
4. **Use "Test" button** — Every flow has a Test button in the top right; use it after each build
5. **Check "Flow checker"** — The orange triangle icon in Power Automate flags errors before you save
6. **Replace placeholders** — Anywhere you see `[YOUR_TENANT]`, `[SITE_URL]`, or `[EMAIL]` — replace with your real values
7. **Start simple** — Build Flow 1 first and test it fully before moving to Flow 2
