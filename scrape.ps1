<#
    Powershell March madness scrape script
#>
$Host.UI.RawUI.WindowTitle = "scrape Script"

function GetElapsedTime([datetime]$starttime) 
{
  $runtime = $(get-date) - $starttime
  $retStr = [string]::format("{0} hours(s), {1} minutes(s), {2} seconds(s)", $runtime.Hours, $runtime.Minutes, $runtime.Seconds)
  $retStr
}
$script:startTime = Get-Date
$wc = New-Object System.Net.WebClient
write-host "scrape Script Started at $script:startTime" -foreground "green"
<#
    Opens the settings file
#>
cd $PSScriptRoot
$CurrentUser = [Environment]::UserName
[xml]$ConfigFile = Get-Content scrape.xml
write-host "settings from $($PSScriptRoot)\scrape.xml" -foreground "yellow"
write-host "Current user: $CurrentUser" -foreground "yellow"
write-host "Current domain: $([Environment]::UserDomainName)" -foreground "yellow"
write-host "Current machine: $([Environment]::MachineName)" -foreground "yellow"
$WorkDirectory = [Environment]::GetFolderPath("Desktop") + "\madness"
New-Item -ItemType Directory -Force -Path $WorkDirectory | Out-Null
<#
    kenpom stats page (turned off for now)
#>

$WebPage = $ConfigFile.Settings.scrape.kenpom.WebPage
$TableNumber = $ConfigFile.Settings.scrape.kenpom.TableNumber
$WebPage 
$request = Invoke-WebRequest $WebPage
$KenpomPath = $WorkDirectory + "\kenpom.csv"
Get-PSBreakpoint | Remove-PSBreakpoint
#Set-PsBreakPoint extract_table.ps1 -Line 50
#.\extract_table.ps1 $request -TableNumber $TableNumber | Select-Object Rank,Team,AdjEM,AdjO,AdjD,AdjT,Luck,SOSAdjEM,OppO,OppD,NCSOSAdjEM  | Export-CSV $KenpomPath
<#
    espn bracket page
#>
$WebPage = $ConfigFile.Settings.scrape.espn.WebPage
$WebPage 
$request = Invoke-WebRequest $WebPage
$BracketPath = $WorkDirectory + "\bracket.csv"
Get-PSBreakpoint | Remove-PSBreakpoint
#Set-PsBreakPoint extract_bracket.ps1 -Line 6
.\extract_bracket.ps1 $request | Select-Object Match,Seed1,Team1,Score1,Seed2,Team2,Score2 | Export-CSV $BracketPath

cd $PSScriptRoot
Convert-Path .
$elapsed = GetElapsedTime $script:startTime
write-host "Total Elapsed Time: " $elapsed -foreground "yellow"
write-host "Script Ended at $(get-date)" -foreground "green"
Write-Host "Press any key to continue ..." -foreground "magenta"
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
