<#
    Powershell March TestMad script
#>
#Get-PSBreakpoint | Remove-PSBreakpoint
#Set-PsBreakPoint TestMad.ps1 -Line 78
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
		$Table += $r.Team.Trim()
	}
}
$Table = $Table | sort
$Bracket = $WorkDirectory + "\bracket.csv"
$BracketCSV = Import-Csv -Path $Bracket -Header Match,Round,Seed1,KenPom1,Bracket1,Predict1,Actual1,Seed2,KenPom2
$ATable=@()
$BTable=@()
foreach($r in $BracketCSV)
{
    if ($r.Match -notlike '#*' -and $r.Round.Contains(" round1 "))
    {
		$ATable += $r.KenPom1.Trim()
		$BTable += $r.KenPom2.Trim()
	}
}
$ACount = ($ATable | sort -Unique).count
$BCount = ($BTable | sort -Unique).count 
if($ACount -eq 32)
{
	Write-Host "All round 1 First Column Teams are Unique - good" -foreground "green"
}
else
{
	$ACount = 32 - $ACount
	Write-Host "warning - $($ACount), round 1 First Column Teams are NOT Unique - bad" -foreground "red"
}
if($BCount -eq 32)
{
	Write-Host "All round 1 Second Column Teams are Unique - good" -foreground "green"
}
else
{
	$BCount = 32 - $BCount
	Write-Host "warning - $($BCount), round 1 Second Column Teams are NOT Unique - bad" -foreground "red"
}
for ($i = 0; $i -lt 31; $i++)
{
	if($Table -contains $ATable[$i])
	{
		Write-Host "Found $($ATable[$($i)]) - good" -foreground "green"
	}
	else
	{
		Write-Host "Did NOT find $($ATable[$($i)]) - bad" -foreground "red"
	}
	if($Table -contains $BTable[$i])
	{
		Write-Host "Found $($BTable[$($i)]) - good" -foreground "green"
	}
	else
	{
		Write-Host "Did NOT find $($BTable[$($i)]) - bad"  -foreground "red"
	}
}
cd $PSScriptRoot
