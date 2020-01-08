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

* In the case of empty table, insert some data:
```
$dbname="Trapeze6_Generic"
sqlcmd -d $dbname -i ./fare-types/fare-types-dml.sql
```

## How to test

### Failure Test

* Double check there is no folder `D:\Temp`
* Execute following statement in Sql Server Management Studio:
```update dbo.FareTypes
set FareTypeId = FareTypeId
where FareTypeId = (select top 1 FareTypeId from dbo.FareTypes)

select * from CqrsErrors

```
* One record should appear in the table stating the folder was not found

### Success Test

* Create folder `D:\Temp\FareTypes`
* Execute following statement in Sql Server Management Studio:
```update dbo.FareTypes
set FareTypeId = FareTypeId
where FareTypeId = (select top 1 FareTypeId from dbo.FareTypes)
