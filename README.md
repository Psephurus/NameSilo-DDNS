# NameSilo-DDNS

A PowerShell script to update Namesilo's DNS record when IP changed.

## Usage: 
- Generate API key in the API MANAGER at Namesilo, and save it to a save place.
- copy the script to somewhere.
- set $APIKey, $domain, and $record in the script.
- Create a task scheduler.

### Set a task

1. Enter "Task Scheduler" in the search box and open it.
2. Click "Create Task".
3. Name the Task as "NameSilo-DDNS" && Check "Run whether user is logged on or not".
4. Set trigger. Set Schedule to "Daily", and Repeat the task every "1 hour" for a duration of "1 day".
5. Set Action. Type "powershell.exe" in the Program/script textbox. And in the "Add Arguments" box type `-ExecutionPolicy Bypass <script location>\NameSiloDDNS.ps1"`
