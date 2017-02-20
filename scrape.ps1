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
    kenpom stats page
#>
$WebPage = $ConfigFile.Settings.scrape.kenpom.WebPage
$TableNumber = $ConfigFile.Settings.scrape.kenpom.TableNumber
$WebPage 
$request = Invoke-WebRequest $WebPage
$KenpomPath = $WorkDirectory + "\kenpom.txt"
Get-PSBreakpoint | Remove-PSBreakpoint
#Set-PsBreakPoint extract.ps1 -Line 45
.\extract.ps1 $request -TableNumber $TableNumber | Select-Object Rank,Team,Conf,W-L,AdjEM,AdjO,AdjD,AdjT,Luck,SOSAdjEM,OppO,OppD,NCSOSAdjEM  | Export-CSV $KenpomPath
<#
    espn bracket page
#>
$WebPage = $ConfigFile.Settings.scrape.espn.WebPage
$WebPage
$content = $wc.DownloadString($WebPage)
$BracketPath = $WorkDirectory + "\espn.html"
$content | Out-File -FilePath $BracketPath

cd $PSScriptRoot
Convert-Path .
$elapsed = GetElapsedTime $script:startTime
write-host "Total Elapsed Time: " $elapsed -foreground "yellow"
write-host "Script Ended at $(get-date)" -foreground "green"
Write-Host "Press any key to continue ..." -foreground "magenta"
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")

