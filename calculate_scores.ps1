<#
    Powershell March Madness calculate_scores script
#>
#Get-PSBreakpoint | Remove-PSBreakpoint
#Set-PsBreakPoint calculate_scores.ps1 -Line 41
#$Scores = .\calculate_scores.ps1 "Gonzaga" "Villanova"
param(
    [Parameter(Mandatory = $true)]
    [string] $TeamA,
    [Parameter(Mandatory = $true)]
    [string] $TeamB
)
$Host.UI.RawUI.WindowTitle = "calculate_scores Script"

$script:startTime = Get-Date
write-host "calculate_scores Script Started at $script:startTime" -foreground "green"
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
$KenPomCSV = Import-Csv -Path $KenPom -Header Rank,Team,AdjEM,AdjO,AdjD,AdjT
$Stats = @()
$Index = -1
$TeamAIndex = -1
$TeamBIndex = -1
foreach($r in $KenPomCSV)
{
    if($r.Rank -notlike '#*' -and $r.Rank -ne "Rank")
    {
		$Index++
		if($r.Team.Trim() -eq $TeamA)
		{
			$TeamAIndex = $Index
		}
		if($r.Team.Trim() -eq $TeamB)
		{
			$TeamBIndex = $Index
		}
		$Stats += @{Team = $r.Team.Trim(); AdjEM = $r.AdjEM.Trim(); AdjO = $r.AdjO.Trim(); AdjD = $r.AdjD.Trim(); AdjT = $r.AdjT;}
	}
}
$AverageOffense = $ConfigFile.Settings.GetMad.KenPom.AverageOffense
$AverageDefense = $ConfigFile.Settings.GetMad.KenPom.AverageDefense
$AverageTempo = $ConfigFile.Settings.GetMad.KenPom.AverageTempo
$ScoreA = "?"
if($TeamAIndex -gt -1)
{
}
$ScoreB = "?"
if($TeamBIndex -gt -1)
{
}
$Scores = @($ScoreA, $ScoreB)
Write-Output $Scores
