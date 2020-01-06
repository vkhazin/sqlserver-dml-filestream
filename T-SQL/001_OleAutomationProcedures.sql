--Security Impact https://www.stigviewer.com/stig/ms_sql_server_2016_instance/2018-03-09/finding/V-79333



Go
sp_configure 'show advanced options', 1 
GO 
RECONFIGURE; 
GO 
sp_configure 'Ole Automation Procedures', 1 
GO 
RECONFIGURE; 
GO 