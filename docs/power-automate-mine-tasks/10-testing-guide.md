# Document 10: End-to-End Testing Guide

---

## Overview

This guide walks you through testing the complete Mine Site Task Management system from task creation to completion. Complete each test in order — each stage depends on the previous one being successful.

**Estimated time:** 45 minutes  
**What you need:** Access to SharePoint, Power Automate, Power Apps, Teams, and Outlook

---

## Before Testing: Pre-Test Checklist

Confirm the following are complete before you start:

- [ ] SharePoint lists created: `WorkTasks`, `CompletionRegister`, `DepartmentContacts`
- [ ] `DepartmentContacts` populated with at least 1 real department contact (your own email for testing)
- [ ] All 5 flows created and **turned ON** (check the flow toggle — it should show "On")
- [ ] Teams workspace and channels created
- [ ] Power Apps app published
- [ ] You have two browser sessions open (or two different accounts) to simulate planner and supervisor roles

> **Use your own email address as both the supervisor and manager contact in `DepartmentContacts` during testing.** This way you receive all notifications yourself.

---

## Test 1: Task Initiation (Flow 1)

### What we're testing:
A planner creates a new task → Flow 1 fires → Supervisor receives Teams card and email

### Steps:

1. Open your SharePoint `WorkTasks` list
2. Click **+ New**
3. Fill in:
   - **Task Title:** `TEST - Shovel Pre-Strip Check`
   - **Department:** `Load & Haul`
   - **Task Description:** `Inspect and confirm pre-strip area clear before first blast`
   - **Priority:** `High`
   - **Assigned Supervisor:** Select yourself (or a test user)
4. Click **Save**

### Expected results (within 1–3 minutes):

- [ ] A new item appears in WorkTasks with Status = `Initiated`
- [ ] The `Task ID` field is auto-populated (e.g., `LOA-20260609-4821`)
- [ ] You receive a **Teams chat message** from Flow bot with the task details card
- [ ] You receive an **email** with the task details
- [ ] (If Priority was Critical) An escalation email was sent to the Mine Manager address

### If it fails:

1. Go to Power Automate → **My flows** → `MineTasks_Flow1_TaskInitiated`
2. Click the flow name → scroll down to **28 day run history**
3. Click the most recent run → look for red X icons to see what failed
4. Compare with the troubleshooting table in Document 3

---

## Test 2: Supervisor Scoping (Flow 2)

### What we're testing:
Supervisor scopes the task → Status changes to "Scoped" → Flow 2 fires → Scheduler notified

### Steps:

1. Open the test task you created in Test 1
2. Click **Edit** in SharePoint
3. Fill in the scope fields:
   - **Scope Notes:** `Area confirmed clear. Standard pre-shift inspection needed.`
   - **Crew Required:** `2x Load & Haul operators, 1x Supervisor`
   - **Equipment Required:** `EX5600 shovel, 793F truck x2`
   - **Permits Required:** `Pre-start checklist, Area clearance form`
   - **Estimated Duration Hours:** `2`
   - **Risk Rating:** `Medium`
4. Change **Status** to `Scoped`
5. Set **Scoped By** to yourself
6. Set **Scoped Date** to today
7. Click **Save**

### Expected results (within 1–3 minutes):

- [ ] Task status updated to `Scoped` in SharePoint
- [ ] You receive a **Teams message** in the `Task Scheduling` channel
- [ ] You receive an **email** as the scheduler with scope details
- [ ] A post appears in the `Load & Haul` Teams channel

### If it fails:

- Check the condition in Flow 2 is checking `Status/Value eq 'Scoped'`
- Ensure the flow is turned ON

---

## Test 3: Task Scheduling (by Scheduler)

### What we're testing:
Scheduler sets the date/time → Status changes to "Scheduled" → task is ready for Flow 3

### Steps:

1. Open the test task in SharePoint
2. Click **Edit**
3. Fill in:
   - **Scheduled Date:** Tomorrow's date
   - **Scheduled Start Time:** `06:00`
   - **Shift:** `Day Shift`
4. Change **Status** to `Scheduled`
5. Set **Scheduled By** to yourself
6. Click **Save**

### Expected results:

- [ ] Task status = `Scheduled` in SharePoint
- [ ] No flow should fire immediately (Flow 3 runs at 4 PM scheduled, Flow 4 runs at 6 AM)

---

## Test 4: Day-Before Reminder (Flow 3)

### What we're testing:
Flow 3 fires at 4 PM and sends tomorrow's task briefing

### Option A — Wait for 4 PM (real test):
- Simply wait until 4 PM today
- The flow will run automatically and query tasks where Scheduled Date = tomorrow

### Option B — Test manually right now:
1. Go to Power Automate → `MineTasks_Flow3_DayBeforeReminder`
2. Click **Test** (top right)
3. Select **Manually**
4. Click **Test**
5. The flow runs with today's data

> **Note:** For the manual test to return results, you need a task with Scheduled Date = tomorrow AND Status = Scheduled.

### Expected results:

- [ ] You receive a **Teams Adaptive Card** from Flow bot with tomorrow's task details
- [ ] You receive a **reminder email** with the pre-task checklist

---

## Test 5: Execution Day Briefing (Flow 4)

### What we're testing:
Flow 4 fires at 6 AM on the task's scheduled day and activates the task

### Setup:
Before testing, edit your test task to change **Scheduled Date** to **today** (so the flow finds it).

### Option A — Wait for 6 AM:
The flow runs automatically at 6 AM if Scheduled Date = today and Status = Scheduled.

### Option B — Test manually right now:
1. First, change your test task's Scheduled Date to today
2. Go to Power Automate → `MineTasks_Flow4_ExecutionDayBriefing`
3. Click **Test → Manually → Test**

### Expected results:

- [ ] Task status changes to `In Progress` automatically
- [ ] You receive a **Teams Adaptive Card** with today's task and action buttons
- [ ] A post appears in the `Today's Tasks` Teams channel
- [ ] The Mine Manager receives a daily briefing email (if configured)

---

## Test 6: Task Completion (Flow 5)

### What we're testing:
Supervisor marks task as Complete → Flow 5 fires → Completion logged, manager notified

### Steps:

1. Open the test task in SharePoint (Status should now be `In Progress`)
2. Click **Edit**
3. Fill in:
   - **Executed By:** Yourself
   - **Actual Start Time:** A time earlier today
   - **Actual Completion Time:** Now
   - **Completion Notes:** `Task completed successfully. Area pre-strip confirmed clear for blast.`
   - **Issues Encountered:** (leave blank or type a test issue)
4. Change **Status** to `Completed`
5. Click **Save**

### Expected results (within 1–3 minutes):

- [ ] A new record appears in the **CompletionRegister** list
- [ ] A completion message is posted to the `Management Summary` Teams channel
- [ ] You receive an **email** as the department manager with the completion report
- [ ] (If Critical) Mine Manager receives escalation email + Critical Alerts channel post

---

## Test 7: Full Power Apps Flow

### What we're testing:
The entire task lifecycle using only the Power Apps app (no SharePoint editing)

### Steps:

1. Open the Power Apps app (`MineSiteTaskManager`)
2. **As Planner:** Create a new task using the New Task form
3. **As Supervisor:** Find the task in the dashboard → tap on it → complete the scope form → submit
4. **As Scheduler:** Find the scoped task → set date/time/shift → confirm schedule
5. **As Supervisor (day of):** Find the In Progress task → record completion details → mark complete
6. Check the CompletionRegister list — a record should exist

---

## Full End-to-End Test Checklist

Use this as your sign-off checklist before going live:

### Flow 1 — Task Initiation
- [ ] New SharePoint item triggers the flow
- [ ] Task ID generated and saved to task
- [ ] Teams card received by supervisor
- [ ] Email received by supervisor
- [ ] Critical task escalation email works (test with Priority = Critical)

### Flow 2 — Supervisor Scoping
- [ ] Status change to "Scoped" triggers the flow
- [ ] Flow does NOT fire for other status changes (test by changing to "Scheduled" — no notification should send)
- [ ] Teams message appears in `Task Scheduling` channel
- [ ] Scheduler email received
- [ ] Department channel post appears

### Flow 3 — Day-Before Reminder
- [ ] Flow finds tasks with Scheduled Date = tomorrow
- [ ] Reminder card received via Teams
- [ ] Reminder email received
- [ ] No reminder sent if there are no tasks tomorrow

### Flow 4 — Execution Day
- [ ] Flow finds tasks with Scheduled Date = today
- [ ] Status updated to "In Progress"
- [ ] Execution day card received
- [ ] Today's Tasks channel post appears
- [ ] Manager daily briefing email received

### Flow 5 — Task Completion
- [ ] Status change to "Completed" triggers the flow
- [ ] CompletionRegister item created with all fields
- [ ] Management Summary Teams post appears
- [ ] Manager email received with full completion details
- [ ] Critical escalation works (test with Priority = Critical)

### Power Apps
- [ ] Dashboard shows active tasks filtered by department
- [ ] New task form submits successfully and triggers Flow 1
- [ ] Scope form updates task and triggers Flow 2
- [ ] Schedule form updates task correctly
- [ ] Complete form marks task done and triggers Flow 5
- [ ] Navigation works between all screens

---

## Performance Benchmarks

After testing, your system should meet these standards:

| Test | Expected Response Time |
|------|----------------------|
| Flow 1 fires after task created | < 3 minutes |
| Flow 2 fires after scope saved | < 3 minutes |
| Flow 3 completes all notifications | < 5 minutes after 4 PM trigger |
| Flow 4 updates all tasks + sends cards | < 5 minutes after 6 AM trigger |
| Flow 5 fires after marked complete | < 3 minutes |

If flows take longer than 5 minutes, check:
- SharePoint connector polling interval (SharePoint triggers poll every 1-3 minutes by default)
- Power Automate plan — higher plans have faster trigger intervals

---

## Go-Live Checklist

Before releasing to real users:

- [ ] Replace all test email addresses in `DepartmentContacts` with real staff emails
- [ ] Replace `[YOURCOMPANY]` placeholder in all flow email/card URLs
- [ ] Replace `[YOUR_APP_ID]` in Flow 4 Teams card with real Power Apps app URL
- [ ] Remove any test tasks from WorkTasks list
- [ ] Train planners on the New Task form (15 min session)
- [ ] Train supervisors on the Scope and Complete screens (20 min session)
- [ ] Train scheduler on the Schedule screen (10 min session)
- [ ] Pin Power Apps to Teams sidebar for all users
- [ ] Add SharePoint tabs to key Teams channels
- [ ] Confirm all 5 flows are **turned ON**

---

## Support and Resources

| Resource | URL |
|----------|-----|
| Power Automate documentation | https://learn.microsoft.com/en-us/power-automate/ |
| Power Apps documentation | https://learn.microsoft.com/en-us/power-apps/ |
| Adaptive Cards designer | https://adaptivecards.io/designer/ |
| SharePoint list formulas | https://learn.microsoft.com/en-us/sharepoint/dev/sp-add-ins/use-odata-query-operations-in-sharepoint-rest-requests |
| Power Automate community forum | https://powerusers.microsoft.com/t5/Microsoft-Power-Automate/ct-p/MPACommunity |
| Microsoft Learn: Power Automate | https://learn.microsoft.com/en-us/training/powerplatform/power-automate |

### Recommended Microsoft Learn Paths for Beginners:

1. **"Get started with Power Automate"** — Free course, ~4 hours  
   Search: `learn.microsoft.com Power Automate get started`

2. **"Build approval flows"** — Shows how to add approval steps  
   Search: `learn.microsoft.com Power Automate approval flows`

3. **"Work with SharePoint in Power Automate"** — Direct relevance to this system  
   Search: `learn.microsoft.com SharePoint Power Automate`

4. **"Create a canvas app in Power Apps"** — Beginner canvas app course  
   Search: `learn.microsoft.com Power Apps canvas app beginner`
