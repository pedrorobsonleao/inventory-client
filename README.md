# inventory-client
A simple powershell script inventory client

The code write in MyInventory.ps1 is a webhook client used with the [google-spreadsheets-webhook](https://github.com/pedrorobsonleao/google-spreadsheets-webhook).

Create a simple MS Windows inventory to your machines.

Write your spreadsheet and have the control of your windows machines.

```powershell
# server or server list to execute this script
$servers = @("localhost")

# webhook endpoint and access token to write in this sheet
$webhook = "https://script.google.com/macros/s/<id>/exec"
$token = "xxxxxxxxxxxx-xxxxxxxxxx-xxxxxxxxx-xxxxx"
```
|variable|description|
|-|-|
|***$servers***|list servers name to execute this script|
|***$webhook***|webhook endpoint|
|***$token***|authorization token webhook write in your spreadsheet|

## references

* [Get Server Inventory: CPU, Memory, and OS information. Export to CSV.](https://gallery.technet.microsoft.com/scriptcenter/PowerShell-Script-Get-beced710)
* [powershell/Get-ServerInfo.ps1](https://github.com/ian8667/powershell)
