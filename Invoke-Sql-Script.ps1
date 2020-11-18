Param(
    [Parameter(Position=0,Mandatory=$True)]
    [string]
    $serverInstance,

    [Parameter(Position=1,Mandatory=$True)]
    [string]
    $databaseName,

    [Parameter(Position=2,Mandatory=$True)]
    [string]
    $scriptFile
)

$retSet = Invoke-Sqlcmd -ServerInstance $serverInstance -Database $databaseName -InputFile $scriptFile -OutputAs DataSet  -OutputSqlErrors $true

return $retSet