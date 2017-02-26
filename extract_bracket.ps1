param(
    [Parameter(Mandatory = $true)]
    [Microsoft.PowerShell.Commands.HtmlWebResponseObject] $WebRequest
)
$games = @($WebRequest.ParsedHtml.getElementsByclassName("match round1 winnertop"))
$games += @($WebRequest.ParsedHtml.getElementsByclassName("match round1 winnerbot"))
foreach($game in $games)
{
	$a = $game.innerHtml
	$a = $a -replace '<B>',''
	$a = $a -replace '</B>',''
	$a = $a -replace '<DL>',''
	$a = $a -replace '</DL>',''
	$a = $a -replace 'amp;',''
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
		$resultObject["Seed1"] += ("" + $seed1)
		$resultObject["Team1"] += ("" + $team1)
		$resultObject["Score1"] += ("" + $score1)
		$resultObject["Seed2"] += ("" + $seed2)
		$resultObject["Team2"] += ("" + $team2)
		$resultObject["Score2"] += ("" + $score2)
		[PSCustomObject] $resultObject
	}
}   	
    	
    	
    
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	
    	