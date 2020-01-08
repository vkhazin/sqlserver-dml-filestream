INSERT [dbo].[FareTypes] (
  [FareTypeId],
  [FareTypeAbbr], 
  [Description], 
  [FlatFareAmt], 
  [FlatRate], 
  [DistanceRate], 
  [PolygonRate], 
  [TimeRate], 
  [PolyTypeId], 
  [PrepaidReq], 
  [FareAdjustDiffZon], 
  [FareAdjustSameZon], 
  [DistanceLimitSameZon], 
  [DistanceLimitDiffZon], 
  [NumCode], [FareMode], 
  [FareCalcType], 
  [VariationOf], 
  [MinFare], 
  [MaxFare], 
  [RoundFare], 
  [DistanceLimit], 
  [RoundDirection], 
  [Accuracy], 
  [InActive]) 

select 1, N'STA', N'Standard Fare', NULL, 2, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 1, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
union all
select 2, N'CON', N'Concessionary Fare', NULL, 1, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 2, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
union all
select 3, N'CSF', N'Child Standard Fare', NULL, 1, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 3, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
union all
select 4, N'CCF', N'Child Concessionary Fare', NULL, 0.5, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 4, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
union all
select 5, N'ESC', N'Escort Fare', NULL, 0.75, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 5, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL
union all
select 6, N'FOC', N'Free Of Charge', NULL, 0, 0, 0, 0, 0, NULL, 0, 0, 0, 0, 6, 0, 0, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL