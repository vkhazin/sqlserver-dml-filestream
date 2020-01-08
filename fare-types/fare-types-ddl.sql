SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

IF OBJECT_ID (N'FareTypes', N'U') IS NULL 
begin 
  CREATE TABLE [dbo].[FareTypes](
    [FareTypeId] [int] NOT NULL,
    [FareTypeAbbr] [varchar](10) NULL,
    [Description] [varchar](30) NULL,
    [FlatFareAmt] [real] NULL,
    [FlatRate] [real] NULL,
    [DistanceRate] [real] NULL,
    [PolygonRate] [real] NULL,
    [TimeRate] [real] NULL,
    [PolyTypeId] [int] NULL,
    [PrepaidReq] [char](2) NULL,
    [FareAdjustDiffZon] [float] NULL,
    [FareAdjustSameZon] [float] NULL,
    [DistanceLimitSameZon] [float] NULL,
    [DistanceLimitDiffZon] [float] NULL,
    [NumCode] [smallint] NULL,
    [FareMode] [smallint] NULL,
    [FareCalcType] [smallint] NULL,
    [VariationOf] [int] NULL,
    [MinFare] [real] NULL,
    [MaxFare] [real] NULL,
    [RoundFare] [tinyint] NULL,
    [DistanceLimit] [int] NULL,
    [RoundDirection] [smallint] NULL,
    [Accuracy] [real] NULL,
    [InActive] [smallint] NULL
  CONSTRAINT [pkFareTypes] PRIMARY KEY CLUSTERED 
  (
    [FareTypeId] ASC
  ) WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
  ) ON [PRIMARY]
end

alter table dbo.FareTypes
	add [Timestamp] [datetime2] DEFAULT SYSUTCDATETIME ()
GO