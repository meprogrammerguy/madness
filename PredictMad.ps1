<#
    Powershell March Madness PredictMad script
#>
#Get-PSBreakpoint | Remove-PSBreakpoint
#Set-PsBreakPoint PredictMad.ps1 -Line 31
$Host.UI.RawUI.WindowTitle = "PredictMad Script"

$script:startTime = Get-Date
write-host "PredictMad Script Started at $script:startTime" -foreground "green"
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
$Bracket = $WorkDirectory + "\bracket.csv"
$AfterRun = $WorkDirectory + "\predict.txt"
$BracketCSV = Import-Csv -Path $Bracket -Header Match,Round,Seed1,KenPom1,Bracket1,Predict1,Seed2,KenPom2,Bracket2,Predict2
$Table = @()
$Scores = @()
$Index = -1
foreach($r in $BracketCSV)
{
    if($r.Match -notlike '#*')
    {
		$Index++
		$Scores = "?", "?"
		if($r.KenPom1.Trim() -gt "" -and $r.KenPom2.Trim() -gt "")
		{
			$Scores = .\calculate_scores.ps1 $r.KenPom1.Trim() $r.KenPom2.Trim()
		}
		if($r.Match -eq "Match")
		{
			$Scores[0] = $r.Predict1.Trim()
			$Scores[1] = $r.Predict2.Trim()
		}
		$Table += @{KenPom1 = $r.KenPom1.Trim(); Predict1 = $Scores[0]; KenPom2 = $r.KenPom2.Trim(); Predict2 = $Scores[1];}
	}
}
$Table | Out-File $AfterRun
