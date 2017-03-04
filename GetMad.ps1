<#
    Powershell March GetMad script
#>
$Host.UI.RawUI.WindowTitle = "GetMad Script"

function GetElapsedTime([datetime]$starttime) 
{
  $runtime = $(get-date) - $starttime
  $retStr = [string]::format("{0} hours(s), {1} minutes(s), {2} seconds(s)", $runtime.Hours, $runtime.Minutes, $runtime.Seconds)
  $retStr
}
$script:startTime = Get-Date
$wc = New-Object System.Net.WebClient
write-host "GetMad WebPag Scraping Script Started at $script:startTime" -foreground "green"
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
If ($FileExists -eq $True)
{
	.\TestMad.ps1
	Write-Host "Madness Directory Alread exists - Delete to re-run GetMad" -foreground "red"
	exit
}

New-Item -ItemType Directory -Force -Path $WorkDirectory | Out-Null
<#
    KenPom stats page
#>

$WebPage = $ConfigFile.Settings.GetMad.KenPom.WebPage
$TableNumber = $ConfigFile.Settings.GetMad.KenPom.TableNumber
$WebPage 
$request = Invoke-WebRequest $WebPage
$KenpomPath = $WorkDirectory + "\kenpom.csv"
Get-PSBreakpoint | Remove-PSBreakpoint
#Set-PsBreakPoint extract_table.ps1 -Line 56
.\extract_table.ps1 $request -TableNumber $TableNumber | Select-Object Rank,Team,AdjEM,AdjO,AdjD,AdjT,Luck,SOSAdjEM,OppO,OppD,NCSOSAdjEM  | Export-CSV $KenpomPath
<#
    espn bracket page
#>
$WebPage = $ConfigFile.Settings.GetMad.espn.WebPage
$WebPage 
$request = Invoke-WebRequest $WebPage
$BracketPath = $WorkDirectory + "\bracket.csv"
Get-PSBreakpoint | Remove-PSBreakpoint
#Set-PsBreakPoint extract_bracket.ps1 -Line 74
.\extract_bracket.ps1 $request | Select-Object Match,Round,Seed1,KenPom1,Bracket1,Predict1,Actual1,Seed2,KenPom2,Bracket2,Predict2,Actual2 | Export-CSV $BracketPath
.\TestMad.ps1
cd $PSScriptRoot
Convert-Path .
$elapsed = GetElapsedTime $script:startTime
write-host "Total Elapsed Time: " $elapsed -foreground "yellow"
write-host "Script Ended at $(get-date)" -foreground "green"
Write-Host "Press any key to continue ..." -foreground "magenta"
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
