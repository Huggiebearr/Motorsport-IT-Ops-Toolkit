# --- CONFIGURATION ---
# 1. The "Source" (Where the Simulator saves data)
$sourcePath = "C:\Simulator_Local_Logs"

# 2. The "Destination" (The Server where Engineers read data)
$serverPath = "C:\Team_Server_Archive"

# --- AUTO-SETUP (Just for testing) ---
# This checks if these folders exist. If not, it creates them for you.
if (-not (Test-Path $sourcePath)) { New-Item -ItemType Directory -Path $sourcePath }
if (-not (Test-Path $serverPath)) { New-Item -ItemType Directory -Path $serverPath }

# Create a "Fake" Telemetry file so we have something to move
$testFile = "$sourcePath\Session_Log_$(Get-Date -Format 'mmss').txt"
New-Item -Path $testFile -ItemType File -Value "Simulation Data: Car ID 44 - Lap Time 1:24.5" -Force

Write-Host "SETUP COMPLETE: Test folders and file created." -ForegroundColor Yellow



# --- THE ARCHIVER ENGINE ---

# 1. Find all text files in the Simulator folder
$filesToMove = Get-ChildItem -Path $sourcePath -Filter "*.txt"

# 2. Loop through every file found
foreach ($file in $filesToMove) {
    Write-Host "Processing: $($file.Name)..." -NoNewline

    # A. Generate "Fingerprint" (Hash) of the ORIGINAL file
    $srcHash = Get-FileHash -Path $file.FullName -Algorithm SHA256

    # B. Copy the file to the Server
    $destFile = "$serverPath\$($file.Name)"
    Copy-Item -Path $file.FullName -Destination $serverPath -Force

    # C. Generate "Fingerprint" of the NEW file on the server
    $destHash = Get-FileHash -Path $destFile -Algorithm SHA256

    # D. Compare the two Fingerprints
    if ($srcHash.Hash -eq $destHash.Hash) {
        # SUCCESS: The files are identical
        Write-Host " [VERIFIED]" -ForegroundColor Green
        
        # Safe to delete the local file to save space
        Remove-Item -Path $file.FullName
        Write-Host "   -> Transfer Secure. Original removed from Simulator." -ForegroundColor Cyan
    }
    else {
        # FAILURE: The data was corrupted
        Write-Host " [CORRUPTION DETECTED]" -ForegroundColor Red
        Write-Host "   -> STOP! Hashes do not match. Original file kept safe." -ForegroundColor Red
    }
}

if ($filesToMove.Count -eq 0) {
    Write-Host "No new telemetry files found to move." -ForegroundColor Gray
}