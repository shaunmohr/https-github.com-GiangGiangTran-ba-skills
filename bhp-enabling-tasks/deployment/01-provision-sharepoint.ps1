#Requires -Modules PnP.PowerShell
<#
.SYNOPSIS
    BHP BMA Enabling Task Manager — SharePoint provisioning script.
    Creates all required SharePoint lists, columns, views, and seeds reference data.

.DESCRIPTION
    Run this script ONCE against the target SharePoint site. It is idempotent —
    it checks for existing lists before creating them. Run with a BHP account
    that has Site Owner permissions on the target site.

.PARAMETER SiteUrl
    Full URL of the SharePoint site (e.g. https://bhp.sharepoint.com/sites/BMAEnablingTasks).
    Create this site manually in SharePoint Admin before running the script.

.PARAMETER SeedData
    Switch. When set, populates TaskTypes, DelayReasons, and Departments lists with
    seed data from the JSON files in /sharepoint/seed-data/. Run after list creation.

.EXAMPLE
    # Create lists only (first run):
    .\01-provision-sharepoint.ps1 -SiteUrl "https://bhp.sharepoint.com/sites/BMAEnablingTasks"

    # Create lists AND seed reference data (recommended for initial deployment):
    .\01-provision-sharepoint.ps1 -SiteUrl "https://bhp.sharepoint.com/sites/BMAEnablingTasks" -SeedData

.NOTES
    Prerequisites:
    - PnP.PowerShell module: Install-Module PnP.PowerShell -Scope CurrentUser
    - Site Owner permissions on the target SharePoint site
    - BHP IT approval to create external connections (PnP uses OAuth — may need IT exemption)
    - Run from the /deployment directory of this repository

    Post-provisioning steps (MANUAL — cannot be scripted):
    1. Update the Departments list: replace REPLACE_WITH_SUPER_UPN with actual emails
    2. Update the Departments list: add Teams channel IDs and group IDs
    3. Update the DataSources/*.json files in /powerapps with the actual site URL
    4. Update the flow definitions in /powerautomate with the actual site URL
    5. Import the Power Apps app using PAC CLI or Power Apps Studio
    6. Import the Power Automate flows and configure connections
    7. Update the Power BI dashboard URL in PDCAScreen.fx.yaml before packaging the app
#>

[CmdletBinding()]
param(
    [Parameter(Mandatory = $true)]
    [string]$SiteUrl,

    [Parameter(Mandatory = $false)]
    [switch]$SeedData
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

#──────────────────────────────────────────────────────────────────────────────
# CONNECT
#──────────────────────────────────────────────────────────────────────────────
Write-Host "`n[BHP BMA] Connecting to SharePoint site: $SiteUrl" -ForegroundColor Cyan
Connect-PnPOnline -Url $SiteUrl -Interactive

#──────────────────────────────────────────────────────────────────────────────
# HELPER: Create list if it doesn't already exist
#──────────────────────────────────────────────────────────────────────────────
function Ensure-List {
    param([string]$Title, [string]$Description)
    $existing = Get-PnPList -Identity $Title -ErrorAction SilentlyContinue
    if ($null -eq $existing) {
        Write-Host "  Creating list: $Title" -ForegroundColor Yellow
        New-PnPList -Title $Title -Template GenericList -OnQuickLaunch
        Set-PnPList -Identity $Title -Description $Description -EnableVersioning $true
        Write-Host "  ✅ Created: $Title" -ForegroundColor Green
    } else {
        Write-Host "  ⏭  List already exists: $Title" -ForegroundColor Gray
    }
}

#──────────────────────────────────────────────────────────────────────────────
# HELPER: Add column if it doesn't already exist
#──────────────────────────────────────────────────────────────────────────────
function Ensure-Field {
    param(
        [string]$ListTitle,
        [string]$InternalName,
        [string]$DisplayName,
        [string]$Type,
        [hashtable]$Extra = @{}
    )
    $existing = Get-PnPField -List $ListTitle -Identity $InternalName -ErrorAction SilentlyContinue
    if ($null -eq $existing) {
        $params = @{
            List         = $ListTitle
            InternalName = $InternalName
            DisplayName  = $DisplayName
            Type         = $Type
            Required     = $false
        }
        foreach ($key in $Extra.Keys) { $params[$key] = $Extra[$key] }
        Add-PnPField @params -AddToDefaultView | Out-Null
        Write-Host "    + Field: $DisplayName ($Type)" -ForegroundColor DarkGray
    }
}

#──────────────────────────────────────────────────────────────────────────────
# 1. TASKTYPES — Enabling task catalogue
#──────────────────────────────────────────────────────────────────────────────
Write-Host "`n[1/5] Provisioning TaskTypes list..." -ForegroundColor Cyan
Ensure-List -Title "TaskTypes" -Description "BMA enabling task catalogue with P50/P80/P90 duration standards and done definitions."

$taskTypeFields = @(
    @{ InternalName="Category";           DisplayName="Category";               Type="Choice";   Extra=@{ Choices=@("Access & Roads","Drainage & Dewatering","Earthworks","Equipment & Float","Ground Preparation","Infrastructure","Safety & Environment","Services & Utilities") } },
    @{ InternalName="DefaultDepartment";  DisplayName="Default Department";      Type="Choice";   Extra=@{ Choices=@("Mine Services - Pump Crew","Mine Services - Road Crew","Production - Truck & Shovel","Drill & Blast","Draglines","Rehabilitation","Survey","Geotechnical","Multiple") } },
    @{ InternalName="DurationP50Days";    DisplayName="P50 Duration (Days)";     Type="Number" },
    @{ InternalName="DurationP80Days";    DisplayName="P80 Duration (Days)";     Type="Number" },
    @{ InternalName="DurationP90Days";    DisplayName="P90 Duration (Days)";     Type="Number" },
    @{ InternalName="SampleSize";         DisplayName="Observations (n)";        Type="Number" },
    @{ InternalName="DoneDefinition";     DisplayName="Done Definition";         Type="Note" },
    @{ InternalName="PlannerNotes";       DisplayName="Planner Notes";           Type="Note" },
    @{ InternalName="TypicalPredecessors";DisplayName="Typical Predecessors";    Type="Text" },
    @{ InternalName="TypicalSuccessors";  DisplayName="Typical Successors";      Type="Text" },
    @{ InternalName="IsActive";           DisplayName="Active";                  Type="Boolean" },
    @{ InternalName="LastDurationReview"; DisplayName="Duration Last Reviewed";  Type="DateTime" }
)
foreach ($f in $taskTypeFields) {
    Ensure-Field -ListTitle "TaskTypes" -InternalName $f.InternalName -DisplayName $f.DisplayName -Type $f.Type -Extra ($f.Extra ?? @{})
}
Write-Host "  ✅ TaskTypes fields provisioned" -ForegroundColor Green

#──────────────────────────────────────────────────────────────────────────────
# 2. DELAYREASONS — Standardised delay reason codes
#──────────────────────────────────────────────────────────────────────────────
Write-Host "`n[2/5] Provisioning DelayReasons list..." -ForegroundColor Cyan
Ensure-List -Title "DelayReasons" -Description "Standardised delay reason codes for PDCA analysis. Must be used consistently across all sites."

$delayFields = @(
    @{ InternalName="Category";        DisplayName="Category";          Type="Choice"; Extra=@{ Choices=@("Weather","Access","Equipment","People","Sequential Dependency","Unplanned Priority","Scope Change","Safety","Other") } },
    @{ InternalName="Description";     DisplayName="Description";       Type="Note" },
    @{ InternalName="IsControllable";  DisplayName="Controllable";      Type="Boolean" },
    @{ InternalName="IsActive";        DisplayName="Active";            Type="Boolean" }
)
foreach ($f in $delayFields) {
    Ensure-Field -ListTitle "DelayReasons" -InternalName $f.InternalName -DisplayName $f.DisplayName -Type $f.Type -Extra ($f.Extra ?? @{})
}
Write-Host "  ✅ DelayReasons fields provisioned" -ForegroundColor Green

#──────────────────────────────────────────────────────────────────────────────
# 3. DEPARTMENTS — Department reference with Teams routing
#──────────────────────────────────────────────────────────────────────────────
Write-Host "`n[3/5] Provisioning Departments list..." -ForegroundColor Cyan
Ensure-List -Title "Departments" -Description "Department reference list with Teams channel routing for automated notifications."

$deptFields = @(
    @{ InternalName="Site";              DisplayName="Mine Site";         Type="Choice"; Extra=@{ Choices=@("Saraji","Caval Ridge","Both") } },
    @{ InternalName="ParentDepartment";  DisplayName="Parent Department"; Type="Text" },
    @{ InternalName="TeamsChannelId";    DisplayName="Teams Channel ID";  Type="Note" },
    @{ InternalName="TeamsChannelName";  DisplayName="Teams Channel Name";Type="Text" },
    @{ InternalName="TeamsGroupId";      DisplayName="Teams Group ID";    Type="Note" },
    @{ InternalName="DepartmentColor";   DisplayName="Color (Hex)";       Type="Text" },
    @{ InternalName="IsActive";          DisplayName="Active";            Type="Boolean" }
)
# SuperintendentEmail is a Person field — requires separate handling
$existing = Get-PnPField -List "Departments" -Identity "SuperintendentEmail" -ErrorAction SilentlyContinue
if ($null -eq $existing) {
    Add-PnPField -List "Departments" -InternalName "SuperintendentEmail" -DisplayName "Superintendent" -Type User -AddToDefaultView | Out-Null
    Write-Host "    + Field: Superintendent (User)" -ForegroundColor DarkGray
}
foreach ($f in $deptFields) {
    Ensure-Field -ListTitle "Departments" -InternalName $f.InternalName -DisplayName $f.DisplayName -Type $f.Type -Extra ($f.Extra ?? @{})
}
Write-Host "  ✅ Departments fields provisioned" -ForegroundColor Green

#──────────────────────────────────────────────────────────────────────────────
# 4. EQUIPMENTMOVEMENTS — Major equipment movement schedule
#──────────────────────────────────────────────────────────────────────────────
Write-Host "`n[4/5] Provisioning EquipmentMovements list..." -ForegroundColor Cyan
Ensure-List -Title "EquipmentMovements" -Description "Major equipment movement schedule from Spry (Micromine). The anchor events that enabling tasks must precede."

$equipFields = @(
    @{ InternalName="Site";            DisplayName="Mine Site";          Type="Choice"; Extra=@{ Choices=@("Saraji","Caval Ridge") } },
    @{ InternalName="EquipmentType";   DisplayName="Equipment Type";     Type="Choice"; Extra=@{ Choices=@("Shovel","Excavator","Dragline","Truck Fleet","Drill Rig","Dozer","Grader","Other") } },
    @{ InternalName="EquipmentID";     DisplayName="Equipment ID";       Type="Text" },
    @{ InternalName="PlannedMoveDate"; DisplayName="Planned Move Date";  Type="DateTime" },
    @{ InternalName="FromLocation";    DisplayName="From Location";      Type="Text" },
    @{ InternalName="ToLocation";      DisplayName="To Location";        Type="Text" },
    @{ InternalName="PitBlock";        DisplayName="Pit / Block";        Type="Text" },
    @{ InternalName="MovementStatus";  DisplayName="Movement Status";    Type="Choice"; Extra=@{ Choices=@("Planned","Confirmed — Enabling Complete","At Risk — Enabling Delayed","Executed","Deferred","Cancelled") } },
    @{ InternalName="SpryReference";   DisplayName="Spry Reference";     Type="Text" },
    @{ InternalName="PlannerNotes";    DisplayName="Planner Notes";      Type="Note" }
)
foreach ($f in $equipFields) {
    Ensure-Field -ListTitle "EquipmentMovements" -InternalName $f.InternalName -DisplayName $f.DisplayName -Type $f.Type -Extra ($f.Extra ?? @{})
}
Write-Host "  ✅ EquipmentMovements fields provisioned" -ForegroundColor Green

#──────────────────────────────────────────────────────────────────────────────
# 5. ENABLEDTASKS — Main task tracking list
#──────────────────────────────────────────────────────────────────────────────
Write-Host "`n[5/5] Provisioning EnabledTasks list..." -ForegroundColor Cyan
Ensure-List -Title "EnabledTasks" -Description "BMA enabling task schedule. Central tracking list for all enabling tasks at Saraji and Caval Ridge."

# Lookup fields — must be created before EnabledTasks fields that reference them
$lookupFields = @(
    @{ InternalName="TaskTypeId";        DisplayName="Task Type";              LookupList="TaskTypes";          LookupField="Title" },
    @{ InternalName="DelayReasonId";     DisplayName="Delay Reason";           LookupList="DelayReasons";       LookupField="Title" },
    @{ InternalName="EquipmentMovementId"; DisplayName="Linked Equipment Move"; LookupList="EquipmentMovements"; LookupField="Title" }
)
foreach ($lf in $lookupFields) {
    $existing = Get-PnPField -List "EnabledTasks" -Identity $lf.InternalName -ErrorAction SilentlyContinue
    if ($null -eq $existing) {
        $lookupListId = (Get-PnPList -Identity $lf.LookupList).Id.ToString()
        Add-PnPFieldFromXml -List "EnabledTasks" -FieldXml "<Field Type='Lookup' DisplayName='$($lf.DisplayName)' Name='$($lf.InternalName)' List='$lookupListId' ShowField='$($lf.LookupField)' />" | Out-Null
        Write-Host "    + Field: $($lf.DisplayName) (Lookup → $($lf.LookupList))" -ForegroundColor DarkGray
    }
}

# Person fields
foreach ($personField in @(@{Name="PlannerEmail";Display="Assigned Planner"}, @{Name="SupervisorEmail";Display="Completing Supervisor"})) {
    $existing = Get-PnPField -List "EnabledTasks" -Identity $personField.Name -ErrorAction SilentlyContinue
    if ($null -eq $existing) {
        Add-PnPField -List "EnabledTasks" -InternalName $personField.Name -DisplayName $personField.Display -Type User -AddToDefaultView | Out-Null
        Write-Host "    + Field: $($personField.Display) (User)" -ForegroundColor DarkGray
    }
}

# Standard fields
$taskFields = @(
    @{ InternalName="Department";         DisplayName="Responsible Department"; Type="Choice";   Extra=@{ Choices=@("Mine Services - Pump Crew","Mine Services - Road Crew","Production - Truck & Shovel","Drill & Blast","Draglines","Rehabilitation","Survey","Geotechnical") } },
    @{ InternalName="Site";               DisplayName="Mine Site";              Type="Choice";   Extra=@{ Choices=@("Saraji","Caval Ridge") } },
    @{ InternalName="PitBlock";           DisplayName="Pit / Block";            Type="Text" },
    @{ InternalName="PlannedStartDate";   DisplayName="Planned Start Date";     Type="DateTime" },
    @{ InternalName="PlannedEndDate";     DisplayName="Planned End Date";       Type="DateTime" },
    @{ InternalName="PlannedDurationDays";DisplayName="Planned Duration (Days)";Type="Number" },
    @{ InternalName="ActualStartDate";    DisplayName="Actual Start Date";      Type="DateTime" },
    @{ InternalName="ActualEndDate";      DisplayName="Actual End Date";        Type="DateTime" },
    @{ InternalName="Status";             DisplayName="Status";                 Type="Choice";   Extra=@{ Choices=@("Not Started","In Progress","Complete","Delayed","Partially Complete","Cancelled") } },
    @{ InternalName="PriorityLevel";      DisplayName="Priority";               Type="Choice";   Extra=@{ Choices=@("Critical","High","Medium","Low") } },
    @{ InternalName="IsOnCriticalPath";   DisplayName="Critical Path";          Type="Boolean" },
    @{ InternalName="DelayNotes";         DisplayName="Delay / Completion Notes";Type="Note" },
    @{ InternalName="ShiftType";          DisplayName="Shift";                  Type="Choice";   Extra=@{ Choices=@("Day","Night","Afternoon","Multi-Shift") } },
    @{ InternalName="IsUnplanned";        DisplayName="Unplanned Task";         Type="Boolean" }
)
foreach ($f in $taskFields) {
    Ensure-Field -ListTitle "EnabledTasks" -InternalName $f.InternalName -DisplayName $f.DisplayName -Type $f.Type -Extra ($f.Extra ?? @{})
}

# VarianceDays calculated column
$existing = Get-PnPField -List "EnabledTasks" -Identity "VarianceDays" -ErrorAction SilentlyContinue
if ($null -eq $existing) {
    $calcXml = "<Field Type='Calculated' DisplayName='Schedule Variance (Days)' Name='VarianceDays' ResultType='Number'><Formula>=IF(ISBLANK([Actual End Date]),DATEDIF(TODAY(),[Planned End Date],""D"")*-1,DATEDIF([Planned End Date],[Actual End Date],""D""))</Formula><FieldRefs><FieldRef Name='PlannedEndDate'/><FieldRef Name='ActualEndDate'/></FieldRefs></Field>"
    Add-PnPFieldFromXml -List "EnabledTasks" -FieldXml $calcXml | Out-Null
    Write-Host "    + Field: Schedule Variance (Calculated)" -ForegroundColor DarkGray
}
Write-Host "  ✅ EnabledTasks fields provisioned" -ForegroundColor Green

#──────────────────────────────────────────────────────────────────────────────
# SEED REFERENCE DATA
#──────────────────────────────────────────────────────────────────────────────
if ($SeedData) {
    Write-Host "`n[Seed] Loading reference data from JSON files..." -ForegroundColor Cyan
    $scriptDir = Split-Path -Parent $PSCommandPath
    $seedDir   = Join-Path $scriptDir "..\sharepoint\seed-data"

    # Seed TaskTypes
    $taskTypeSeedPath = Join-Path $seedDir "TaskTypes-seed.json"
    if (Test-Path $taskTypeSeedPath) {
        $taskTypeData = (Get-Content $taskTypeSeedPath -Raw | ConvertFrom-Json).items
        Write-Host "  Seeding $($taskTypeData.Count) task types..." -ForegroundColor Yellow
        foreach ($item in $taskTypeData) {
            $existing = Get-PnPListItem -List "TaskTypes" -Query "<View><Query><Where><Eq><FieldRef Name='Title'/><Value Type='Text'>$($item.Title)</Value></Eq></Where></Query></View>" -ErrorAction SilentlyContinue
            if ($null -eq $existing -or $existing.Count -eq 0) {
                Add-PnPListItem -List "TaskTypes" -Values @{
                    Title              = $item.Title
                    Category           = $item.Category
                    DefaultDepartment  = $item.DefaultDepartment
                    DurationP50Days    = $item.DurationP50Days
                    DurationP80Days    = $item.DurationP80Days
                    DurationP90Days    = $item.DurationP90Days
                    SampleSize         = $item.SampleSize
                    DoneDefinition     = $item.DoneDefinition
                    PlannerNotes       = if ($item.PlannerNotes) { $item.PlannerNotes } else { "" }
                    TypicalPredecessors= if ($item.TypicalPredecessors) { $item.TypicalPredecessors } else { "" }
                    TypicalSuccessors  = if ($item.TypicalSuccessors) { $item.TypicalSuccessors } else { "" }
                    IsActive           = $true
                } | Out-Null
                Write-Host "    + $($item.Title)" -ForegroundColor DarkGray
            } else {
                Write-Host "    ⏭  Already exists: $($item.Title)" -ForegroundColor Gray
            }
        }
        Write-Host "  ✅ TaskTypes seeded" -ForegroundColor Green
    }

    # Seed DelayReasons
    $delayReasonSeedPath = Join-Path $seedDir "DelayReasons-seed.json"
    if (Test-Path $delayReasonSeedPath) {
        $delayData = (Get-Content $delayReasonSeedPath -Raw | ConvertFrom-Json).items
        Write-Host "  Seeding $($delayData.Count) delay reasons..." -ForegroundColor Yellow
        foreach ($item in $delayData) {
            $existing = Get-PnPListItem -List "DelayReasons" -Query "<View><Query><Where><Eq><FieldRef Name='Title'/><Value Type='Text'>$($item.Title)</Value></Eq></Where></Query></View>" -ErrorAction SilentlyContinue
            if ($null -eq $existing -or $existing.Count -eq 0) {
                Add-PnPListItem -List "DelayReasons" -Values @{
                    Title           = $item.Title
                    Category        = $item.Category
                    Description     = $item.Description
                    IsControllable  = $item.IsControllable
                    IsActive        = $true
                } | Out-Null
                Write-Host "    + $($item.Title)" -ForegroundColor DarkGray
            }
        }
        Write-Host "  ✅ DelayReasons seeded" -ForegroundColor Green
    }

    # Seed Departments (no people fields — must be updated manually post-seeding)
    $deptSeedPath = Join-Path $seedDir "Departments-seed.json"
    if (Test-Path $deptSeedPath) {
        $deptData = (Get-Content $deptSeedPath -Raw | ConvertFrom-Json).items
        Write-Host "  Seeding $($deptData.Count) departments (structure only — update superintendent emails manually)..." -ForegroundColor Yellow
        foreach ($item in $deptData) {
            Add-PnPListItem -List "Departments" -Values @{
                Title            = $item.Title
                Site             = $item.Site
                ParentDepartment = $item.ParentDepartment
                TeamsChannelId   = $item.TeamsChannelId
                TeamsChannelName = $item.TeamsChannelName
                TeamsGroupId     = $item.TeamsGroupId
                DepartmentColor  = $item.DepartmentColor
                IsActive         = $true
            } | Out-Null
            Write-Host "    + $($item.Title) ($($item.Site))" -ForegroundColor DarkGray
        }
        Write-Host "  ✅ Departments seeded — UPDATE SUPERINTENDENT EMAILS AND TEAMS IDs BEFORE USING" -ForegroundColor Yellow
    }
}

#──────────────────────────────────────────────────────────────────────────────
# SUMMARY
#──────────────────────────────────────────────────────────────────────────────
Write-Host "`n═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host " BHP BMA SharePoint Provisioning Complete" -ForegroundColor Green
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host " Site: $SiteUrl" -ForegroundColor White
Write-Host " Lists created: TaskTypes, DelayReasons, Departments, EquipmentMovements, EnabledTasks"
if ($SeedData) {
    Write-Host " Reference data seeded: TaskTypes (35 items), DelayReasons (22 items), Departments (10 items)"
    Write-Host ""
    Write-Host " NEXT STEPS (manual):" -ForegroundColor Yellow
    Write-Host "  1. Update Departments list — replace REPLACE_WITH_SUPER_UPN with actual superintendent emails"
    Write-Host "  2. Update Departments list — add Teams group IDs and channel IDs"
    Write-Host "  3. Update /powerapps/BHPEnablingTaskManager/DataSources/*.json with this site URL"
    Write-Host "  4. Update /powerautomate/*/definition.json with this site URL"
    Write-Host "  5. Pack and import the Power App using PAC CLI:"
    Write-Host "     pac canvas pack --sources .\powerapps\BHPEnablingTaskManager\Src --msapp .\BHPEnablingTaskManager.msapp"
    Write-Host "  6. Import flows in /powerautomate/ and configure SharePoint + Teams connections"
    Write-Host "  7. Share the app with all enabling task team members"
}
Write-Host "═══════════════════════════════════════════════════" -ForegroundColor Cyan

Disconnect-PnPOnline
