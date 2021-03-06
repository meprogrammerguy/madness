param(
    [Parameter(Mandatory = $true)]
    [Microsoft.PowerShell.Commands.HtmlWebResponseObject] $WebRequest,
    [Parameter(Mandatory = $true)]
    [int] $TableNumber
)

## Extract the tables out of the web request
$tables = @($WebRequest.ParsedHtml.getElementsByTagName("TABLE"))
$table = $tables[$TableNumber]
$titles = @()
$rows = @($table.Rows)
$AllTeams = @()
'@"' | Set-Content 'TeamNames.ps1'
## Go through all of the rows in the table
foreach($row in $rows)
{
   $cells = @($row.Cells)

   ## If we've found a table header, remember its titles
   if($cells[0].tagName -eq "TH")
    {
        $titles = @($cells | % { ("" + $_.InnerText).Trim() })
		$titles[$cells.Count - 4] = "SOS" + $titles[$cells.Count - 4]
		$titles[$cells.Count - 1] = "NCSOS" + $titles[$cells.Count - 1]
        continue
    }
    ## If we haven't found any table headers, make up names "P1", "P2", etc.
    if(-not $titles)
    {
        $titles = @(1..($cells.Count + 2) | % { "P$_" })
    }

    ## Now go through the cells in the the row. For each, try to find the
    ## title that represents that column and create a hashtable mapping those
    ## titles to content
    $resultObject = [Ordered] @{}
	$cellcounter = -1
    for($counter = 0; $counter -lt $cells.Count ; $counter++)
    {
	    $title = $titles[$counter]
        if(-not $title)
		{
			continue
		}
		$cellcounter += 1
		if($cells[$cellcounter].className -eq "td-right") #ignore kenpom stupid seeds
		{
			$cellcounter += 1
		}
        $resultObject[$title] = ("" + $cells[$cellcounter].InnerText).Trim()
		if($title -eq "Team")
		{
			$AllTeams += $cells[$cellcounter].InnerText.Trim().ToString()
		}
    }
    ## And finally cast that hashtable to a PSCustomObject
	[PSCustomObject] $resultObject
}
$AllTeams = $AllTeams | sort
$AllTeams | Add-Content 'TeamNames.ps1'
'"@ -split "`n"' | Add-Content 'TeamNames.ps1'