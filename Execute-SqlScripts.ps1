# --- Configuration ---
$server = "DESKTOP-C832D1L\SQLEXPRESS"
$database = "refactor"
$useWindowsAuth = $true
$sqlUsername = ""
$sqlPassword = ""

# --- Paths ---
$scriptRoot = "C:\dot net\DB1_SQLScripts"
$scriptOrderFile = Join-Path $scriptRoot "ScriptOrder.txt"

# --- Read Script Order ---
$orderedScripts = Get-Content -Path $scriptOrderFile | Where-Object { $_.Trim() -ne "" }

# --- Function to Execute Script ---
function Execute-SqlScript {
    param (
        [string]$scriptPath
    )
    Write-Host "`nExecuting: $scriptPath"

    if ($useWindowsAuth) {
        Invoke-Sqlcmd -ServerInstance $server -Database $database -InputFile $scriptPath -ErrorAction Stop
    } else {
        Invoke-Sqlcmd -ServerInstance $server -Database $database -InputFile $scriptPath -Username $sqlUsername -Password $sqlPassword -ErrorAction Stop
    }

    Write-Host "Completed: $scriptPath"
}

# --- Execute Scripts in Order ---
foreach ($relativePath in $orderedScripts) {
    $fullPath = Join-Path $scriptRoot $relativePath
    if (-Not (Test-Path $fullPath)) {
        Write-Error "Script not found: $fullPath"
        throw
    }
    try {
        Execute-SqlScript -scriptPath $fullPath
    } catch {
        Write-Error "Execution failed: $fullPath"
        throw
    }
}
