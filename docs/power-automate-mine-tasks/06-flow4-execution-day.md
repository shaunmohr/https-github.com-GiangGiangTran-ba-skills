# Document 6: Flow 4 — Execution Day Morning Briefing

---

## Overview

| Field | Value |
|-------|-------|
| **Flow Name** | `MineTasks_Flow4_ExecutionDayBriefing` |
| **Trigger** | Scheduled — runs every day at 6:00 AM |
| **Purpose** | Sends the supervisor a morning briefing with today's tasks and updates their status to "In Progress" |
| **Outputs** | Teams Adaptive Card (with action buttons) + Email briefing + Status updated to "In Progress" |
| **Time to build** | ~35 minutes |

---

## Flow Logic Diagram

```
[TRIGGER] Daily at 6:00 AM
    ↓
[ACTION 1] Get today's date
    ↓
[ACTION 2] Get all WorkTasks where:
           Scheduled Date = Today AND Status = "Scheduled"
    ↓
[CONDITION] Any tasks found?
    ├── NO → Terminate
    └── YES ↓
[Apply to each task]:
    ├── [A] Update task Status → "In Progress"
    ├── [B] Send Teams Adaptive Card with action buttons to supervisor
    └── [C] Post to department Teams channel: "Task is live today"
    ↓
[ACTION 3] Send consolidated email briefing to each supervisor
```

---

## Step-by-Step Build Instructions

### Step 1: Create a New Scheduled Flow

1. Go to `https://make.powerautomate.com`
2. Click **+ Create → Scheduled cloud flow**
3. Fill in:
   - **Flow name:** `MineTasks_Flow4_ExecutionDayBriefing`
   - **Repeat every:** `1` `Day`
4. Click **Create**

---

### Step 2: Set Run Time to 6:00 AM

1. Click the **Recurrence** trigger box
2. Click **Show advanced options**
3. Set:
   - **Time zone:** Your local time zone (e.g., `(UTC+10:00) Brisbane`)
   - **At these hours:** `6`
   - **At these minutes:** `0`

---

### Step 3: Initialize Today's Date Variable

1. Click **+ New step → Initialize variable**
2. Fill in:
   - **Name:** `TodayDate`
   - **Type:** String
   - **Value:** Expression: `formatDateTime(utcNow(), 'yyyy-MM-dd')`

**Add a second variable for display:**
1. **+ New step → Initialize variable**
2. Fill in:
   - **Name:** `TodayDateDisplay`
   - **Type:** String
   - **Value:** Expression: `formatDateTime(utcNow(), 'dddd dd MMMM yyyy')`

---

### Step 4: Get Today's Tasks

1. Click **+ New step → SharePoint → Get items**
2. Fill in:
   - **Site Address:** Your SharePoint site URL
   - **List Name:** `WorkTasks`
   - **Filter Query:**
     ```
     Status/Value eq 'Scheduled' and ScheduledDate eq '@{variables('TodayDate')}'
     ```
   - **Top Count:** `50`

---

### Step 5: Condition — Any Tasks Today?

1. Click **+ New step → Condition**
2. Left: Expression: `length(body('Get_items')?['value'])`
3. Operator: `is greater than`
4. Right: `0`

---

### Step 6: YES Branch — Loop Through Tasks

Inside YES, add **Apply to each**:
- **Select output:** `value` from Get items

#### Inside the loop — Action A: Update Status to "In Progress"

1. Click **Add an action**
2. Select **SharePoint → "Update item"**
3. Fill in:
   - **Site Address:** Your SharePoint site URL
   - **List Name:** `WorkTasks`
   - **Id:** Dynamic content → `ID` (from current loop item)
   - **Status Value:** Type `In Progress`

> This changes the task's status from "Scheduled" to "In Progress" so Flow 3 won't send it again tomorrow if it wasn't completed.

---

#### Inside the loop — Action B: Send Teams Adaptive Card to Supervisor

1. Click **Add an action**
2. Select **Microsoft Teams → "Post an Adaptive Card to a Teams user"**
3. Fill in:
   - **Post as:** Flow bot
   - **Post in:** Chat with Flow bot
   - **Recipient:** Dynamic content → `Assigned Supervisor Email` from the current item
   - **Adaptive Card:**

```json
{
  "type": "AdaptiveCard",
  "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
  "version": "1.4",
  "body": [
    {
      "type": "Container",
      "style": "accent",
      "items": [
        {
          "type": "TextBlock",
          "text": "EXECUTION DAY — TASK ACTIVE TODAY",
          "weight": "Bolder",
          "size": "Large",
          "color": "Light"
        },
        {
          "type": "TextBlock",
          "text": "@{variables('TodayDateDisplay')}",
          "color": "Light",
          "size": "Medium"
        }
      ]
    },
    {
      "type": "FactSet",
      "facts": [
        {
          "title": "Task:",
          "value": "@{items('Apply_to_each')?['Title']}"
        },
        {
          "title": "Department:",
          "value": "@{items('Apply_to_each')?['Department']?['Value']}"
        },
        {
          "title": "Priority:",
          "value": "@{items('Apply_to_each')?['Priority']?['Value']}"
        },
        {
          "title": "Start Time:",
          "value": "@{items('Apply_to_each')?['ScheduledStartTime']?['Value']}"
        },
        {
          "title": "Shift:",
          "value": "@{items('Apply_to_each')?['Shift']?['Value']}"
        }
      ]
    },
    {
      "type": "Container",
      "style": "emphasis",
      "items": [
        {
          "type": "TextBlock",
          "text": "RESOURCES CONFIRMED",
          "weight": "Bolder"
        },
        {
          "type": "FactSet",
          "facts": [
            {
              "title": "Crew:",
              "value": "@{items('Apply_to_each')?['CrewRequired']}"
            },
            {
              "title": "Equipment:",
              "value": "@{items('Apply_to_each')?['EquipmentRequired']}"
            },
            {
              "title": "Permits:",
              "value": "@{items('Apply_to_each')?['PermitsRequired']}"
            },
            {
              "title": "Est. Duration:",
              "value": "@{items('Apply_to_each')?['EstimatedDurationHours']} hours"
            }
          ]
        }
      ]
    },
    {
      "type": "TextBlock",
      "text": "When the task is complete, open the Power Apps form to record completion details and mark as done.",
      "wrap": true,
      "color": "Warning",
      "weight": "Bolder"
    }
  ],
  "actions": [
    {
      "type": "Action.OpenUrl",
      "title": "Mark Task Complete (SharePoint)",
      "url": "https://[YOURCOMPANY].sharepoint.com/sites/MineSiteTasks/Lists/WorkTasks/DispForm.aspx?ID=@{items('Apply_to_each')?['ID']}"
    },
    {
      "type": "Action.OpenUrl",
      "title": "Open in Power Apps",
      "url": "https://apps.powerapps.com/play/[YOUR_APP_ID]"
    }
  ]
}
```

> Replace `[YOURCOMPANY]` and `[YOUR_APP_ID]` with your real values after setting up Power Apps.

---

#### Inside the loop — Action C: Post to Department Teams Channel

1. Click **Add an action**
2. Select **Microsoft Teams → "Post a message in a chat or channel"**
3. Fill in:
   - **Post as:** Flow bot
   - **Post in:** Channel
   - **Team:** Your mine site Teams group
   - **Channel:** Post to the **general department channel** or a `#today-tasks` channel
   - **Message:**

```
🟢 TASK LIVE TODAY — @{items('Apply_to_each')?['Department']?['Value']}

Task: @{items('Apply_to_each')?['Title']}
Supervisor: @{items('Apply_to_each')?['AssignedSupervisor']?['DisplayName']}
Start Time: @{items('Apply_to_each')?['ScheduledStartTime']?['Value']} | Shift: @{items('Apply_to_each')?['Shift']?['Value']}
Priority: @{items('Apply_to_each')?['Priority']?['Value']}

Crew: @{items('Apply_to_each')?['CrewRequired']}
Equipment: @{items('Apply_to_each')?['EquipmentRequired']}

Status updated to: IN PROGRESS
```

---

### Step 7: After the Loop — Send Consolidated Summary (Optional Enhancement)

After the "Apply to each" action (outside the loop), you can send a single consolidated summary to the Mine Manager:

1. Click **+ New step** (below the Apply to each block)
2. Select **Office 365 Outlook → "Send an email (V2)"**
3. Fill in:
   - **To:** Mine Manager's email address (hardcode)
   - **Subject:** `[DAILY TASK BRIEFING] @{variables('TodayDateDisplay')} — @{length(body('Get_items')?['value'])} Active Tasks`
   - **Body:**

```html
<h2>Mine Site Daily Task Briefing</h2>
<p>Date: <strong>@{variables('TodayDateDisplay')}</strong></p>
<p>Total Active Tasks Today: <strong>@{length(body('Get_items')?['value'])}</strong></p>

<p>The following tasks have been activated for today's operations. Each supervisor has been notified via Teams and email.</p>

<p><a href="https://[YOURCOMPANY].sharepoint.com/sites/MineSiteTasks/Lists/WorkTasks">View All Tasks in SharePoint</a></p>

<p><em>This is an automated morning briefing from the Mine Site Task Management System.</em></p>
```

---

### Step 8: Save and Test

1. Click **Save**
2. Click **Test → Manually**
3. You need a task with today's date and Status = `Scheduled`
   - Go to WorkTasks, edit a test task, set Scheduled Date to today
4. Run the test and verify:
   - Task status updated to "In Progress"
   - Teams card received by supervisor
   - Channel post appears
   - Manager summary email received (if configured)

---

## Key Design Decisions Explained

### Why update status to "In Progress" at 6 AM?

This serves two purposes:
1. **Flow 3 won't send a reminder tonight** — because it filters on `Status = "Scheduled"`, and the task is now "In Progress"
2. **Flow 5 (completion)** checks for "In Progress" before allowing completion — this prevents double-firing

### What if a task starts at 2 PM not 6 AM?

The 6 AM flow is a **notification trigger**, not the actual task start time. The task's `Scheduled Start Time` field tells the supervisor exactly when to start. The 6 AM flow ensures the supervisor has their briefing at the start of the day shift.

For afternoon and night shift tasks, you can optionally add a second scheduled flow (e.g., at 12 PM for afternoon shift tasks).

---

## Advanced: Shift-Based Timing (Optional)

If you want different reminder times per shift, create three separate flows:

| Flow | Run Time | Filter |
|------|----------|--------|
| Flow 4a — Day Shift | 6:00 AM | Shift = "Day Shift" |
| Flow 4b — Afternoon Shift | 12:00 PM | Shift = "Afternoon Shift" |
| Flow 4c — Night Shift | 4:00 PM | Shift = "Night Shift" |

Each flow is identical except for the run time and the Shift filter in the "Get items" query.

---

## Troubleshooting Flow 4

| Problem | Cause | Fix |
|---------|-------|-----|
| Status not updating to "In Progress" | "Update item" action has wrong column name | Check exact column internal name in SharePoint list settings |
| Supervisor doesn't receive card | Email in task doesn't match M365 account | Ensure Assigned Supervisor is a valid M365 user in your tenant |
| Flow runs but finds no tasks | Date format mismatch | Try `formatDateTime(utcNow(), 'yyyy-MM-ddT00:00:00Z')` instead |
| Flow runs twice | Duplicate trigger conditions | Check no other flow is also triggering status updates at the same time |
