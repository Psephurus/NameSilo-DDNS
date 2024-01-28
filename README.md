# NameSilo-DDNS

A PowerShell script to update Namesilo's DNS record when IP changes (mostly used on Windows).

## Usage

1. Generate an API key in the [API MANAGER](https://www.namesilo.com/account/api-manager) at Namesilo and save it in a secure location.
2. Copy the script to a desired location.
3. Rename `conf.json.example` to `conf.json` and configure the parameters.
4. Create a task scheduler.

### Set up a Task in Task Scheduler

1. Open "Task Scheduler" (e.g., by searching for it in the Start menu).
2. Click "Create Task".
3. Name the Task as "NameSilo-DDNS" (or any preferred name) and Check "Run whether user is logged on or not".
4. Set the trigger: Set Schedule to "Daily", and Repeat the task every "1 hour" for a duration of "1 day".
5. Set the Action:
    - Type "powershell.exe" (or "pwsh" for the new PowerShell) in the Program/script textbox.
    - In the "Add Arguments" box, type `-ExecutionPolicy Bypass -File <script location>\NameSiloDDNS.ps1"`
