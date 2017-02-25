param(
    [Parameter(Mandatory = $true)]
    [Microsoft.PowerShell.Commands.HtmlWebResponseObject] $WebRequest
)
$IDs = @()
for($counter = 1; $counter -lt 65 ; $counter++)
{
	$IDs += "match" + $counter
}
$games = @()
$headers = "Match","Seed1","Team1","Score1","Seed2","Team2","Score2"
$index = 0
foreach($id in $IDs)
{
	$games += @($WebRequest.ParsedHtml.getElementByID($id))
}
$resultObject = [Ordered] @{}
$index = 0
foreach($game in $games)
{
	$index++
	$a = $game.innerHtml
	$a = $a -replace '<B>',''
	$a = $a -replace '</B>',''
	if($a.length > 0)
	{
		$seed1 = ($a -split "<DT>").split("<")[1].Trim()
		$team1 = ($a -split 'href=')[1].split('>')[1].split("<")[0]
		$score1 = ($a -split "pointer")[1].split(">")[1].split("<")[0]
		$seed2 = ($a -split "<BR>")[1].split("<")[0].Trim()
		$team2 = ($a -split 'href=')[2].split('>')[1].split("<")[0]
		$score2 = ($a -split "pointer")[1].split(">")[2].split("<")[0]
		$resultObject["Match"] = ("" + $index)
		$resultObject["Seed1"] = ("" + $seed1)
		$resultObject["Team1"] = ("" + $team1)
		$resultObject["Score1"] = ("" + $score1)
		$resultObject["Seed2"] = ("" + $seed2)
		$resultObject["Team2"] = ("" + $team2)
		$resultObject["Score2"] = ("" + $score2)
		Write-Host $resultObject
		[PSCustomObject] $resultObject
	}
}
