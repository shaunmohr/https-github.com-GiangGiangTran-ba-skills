# Document 4: Flow 2 — Task Scoped → Notify Scheduler

---

## Overview

| Field | Value |
|-------|-------|
| **Flow Name** | `MineTasks_Flow2_TaskScoped` |
| **Trigger** | When an item is modified in SharePoint [WorkTasks] |
| **Condition** | Status equals "Scoped" |
| **Purpose** | Notifies the Task Scheduler that a task has been scoped and is ready for scheduling |
| **Outputs** | Teams message to scheduler + Email to scheduler + Department channel post |
| **Time to build** | ~25 minutes |

---

## Flow Logic Diagram

```
[TRIGGER] Item modified in WorkTasks
    ↓
[CONDITION] Is Status = "Scoped"?
    ├── NO → Terminate (do nothing)
    └── YES ↓
[ACTION 1] Get Department Contact (manager/scheduler details)
    ↓
[ACTION 2] Post Teams message to Task Scheduler
    ↓
[ACTION 3] Send Email to Task Scheduler
    ↓
[ACTION 4] Post summary to Department Teams channel
```

---

## Step-by-Step Build Instructions

### Step 1: Create a New Flow

1. Go to `https://make.powerautomate.com`
2. Click **+ Create → Automated cloud flow**
3. Flow name: `MineTasks_Flow2_TaskScoped`
4. Trigger: Search `SharePoint` → Select **"When an item is modified"**
5. Click **Create**

---

### Step 2: Configure the Trigger

1. Click the trigger box
2. Fill in:
   - **Site Address:** Your SharePoint site URL
   - **List Name:** `WorkTasks`

---

### Step 3: Add Condition — Check if Status = Scoped

This is critical. Without this condition, the flow would fire every time ANY field is changed.

1. Click **+ New step**
2. Search for **"Condition"** (Control connector)
3. In the condition editor:
   - **Left field:** Click → Dynamic content → find `Status Value`  
     (it should appear as `@{triggerOutputs()?['body/Status/Value']}`)
   - **Operator:** `is equal to`
   - **Right field:** Type exactly: `Scoped`

> **Important:** The condition check must be on the **Value** field of the Status choice column, not the Status column itself.

---

### Step 4: Build the YES Branch — Get Scheduler Details

Inside the **YES** branch:

1. Click **Add an action**
2. Select **SharePoint → "Get items"**
3. Fill in:
   - **Site Address:** Your SharePoint site URL
   - **List Name:** `DepartmentContacts`
   - **Filter Query:** `Department eq '@{triggerOutputs()?['body/Department/Value']}'`

---

### Step 5: Add Parallel Branch — Teams + Email Simultaneously

Instead of sending Teams then waiting to send email, run them in parallel for speed.

1. After the "Get items" action, click **+** below it
2. Click **Add a parallel branch**

This creates two parallel paths. Build one action in each:

**Branch A — Teams message to Scheduler:**

1. In Branch A, click **Add an action**
2. Select **Microsoft Teams → "Post a message in a chat or channel"**
3. Fill in:
   - **Post as:** Flow bot
   - **Post in:** Channel
   - **Team:** Select your mine site Teams group (or type the name)
   - **Channel:** `Task Scheduling` (you will create this in the Teams setup document)
   - **Message:**

```
📋 TASK READY FOR SCHEDULING

Task: @{triggerOutputs()?['body/Title']}
Department: @{triggerOutputs()?['body/Department/Value']}
Priority: @{triggerOutputs()?['body/Priority/Value']}
Supervisor: @{triggerOutputs()?['body/AssignedSupervisor/DisplayName']}

Scope Summary:
• Crew Required: @{triggerOutputs()?['body/CrewRequired']}
• Equipment: @{triggerOutputs()?['body/EquipmentRequired']}
• Permits: @{triggerOutputs()?['body/PermitsRequired']}
• Est. Duration: @{triggerOutputs()?['body/EstimatedDurationHours']} hours

Scope Notes: @{triggerOutputs()?['body/ScopeNotes']}

👉 Please open WorkTasks and set the Scheduled Date, Start Time, and Shift.
```

**Branch B — Email to Scheduler:**

1. In Branch B, click **Add an action**
2. Select **Office 365 Outlook → "Send an email (V2)"**
3. Fill in:

**To:** Your scheduler's email address  
(You can hardcode this or add it to DepartmentContacts and look it up)

**Subject:**
```
[SCHEDULE REQUIRED] @{triggerOutputs()?['body/Title']} — @{triggerOutputs()?['body/Department/Value']} — @{triggerOutputs()?['body/Priority/Value']} Priority
```

**Body:**
```html
<h2>Work Task Ready for Scheduling</h2>

<p>A task has been scoped by the supervisor and is now ready to be scheduled.</p>

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse:collapse; width:600px;">
  <tr style="background-color:#1a3c5e; color:white;">
    <td colspan="2"><strong>TASK DETAILS</strong></td>
  </tr>
  <tr><td width="200"><strong>Task Title</strong></td><td>@{triggerOutputs()?['body/Title']}</td></tr>
  <tr><td><strong>Department</strong></td><td>@{triggerOutputs()?['body/Department/Value']}</td></tr>
  <tr><td><strong>Priority</strong></td><td>@{triggerOutputs()?['body/Priority/Value']}</td></tr>
  <tr><td><strong>Assigned Supervisor</strong></td><td>@{triggerOutputs()?['body/AssignedSupervisor/DisplayName']}</td></tr>
  <tr style="background-color:#f0f4f8;">
    <td colspan="2"><strong>SCOPE DETAILS</strong></td>
  </tr>
  <tr><td><strong>Crew Required</strong></td><td>@{triggerOutputs()?['body/CrewRequired']}</td></tr>
  <tr><td><strong>Equipment Required</strong></td><td>@{triggerOutputs()?['body/EquipmentRequired']}</td></tr>
  <tr><td><strong>Permits Required</strong></td><td>@{triggerOutputs()?['body/PermitsRequired']}</td></tr>
  <tr><td><strong>Estimated Duration</strong></td><td>@{triggerOutputs()?['body/EstimatedDurationHours']} hours</td></tr>
  <tr><td><strong>Risk Rating</strong></td><td>@{triggerOutputs()?['body/RiskRating/Value']}</td></tr>
  <tr><td><strong>Scope Notes</strong></td><td>@{triggerOutputs()?['body/ScopeNotes']}</td></tr>
</table>

<br/>
<p><strong>Action Required:</strong> Please open the WorkTasks list and set:</p>
<ul>
  <li>Scheduled Date</li>
  <li>Scheduled Start Time</li>
  <li>Shift (Day / Afternoon / Night)</li>
  <li>Update Status to "Scheduled"</li>
</ul>

<p><a href="https://[YOURCOMPANY].sharepoint.com/sites/MineSiteTasks/Lists/WorkTasks">Open WorkTasks List</a></p>
```

---

### Step 6: After the Parallel Branch — Post to Department Channel

After both parallel branches complete:

1. Click **+** below the parallel branch section
2. Add **Microsoft Teams → "Post a message in a chat or channel"**
3. Fill in:
   - **Post as:** Flow bot
   - **Post in:** Channel
   - **Team:** Your mine site Teams group
   - **Channel:** Name matching the department (see Teams setup guide)
   - **Message:**

```
✅ Task Scoped: @{triggerOutputs()?['body/Title']}

Department: @{triggerOutputs()?['body/Department/Value']}
Scoped by: @{triggerOutputs()?['body/ScopedBy/DisplayName']}
Priority: @{triggerOutputs()?['body/Priority/Value']}

This task has been passed to Scheduling. A scheduled date will be confirmed shortly.
```

---

### Step 7: Build the NO Branch

Inside the **NO** branch (Status is NOT "Scoped"):

1. Click **Add an action**
2. Search for **"Terminate"** (Control connector)
3. Status: **Succeeded**
4. (This gracefully exits the flow without doing anything)

---

### Step 8: Save and Test

1. Click **Save**
2. Click **Test → Manually**
3. Go to SharePoint `WorkTasks` list
4. Find your test task from Flow 1
5. Edit it: change Status to `Scoped`, fill in crew/equipment fields
6. Save the item
7. Return to Power Automate — the flow should run successfully

---

## Understanding the Status Check

**Why do we check for Status = "Scoped" specifically?**

The "When an item is modified" trigger fires every single time ANY field is changed — including when Flow 1 updates the Task ID. Without the condition, this flow would also fire during those updates, causing duplicate notifications.

By checking `Status = "Scoped"`, we ensure this flow only runs when the supervisor has explicitly updated the status after completing their scope.

---

## Troubleshooting Flow 2

| Problem | Cause | Fix |
|---------|-------|-----|
| Flow fires multiple times | Condition too broad | Add a second condition: check the previous status wasn't already "Scoped" using `@{triggerOutputs()?['body/Status/Value']}` |
| Teams channel not found | Channel name wrong | Check exact channel name in Teams settings |
| Department filter returns empty | Department choice values don't match | Open DepartmentContacts and check the Department choice values exactly match the WorkTasks Department choice values |
| Parallel branch fails on one side | One connector has an auth error | Click the failing action, click "..." and re-authenticate |
