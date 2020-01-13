# Sql Server T-Sql 

## Objectives

* Implement t-sql triggers to write out file to disk
* One file per table per statement
* File content to list all the values and the action type taken
* Sql Server 2019 running on windows server 2019 data center edition VM on Azure
* File name: path with table name, action taken, dash, YYYY-MM-DDTHH-MM-SS-MS, dot, json
* File content:
```
{
	"FareTypeId": 1,
	"FareTypeAbbr": "STA",
	"Description": "Standard Fare",
	"FlatRate": 2.0,
	"DistanceRate": 0.0,
	"PolygonRate": 0.0,
	"TimeRate": 0.0,
	"PolyTypeId": 0,
	"FareAdjustDiffZon": 0.0,
	"FareAdjustSameZon": 0.0,
	"DistanceLimitSameZon": 0.0,
	"DistanceLimitDiffZon": 0.0,
	"NumCode": 1,
	"FareMode": 0,
	"FareCalcType": 0,
	"SourceTimestamp": "2002-10-02T15:00:00.05Z"
}
```
* In case of error generating file, write record to sql server table: CqrsErrors
* A separate deliverable to send the files to Azure Event Hub
* A separate deliverable to implement CqrsErrors processing  

## Sql Server Configuration

* One-time setup using powershell execute:
```
$dbname="Trapeze6_Generic"
# Once per Sql Server instance
sqlcmd -d $dbname -i ./common/sqlserver-config.sql
# Once per Sql Server database 
sqlcmd -d $dbname -i ./common/fn-file-name.sql
sqlcmd -d $dbname -i ./common/fn-write-file.sql
sqlcmd -d $dbname -i ./common/cqrs-errors-ddl.sql
sqlcmd -d $dbname -i ./common/sp-log-cqrs-error.sql

# Once per table to cqrs
sqlcmd -d $dbname -i ./fare-types/tr-fare-types-insert.sql
sqlcmd -d $dbname -i ./fare-types/tr-fare-types-update.sql
sqlcmd -d $dbname -i ./fare-types/tr-fare-types-delete.sql
```

* Login to Windows VM and create new user e.g. `sqlservice`
* Unselect: `User must change password at next login`
* Select: `Password never expires`
* Add the newly created user to `Administrators` group
* Open `Local Security Policies` -> `Local Policies` -> `User Rights Assignment` -> `Log on as a service`
* Add the newly created user to the `Log on as a service` right
* Open `Sql Server Configuration Manager` and change Sql Server service to use the newly created user
* Verify Sql Server is running after the service account change
* `Azure Portal` -> Create new Azure Storage Account with a File Share
* Copy the powershell script to connect to the account from Windows Server
* `Sql Server VM` using the PowerShell ISE open another instance of PowerShell ISE as the service account:
```
$password = ConvertTo-SecureString -String "<service-account-password>" -AsPlainText -Force
$credential = New-Object System.Management.Automation.PSCredential -ArgumentList "sqlservice", $password
Start-Process -FilePath PowerShell_ISE.exe -Credential $credential -LoadUserProfile 
```
* Inside the new PowerShell ISE, create credentias to zure Storage Account by executing portion of the script copied from Azure File Share:
```
cmd.exe /C "cmdkey /add:`"stlegacydata.file.core.windows.net`" /user:`"Azure\stlegacydata`" /pass:`"BRdqBVYqNntplnr2qvupQalfd/GYKaZc93jELe29lMgF5Q7YR7gJV4rDmFc/lpkthmza52qFAq7GdscoFrh/tQ==`""
```
* Verify code inside Sql Server Function `CqrsGenerateFileName` points to the Azure Storage:
```
...
Set @result = (
		'\\stlegacydata.file.core.windows.net\passcqrs\' + 
    @tableName + '\' +
		@event + '_' + 
		Replace(
			Replace(
				Replace(
					convert(varchar, SYSUTCDATETIME (), 21),' ','T'
				),'.','-'
			),':','-'
		) + '.json'
	);
...
```

* In the case of empty table, insert some data:
```
$dbname="Trapeze6_Generic"
sqlcmd -d $dbname -i ./fare-types/fare-types-dml.sql
```

## How to test

### Failure Test

* Double check there is no folder in the Azure File Share `FareTypes`
* Execute following statement in Sql Server Management Studio:
```
update dbo.FareTypes
set FareTypeId = FareTypeId
where FareTypeId = (select top 1 FareTypeId from dbo.FareTypes)

select * from CqrsErrors
```
* One record should appear in the table stating error writing file

### Success Test

* Create folder under Azure File Share `FareTypes`
* Execute the following statement in Sql Server Management Studio:
```
update dbo.FareTypes
set FareTypeId = FareTypeId
where FareTypeId = (select top 1 FareTypeId from dbo.FareTypes)
```
* Open Azure File Share to see a new file posted
