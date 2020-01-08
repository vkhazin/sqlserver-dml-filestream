SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE PROCEDURE [dbo].[CqrsLogError]
	@tableName nvarchar(100),
	@errorMessage nvarchar(100),
	@data nvarchar(max),
	@event nvarchar(100)
AS
BEGIN

	SET NOCOUNT ON;
	insert into [dbo].[CqrsErrors] values (newid(), getutcdate(),@tableName , @errorMessage, @data, @event)

END
GO
