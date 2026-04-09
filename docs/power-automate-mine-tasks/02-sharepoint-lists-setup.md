# Document 2: SharePoint Lists Setup

---

## 2.1 Before You Begin

You need to create **3 SharePoint lists** and **1 document library** before building any Power Automate flows. The flows connect to these lists.

**Time required:** 45 minutes  
**Access required:** SharePoint Site Owner or Site Admin

---

## 2.2 Create Your SharePoint Site

### Step-by-step:

1. Open a browser and go to: `https://[yourcompany].sharepoint.com`
2. Click **+ Create site** (top left of SharePoint home)
3. Select **Team site**
4. Fill in:
   - **Site name:** `Mine Site Tasks`
   - **Site description:** `Work task management for mine site departments`
   - **Privacy:** Private
5. Click **Next**, then **Finish**
6. Your site URL will be: `https://[yourcompany].sharepoint.com/sites/MineSiteTasks`

> **Save this URL** — you will need it when building every flow.

---

## 2.3 List 1: WorkTasks

This is the **main list** where all tasks live throughout their lifecycle.

### How to create a new list:

1. Go to your SharePoint site
2. Click **+ New** in the top menu bar
3. Select **List**
4. Click **Blank list**
5. Name it exactly: `WorkTasks`
6. Click **Create**

### Columns to add:

SharePoint creates a `Title` column by default. Rename it and add the following columns.

---

#### Rename the default "Title" column:
1. Click the column header **Title**
2. Click **Column settings → Rename**
3. Type: `Task Title`
4. Click **Save**

---

#### Add each column below (repeat for each):

**How to add a column:**
1. Click **+ Add column** (far right of the column headers)
2. Select the column type listed below
3. Fill in the Name and any settings
4. Click **Save**

---

| Column Name | Type | Settings / Choices |
|-------------|------|-------------------|
| Task Title | Single line of text | (renamed from Title) |
| Department | Choice | Mine Planning; Mine Services; Load & Haul; Drill & Blast; Dragline |
| Task Description | Multiple lines of text | Plain text |
| Priority | Choice | Critical; High; Medium; Low — Default: Medium |
| Status | Choice | Initiated; Scoped; Scheduled; In Progress; Completed; Cancelled — Default: Initiated |
| Assigned Supervisor | Person | Allow selection of: People only |
| Initiated By | Person | Allow selection of: People only |
| Initiated Date | Date and Time | Date and Time format |
| Scope Notes | Multiple lines of text | Plain text |
| Crew Required | Multiple lines of text | Plain text (e.g., "2x Operators, 1x Supervisor") |
| Equipment Required | Multiple lines of text | Plain text (e.g., "EX5600 shovel, 793F truck") |
| Permits Required | Multiple lines of text | Plain text (e.g., "PTW, SWMS, Isolation Cert") |
| Estimated Duration Hours | Number | Min: 0, Max: 24, Decimal places: 1 |
| Scoped By | Person | Allow selection of: People only |
| Scoped Date | Date and Time | Date only |
| Scheduled Date | Date and Time | Date only |
| Scheduled Start Time | Choice | 06:00; 07:00; 08:00; 14:00; 18:00; 00:00 |
| Shift | Choice | Day Shift; Afternoon Shift; Night Shift |
| Scheduled By | Person | Allow selection of: People only |
| Scheduled Date Logged | Date and Time | Date and Time format |
| Executed By | Person | Allow selection of: People only |
| Actual Start Time | Date and Time | Date and Time format |
| Actual Completion Time | Date and Time | Date and Time format |
| Completion Notes | Multiple lines of text | Plain text |
| Issues Encountered | Multiple lines of text | Plain text |
| Risk Rating | Choice | High; Medium; Low |
| Task ID | Single line of text | Leave blank — auto-filled by Flow 1 |

---

### Set up a default view (optional but recommended):

1. Click **All Items** at the top → **Create new view**
2. Name it: `Active Tasks`
3. Filter: Status is not equal to `Completed` and Status is not equal to `Cancelled`
4. Click **OK**

---

## 2.4 List 2: CompletionRegister

This list stores a copy of every completed task as an audit record.

### Create the list:
1. Click **+ New → List → Blank list**
2. Name it: `CompletionRegister`
3. Click **Create**

### Columns to add:

| Column Name | Type | Notes |
|-------------|------|-------|
| Task Title | Single line of text | (renamed from Title) |
| Department | Choice | Same choices as WorkTasks |
| Priority | Choice | Same choices as WorkTasks |
| Assigned Supervisor | Person | |
| Scheduled Date | Date and Time | Date only |
| Actual Start Time | Date and Time | Date and Time |
| Actual Completion Time | Date and Time | Date and Time |
| Executed By | Person | |
| Crew Members | Multiple lines of text | |
| Equipment Used | Multiple lines of text | |
| Completion Notes | Multiple lines of text | |
| Issues Encountered | Multiple lines of text | |
| Original Task ID | Single line of text | Links back to WorkTasks |
| Completion Logged | Date and Time | Auto set by Flow 5 |

---

## 2.5 List 3: DepartmentContacts

This lookup list stores supervisor and manager email addresses. Flows use this to look up who to notify.

### Create the list:
1. Click **+ New → List → Blank list**
2. Name it: `DepartmentContacts`
3. Click **Create**

### Columns to add:

| Column Name | Type | Notes |
|-------------|------|-------|
| Department | Choice | Mine Planning; Mine Services; Load & Haul; Drill & Blast; Dragline — (renamed from Title) |
| Supervisor Name | Single line of text | |
| Supervisor Email | Single line of text | Must be a valid M365 email |
| Manager Name | Single line of text | |
| Manager Email | Single line of text | Must be a valid M365 email |
| Teams Channel ID | Single line of text | Filled in after Teams setup (optional) |

### Populate the list with your data:

Click **+ New** for each department and fill in the real names and email addresses.

Example:

| Department | Supervisor Name | Supervisor Email | Manager Name | Manager Email |
|-----------|----------------|-----------------|-------------|--------------|
| Mine Planning | John Smith | j.smith@yourcompany.com | Sarah Jones | s.jones@yourcompany.com |
| Load & Haul | Mike Brown | m.brown@yourcompany.com | Sarah Jones | s.jones@yourcompany.com |
| Drill & Blast | Chris Lee | c.lee@yourcompany.com | Tom Wilson | t.wilson@yourcompany.com |
| Dragline | Dave Miller | d.miller@yourcompany.com | Tom Wilson | t.wilson@yourcompany.com |
| Mine Services | Lisa White | l.white@yourcompany.com | Sarah Jones | s.jones@yourcompany.com |

---

## 2.6 Document Library: TaskAttachments

1. Click **+ New → Document library**
2. Name it: `TaskAttachments`
3. Click **Create**

This library will hold SWMS documents, permits, and completion photos uploaded through Power Apps.

---

## 2.7 Get Your List GUIDs (Important for Flows)

When building flows, Power Automate will ask you to select your SharePoint site and list. However, it's useful to note your list GUIDs in case of connection issues.

**To find a list GUID:**
1. Go to your list (e.g., WorkTasks)
2. Click **Settings (gear icon) → List settings**
3. Look at the URL — it will contain `List=%7B` followed by a GUID like:  
   `List=%7B12345678-abcd-efgh-ijkl-123456789012%7D`
4. The GUID is the characters between `%7B` and `%7D`

**Record your GUIDs here:**

| List | GUID |
|------|------|
| WorkTasks | ______________________________________ |
| CompletionRegister | ______________________________________ |
| DepartmentContacts | ______________________________________ |

---

## 2.8 Verify Your Setup

Before moving to the flows, check:

- [ ] SharePoint site created at correct URL
- [ ] `WorkTasks` list exists with all columns
- [ ] `CompletionRegister` list exists with all columns
- [ ] `DepartmentContacts` list exists and is populated with real email addresses
- [ ] `TaskAttachments` document library created
- [ ] You can add a test item to `WorkTasks` manually

---

## 2.9 Beginner Troubleshooting

**Problem:** I can't find "+ Add column"  
**Fix:** Make sure you are in the list view (not a form). Click the list name in the left navigation. The + Add column appears at the far right of the column header row.

**Problem:** My Choice column options show as one long string  
**Fix:** Each choice must be on its own line. Press **Enter** between each choice when typing them in.

**Problem:** Person column won't let me save  
**Fix:** Make sure the person you're adding has an account in your Microsoft 365 tenant.

**Problem:** I accidentally named a list incorrectly  
**Fix:** Go to **List settings → List name, description and navigation** and rename it. Also update the name in any flows that reference it.
