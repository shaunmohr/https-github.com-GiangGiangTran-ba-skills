# Document 3: Flow 1 — Task Initiated → Notify Supervisor

---

## Overview

| Field | Value |
|-------|-------|
| **Flow Name** | `MineTasks_Flow1_TaskInitiated` |
| **Trigger** | When a new item is created in SharePoint [WorkTasks] |
| **Purpose** | Notifies the assigned supervisor that a new task needs scoping |
| **Outputs** | Teams message to supervisor + Email to supervisor |
| **Time to build** | ~30 minutes |

---

## Flow Logic Diagram

```
[TRIGGER] New item created in WorkTasks
    ↓
[ACTION 1] Get supervisor details from DepartmentContacts
    ↓
[ACTION 2] Generate a unique Task ID
    ↓
[ACTION 3] Update WorkTasks item with Task ID
    ↓
[ACTION 4] Post Teams Adaptive Card to Supervisor
    ↓
[ACTION 5] Send Email to Supervisor
    ↓
[ACTION 6] Post message to Department Teams Channel
```

---

## Step-by-Step Build Instructions

### Step 1: Open Power Automate

1. Open your browser and go to: `https://make.powerautomate.com`
2. Sign in with your Microsoft 365 account
3. Make sure you are in the correct **Environment** (shown in the top right — should be your company environment, not "Default")

---

### Step 2: Create a New Flow

1. In the left navigation, click **+ Create**
2. Click **Automated cloud flow**
3. In the dialog box:
   - **Flow name:** Type `MineTasks_Flow1_TaskInitiated`
   - **Choose your flow's trigger:** Search for `SharePoint`
   - Select **"When an item is created"** (from the SharePoint options)
4. Click **Create**

---

### Step 3: Configure the Trigger

You will see the trigger box at the top of your flow canvas.

1. Click the trigger box **"When an item is created"**
2. Fill in:
   - **Site Address:** Click the dropdown and select your SharePoint site  
     (e.g., `https://[yourcompany].sharepoint.com/sites/MineSiteTasks`)
   - **List Name:** Select `WorkTasks`
3. The trigger is now configured

> **Tip:** If your site doesn't appear in the dropdown, click "Enter custom value" and type the URL directly.

---

### Step 4: Add Action 1 — Get Department Contact

This action looks up the supervisor's email from your DepartmentContacts list.

1. Click **+ New step**
2. Search for **SharePoint** and select the SharePoint connector
3. Choose action: **"Get items"**
4. Fill in:
   - **Site Address:** Your SharePoint site URL
   - **List Name:** `DepartmentContacts`
   - Click **Show advanced options**
   - **Filter Query:** `Department eq '@{triggerOutputs()?['body/Department/Value']}'`

> This filters DepartmentContacts to only return the row matching the task's department.

---

### Step 5: Add Action 2 — Generate Task ID

1. Click **+ New step**
2. Search for **"Initialize variable"** (from the Variables connector)
3. Choose: **Initialize variable**
4. Fill in:
   - **Name:** `TaskID`
   - **Type:** String
   - **Value:** Click in the value field, then click **Expression** tab and paste:
     ```
     concat(toUpper(substring(triggerOutputs()?['body/Department/Value'],0,3)),'-',formatDateTime(utcNow(),'yyyyMMdd'),'-',substring(string(rand(1000,9999)),0,4))
     ```
5. Click **OK**

> This creates an ID like `LOA-20250610-4821` (first 3 letters of department + date + random number).

---

### Step 6: Add Action 3 — Update Task with Task ID

1. Click **+ New step**
2. Search for **SharePoint**, select **"Update item"**
3. Fill in:
   - **Site Address:** Your SharePoint site URL
   - **List Name:** `WorkTasks`
   - **Id:** Click the field, then in Dynamic content select **ID** (from the trigger)
   - **Task ID field:** Click, then in Dynamic content select your `TaskID` variable
   - **Initiated Date:** Click the field, click **Expression**, type `utcNow()`, click OK

---

### Step 7: Add Action 4 — Post Teams Message to Supervisor

1. Click **+ New step**
2. Search for **"Microsoft Teams"**
3. Choose action: **"Post a message (V3)"** or **"Post an Adaptive Card to a Teams user"**

> Use **"Post an Adaptive Card to a Teams user"** for a richer notification.

4. Fill in:
   - **Post as:** Flow bot
   - **Post in:** Chat with Flow bot
   - **Recipient:** 
     - Click the field → Dynamic content
     - Navigate to the "Get items" step results → look for **Supervisor Email**
     - Select `body/value/SupervisorEmail`
   - **Adaptive Card:** Paste the JSON below (replace nothing — the dynamic fields are already in it):

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
          "text": "NEW WORK TASK — ACTION REQUIRED",
          "weight": "Bolder",
          "size": "Large",
          "color": "Attention"
        }
      ]
    },
    {
      "type": "FactSet",
      "facts": [
        {
          "title": "Task ID:",
          "value": "See task in SharePoint"
        },
        {
          "title": "Department:",
          "value": "@{triggerOutputs()?['body/Department/Value']}"
        },
        {
          "title": "Task Title:",
          "value": "@{triggerOutputs()?['body/Title']}"
        },
        {
          "title": "Priority:",
          "value": "@{triggerOutputs()?['body/Priority/Value']}"
        },
        {
          "title": "Description:",
          "value": "@{triggerOutputs()?['body/TaskDescription']}"
        },
        {
          "title": "Created By:",
          "value": "@{triggerOutputs()?['body/InitiatedBy/DisplayName']}"
        }
      ]
    },
    {
      "type": "TextBlock",
      "text": "Please open the task in Power Apps and add your scope details (crew, equipment, permits, duration).",
      "wrap": true
    }
  ],
  "actions": [
    {
      "type": "Action.OpenUrl",
      "title": "Open Task in SharePoint",
      "url": "https://[YOURCOMPANY].sharepoint.com/sites/MineSiteTasks/Lists/WorkTasks"
    }
  ]
}
```

> **Important:** Replace `[YOURCOMPANY]` with your actual tenant name in the URL at the bottom of the card.

---

### Step 8: Add Action 5 — Send Email to Supervisor

1. Click **+ New step**
2. Search for **"Office 365 Outlook"**
3. Choose action: **"Send an email (V2)"**
4. Fill in the fields:

**To:**
- Dynamic content → Get items results → `Supervisor Email`

**Subject:**
```
[ACTION REQUIRED] New Work Task: @{triggerOutputs()?['body/Title']} — @{triggerOutputs()?['body/Department/Value']}
```

**Body (HTML):**
```html
<p>Dear @{first(body('Get_items')?['value'])?['SupervisorName']},</p>

<p>A new work task has been created and requires your scoping action.</p>

<table border="1" cellpadding="8" cellspacing="0" style="border-collapse:collapse;">
  <tr><td><strong>Department</strong></td><td>@{triggerOutputs()?['body/Department/Value']}</td></tr>
  <tr><td><strong>Task Title</strong></td><td>@{triggerOutputs()?['body/Title']}</td></tr>
  <tr><td><strong>Priority</strong></td><td>@{triggerOutputs()?['body/Priority/Value']}</td></tr>
  <tr><td><strong>Description</strong></td><td>@{triggerOutputs()?['body/TaskDescription']}</td></tr>
  <tr><td><strong>Created By</strong></td><td>@{triggerOutputs()?['body/InitiatedBy/DisplayName']}</td></tr>
  <tr><td><strong>Date Created</strong></td><td>@{formatDateTime(utcNow(), 'dd/MM/yyyy HH:mm')}</td></tr>
</table>

<p><strong>Your Action Required:</strong><br/>
Please log in to SharePoint and open the WorkTasks list to add your scope details including:<br/>
- Crew members required<br/>
- Equipment required<br/>
- Permits/SWMS required<br/>
- Estimated duration<br/>
- Any safety considerations</p>

<p><a href="https://[YOURCOMPANY].sharepoint.com/sites/MineSiteTasks/Lists/WorkTasks">Click here to open WorkTasks list</a></p>

<p>This is an automated notification from the Mine Site Task Management System.</p>
```

> Replace `[YOURCOMPANY]` with your real tenant name.

---

### Step 9: Add Condition — Alert if Critical Priority

1. Click **+ New step**
2. Search for **"Condition"** (Control connector)
3. In the condition box:
   - Left side: Dynamic content → `Priority Value` (from trigger)
   - Operator: **is equal to**
   - Right side: Type `Critical`

**In the YES branch** (if priority is Critical):
1. Click **Add an action** inside the YES box
2. Add **"Send an email (V2)"** again
3. To: Your Mine Manager's email address (hardcode this)
4. Subject: `[CRITICAL TASK ALERT] @{triggerOutputs()?['body/Title']}`
5. Body: Include the same task details with a note that it is Critical priority

**In the NO branch:** Leave empty (no action needed)

---

### Step 10: Save and Test

1. Click **Save** (top right)
2. Click **Test** (top right)
3. Select **Manually**
4. Click **Test**
5. Go to your SharePoint `WorkTasks` list
6. Click **+ New** and add a test task
7. Go back to Power Automate — you should see the flow run successfully (green ticks)

---

## Troubleshooting Flow 1

| Problem | Cause | Fix |
|---------|-------|-----|
| "Get items" returns no results | Department filter not matching | Check the exact text matches between your list choice values and the filter |
| Teams card not delivered | Wrong email in Recipient field | Use the email from DepartmentContacts, not the trigger person field |
| Email not sent | Outlook connection not authorized | Click the "..." on the email action and re-authenticate |
| Flow doesn't trigger | List name typo | Check the list name in the trigger exactly matches `WorkTasks` |

---

## What Success Looks Like

When Flow 1 works correctly, within 1–3 minutes of a new task being saved to SharePoint:

- The assigned supervisor receives a **Teams chat message** with the task details card
- The assigned supervisor receives an **email** with full task details  
- If Critical: the Mine Manager also receives an **escalation email**
- The task's `Task ID` field is populated (e.g., `LOA-20250610-4821`)
