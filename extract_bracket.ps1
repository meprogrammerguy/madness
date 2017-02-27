param(
    [Parameter(Mandatory = $true)]
    [Microsoft.PowerShell.Commands.HtmlWebResponseObject] $WebRequest
)

Import-Module PowerShellFuzzySearch

$games = @($WebRequest.ParsedHtml.getElementsByclassName("match round1 winnertop"))
$games += @($WebRequest.ParsedHtml.getElementsByclassName("match round1 winnerbot"))
$games += @($WebRequest.ParsedHtml.getElementsByclassName("match round2 winnertop"))
$games += @($WebRequest.ParsedHtml.getElementsByclassName("match round2 winnerbot"))
$games += @($WebRequest.ParsedHtml.getElementsByclassName("match round3 winnertop"))
$games += @($WebRequest.ParsedHtml.getElementsByclassName("match round3 winnerbot"))
$games += @($WebRequest.ParsedHtml.getElementsByclassName("match round4 winnertop"))
$games += @($WebRequest.ParsedHtml.getElementsByclassName("match round4 winnerbot"))
$games += @($WebRequest.ParsedHtml.getElementsByclassName("match round5 winnertop"))
$games += @($WebRequest.ParsedHtml.getElementsByclassName("match round5 winnerbot"))
$games += @($WebRequest.ParsedHtml.getElementsByclassName("match round6 winnertop"))
$games += @($WebRequest.ParsedHtml.getElementsByclassName("match round6 winnerbot"))
foreach($game in $games)
{
	$a = $game.innerHtml
	$a = $a -replace '<B>',''
	$a = $a -replace '</B>',''
	$a = $a -replace '<DL>',''
	$a = $a -replace '</DL>',''
	$a = $a -replace 'amp;',''
	$a = $a -replace "'i",'i'
	$a = $a.Trim()
	if($a.length -gt 0)
	{
		$seed1 = ($a -split "<DT>").split("<")[1].Trim()
		$team1 = ($a -split 'href=')[1].split('>')[1].split("<")[0]
		$k1Index = 1
		$kenpom1 = @()
		if($team1.length -gt 0 -and $game.className.contains("round1"))
		{
			$kenpom1 = ./TeamNames.ps1 | Select-Fuzzy $team1
			if($kenpom1.count -gt 1)
			{
				write-host "Bracket = $($team1)"
				foreach($kenpom in $kenpom1)
				{
					write-host "			KenPom = $($kenpom)"
				}
				$PromptText = "							(1-$($kenpom1.length))"
				$k1Index = Read-Host $PromptText
			}
		}
		$score1 = ($a -split "pointer")[1].split(">")[1].split("<")[0] 
		$seed2 = ($a -split "<BR>")[1].split("<")[0].Trim()
		$team2 = ($a -split 'href=')[2].split('>')[1].split("<")[0]
		$k2Index = 1
		$kenpom2 = @()
		if($team2.length -gt 0 -and $game.className.contains("round1"))
		{
			$kenpom2 = ./TeamNames.ps1 | Select-Fuzzy $team2
			if($kenpom2.count -gt 1)
			{
				write-host "Bracket = $($team2)"
				foreach($kenpom in $kenpom2)
				{
					write-host "			KenPom = $($kenpom)"
				}
				$PromptText = "							(1-$($kenpom2.length))"
				$k2Index = Read-Host $PromptText
			}
		}
		$score2 = ($a -split "pointer")[1].split(">")[2].split("<")[0]
		$resultObject = [Ordered] @{}
		$resultObject["Match"] += ("" + $game.id)
		$resultObject["Round"] += ("" + $game.className)
		$resultObject["Seed1"] += ("" + $seed1)
		[int]$intNum = [convert]::ToInt32($k1Index, 10)
		$intNum = $intNum - 1
		if($kenpom1.count-eq 1 -or $kenpom1 -eq "")
		{
			$resultObject["KenPom1"] += ("" + $kenpom1)
		}
		else
		{
			$resultObject["KenPom1"] += ("" + $kenpom1[$intNum])
		}
		$resultObject["Bracket1"] += ("" + $team1)
		$resultObject["Actual1"] += ("" + $score1)
		$resultObject["Predict1"] += ("")
		$resultObject["Seed2"] += ("" + $seed2)
		[int]$intNum = [convert]::ToInt32($k2Index, 10)
		$intNum = $intNum - 1
		if($kenpom2.count -eq 1 -or $kenpom2 -eq "")
		{
			$resultObject["KenPom2"] += ("" + $kenpom2)
		}
		else
		{
			$resultObject["KenPom2"] += ("" + $kenpom2[$intNum])
		}
		$resultObject["Bracket2"] += ("" + $team2)
		$resultObject["Predict2"] += ("")
		$resultObject["Actual2"] += ("" + $score2)
		[PSCustomObject] $resultObject
	}
} 	
    	
    	
    
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	