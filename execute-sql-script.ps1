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

$dataSet = & .\Invoke-Sql-Script.ps1 -ServerInstance $serverInstance -DatabaseName $databaseName -ScriptFile $scriptFile

& .\Print-DataSet.ps1 -dataSet $dataSet
