# BHP BMA Enabling Task Manager — Deployment Guide

**Version:** 1.0  
**Target Sites:** Saraji, Caval Ridge  
**Platform:** Microsoft Power Platform (Power Apps, Power Automate, SharePoint, Power BI)  
**Estimated Deployment Time:** 2–3 days (excluding BHP IT approvals)

---

## Prerequisites

Before starting, confirm the following are in place:

| Prerequisite | Owner | Status |
|---|---|---|
| SharePoint site created (`BMAEnablingTasks`) | BHP IT | ☐ |
| Power Apps premium licences assigned (supervisors + planners) | BHP IT / M365 Admin | ☐ |
| Power Automate premium licences (if not included in M365 plan) | BHP IT / M365 Admin | ☐ |
| Power BI Pro licences for planners and superintendents | BHP IT / M365 Admin | ☐ |
| PnP.PowerShell module installed on deployment workstation | Deployer | ☐ |
| PAC CLI (Power Platform CLI) installed on deployment workstation | Deployer | ☐ |
| Site Owner access on the SharePoint site | BHP IT | ☐ |
| Power Platform environment identified (default or dedicated BMA environment) | BHP IT | ☐ |
| Microsoft Teams — department channels created at each site | Site IT / Mine Planner | ☐ |

Install PAC CLI:
```powershell
winget install Microsoft.PowerAppsCLI
# OR
npm install -g @microsoft/powerplatform-cli
```

Install PnP.PowerShell:
```powershell
Install-Module PnP.PowerShell -Scope CurrentUser -Force
```

---

## Step 1 — Create the SharePoint Site

1. Go to the SharePoint Admin Centre (requires Global Admin or SharePoint Admin role)
2. Create a new **Team Site**: `BMA Enabling Tasks`
3. Site URL: `https://bhp.sharepoint.com/sites/BMAEnablingTasks`
4. Set privacy: **Private** (members only)
5. Add the mine planner accounts as **Site Owners**
6. Add all superintendent and supervisor accounts as **Site Members**
7. Note the full site URL — you'll need it in all subsequent steps

---

## Step 2 — Provision SharePoint Lists

Run the provisioning PowerShell script from the `/deployment` directory:

```powershell
# Navigate to the deployment directory
cd .\deployment

# Create all lists AND seed reference data (recommended for initial deployment)
.\01-provision-sharepoint.ps1 -SiteUrl "https://bhp.sharepoint.com/sites/BMAEnablingTasks" -SeedData
```

This creates:
- **TaskTypes** — 35 enabling task types pre-populated with done-definitions and P50/P80/P90 estimates
- **DelayReasons** — 22 standardised delay reason codes
- **Departments** — 10 department records (5 per site — structure only, needs manual update)
- **EquipmentMovements** — empty (populated by mine planner from Spry)
- **EnabledTasks** — empty (the main tracking list)

**After running the script, manually update the Departments list:**

1. Open the SharePoint site → Departments list
2. For each department record, replace:
   - `REPLACE_WITH_SUPER_UPN` → the actual superintendent's BHP email (e.g. `john.smith@bhpbilliton.com`)
   - `REPLACE_AFTER_TEAMS_SETUP` → the actual Teams channel and group IDs (see Step 3)

---

## Step 3 — Get Teams Channel IDs

For each department Teams channel (one per department per site), you need the **Group ID** and **Channel ID** to configure the Power Automate flow notifications.

**To get the Channel ID:**
1. Open Microsoft Teams
2. Navigate to the relevant channel
3. Click `•••` (More options) → **Get link to channel**
4. The URL contains both IDs in the format:
   `https://teams.microsoft.com/l/channel/19:CHANNEL_ID@thread.tacv2/...?groupId=GROUP_ID&...`
5. Copy the `19:...@thread.tacv2` portion as the **Channel ID**
6. Copy the `groupId` value as the **Group ID**
7. Paste into the Departments list for the relevant department

**Alternatively, use PowerShell:**
```powershell
Connect-MgGraph -Scopes "Team.ReadBasic.All", "Channel.ReadBasic.All"
Get-MgTeam | Select DisplayName, Id
# Then for a specific team:
Get-MgTeamChannel -TeamId "YOUR_GROUP_ID" | Select DisplayName, Id
```

---

## Step 4 — Update Configuration Files

Before importing the Power App and flows, update the site URL and other configuration values in the source files.

### 4a — Update SharePoint URL in DataSource files

Open each file in `/powerapps/BHPEnablingTaskManager/DataSources/` and replace:
```
"https://bhp.sharepoint.com/sites/BMAEnablingTasks"
```
with the actual SharePoint site URL if different.

### 4b — Update SharePoint URL in Flow definitions

Open each `definition.json` in `/powerautomate/` and replace all instances of:
```
https://bhp.sharepoint.com/sites/BMAEnablingTasks
```
with the actual site URL.

### 4c — Update Power BI Dashboard URL

Once the Power BI report is published (Step 6), update the `OnSelect` property of `PDCA_PBI_Btn` in `/powerapps/BHPEnablingTaskManager/Src/PDCAScreen.fx.yaml`:

```yaml
OnSelect: =Launch("https://app.powerbi.com/groups/YOUR_WORKSPACE_ID/reports/YOUR_REPORT_ID", {}, LaunchTarget.New)
```

Replace `YOUR_WORKSPACE_ID` and `YOUR_REPORT_ID` with the actual values from the published Power BI report URL.

---

## Step 5 — Import and Publish the Power App

### Pack the canvas app source files

```powershell
# From the repository root
pac canvas pack --sources .\powerapps\BHPEnablingTaskManager\Src --msapp .\BHPEnablingTaskManager.msapp
```

### Import via Power Apps Studio

1. Go to [make.powerapps.com](https://make.powerapps.com)
2. Select the correct BHP Power Platform **environment**
3. Go to **Apps** → **Import canvas app**
4. Upload `BHPEnablingTaskManager.msapp`
5. The app will open in Power Apps Studio
6. Connect the five SharePoint data sources to the provisioned lists:
   - EnabledTasks → `https://bhp.sharepoint.com/sites/BMAEnablingTasks` → `EnabledTasks`
   - TaskTypes → same site → `TaskTypes`
   - DelayReasons → same site → `DelayReasons`
   - Departments → same site → `Departments`
   - EquipmentMovements → same site → `EquipmentMovements`
7. Click **Save** then **Publish**

### Share the app

1. In Power Apps, click `•••` next to the app → **Share**
2. Add all mine planners as **Co-owners** (can edit)
3. Add all superintendents and supervisors as **Users** (can use)
4. Check **Send an email invitation** so users get the link

---

## Step 6 — Import Power Automate Flows

Import each flow from the `/powerautomate/` directory. Flows must be imported **one at a time** through the Power Automate portal.

**For each flow directory:**

1. Go to [make.powerautomate.com](https://make.powerautomate.com)
2. Select the correct BHP environment
3. Go to **My flows** → **Import** → **Import Package (Legacy)**

   > **Note:** The JSON files in this repo are flow **definitions**, not export packages. You have two options:
   >
   > **Option A (Recommended):** Create each flow manually using the definition.json as a reference blueprint. The definition files document every trigger, action, condition, and connection exactly — a skilled Power Automate developer can build each flow in 1–2 hours.
   >
   > **Option B:** Use PAC CLI to deploy flows as part of a Power Platform solution package (requires a Solution export — contact BHP's Power Platform CoE for assistance with solution packaging).

4. Configure connections for each flow:
   - **SharePoint connection:** Connect to `https://bhp.sharepoint.com/sites/BMAEnablingTasks` using the mine planner's BHP account (or a service account)
   - **Teams connection:** Connect using the same account
   - **Office 365 Outlook connection:** For the email flows (Flows 4 and 5)

5. **Enable** each flow after import (flows are imported in disabled state)

**Flow schedule summary:**

| Flow | Trigger | Time (AEST) |
|---|---|---|
| 01 — Daily Notification | Scheduled | 05:30 daily |
| 02 — Overdue Alert | Scheduled | Every 2h, 07:00–17:00 |
| 03 — New Task Assignment | SharePoint item created | Immediate |
| 04 — Shift Completion Summary | Scheduled | 06:30 and 18:30 daily |
| 05 — Weekly PDCA Report | Scheduled | Monday 07:00 |

---

## Step 7 — Build the Power BI PDCA Dashboard

Connect Power BI Desktop to the SharePoint `EnabledTasks` list and build the PDCA dashboard. Minimum required visuals:

| Visual | Data | Purpose |
|---|---|---|
| KPI card — Completion Rate | EnabledTasks[Status] | Weekly/monthly PDCA |
| KPI card — On-Time Delivery | Planned vs Actual end date | Schedule reliability |
| KPI card — Avg Variance (days) | VarianceDays field | Plan accuracy |
| Bar chart — Delay Reason Pareto | DelayReasonId, count | Top 5 delay causes |
| Table — Department performance | Department, Status, VarianceDays | Comparative performance |
| Line chart — Completion Rate trend | Week number, Completion % | Is it improving? |
| Histogram — Task duration distribution | ActualDurationDays by TaskTypeId | Probabilistic library |
| Matrix — Task type P50 vs actual | TaskTypeId, PlannedDurationDays, actual | Duration standard validation |

**Publish and get the URL:**
1. Publish the report to the BHP Power BI workspace
2. Copy the report URL
3. Update `PDCAScreen.fx.yaml` with the actual URL (Step 4c)
4. Re-pack and re-publish the Power App

---

## Step 8 — User Training and Go-Live

### Training sessions (suggested format)

**Planners (1.5 hours):**
- Adding enabling tasks (AddTaskScreen)
- Linking to equipment movements
- Managing the task list (TaskListScreen)
- Reading the PDCA dashboard (Power BI)
- Weekly PDCA review meeting process

**Superintendents (45 minutes):**
- Viewing department status (HomeScreen)
- Understanding automated alerts (Teams messages)
- Using the PDCA screen in the app
- Weekly PDCA review expectations

**Supervisors (30 minutes):**
- Viewing today's tasks (HomeScreen → department card)
- Marking tasks complete (CompleteTaskScreen) — the 3-tap workflow
- Selecting delay reasons — when to use each code
- Logging unplanned tasks

### Go-live checklist

- [ ] All SharePoint lists provisioned and seeded
- [ ] Departments list updated with real superintendent emails and Teams channel IDs
- [ ] Power App published and shared with all users
- [ ] All 5 Power Automate flows enabled and tested
- [ ] Power BI dashboard published and URL updated in the app
- [ ] At least one test task created end-to-end (create → notify → complete → report)
- [ ] Planner training complete — Saraji
- [ ] Planner training complete — Caval Ridge
- [ ] Superintendent training complete — both sites
- [ ] Supervisor training complete — both sites
- [ ] First daily notification received and verified correct
- [ ] Hypercare period defined (recommended: 30 days with weekly check-in)

---

## Maintenance and Administration

### Monthly tasks (Mine Planner)
- Review the P50/P80/P90 duration estimates in the TaskTypes list
- Update estimates where SampleSize ≥ 10 with statistically validated values from Power BI duration histograms
- Review and add any new task types not in the catalogue
- Archive completed equipment movements older than 6 months

### Quarterly tasks (Mine Planning Superintendent)
- Review delay reason Pareto — are any new reason codes needed?
- Review department completion rates — identify systemic underperformance
- Validate that unplanned task volume is reducing as the process matures
- Review Leader Standard Work compliance — are superintendents reviewing the daily board?

### When a superintendent changes
- Update the `SuperintendentEmail` field in the Departments list for the affected department
- The Power Automate flows will automatically route to the new email

### Adding a new site (future convergence — Goonyella / Peak Downs)
1. Run `01-provision-sharepoint.ps1 -SeedData` against the new site
2. Add new site entries to the Departments list seed data
3. Add the new site as a Choice option in the `Site` field of each list
4. Update the `App.OnStart` formula in Power Apps to include the new site in `gblCurrentSite` options
5. Share the app with the new site's users
