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
$constParameterSize="Size"

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
function GetParameterSize
{
    param (
        [Hashtable]$hash
    )
    return GetHashValue -Hash $hash -Name $constParameterSize -Mandatory $False -DefValue -1
}

function CallProcedureDbMars
{
$SqlConn = New-Object System.Data.SqlClient.SqlConnection("Server = $serverInstance; Database = $databaseName; Integrated Security = True;")
$SqlConn.Open()
$cmd = $SqlConn.CreateCommand()
$cmd.CommandType = 'StoredProcedure'
$cmd.CommandText = $procedureName

$outputs = @()

foreach($p in $procParams)
{
    $paramName = GetParameterName -Hash $p
    $paramType = GetParameterType -Hash $p
    $direction = GetParameterDirection -Hash $p
    $value = GetParameterValue -Hash $p
    $size = GetParameterSize -Hash $p
    $dbp = $cmd.Parameters.Add($paramName,$paramType)
    $dbp.Direction = $direction
    $dbp.Value = $value
    if($size -gt 0)
    {
        $dbp.Size=$size
    }

    if($direction -eq "Output")
    {
        $outputs += ,@($paramName)
    }
}

$cmd.Parameters.Add("@ReturnValue","")
$cmd.Parameters["@ReturnValue"].Direction='ReturnValue'

$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter($cmd)
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)

$ot = @()
$hasOutputs = $False
$returnValue = $cmd.Parameters["@ReturnValue"].Value
$hasReturn = $False
if($null -ne $returnValue)
{
    $hasReturn = $True
}


foreach($op in $outputs)
{
    $name = $op
    $value = $cmd.Parameters[$op].Value
    $ot += ,@{Name=$name;Value=$value}
    $hasOutputs=$True
}

$resultSet = @{DataTables=$DataSet.Tables;HasOutputs=$hasOutputs;Outputs=$ot;HasResult=$hasReturn;Result=$returnValue}
$SqlConn.Close()

return $resultSet
}

$resSet = CallProcedureDbMars

return $resSet
