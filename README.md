# Sql Server T-Sql 

## Sql Server Configuration

* One-time setup using powershell execute:
```
$dbname="Trapeze6_Generic"
sqlcmd -d $dbname -i ./common/sqlserver-config.sql
sqlcmd -d $dbname -i ./common/fn-file-name.sql
sqlcmd -d $dbname -i ./common/fn-write-file.sql
sqlcmd -d $dbname -i ./common/cqrs-errors-ddl.sql
sqlcmd -d $dbname -i ./common/sp-log-cqrs-error.sql


sqlcmd -d $dbname -i ./fare-types/tr-fare-types-insert.sql
sqlcmd -d $dbname -i ./fare-types/tr-fare-types-update.sql
sqlcmd -d $dbname -i ./fare-types/tr-fare-types-delete.sql
```

* In the case of empty table, insert some data:
```
$dbname="Trapeze6_Generic"
sqlcmd -d $dbname -i ./fare-types/fare-types-dml.sql
```

## Scope

* Sql Server 2019 running on windows server 2019 data center edition VM on Azure
* DDL for the table:
```

```
* Sample data for the table:
```

```
* Implement t-sql trigger on insert, update, and delete to write a file on the disk
* File name: path as a constant inside t-sql code, slash, PK int value, dash, YYYY-MM-DDTHH-MM-SS-MS, dot, json
* File content:
```
{
  "table": "FareTypes",
  "action": "insert|update|delete",
  "timestamp": "2002-10-02T15:00:00.05Z",
  "id": "single field pk field value",
  "data": {
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
}
```
* Create a stress test using JMeter to test performance with 1, 10, 25, 50 thread users
* Markdown documentation for instructions
