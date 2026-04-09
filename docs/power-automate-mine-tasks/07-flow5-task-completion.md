# Document 7: Flow 5 — Task Completed → Management Notification + Register

---

## Overview

| Field | Value |
|-------|-------|
| **Flow Name** | `MineTasks_Flow5_TaskCompleted` |
| **Trigger** | When an item is modified in SharePoint [WorkTasks] |
| **Condition** | Status equals "Completed" |
| **Purpose** | Logs the completed task to the CompletionRegister, notifies the department manager, posts to the management Teams channel, and escalates if Critical |
| **Outputs** | CompletionRegister record + Teams post + Manager email + (Critical) Mine Manager email |
| **Time to build** | ~40 minutes |

---

## Flow Logic Diagram

```
[TRIGGER] Item modified in WorkTasks
    ↓
[CONDITION] Is Status = "Completed"?
    ├── NO → Terminate
    └── YES ↓
[ACTION 1] Get Department Contact (manager details)
    ↓
[ACTION 2] Create record in CompletionRegister list
    ↓
[ACTION 3] Post completion message to Management Teams channel
    ↓
[ACTION 4] Send completion email to Department Manager
    ↓
[CONDITION 2] Was Priority = "Critical"?
    ├── NO → End
    └── YES ↓
[ACTION 5] Send escalation email to Mine Manager
    ↓
[ACTION 6] Post to Executive Teams channel
```

---

## Step-by-Step Build Instructions

### Step 1: Create a New Flow

1. Go to `https://make.powerautomate.com`
2. Click **+ Create → Automated cloud flow**
3. Flow name: `MineTasks_Flow5_TaskCompleted`
4. Trigger: SharePoint → **"When an item is modified"**
5. Click **Create**

---

### Step 2: Configure Trigger

1. Click the trigger
2. Fill in:
   - **Site Address:** Your SharePoint site URL
   - **List Name:** `WorkTasks`

---

### Step 3: Add Condition — Check Status = "Completed"

1. Click **+ New step → Condition**
2. Fill in:
   - **Left:** Dynamic content → `Status Value` → `@{triggerOutputs()?['body/Status/Value']}`
   - **Operator:** `is equal to`
   - **Right:** `Completed`

---

### Step 4: YES Branch — Action 1: Get Manager Contact

Inside YES branch:

1. Click **Add an action**
2. Select **SharePoint → "Get items"**
3. Rename: `GetManagerContact`
4. Fill in:
   - **Site Address:** Your SharePoint site URL
   - **List Name:** `DepartmentContacts`
   - **Filter Query:** `Department eq '@{triggerOutputs()?['body/Department/Value']}'`

---

### Step 5: Action 2 — Create CompletionRegister Record

This creates the permanent audit log entry.

1. Click **Add an action**
2. Select **SharePoint → "Create item"**
3. Fill in:
   - **Site Address:** Your SharePoint site URL
   - **List Name:** `CompletionRegister`
   - Map each field using Dynamic content from the trigger:

| CompletionRegister Field | Source (Dynamic Content) |
|--------------------------|-------------------------|
| Title | `@{triggerOutputs()?['body/Title']}` |
| Department | `@{triggerOutputs()?['body/Department/Value']}` |
| Priority | `@{triggerOutputs()?['body/Priority/Value']}` |
| Assigned Supervisor | `@{triggerOutputs()?['body/AssignedSupervisor/Email']}` |
| Scheduled Date | `@{triggerOutputs()?['body/ScheduledDate']}` |
| Actual Start Time | `@{triggerOutputs()?['body/ActualStartTime']}` |
| Actual Completion Time | `@{triggerOutputs()?['body/ActualCompletionTime']}` |
| Executed By | `@{triggerOutputs()?['body/ExecutedBy/Email']}` |
| Crew Members | `@{triggerOutputs()?['body/CrewRequired']}` |
| Equipment Used | `@{triggerOutputs()?['body/EquipmentRequired']}` |
| Completion Notes | `@{triggerOutputs()?['body/CompletionNotes']}` |
| Issues Encountered | `@{triggerOutputs()?['body/IssuesEncountered']}` |
| Original Task ID | `@{triggerOutputs()?['body/TaskID']}` |
| Completion Logged | Expression: `utcNow()` |

---

### Step 6: Action 3 — Post to Management Teams Channel

1. Click **Add an action**
2. Select **Microsoft Teams → "Post a message in a chat or channel"**
3. Fill in:
   - **Post as:** Flow bot
   - **Post in:** Channel
   - **Team:** Your mine site Teams group
   - **Channel:** `Management` or `Operations Summary` (create this channel first)
   - **Message:**

```
✅ TASK COMPLETED — @{triggerOutputs()?['body/Department/Value']}

Task: @{triggerOutputs()?['body/Title']}
Priority: @{triggerOutputs()?['body/Priority/Value']}
Supervisor: @{triggerOutputs()?['body/AssignedSupervisor/DisplayName']}
Executed By: @{triggerOutputs()?['body/ExecutedBy/DisplayName']}

Scheduled: @{formatDateTime(triggerOutputs()?['body/ScheduledDate'], 'dd/MM/yyyy')}
Started: @{formatDateTime(triggerOutputs()?['body/ActualStartTime'], 'dd/MM/yyyy HH:mm')}
Completed: @{formatDateTime(triggerOutputs()?['body/ActualCompletionTime'], 'dd/MM/yyyy HH:mm')}

Completion Notes: @{triggerOutputs()?['body/CompletionNotes']}
Issues: @{if(empty(triggerOutputs()?['body/IssuesEncountered']), 'None reported', triggerOutputs()?['body/IssuesEncountered'])}

📋 Logged to Completion Register.
```

---

### Step 7: Action 4 — Send Email to Department Manager

1. Click **Add an action**
2. Select **Office 365 Outlook → "Send an email (V2)"**
3. Fill in:

**To:** Dynamic content → GetManagerContact → Manager Email

**Subject:**
```
[TASK COMPLETED] @{triggerOutputs()?['body/Title']} — @{triggerOutputs()?['body/Department/Value']}
```

**Body:**
```html
<h2>Work Task Completion Report</h2>

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse:collapse; width:620px;">
  <tr style="background-color:#1a7a2e; color:white;">
    <td colspan="2"><strong>✅ TASK COMPLETED</strong></td>
  </tr>
  <tr><td width="200"><strong>Task Title</strong></td><td>@{triggerOutputs()?['body/Title']}</td></tr>
  <tr><td><strong>Department</strong></td><td>@{triggerOutputs()?['body/Department/Value']}</td></tr>
  <tr><td><strong>Priority</strong></td><td>@{triggerOutputs()?['body/Priority/Value']}</td></tr>
  <tr><td><strong>Supervisor</strong></td><td>@{triggerOutputs()?['body/AssignedSupervisor/DisplayName']}</td></tr>
  <tr><td><strong>Executed By</strong></td><td>@{triggerOutputs()?['body/ExecutedBy/DisplayName']}</td></tr>
  <tr style="background-color:#f0f4f8;"><td colspan="2"><strong>TIMELINE</strong></td></tr>
  <tr><td><strong>Scheduled Date</strong></td><td>@{formatDateTime(triggerOutputs()?['body/ScheduledDate'], 'dd/MM/yyyy')}</td></tr>
  <tr><td><strong>Actual Start Time</strong></td><td>@{formatDateTime(triggerOutputs()?['body/ActualStartTime'], 'dd/MM/yyyy HH:mm')}</td></tr>
  <tr><td><strong>Completion Time</strong></td><td>@{formatDateTime(triggerOutputs()?['body/ActualCompletionTime'], 'dd/MM/yyyy HH:mm')}</td></tr>
  <tr style="background-color:#f0f4f8;"><td colspan="2"><strong>OUTCOME</strong></td></tr>
  <tr><td><strong>Completion Notes</strong></td><td>@{triggerOutputs()?['body/CompletionNotes']}</td></tr>
  <tr><td><strong>Issues Encountered</strong></td><td>@{if(empty(triggerOutputs()?['body/IssuesEncountered']), 'None reported', triggerOutputs()?['body/IssuesEncountered'])}</td></tr>
  <tr><td><strong>Crew Used</strong></td><td>@{triggerOutputs()?['body/CrewRequired']}</td></tr>
  <tr><td><strong>Equipment Used</strong></td><td>@{triggerOutputs()?['body/EquipmentRequired']}</td></tr>
</table>

<br/>
<p>This task has been automatically logged to the Completion Register in SharePoint.</p>
<p><a href="https://[YOURCOMPANY].sharepoint.com/sites/MineSiteTasks/Lists/CompletionRegister">View Completion Register</a></p>

<p><em>Automated completion report — Mine Site Task Management System</em></p>
```

---

### Step 8: Add Condition 2 — Check if Critical Priority

After the email action (still inside YES branch):

1. Click **Add an action → Condition**
2. Left: `@{triggerOutputs()?['body/Priority/Value']}`
3. Operator: `is equal to`
4. Right: `Critical`

**Inside YES (Critical):**

**Action 5a — Email Mine Manager:**

1. Add **Office 365 Outlook → Send an email (V2)**
2. Fill in:
   - **To:** Mine Manager email (hardcode the actual email address)
   - **Subject:** `[CRITICAL TASK COMPLETED] @{triggerOutputs()?['body/Title']}`
   - **Body:**

```html
<h2 style="color: #cc0000;">Critical Task Completion Report</h2>

<p>A <strong>CRITICAL</strong> priority task has been completed and requires your awareness.</p>

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse:collapse; width:620px;">
  <tr style="background-color:#cc0000; color:white;">
    <td colspan="2"><strong>⚠️ CRITICAL TASK — COMPLETED</strong></td>
  </tr>
  <tr><td width="200"><strong>Task Title</strong></td><td>@{triggerOutputs()?['body/Title']}</td></tr>
  <tr><td><strong>Department</strong></td><td>@{triggerOutputs()?['body/Department/Value']}</td></tr>
  <tr><td><strong>Supervisor</strong></td><td>@{triggerOutputs()?['body/AssignedSupervisor/DisplayName']}</td></tr>
  <tr><td><strong>Completed At</strong></td><td>@{formatDateTime(triggerOutputs()?['body/ActualCompletionTime'], 'dd/MM/yyyy HH:mm')}</td></tr>
  <tr><td><strong>Issues</strong></td><td>@{if(empty(triggerOutputs()?['body/IssuesEncountered']), 'None reported', triggerOutputs()?['body/IssuesEncountered'])}</td></tr>
  <tr><td><strong>Notes</strong></td><td>@{triggerOutputs()?['body/CompletionNotes']}</td></tr>
</table>

<p><a href="https://[YOURCOMPANY].sharepoint.com/sites/MineSiteTasks/Lists/CompletionRegister">View Completion Register</a></p>
```

**Action 5b — Post to Executive/Management Teams Channel:**

1. Add **Microsoft Teams → Post a message**
2. Team: Your mine site team
3. Channel: `Management` or `Executive Operations`
4. Message:

```
⚠️ CRITICAL TASK COMPLETED

@{triggerOutputs()?['body/Title']} — @{triggerOutputs()?['body/Department/Value']}
Supervisor: @{triggerOutputs()?['body/AssignedSupervisor/DisplayName']}
Completed: @{formatDateTime(triggerOutputs()?['body/ActualCompletionTime'], 'dd/MM/yyyy HH:mm')}
Issues: @{if(empty(triggerOutputs()?['body/IssuesEncountered']), 'None', triggerOutputs()?['body/IssuesEncountered'])}
```

---

### Step 9: NO Branch — Terminate

In the outer NO branch (Status is not "Completed"):
1. Add **Terminate** → Status: Succeeded

In the Critical condition NO branch:
- Leave empty (no action needed for non-critical completions)

---

### Step 10: Save and Test

1. Click **Save**
2. Test by:
   - Opening a task in WorkTasks that is currently "In Progress"
   - Editing it: set Status to `Completed`, fill in Actual Start/Completion times and Completion Notes
   - Save the item
3. Verify:
   - [ ] A record appears in CompletionRegister
   - [ ] Teams management channel has a new post
   - [ ] Department Manager received an email
   - [ ] (If critical) Mine Manager received email + Teams post

---

## Completion Flow Summary

| Output | Recipient | When |
|--------|-----------|------|
| CompletionRegister record | (automatic log) | Every completion |
| Teams channel post | Management channel | Every completion |
| Email | Department Manager | Every completion |
| Escalation email | Mine Manager | Critical tasks only |
| Executive Teams post | Executive channel | Critical tasks only |

---

## Troubleshooting Flow 5

| Problem | Cause | Fix |
|---------|-------|-----|
| CompletionRegister item missing fields | Column names don't match | Check the internal column names via List settings → go to each column and note the URL parameter `Field=...` |
| Flow fires when status changes to other values | Missing condition | Verify the condition checks `Status/Value eq 'Completed'` exactly |
| Manager email address blank | GetManagerContact returned no results | Check DepartmentContacts list has an entry for every department value |
| Date fields show as null | Actual times not filled in | Ensure Power Apps form requires these fields before saving |
