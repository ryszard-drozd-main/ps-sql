# ps-sql
Access Sql Server from PS

.\execute-slq-script.ps1 "SERVERNAME\INSTANCENAME" "master" show-sql-server.sql

$pa = @{Name="@StartProductID";Type="int";Value=893},@{Name="@CheckDate";Type="DateTime";Value="2010-05-26"}  
$ds = .\Invoke-Sql-Procedure.ps1 -ServerInstance "SERVERNAME\INSTANCENAME" -DatabaseName "AdventureWorks2017" -ProcedureName "uspGetBillOfMaterials" -ProcParams $pa  
$ds.HasResult  
$ds.Result  
$ds.HasOutputs  
$ds.Outputs  
$ds.DataTables  

OUTPUT parameters, multiple resultsets:  
$pa = @{Name="@RandResult";Type="int";Value=0;Direction='Output'},@{Name="@RandResult2";Type="int";Value=0;Direction='Output'},@{Name="@TextResult";Type="string";Value="";Direction='Output';Size=200}  
$ds = .\Invoke-Sql-Procedure.ps1 -ServerInstance "SERVERNAME\INSTANCENAME" -DatabaseName "q1" -ProcedureName "WithOutParameters" -ProcParams $pa  
$ds.HasResult  
$ds.Result  
$ds.HasOutputs  
$ds.Outputs  
$ds.DataTables[0]  
$ds.DataTables[1]  

Nicer formatting:  
$pa = @{Name="@RandResult";Type="int";Value=0;Direction='Output'},@{Name="@RandResult2";Type="int";Value=0;Direction='Output'},@{Name="@TextResult";Type="string";Value="";Direction='Output';Size=200}  
$ds = .\Invoke-Sql-Procedure.ps1 -ServerInstance "SERVERNAME\INSTANCENAME" -DatabaseName "q1" -ProcedureName "WithOutParameters" -ProcParams $pa  
$ds.HasResult  
$ds.Result  
$ds.HasOutputs  
foreach($output in $ds.Outputs){Write-Host ($output | Out-String)}  
foreach($table in $ds.DataTables){Write-Host ($table | Out-String)}  
