# Document 9: Microsoft Teams Channel Setup

---

## Overview

Power Automate flows post messages to specific Teams channels. This document explains exactly which channels to create and how to configure them.

**Time required:** 20 minutes  
**Access required:** Teams Owner or Admin for your mine site Teams workspace

---

## 9.1 Recommended Teams Structure

```
Teams Workspace: "Mine Site Operations"
├── General (default)
├── 📋 Task Scheduling          ← Flow 2 posts here (scoped tasks ready to schedule)
├── 🟢 Today's Tasks            ← Flow 4 posts here (execution day briefings)
├── 📊 Management Summary       ← Flow 5 posts completions here (management view)
├── 🔴 Critical Alerts          ← Flow 5 escalations for Critical priority tasks
│
├── Department Channels:
│   ├── Mine Planning           ← Department-specific task updates
│   ├── Mine Services           ← Department-specific task updates
│   ├── Load & Haul             ← Department-specific task updates
│   ├── Drill & Blast           ← Department-specific task updates
│   └── Dragline                ← Department-specific task updates
```

---

## 9.2 Create the Teams Workspace (if not already existing)

1. Open **Microsoft Teams**
2. In the left sidebar, click **Teams**
3. Click **Join or create a team** (bottom of list)
4. Click **Create team**
5. Select **From scratch**
6. Select **Private** (or Public depending on your company policy)
7. **Team name:** `Mine Site Operations`
8. **Description:** `Mine site work task management and operational communications`
9. Click **Create**
10. Add members: type in the names/emails of all supervisors, planners, schedulers, and managers

---

## 9.3 Create Required Channels

By default, every team has a **General** channel. You need to create additional channels.

**How to create a channel:**
1. In Teams, find your `Mine Site Operations` team
2. Click the **three dots (...)** next to the team name
3. Click **Add channel**
4. Fill in the channel name and description
5. Set **Privacy:** Standard (visible to all team members)
6. Click **Create**

---

### Channels to create:

| Channel Name | Purpose | Who Posts | Who Reads |
|-------------|---------|----------|----------|
| `Task Scheduling` | Notifies schedulers when tasks are scoped and ready to schedule | Flow 2 | Task Schedulers |
| `Today's Tasks` | Morning briefing of all tasks active today | Flow 4 | All Supervisors |
| `Management Summary` | Completed task notifications | Flow 5 | Department Managers |
| `Critical Alerts` | Critical task escalations | Flow 5 | Mine Manager + Senior Management |
| `Mine Planning` | Department channel for Mine Planning tasks | Flow 1, 2 | Mine Planning team |
| `Mine Services` | Department channel for Mine Services tasks | Flow 1, 2 | Mine Services team |
| `Load & Haul` | Department channel for Load & Haul tasks | Flow 1, 2 | Load & Haul supervisors |
| `Drill & Blast` | Department channel for Drill & Blast tasks | Flow 1, 2 | Drill & Blast supervisors |
| `Dragline` | Department channel for Dragline tasks | Flow 1, 2 | Dragline operators/supervisors |

---

## 9.4 Channel Descriptions (copy-paste when creating):

| Channel | Description to use |
|---------|-------------------|
| Task Scheduling | Tasks scoped by supervisor and awaiting date/time scheduling. Action required by schedulers. |
| Today's Tasks | Live daily briefing of all active work tasks across departments. Updated automatically at 6 AM. |
| Management Summary | Automated completion reports for all departments. Provides real-time task completion visibility. |
| Critical Alerts | Escalation channel for Critical priority tasks. Mine Manager and senior staff only. |
| Mine Planning | Work task notifications for the Mine Planning department. |
| Mine Services | Work task notifications for the Mine Services department. |
| Load & Haul | Work task notifications for the Load & Haul department. |
| Drill & Blast | Work task notifications for the Drill & Blast department. |
| Dragline | Work task notifications for the Dragline department. |

---

## 9.5 Set Channel Membership (Recommended)

For operational channels, it's good practice to set up who can post to avoid channel clutter.

For **Management Summary** and **Critical Alerts**:
1. Click the **three dots (...)** next to the channel
2. Click **Manage channel**
3. Under **Channel moderation**, set to **On**
4. Set: Only owners and moderators can post new messages
5. (The Flow bot is an owner-level poster — flows bypass moderation settings)

---

## 9.6 Connect Power Automate to Teams Channels

When you build the flows, Power Automate needs to know which Teams and which channel to post to. Here's how to find the exact details:

### Find your Team ID and Channel ID:

**Method 1 — From Teams desktop app:**
1. Right-click on your team name → **Get link to team**
2. The URL contains the team ID:  
   `https://teams.microsoft.com/l/team/...?groupId=XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX`
3. Copy the GUID after `groupId=`

**Method 2 — In Power Automate (easier for beginners):**
When you add a Teams action in Power Automate and click the "Team" dropdown, Teams will appear by name. Just select it from the dropdown — no need to know the GUID.

---

## 9.7 Record Your Channel Names Here

When building flows, you'll need to type these channel names exactly. Record them here:

| Flow | Channel Used | Exact Channel Name in Teams |
|------|-------------|---------------------------|
| Flow 2 | Scheduler notification | `Task Scheduling` |
| Flow 3 | Supervisor reminder | (Sent directly to user, no channel) |
| Flow 4 | Today's briefing | `Today's Tasks` |
| Flow 4 | Department notification | Mine Planning / Mine Services / Load & Haul / Drill & Blast / Dragline |
| Flow 5 | Management notification | `Management Summary` |
| Flow 5 | Critical escalation | `Critical Alerts` |

> **Tip:** Channel names in Power Automate dropdowns are case-sensitive and must match exactly. Copy them from Teams.

---

## 9.8 Pin the Power Apps App in Teams

To make it easy for users to access the Power Apps form directly from Teams:

1. In Teams, click **Apps** (left sidebar)
2. Search for **Power Apps**
3. Click **Add**
4. Once added, click the Power Apps icon in the left sidebar
5. You should see `MineSiteTaskManager` listed
6. Click the **three dots (...)** next to the app name → **Pin** (adds it to the sidebar permanently)

---

## 9.9 Add a SharePoint Tab to Key Channels

For easy access to the WorkTasks list from within Teams:

1. Go to the `Task Scheduling` channel
2. Click the **+** tab at the top of the channel
3. Search for **SharePoint**
4. Click **SharePoint**
5. Select your site → Select the `WorkTasks` list
6. Click **Save**

Repeat for the `Management Summary` channel using the `CompletionRegister` list.

---

## 9.10 Test Teams Integration

Before finalising your flows, test that Teams posts are working:

1. In Power Automate, create a **test flow** with a manual trigger
2. Add one action: **Microsoft Teams → Post a message in a chat or channel**
3. Set Team = Mine Site Operations, Channel = General
4. Message = `Test message from Power Automate - Flow integration working ✅`
5. Run the flow
6. Check Teams — the message should appear in the General channel within seconds

If you see the message: Teams integration is working correctly. Delete this test flow.

---

## Common Teams/Power Automate Issues

| Issue | Fix |
|-------|-----|
| Team doesn't appear in dropdown | Ensure you are a member of the team with posting rights |
| Channel not in dropdown | Channels only appear after the team is selected first |
| Message posts to wrong channel | Double-check channel names — "Load & Haul" and "Load and Haul" are different |
| "Access denied" error | The Power Automate connection account must be a Teams member |
| Adaptive card doesn't render | Check the card JSON is valid at https://adaptivecards.io/designer |
