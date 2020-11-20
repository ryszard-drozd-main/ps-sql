#System.Data.SqlClient.SqlParameterCollection
Param(
    [Parameter(Position=0,Mandatory=$True)]
    [string]
    $serverInstance,

    [Parameter(Position=1,Mandatory=$True)]
    [string]
    $databaseName,

    [Parameter(Position=2,Mandatory=$True)]
    [string]
    $procedureName,

    [Parameter(Position=3,Mandatory=$False)]
    [Hashtable[]]
    $procParams
)

$constParameterName="Name"
$constParameterType="Type"
$constParameterValue="Value"
$constParameterDirection="Direction"

function GetHashValue
{
    param (
        [Hashtable]$hash
        ,[string]$name
        ,[bool]$mandatory
        ,[object]$defValue
    )
    if($hash.ContainsKey($name))
    {
        return $hash[$name]
    }
    elseif($mandatory)
    {
        throw "No parameter " + $name
    }
    else
    {
        return $defValue
    }
}

function GetParameterName
{
    param (
        [Hashtable]$hash
    )
    return GetHashValue -Hash $hash -Name $constParameterName -Mandatory $True -DefValue ""
}
function GetParameterValue
{
    param (
        [Hashtable]$hash
    )
    return GetHashValue -Hash $hash -Name $constParameterValue -Mandatory $True -DefValue ""
}
function GetParameterType
{
    param (
        [Hashtable]$hash
    )
    return GetHashValue -Hash $hash -Name $constParameterType -Mandatory $True -DefValue ""
}
function GetParameterDirection
{
    param (
        [Hashtable]$hash
    )
    return GetHashValue -Hash $hash -Name $constParameterDirection -Mandatory $False -DefValue 'Input'
}

function CallProcedureDb
{
$SqlConn = New-Object System.Data.SqlClient.SqlConnection("Server = $serverInstance; Database = $databaseName; Integrated Security = True;")
$SqlConn.Open()
$cmd = $SqlConn.CreateCommand()
$cmd.CommandType = 'StoredProcedure'
$cmd.CommandText = $procedureName

foreach($p in $procParams)
{
    $paramName = GetParameterName -Hash $p
    $paramType = GetParameterType -Hash $p
    $direction = GetParameterDirection -Hash $p
    $value = GetParameterValue -Hash $p
    $dbp = $cmd.Parameters.Add($paramName,$paramType)
    $dbp.Direction = $direction
    $dbp.Value = $value
}

$results = $cmd.ExecuteReader()
$dt = New-Object System.Data.DataTable
$dt.Load($results)
$SqlConn.Close()

return $dt
}

$retSet = CallProcedureDb

return $retSet
