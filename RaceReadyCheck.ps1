# --- CONFIGURATION ---
# The service needs to be kept alive ( Pretend this is 'SimEngine' )
$targetService = "Spooler" 

# The server we need to talk to (Using Google DNS as a test dummy)
$criticalServer = "8.8.8.8" 

# The maximum allowed ping (in milliseconds) before we go Bananas
$maxLatency = 50

# --- 1 SERVICE CHECK ---
if ($serviceStatus.Status -eq 'Running') {
    #If its running print Green 
    Write-Host "[$targetService] is RUNNING" -ForegroundColor Green
    }
    else {
        # If its NOT running, print in Red and try to fix it
        Write-Host "{$targetService} is STOPPED. Attempting restart..." -ForegroundColor Red

        # The automation command 
        Start-Service -Name $targetService

        # Check one more time to see if it worked 
        $retry = Get-Service -Name $targetService
        if ($retry.Status -eq 'Running') {
        Write-Host "-> SUCCESS: Service restarted!" -ForegroundColor Cyan
        
        # --- THE PYTHON ALERT TRIGGER ---
        python alert.py "CRITICAL FIX: The $targetService service crashed, but I automatically restarted it. System is Green."
    }
        } else {
            Write-Host "-> ERROR: Could not restart Service." -ForegroundColor Magenta
    }

    # --- 2. NETWORK LATENCY CHECK ---
    # Seilently ping the server 1 time (-Count 1) and get the ResponseTime
    $ping = Test-Connection -ComputerName $criticalServer -Count 1 -ErrorAction SilentlyContinue

    if ($ping) {
        # If the ping was successful, check the speed
        if ($ping.ResponseTime -lt $maxLatency) {
            Write-Host "Network Connection: Optimal ($($ping.ResponseTime)ms)" -foregroundColor Green
        }
        else {
            Write-Host "Network Connection: SLOW ($($ping.ResponseTime)ms)" -foregroundColor Yellow
        }
    }
    else {
        # If the ping failed entirely
        Write-Host "Network Connection: FAILED. Server Unreachable." -ForegroundColor Red
    }

    # ---3. DISK SPACE CHECK ---
    # Get drive info for C:
    $disk = Get-Volume -DriveLetter C

    # Calculate free space in GB (Powershell does math for us)
    $freeSpaceGB = [math]::Round($disk.SizeRemaining / 1GB, 2)

    if ($freeSpaceGB -gt 20) {
        Write-Host "Disk Space: OK ($freeSpaceGB GB Free)" -ForegroundColor Green
    }
    else {
        Write-Host "Disk Space: CRITICAL LOW ($freeSpaceGB GB Free)" -ForegroundColor Red
    }

