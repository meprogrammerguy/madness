param(
    [Parameter(Mandatory = $true)]
    [Microsoft.PowerShell.Commands.HtmlWebResponseObject] $WebRequest
)

function ParseGoodness($data) 
{
	$retStr = ""
	if(($data[1] -gt -1) -and ($data[2] -gt $data[1]))
	{
		$retStr = $data[0].Substring($data[1], $data[2] - $data[1]).Trim()
	}
	$retStr
}

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
	$a = $a -replace '"',''
	if($a.length -gt 0)
	{
		$LeftPos = $a.IndexOf("<DT>") + 4
		$RightPos = $a.IndexOf("<A")
		$seed1 = ParseGoodness $a, $LeftPos, $RightPos
		$LeftPos = $a.IndexOf("title=") + 6
		$RightPos = $a.IndexOf("href=")
		$team1 = ParseGoodness $a, $LeftPos, $RightPos
		$k1Index = 0
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
		$seed2 = ($a -split "<BR>")[1].split("< A")[0].Trim()
		$team2 = ($a -split "title=")[2].split("href=")[0].Trim()
		$k2Index = 0
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
		$resultObject["Match"] += ("" + $game.id).Trim()
		$resultObject["Round"] += ("" + $game.className).Trim()
		$resultObject["Seed1"] += ("" + $seed1).Trim()
		[int]$intNum = [convert]::ToInt32($k1Index, 10)
		$intNum = $intNum - 1
		if($kenpom1.count -lt 1 -or $intNum -lt 0)
		{
			$resultObject["KenPom1"] += ("" + $kenpom1).Trim()
		}
		else
		{
			$resultObject["KenPom1"] += ("" + $kenpom1[$intNum]).Trim()
		}
		$resultObject["Bracket1"] += ("" + $team1).Trim()
		$resultObject["Actual1"] += ("" + $score1).Trim()
		$resultObject["Predict1"] += ("").Trim()
		$resultObject["Seed2"] += ("" + $seed2).Trim()
		[int]$intNum = [convert]::ToInt32($k2Index, 10)
		$intNum = $intNum - 1
		if($kenpom2.count -lt 1 -or $intNum -lt 0)
		{
			$resultObject["KenPom2"] += ("" + $kenpom2).Trim()
		}
		else
		{
			$resultObject["KenPom2"] += ("" + $kenpom2[$intNum]).Trim()
		}
		$resultObject["Bracket2"] += ("" + $team2).Trim()
		$resultObject["Predict2"] += ("").Trim()
		$resultObject["Actual2"] += ("" + $score2).Trim()
		[PSCustomObject] $resultObject
	}
} 	
    	
    	
    
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	