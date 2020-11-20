# ps-sql
Access Sql Server from PS

.\execute-slq-script.ps1 "SERVERNAME\INSTANCENAME" "master" show-sql-server.sql

$pa = @{Name="@StartProductID";Type="int";Value=893},@{Name="@CheckDate";Type="DateTime";Value="2010-05-26"}
$ds = .\Invoke-Sql-Procedure.ps1 -ServerInstance "SERVERNAME\INSTANCENAME" -DatabaseName "AdventureWorks2017" -ProcedureName "uspGetBillOfMaterials" -ProcParams $pa
$ds