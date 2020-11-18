<#
.SYNOPSIS
Script for executing Sql Server scripts

.DESCRIPTION
This script execute Sql Server scripts

.PARAMETER serverInstance
Instance of Sql Server

.PARAMETER databaseName
Name of database

.PARAMETER scriptFile
File name of Sql Server script to execute

#>

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

Write-Host "Execute script " $scriptFile
Write-Host "on server " $serverInstance
Write-Host "in context of database " $databaseName
Write-Host ""

# example:
# .\execute-sq-script.ps1 "DESKTOP-S7I74JH\SE2017" "master" show-sql-server.sql

$dataSet = Invoke-Sqlcmd -ServerInstance $serverInstance -Database $databaseName -InputFile $scriptFile -OutputAs DataSet  -OutputSqlErrors $true

foreach($table in $dataSet.Tables)
{
    Write-Host $table

    for($columnIndex=0; $columnIndex -le $table.Columns.Count; $columnIndex++)
    {
        $column = $table.Columns[$columnIndex]
        foreach($row in $table.Rows)
        {
            $item = $row.ItemArray[$columnIndex]
            Write-Host $column " - " $item
        }
    }
}
