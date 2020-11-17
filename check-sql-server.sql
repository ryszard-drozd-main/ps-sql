-- check sql server
SELECT
	SERVERPROPERTY('IsClustered') AS IsClustered
	,SERVERPROPERTY('MachineName') AS MachineName
	,SERVERPROPERTY('ComputerNamePhysicalNetBIOS') AS ComputerNamePhysicalNetBIOS
	,COALESCE(SERVERPROPERTY('InstanceName'),'') AS InstanceName
	,SERVERPROPERTY('Edition') AS Edition
	,SERVERPROPERTY('ServerName') AS ServerName
	,SERVERPROPERTY('ProductVersion') AS ProductVersion
	,DB_NAME() AS DatabaseName
	,@@SERVERNAME AS OryginalServerName
;

