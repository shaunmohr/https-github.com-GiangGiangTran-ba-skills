# Document 5: Flow 3 — Day-Before Scheduled Task Reminder

---

## Overview

| Field | Value |
|-------|-------|
| **Flow Name** | `MineTasks_Flow3_DayBeforeReminder` |
| **Trigger** | Scheduled — runs every day at 4:00 PM |
| **Purpose** | Queries all tasks scheduled for tomorrow and sends a pre-shift briefing to supervisors |
| **Outputs** | Teams Adaptive Card + Email to each supervisor with tomorrow's tasks |
| **Time to build** | ~35 minutes |

---

## Flow Logic Diagram

```
[TRIGGER] Daily at 4:00 PM
    ↓
[ACTION 1] Calculate tomorrow's date
    ↓
[ACTION 2] Get all WorkTasks where:
           Scheduled Date = Tomorrow AND Status = "Scheduled"
    ↓
[CONDITION] Were any tasks found?
    ├── NO → Terminate (nothing to notify)
    └── YES ↓
[ACTION 3] Apply to each task found:
    ├── [ACTION 3a] Get supervisor contact details
    ├── [ACTION 3b] Send Teams Adaptive Card to supervisor
    └── [ACTION 3c] Send reminder email to supervisor
```

---

## Step-by-Step Build Instructions

### Step 1: Create a New Flow

1. Go to `https://make.powerautomate.com`
2. Click **+ Create → Scheduled cloud flow**
3. Fill in:
   - **Flow name:** `MineTasks_Flow3_DayBeforeReminder`
   - **Starting:** Today's date
   - **Repeat every:** `1` `Day`
4. Click **Create**

---

### Step 2: Set the Exact Run Time (4 PM)

The scheduled trigger defaults to a specific time. To change it to 4:00 PM:

1. Click the trigger box **"Recurrence"**
2. Click **Show advanced options**
3. Fill in:
   - **Time zone:** Select your local time zone (e.g., `(UTC+10:00) Brisbane` for AEST)
   - **At these hours:** `16` (this is 4 PM in 24-hour format)
   - **At these minutes:** `0`

---

### Step 3: Initialize Variables

You need two variables: tomorrow's date (for querying) and a counter.

**Variable 1 — Tomorrow's Date (formatted):**

1. Click **+ New step**
2. Search **"Initialize variable"**
3. Fill in:
   - **Name:** `TomorrowDate`
   - **Type:** String
   - **Value:** Click **Expression** tab, paste:
     ```
     formatDateTime(addDays(utcNow(), 1), 'yyyy-MM-dd')
     ```
   - Click **OK**

**Variable 2 — Tomorrow's Date (display format for emails):**

1. Click **+ New step → Initialize variable**
2. Fill in:
   - **Name:** `TomorrowDateDisplay`
   - **Type:** String
   - **Value:** Expression:
     ```
     formatDateTime(addDays(utcNow(), 1), 'dddd dd MMMM yyyy')
     ```

---

### Step 4: Get Tomorrow's Scheduled Tasks

1. Click **+ New step**
2. Select **SharePoint → "Get items"**
3. Fill in:
   - **Site Address:** Your SharePoint site URL
   - **List Name:** `WorkTasks`
   - Click **Show advanced options**
   - **Filter Query:**
     ```
     Status/Value eq 'Scheduled' and ScheduledDate eq '@{variables('TomorrowDate')}'
     ```
   - **Top Count:** `50` (limits results to 50 tasks max per day — adjust if needed)

> **Note on date filtering in SharePoint:** SharePoint date columns store dates in ISO format. The variable `TomorrowDate` outputs `yyyy-MM-dd` which matches SharePoint's internal format.

---

### Step 5: Add Condition — Were Tasks Found?

1. Click **+ New step → Condition**
2. In the condition:
   - **Left:** Click Expression tab, paste: `length(body('Get_items')?['value'])`
   - **Operator:** `is greater than`
   - **Right:** `0`

---

### Step 6: Build YES Branch — Loop Through Each Task

Inside the **YES** branch:

1. Click **Add an action**
2. Search **"Apply to each"** (Control connector)
3. In the **Select an output from previous steps** field:
   - Dynamic content → `value` (from the "Get items" step)

Now, inside the **Apply to each** loop, add the following actions:

---

#### Inside the loop — Action A: Get Supervisor Contact

1. Click **Add an action** inside the loop
2. Select **SharePoint → "Get items"**
3. Rename this action: click "..." → **Rename** → type `GetSupervisorContact`
4. Fill in:
   - **Site Address:** Your SharePoint site URL
   - **List Name:** `DepartmentContacts`
   - **Filter Query:** `Department eq '@{items('Apply_to_each')?['Department']?['Value']}'`

---

#### Inside the loop — Action B: Post Teams Adaptive Card

1. Click **Add an action**
2. Select **Microsoft Teams → "Post an Adaptive Card to a Teams user"**
3. Fill in:
   - **Post as:** Flow bot
   - **Post in:** Chat with Flow bot
   - **Recipient:** Dynamic content → GetSupervisorContact → `Supervisor Email`
   - **Adaptive Card:**

```json
{
  "type": "AdaptiveCard",
  "$schema": "http://adaptivecards.io/schemas/adaptive-card.json",
  "version": "1.4",
  "body": [
    {
      "type": "Container",
      "style": "emphasis",
      "items": [
        {
          "type": "TextBlock",
          "text": "TOMORROW'S TASK BRIEFING",
          "weight": "Bolder",
          "size": "Large"
        },
        {
          "type": "TextBlock",
          "text": "You have a task scheduled for tomorrow. Please review and prepare.",
          "wrap": true
        }
      ]
    },
    {
      "type": "FactSet",
      "facts": [
        {
          "title": "Date:",
          "value": "@{variables('TomorrowDateDisplay')}"
        },
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
        },
        {
          "title": "Crew Required:",
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
    },
    {
      "type": "TextBlock",
      "text": "Ensure all permits are arranged and crew is briefed before the task start time.",
      "wrap": true,
      "color": "Warning"
    }
  ],
  "actions": [
    {
      "type": "Action.OpenUrl",
      "title": "View Task in SharePoint",
      "url": "https://[YOURCOMPANY].sharepoint.com/sites/MineSiteTasks/Lists/WorkTasks"
    }
  ]
}
```

---

#### Inside the loop — Action C: Send Reminder Email

1. Click **Add an action** inside the loop
2. Select **Office 365 Outlook → "Send an email (V2)"**
3. Fill in:

**To:** Dynamic content → GetSupervisorContact → Supervisor Email

**Subject:**
```
[TOMORROW'S TASK] @{items('Apply_to_each')?['Title']} — @{variables('TomorrowDateDisplay')}
```

**Body:**
```html
<h2>Pre-Shift Task Reminder</h2>

<p>You have a work task scheduled for <strong>@{variables('TomorrowDateDisplay')}</strong>.</p>

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse:collapse; width:600px;">
  <tr style="background-color:#1a3c5e; color:white;">
    <td colspan="2"><strong>TOMORROW'S TASK BRIEFING</strong></td>
  </tr>
  <tr><td width="200"><strong>Task</strong></td><td>@{items('Apply_to_each')?['Title']}</td></tr>
  <tr><td><strong>Department</strong></td><td>@{items('Apply_to_each')?['Department']?['Value']}</td></tr>
  <tr><td><strong>Priority</strong></td><td>@{items('Apply_to_each')?['Priority']?['Value']}</td></tr>
  <tr><td><strong>Scheduled Date</strong></td><td>@{variables('TomorrowDateDisplay')}</td></tr>
  <tr><td><strong>Start Time</strong></td><td>@{items('Apply_to_each')?['ScheduledStartTime']?['Value']}</td></tr>
  <tr><td><strong>Shift</strong></td><td>@{items('Apply_to_each')?['Shift']?['Value']}</td></tr>
  <tr style="background-color:#f0f4f8;"><td colspan="2"><strong>RESOURCE REQUIREMENTS</strong></td></tr>
  <tr><td><strong>Crew Required</strong></td><td>@{items('Apply_to_each')?['CrewRequired']}</td></tr>
  <tr><td><strong>Equipment Required</strong></td><td>@{items('Apply_to_each')?['EquipmentRequired']}</td></tr>
  <tr><td><strong>Permits/SWMS Required</strong></td><td>@{items('Apply_to_each')?['PermitsRequired']}</td></tr>
  <tr><td><strong>Estimated Duration</strong></td><td>@{items('Apply_to_each')?['EstimatedDurationHours']} hours</td></tr>
  <tr><td><strong>Scope Notes</strong></td><td>@{items('Apply_to_each')?['ScopeNotes']}</td></tr>
</table>

<br/>
<h3>Pre-Task Checklist (Please Confirm Before Start):</h3>
<ul>
  <li>☐ Crew briefed on task requirements</li>
  <li>☐ All permits obtained and signed</li>
  <li>☐ SWMS reviewed with crew</li>
  <li>☐ Equipment inspected and serviceable</li>
  <li>☐ Area inspected and hazards identified</li>
  <li>☐ Emergency contacts confirmed</li>
</ul>

<p><a href="https://[YOURCOMPANY].sharepoint.com/sites/MineSiteTasks/Lists/WorkTasks">Open Task in SharePoint</a></p>

<p><em>This is an automated reminder. Reply to your scheduler if there are any issues with this task proceeding tomorrow.</em></p>
```

---

### Step 7: Build NO Branch — Terminate Gracefully

Inside the **NO** branch:

1. Click **Add an action**
2. Search **"Terminate"**
3. Status: **Succeeded**
4. (No notification needed if there are no tasks tomorrow)

---

### Step 8: Save and Test

1. Click **Save**
2. To test manually without waiting until 4 PM:
   - Click **Test → Manually → Test**
   - Ensure you have a task in WorkTasks with Status = `Scheduled` and Scheduled Date = tomorrow's date
3. Check your Teams and email for the reminder

---

## How to Handle Multiple Tasks for the Same Supervisor

If a supervisor has 3 tasks scheduled for tomorrow, they will receive **3 separate cards and 3 emails** (one per task). This is by design — each card shows specific task details.

If you prefer a **single digest email** with all tasks grouped, this requires a more advanced pattern (HTML table built in a loop with string concatenation). This is documented in the Advanced Patterns section of the testing guide.

---

## Troubleshooting Flow 3

| Problem | Cause | Fix |
|---------|-------|-----|
| No tasks returned | Date format mismatch | Check SharePoint stores dates as `yyyy-MM-dd` — use List settings to confirm date column type |
| Flow doesn't run at 4 PM | Time zone not set | In the Recurrence trigger, explicitly set the time zone to your local zone |
| Loop fails | "Apply to each" crashes on empty value | Add a null check before the loop using `if(empty(body('Get_items')?['value']), ...)` |
| Supervisor gets reminder for completed task | Status not updating correctly | Ensure Flow 5 updates the status to "Completed" when a task is signed off |
