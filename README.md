# Sql Server T-Sql Trigger Write File

## Objectives

* Implement t-sql triggers to write out file to disk
* One file per table per statement
* File content to list all the values and the action type taken
* Sql Server 2019 running on windows server 2019 data center edition VM on Azure
* File name: path with table name, action taken, dash, YYYY-MM-DDTHH-MM-SS-MS, dot, json
* File content:
```
[
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
		"Timestamp": "2002-10-02T15:00:00.05Z"
	}
]
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
sqlcmd -d $dbname -i ./fare-types/tr-fare-types-cqrs.sql
```

* In the case of empty table, insert some data:
```
$dbname="Trapeze6_Generic"
sqlcmd -d $dbname -i ./fare-types/fare-types-dml.sql
```

## How to test

### Failure Test

* Double check there is no folder `D:\Temp`
* Execute the following statements in Sql Server Management Studio:
```
delete from dbo.CqrsErrors

INSERT [dbo].[FareTypes] ([FareTypeId], [FareTypeAbbr], [Description], [FlatFareAmt], [FlatRate], [DistanceRate], [PolygonRate], [TimeRate], [PolyTypeId], [PrepaidReq], [FareAdjustDiffZon], [FareAdjustSameZon], [DistanceLimitSameZon], [DistanceLimitDiffZon], [NumCode], [FareMode], [FareCalcType], [VariationOf], [MinFare], [MaxFare], [RoundFare], [DistanceLimit], [RoundDirection], [Accuracy], [InActive], [Timestamp])
VALUES (100, N'STA', N'Standard Fare', NULL, 2, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 1, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)

update dbo.FareTypes
set FareTypeId = FareTypeId
where FareTypeId = 100

update dbo.FareTypes
set FareTypeId = FareTypeId
where FareTypeId = 100

delete from dbo.FareTypes where FareTypeId=100

select * from dbo.CqrsErrors order by Timestamp

```
* Few records with error should appear in the table stating the folder was not found

### Success Test

* Create folder `D:\Temp\FareTypes`
* Re-execute the sql statements above
* Check the folder to see few files created with json content

## The fine print

* For performance reasons the output folder needs to be on a separate disk from the rest of the System
* The approach has been tested for a single table replication