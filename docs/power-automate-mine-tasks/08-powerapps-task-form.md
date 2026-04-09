# Document 8: Power Apps — Mine Site Task Management App

---

## Overview

The Power Apps canvas app gives users a mobile-friendly interface for:
- **Planners/Schedulers:** Creating new work tasks
- **Supervisors:** Viewing assigned tasks, completing the scope, and marking tasks as executed
- **All roles:** Viewing the task dashboard filtered by department

| Field | Value |
|-------|-------|
| **App Name** | `MineSiteTaskManager` |
| **Type** | Canvas App (tablet layout) |
| **Data Source** | SharePoint WorkTasks list |
| **Time to build** | ~60 minutes |

---

## App Structure (Screens)

```
Screen 1: HOME / DASHBOARD
    - Filter by Department
    - Task count cards (Initiated / Scoped / Scheduled / In Progress)
    - Recent tasks gallery

Screen 2: NEW TASK FORM (Planner/Scheduler)
    - Fill in task details
    - Submit → creates SharePoint item

Screen 3: TASK DETAIL / SCOPE (Supervisor)
    - View task details
    - Add scope information
    - Submit scope → updates status to "Scoped"

Screen 4: SCHEDULE TASK (Task Scheduler)
    - Set date, time, shift
    - Confirm → updates status to "Scheduled"

Screen 5: EXECUTE / COMPLETE TASK (Supervisor)
    - Record actual start/end times
    - Add completion notes
    - Upload photo (optional)
    - Mark Complete → updates status to "Completed"
```

---

## Step-by-Step Build Instructions

### Step 1: Open Power Apps

1. Go to `https://make.powerapps.com`
2. Sign in with your Microsoft 365 account
3. Confirm you are in the correct Environment (top right)

---

### Step 2: Create a New Canvas App

1. Click **+ Create** in the left nav
2. Select **Canvas app from blank**
3. Fill in:
   - **App name:** `MineSiteTaskManager`
   - **Format:** Tablet (recommended for mine site use on tablets/desktop)
4. Click **Create**

The Power Apps editor will open with a blank screen.

---

### Step 3: Connect to SharePoint

1. In the left panel, click the **Data** icon (cylinder/database shape)
2. Click **+ Add data**
3. Search for **SharePoint**
4. Click **SharePoint**
5. Enter your SharePoint site URL:  
   `https://[yourcompany].sharepoint.com/sites/MineSiteTasks`
6. Click **Connect**
7. A list of your SharePoint lists will appear. Select:
   - **WorkTasks** ✓
   - **DepartmentContacts** ✓
   - **CompletionRegister** ✓
8. Click **Connect**

You will now see these data sources in the Data panel.

---

### Step 4: Build Screen 1 — Dashboard

#### Set up the screen:

1. Rename the default screen: click on `Screen1` in the tree view (left panel) → press F2 → type `HomeScreen`

#### Add a header rectangle:

1. Click **+ Insert → Rectangle**
2. Set properties in the right panel:
   - **Fill:** `ColorValue("#1a3c5e")` (dark blue)
   - **X:** 0, **Y:** 0, **Width:** 1366, **Height:** 80

#### Add app title text:

1. **Insert → Text label**
2. **Text:** `"Mine Site Task Manager"`
3. **Color:** White
4. **Size:** 24, **Bold:** On
5. Position inside the blue header

#### Add a Department dropdown:

1. **Insert → Input → Drop down**
2. **Items:** `["All Departments", "Mine Planning", "Mine Services", "Load & Haul", "Drill & Blast", "Dragline"]`
3. Rename the control: `DropdownDepartment`
4. Position below the header

#### Add a Gallery showing active tasks:

1. **Insert → Blank vertical gallery**
2. In the **Items** property (formula bar at top), enter:

```
If(
    DropdownDepartment.Selected.Value = "All Departments",
    Filter(WorkTasks, Status.Value <> "Completed" && Status.Value <> "Cancelled"),
    Filter(WorkTasks, Department.Value = DropdownDepartment.Selected.Value && Status.Value <> "Completed" && Status.Value <> "Cancelled")
)
```

3. Inside the gallery template, add:
   - **Label 1** — Text: `ThisItem.Title` — Bold, size 16
   - **Label 2** — Text: `ThisItem.Department.Value & " | " & ThisItem.Status.Value`
   - **Label 3** — Text: `ThisItem.Priority.Value`
   - **Color for Label 3:** 
     ```
     Switch(ThisItem.Priority.Value, "Critical", Color.Red, "High", Color.Orange, "Medium", Color.DarkBlue, Color.Gray)
     ```

4. Add an **OnSelect** action on the gallery item to navigate to the detail screen:
   ```
   Set(varSelectedTask, ThisItem); Navigate(TaskDetailScreen, ScreenTransition.Fade)
   ```

#### Add status count cards:

1. Insert 4 **Rectangle + Label** combos at the top (below header, above gallery)
2. Each card shows a count:

| Card | Label Formula |
|------|--------------|
| Initiated | `CountIf(WorkTasks, Status.Value = "Initiated")` |
| Scoped | `CountIf(WorkTasks, Status.Value = "Scoped")` |
| Scheduled | `CountIf(WorkTasks, Status.Value = "Scheduled")` |
| In Progress | `CountIf(WorkTasks, Status.Value = "In Progress")` |

#### Add a "New Task" button:

1. **Insert → Button**
2. **Text:** `"+ New Task"`
3. **Fill:** `ColorValue("#1a7a2e")` (green)
4. **OnSelect:** `Navigate(NewTaskScreen, ScreenTransition.Cover)`

---

### Step 5: Build Screen 2 — New Task Form (Planner)

1. Click **+ New screen → Blank**
2. Rename: `NewTaskScreen`

#### Add a form:

1. **Insert → Edit form**
2. In the right panel, set **Data source:** `WorkTasks`
3. Click **Edit fields** → Add the following fields:
   - Task Title (Title)
   - Department
   - Task Description
   - Priority
   - Assigned Supervisor
   - Risk Rating
4. Rename the form: `NewTaskForm`

#### Add a Submit button:

1. **Insert → Button**
2. **Text:** `"Submit Task"`
3. **Fill:** Green
4. **OnSelect:**
```
If(
    IsBlank(NewTaskForm.LastSubmit),
    SubmitForm(NewTaskForm);
    Patch(
        WorkTasks,
        NewTaskForm.LastSubmit,
        {
            Status: {Value: "Initiated"},
            InitiatedDate: Now()
        }
    );
    Notify("Task submitted successfully!", NotificationType.Success);
    Navigate(HomeScreen, ScreenTransition.Back),
    Notify("Please fill in all required fields.", NotificationType.Error)
)
```

> **Note:** `SubmitForm` saves the form to SharePoint. The `Patch` updates the Status and date immediately after. This triggers Flow 1.

#### Add a Back button:

1. **Insert → Button**
2. **Text:** `"< Back"`
3. **OnSelect:** `Navigate(HomeScreen, ScreenTransition.Back)`

---

### Step 6: Build Screen 3 — Task Detail / Scope (Supervisor)

1. **+ New screen → Blank**
2. Rename: `TaskDetailScreen`

#### Display task information:

1. Add labels to show the selected task's data using `varSelectedTask`:

```
varSelectedTask.Title
varSelectedTask.Department.Value
varSelectedTask.Priority.Value
varSelectedTask.Status.Value
varSelectedTask.TaskDescription
```

#### Add scope input fields (only visible to supervisor):

1. **Insert → Text input** for each scoping field:
   - `TextInputCrew` — Hint text: "Enter crew requirements"
   - `TextInputEquipment` — Hint text: "Enter equipment needed"
   - `TextInputPermits` — Hint text: "Enter permits/SWMS required"
   - `TextInputDuration` — Hint text: "Estimated hours"
   - `TextInputScopeNotes` — Hint text: "Additional scope notes"

#### Add "Submit Scope" button:

1. **Insert → Button**
2. **Text:** `"Submit Scope"`
3. **Fill:** Blue
4. **OnSelect:**

```
Patch(
    WorkTasks,
    varSelectedTask,
    {
        Status: {Value: "Scoped"},
        CrewRequired: TextInputCrew.Text,
        EquipmentRequired: TextInputEquipment.Text,
        PermitsRequired: TextInputPermits.Text,
        EstimatedDurationHours: Value(TextInputDuration.Text),
        ScopeNotes: TextInputScopeNotes.Text,
        ScopedDate: Today()
    }
);
Notify("Scope submitted. Scheduler will be notified.", NotificationType.Success);
Navigate(HomeScreen, ScreenTransition.Back)
```

> This `Patch` update triggers **Flow 2** because it changes the Status to "Scoped".

---

### Step 7: Build Screen 4 — Schedule Task

1. **+ New screen → Blank**
2. Rename: `ScheduleTaskScreen`

#### Add scheduling input controls:

1. **Date picker** — `DatePickerScheduled`
2. **Dropdown** for Start Time — Items: `["06:00","07:00","08:00","14:00","18:00","00:00"]`
3. **Dropdown** for Shift — Items: `["Day Shift","Afternoon Shift","Night Shift"]`

#### Add "Confirm Schedule" button:

```
Patch(
    WorkTasks,
    varSelectedTask,
    {
        Status: {Value: "Scheduled"},
        ScheduledDate: DatePickerScheduled.SelectedDate,
        ScheduledStartTime: {Value: DropdownStartTime.Selected.Value},
        Shift: {Value: DropdownShift.Selected.Value},
        ScheduledDateLogged: Now()
    }
);
Notify("Task scheduled successfully!", NotificationType.Success);
Navigate(HomeScreen, ScreenTransition.Back)
```

---

### Step 8: Build Screen 5 — Execute / Complete Task

1. **+ New screen → Blank**
2. Rename: `CompleteTaskScreen`

#### Add completion input controls:

1. **Date+time picker** or time input — Actual Start Time
2. **Date+time picker** — Actual Completion Time
3. **Text area** — Completion Notes
4. **Text area** — Issues Encountered

#### Add "Mark as Complete" button:

```
Patch(
    WorkTasks,
    varSelectedTask,
    {
        Status: {Value: "Completed"},
        ActualStartTime: DateTimeValue(TextInputActualStart.Text),
        ActualCompletionTime: DateTimeValue(TextInputActualEnd.Text),
        CompletionNotes: TextInputCompletionNotes.Text,
        IssuesEncountered: TextInputIssues.Text,
        ExecutedBy: {
            Claims: "i:0#.f|membership|" & User().Email,
            DisplayName: User().FullName,
            Email: User().Email
        }
    }
);
Notify("Task marked as complete. Management has been notified.", NotificationType.Success);
Navigate(HomeScreen, ScreenTransition.Back)
```

> This triggers **Flow 5** because it sets Status to "Completed".

---

### Step 9: Add Navigation Between Screens

On the HomeScreen gallery, the OnSelect is already set to navigate to TaskDetailScreen.

On TaskDetailScreen, add logic to show different action buttons based on current task status:

```
// Show "Submit Scope" button only if Status = Initiated
Visible: varSelectedTask.Status.Value = "Initiated"

// Show "Schedule" button only if Status = Scoped
Visible: varSelectedTask.Status.Value = "Scoped"

// Show "Complete" button only if Status = In Progress
Visible: varSelectedTask.Status.Value = "In Progress"
```

---

### Step 10: Save and Publish

1. Click **File → Save** (or Ctrl+S)
2. Click **Publish to this device** for testing, or **Share** to share with users
3. To publish to Teams: Go to Teams → Apps → Upload custom app (or use Power Apps app in Teams)

---

## Sharing the App

1. In Power Apps maker portal, click the app's **three dots (...)**
2. Click **Share**
3. Add the names/emails of all users who need access (planners, supervisors, schedulers)
4. Ensure they have at least **"Can use"** permission
5. They can access the app from `https://apps.powerapps.com` or via the Power Apps app in Teams

---

## Beginner Tips for Power Apps

| Tip | Detail |
|-----|--------|
| **Tree View** | Use the left panel Tree View to find and rename every control |
| **Formula bar** | Every property (like `Text`, `Fill`, `OnSelect`) has a formula bar at the top — click the property dropdown to switch |
| **Preview mode** | Press the ▶ Play button to test your app without saving |
| **Ctrl+Z** | Undo your last action if something breaks |
| **Lock a control** | Right-click → Lock to prevent accidentally moving a positioned element |
| **Error in formula** | Red underline in formula bar = error. Hover over it for details |
