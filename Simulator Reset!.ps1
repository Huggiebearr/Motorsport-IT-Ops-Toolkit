# --- THE PANIC BUTTON ---
$appName = "notepad"
$appPath = "C:\Windows\System32\notepad.exe"
$cachePath = "C:\Simulator_Cache_Temp"

Write-Host "!!! INITIATING EMERGENCY RESET !!!" -ForegroundColor Red -BackgroundColor Yellow

# 1. KILL THE PROCESS (The Hammer)
# -ErrorAction SilentlyContinue means "If it's already dead, don't complain"
$process = Get-Process -Name $appName -ErrorAction SilentlyContinue

if ($process) {
    Write-Host " -> Detected frozen process ($appName). Terminating..." -NoNewline
    Stop-Process -Name $appName -Force
    Write-Host " [KILLED]" -ForegroundColor Red
} else {
    Write-Host " -> Process was not running." -ForegroundColor Gray
}

# 2. CLEAR THE CACHE (The Cleanup)
# This removes temporary files that might cause glitches
if (Test-Path $cachePath) {
    Write-Host " -> Clearing temporary cache files..." -NoNewline
    # Remove everything INSIDE the folder, but keep the folder itself
    Get-ChildItem -Path $cachePath | Remove-Item -Recurse -Force
    Write-Host " [CLEANED]" -ForegroundColor Cyan
}

# 3. RELAUNCH (The Recovery)
Write-Host " -> Relaunching System..." -ForegroundColor Green
Start-Process -FilePath $appPath

Write-Host "SYSTEM RESET COMPLETE. READY FOR DRIVER." -ForegroundColor Green