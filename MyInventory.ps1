<#
.SYNOPSIS 
Get Windows Host information
.DESCRIPTION 
This script will get the CPU specifications, memory usage statistics, and OS configuration of any Server or Computer listed in $servers variable and post data to $webhook url. 
.NOTES   
The script will execute the commands on multiple machines sequentially using non-concurrent sessions. This will process all servers from $servers variable listed order. 
The info will be exported to a csv format. 
Requires:  
File Name  : MyInventory.ps1 
Author: Pedro Robson Leao <pedro.leao@gmail.com> 
http://github.com/pedrorobsonleao
References:
https://gallery.technet.microsoft.com/scriptcenter/PowerShell-Script-Get-beced710
https://github.com/ian8667/powershell/blob/master/Get-ServerInfo.ps1
#>

# server or server list to execute this script
$servers = @("localhost")

# webhook endpoint and access token to write in this sheet
$webhook = "https://script.google.com/macros/s/AKfycbyc2qdCZ6_P7uBIvOTOtXHE3NlD-5GeRCZDS7w99JOFIlkyesk/exec"
$token = "5e041d8d-7cb6-4bd7-85eb-1c96f5a96998"
 
# config class to get information and sheet to write this information
$configs = '[
	{ "class": "Win32_SystemEnclosure", "sheet": "manufacture" },
	{ "class": "Win32_Processor",       "sheet": "cpu" },
	{ "class": "Win32_OperatingSystem", "sheet": "operacional_system" },
	{ "class": "CIM_PhysicalMemory",    "sheet": "memory" },
	{ "class": "Win32_UserAccount",     "sheet": "users" },
	{ "class": "Win32_Product",         "sheet": "softwares" },
	{ "class": "Win32_Volume",          "sheet": "volumes"},
	{ "class": "Service",               "sheet": "services" }
	]' | ConvertFrom-Json 

# start data object to post with the token
$data = @{
	"token" = $token
}

# server list iterator
ForEach ($server in $servers) {
	# config lines iterator
	ForEach ($config in $configs) { 
		# set sheet name to write
		$data.sheet_name = $config.sheet
		
		Try {
			if ($config.class -eq "Service") {
				# to Service need consult Get-Service information
				$data.data = Get-Service   -ComputerName $server                      -ErrorAction Stop
			} else {
				# to another information use Get-WmiObject with the class
				$data.data = Get-WmiObject -ComputerName $server -Class $config.class -ErrorAction Stop
			}
			
			if($config.sheet -eq "manufacture") {
				# the service tag only is read in manufacture session. I save this information to use in another posts data
				$data.service_tag = $data.data.SerialNumber
			}
			
			# convert data powershell to json to post
			$dt = $data | ConvertTo-Json
		
			# post data to endpoint
			$response = Invoke-WebRequest -UseBasicParsing -Uri $webhook -Method Post -ContentType "application/json;charset=UTF-8" -Body $dt
			# show status, description and posted data
			Write-Host $config.sheet $response.StatusCode $response.StatusDescription
			$dt
		} Catch {
			# when error - show error information
			Write-Host $config.sheet $_.Exception
		}
	}
}
