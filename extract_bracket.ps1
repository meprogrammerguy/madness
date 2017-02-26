param(
    [Parameter(Mandatory = $true)]
    [Microsoft.PowerShell.Commands.HtmlWebResponseObject] $WebRequest
)
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
		$score1 = ($a -split "pointer")[1].split(">")[1].split("<")[0]
		$seed2 = ($a -split "<BR>")[1].split("<")[0].Trim()
		$team2 = ($a -split 'href=')[2].split('>')[1].split("<")[0]
		$score2 = ($a -split "pointer")[1].split(">")[2].split("<")[0]
		$resultObject = [Ordered] @{}
		$resultObject["Match"] += ("" + $game.id)
		$resultObject["Round"] += ("" + $game.className)
		$resultObject["Seed1"] += ("" + $seed1)
		$resultObject["KenPom11"] += ("")
		$resultObject["Bracket1"] += ("" + $team1)
		$resultObject["Actual1"] += ("" + $score1)
		$resultObject["Predict1"] += ("")
		$resultObject["Seed2"] += ("" + $seed2)
		$resultObject["KenPom11"] += ("")
		$resultObject["Bracket2"] += ("" + $team2)
		$resultObject["Predict2"] += ("")
		$resultObject["Actual2"] += ("" + $score2)
		[PSCustomObject] $resultObject
	}
}   	
    	
    	
    
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	