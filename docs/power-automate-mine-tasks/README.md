# Mine Site Work Task Management System
## Microsoft Power Platform Solution

**Version:** 1.0  
**Platform:** Microsoft Power Platform (Power Automate + Power Apps + SharePoint + Teams)  
**Departments:** Mine Planning | Mine Services | Load & Haul | Drill & Blast | Dragline

---

## What This System Does

This solution automates the full lifecycle of mine site work tasks — from creation by a planner, through supervisor scoping and scheduling, to execution and completion reporting on the day.

```
PLANNER              SUPERVISOR           TASK SCHEDULER       SUPERVISOR (Day-of)
   |                     |                     |                     |
[Creates Task] --> [Scopes Task] -------> [Schedules Task] --> [Executes Task]
   |                     |                     |                     |
   v                     v                     v                     v
SharePoint          Teams Alert          Calendar Entry         Completion
WorkTasks List      + Approval Form      + Reminders            Report + Notifications
```

---

## Departments Supported

| # | Department | Typical Tasks |
|---|-----------|---------------|
| 1 | Mine Planning | Survey, grade control, blast design, resource modelling |
| 2 | Mine Services | Dewatering, road maintenance, environmental monitoring |
| 3 | Load & Haul | Truck allocation, shovel moves, payload checks |
| 4 | Drill & Blast | Drill pattern setup, blast prep, firing execution, misfires |
| 5 | Dragline | Dragline moves, pre-strip blasting, stripping operations |

---

## System Components

| Component | Tool | Purpose |
|-----------|------|---------|
| Task Data Store | SharePoint Online | Stores all tasks, status, history |
| Task Entry Form | Power Apps | Planner enters new tasks |
| Workflow Engine | Power Automate (5 flows) | Automates notifications and approvals |
| Notifications | Microsoft Teams + Outlook | Alerts for each stage |
| Completion Register | SharePoint List | Full audit trail of completed tasks |
| Reporting | Power BI (optional) | Dashboard of task status by department |

---

## The 5 Power Automate Flows

| Flow | Name | Trigger | Purpose |
|------|------|---------|---------|
| 1 | Task Initiated | New SharePoint item | Notifies supervisor task needs scoping |
| 2 | Task Scoped | Status → "Scoped" | Notifies scheduler task is ready |
| 3 | Scheduled Task Reminder | Daily at 4 PM | Alerts supervisor of next-day tasks |
| 4 | Execution Day Briefing | Daily at 6 AM | Morning pack for supervisor |
| 5 | Task Completed | Status → "Completed" | Notifies management + logs to register |

---

## Documents in This Guide

| File | Description |
|------|-------------|
| [01-overview-and-architecture.md](./01-overview-and-architecture.md) | Full system design and process map |
| [02-sharepoint-lists-setup.md](./02-sharepoint-lists-setup.md) | How to create the SharePoint lists |
| [03-flow1-task-initiation.md](./03-flow1-task-initiation.md) | Flow 1: Task created → Notify supervisor |
| [04-flow2-supervisor-scoping.md](./04-flow2-supervisor-scoping.md) | Flow 2: Task scoped → Notify scheduler |
| [05-flow3-scheduled-reminder.md](./05-flow3-scheduled-reminder.md) | Flow 3: Day-before reminder |
| [06-flow4-execution-day.md](./06-flow4-execution-day.md) | Flow 4: Execution day morning briefing |
| [07-flow5-task-completion.md](./07-flow5-task-completion.md) | Flow 5: Completion → Management report |
| [08-powerapps-task-form.md](./08-powerapps-task-form.md) | Power Apps task entry form |
| [09-teams-channels-setup.md](./09-teams-channels-setup.md) | Teams channel configuration |
| [10-testing-guide.md](./10-testing-guide.md) | Full end-to-end testing checklist |

---

## Prerequisites

Before you begin, ensure you have:

- [ ] Microsoft 365 Business Standard or higher licence
- [ ] Power Automate licence (included with M365 Business Standard)
- [ ] Power Apps licence (included with M365 Business Standard)
- [ ] SharePoint Online site created (e.g., `https://yourcompany.sharepoint.com/sites/MineTasks`)
- [ ] Microsoft Teams workspace set up
- [ ] Admin or Site Owner access to SharePoint
- [ ] A list of supervisor email addresses for each department
- [ ] A list of department manager email addresses

---

## Quick Start

1. Start with **[02-sharepoint-lists-setup.md](./02-sharepoint-lists-setup.md)** — create your lists first
2. Set up your **[Teams channels](./09-teams-channels-setup.md)**
3. Build each flow in order: **Flow 1 → Flow 2 → Flow 3 → Flow 4 → Flow 5**
4. Build the **[Power Apps form](./08-powerapps-task-form.md)**
5. Run through the **[testing guide](./10-testing-guide.md)**

---

## Estimated Setup Time

| Task | Time (Beginner) |
|------|----------------|
| SharePoint lists | 45 minutes |
| Flow 1 | 30 minutes |
| Flow 2 | 25 minutes |
| Flow 3 | 35 minutes |
| Flow 4 | 35 minutes |
| Flow 5 | 40 minutes |
| Power Apps form | 60 minutes |
| Teams setup | 20 minutes |
| Testing | 45 minutes |
| **Total** | **~5.5 hours** |

---

*Built for mine site operations. Modify department names, email addresses, and SharePoint site URLs to match your environment before building.*
