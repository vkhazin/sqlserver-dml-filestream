USE [FaresDB]
GO

/****** Object:  Table [dbo].[ReplicationErrors]    Script Date: 07/01/2020 22:01:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[ReplicationErrors](
	[ID] [uniqueidentifier] NOT NULL,
	[Timestamp] [datetime] NOT NULL,
	[TableName] [nvarchar](100) NOT NULL,
	[ErrorMessage] [nvarchar](max) NULL,
	[Data] [nvarchar](max) NULL,
	[Event] [nvarchar](100) NULL,
 CONSTRAINT [PK_ReplicationErrors] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ReplicationErrors] ADD  CONSTRAINT [DF_ReplicationErrors_ID]  DEFAULT (newid()) FOR [ID]
GO

ALTER TABLE [dbo].[ReplicationErrors] ADD  CONSTRAINT [DF_ReplicationErrors_Timestamp]  DEFAULT (getdate()) FOR [Timestamp]
GO


