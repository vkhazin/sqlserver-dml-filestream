SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[CqrsGenerateFileName]
(
  @tableName      varchar(100),
	@event  varchar(100)
)
RETURNS varchar(255)
AS
BEGIN
	-- Declare the return variable here
	declare @result varchar(255)

	Set @result = (
		'D:\Temp\' + 
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
	
	RETURN @result
END
GO