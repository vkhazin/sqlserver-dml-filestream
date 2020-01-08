SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[CqrsErrors](
	[ID] [uniqueidentifier] NOT NULL,
	[Timestamp] [datetime] NOT NULL,
	[TableName] [nvarchar](100) NOT NULL,
	[ErrorMessage] [nvarchar](max) NULL,
	[Data] [nvarchar](max) NULL,
	[Event] [nvarchar](100) NULL,
 CONSTRAINT [PK_CqrsErrors] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CqrsErrors] ADD  CONSTRAINT [DF_CqrsErrors_ID]  DEFAULT (newid()) FOR [ID]
GO

ALTER TABLE [dbo].[CqrsErrors] ADD  CONSTRAINT [DF_CqrsErrors_Timestamp]  DEFAULT (getutcdate()) FOR [Timestamp]
GO
