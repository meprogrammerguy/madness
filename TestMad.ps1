<#
    Powershell March TestMad script
#>
$Host.UI.RawUI.WindowTitle = "TestMad Script"

function GetElapsedTime([datetime]$starttime) 
{
  $runtime = $(get-date) - $starttime
  $retStr = [string]::format("{0} hours(s), {1} minutes(s), {2} seconds(s)", $runtime.Hours, $runtime.Minutes, $runtime.Seconds)
  $retStr
}
$script:startTime = Get-Date
$wc = New-Object System.Net.WebClient
write-host "TestMad Table Checking Script Started at $script:startTime" -foreground "green"
<#
    Opens the settings file
#>
cd $PSScriptRoot
$CurrentUser = [Environment]::UserName
[xml]$ConfigFile = Get-Content GetMad.xml
write-host "settings from $($PSScriptRoot)\GetMad.xml" -foreground "yellow"
write-host "Current user: $CurrentUser" -foreground "yellow"
write-host "Current domain: $([Environment]::UserDomainName)" -foreground "yellow"
write-host "Current machine: $([Environment]::MachineName)" -foreground "yellow"
$WorkDirectory = [Environment]::GetFolderPath("Desktop") + "\madness"

$FileExists = Test-Path $WorkDirectory 
If ($FileExists -eq $False)
{
	Write-Host "Madness Directory Does not exist - run GetMad" first -foreground "red"
	exit
}
$KenPom = $WorkDirectory + "\kenpom.csv"
$KenPomCSV = Import-Csv -Path $KenPom -Header Rank,Team
$Table=@()
foreach($r in $KenPomCSV)
{
    if ($r.Rank -notlike '#*')
    {
		$Table += $r.Team
	}
}
cd $PSScriptRoot
Convert-Path .
$elapsed = GetElapsedTime $script:startTime
write-host "Total Elapsed Time: " $elapsed -foreground "yellow"
write-host "Script Ended at $(get-date)" -foreground "green"
Write-Host "Press any key to continue ..." -foreground "magenta"
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
