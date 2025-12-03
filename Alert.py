import sys
import requests
import json

# --- CONFIGURATION ---
# WEBHOOK URL - For Discord Bot
WEBHOOK_URL = "https://discordapp.com/api/webhooks/1445192263910293534/98CE97uNudAMTvsjYvna79ji_A4F55UYwe6NXe3HeZQr3UIkLq_9eohQXO8EChc4F47m"

# --- THE LOGIC ---
def send_alert(message):
    # Prepare the data package (JSON)
    payload = {
        "content": f"🚨 **F1 SIMULATOR ALERT** 🚨\n{message}"
    }
    
    # Send it to the server
    try:
        response = requests.post(WEBHOOK_URL, json=payload)
        
        if response.status_code == 204 or response.status_code == 200:
            print(" -> Python: Alert sent successfully!")
        else:
            print(f" -> Python: Failed to send. Error: {response.status_code}")
            
    except Exception as e:
        print(f" -> Python Error: {e}")

# --- MAIN EXECUTION ---
# This checks if PowerShell sent an argument (the message)
if len(sys.argv) > 1:
    # Join all arguments into one string (in case of spaces)
    msg = " ".join(sys.argv[1:])
    send_alert(msg)
else:
    print(" -> Python: No message provided. Run with arguments!")