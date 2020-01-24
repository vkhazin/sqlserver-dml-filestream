USE [FaresDB]
GO

/****** Object:  UserDefinedFunction [dbo].[GenerateFileName]    Script Date: 07/01/2020 22:01:21 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[GenerateFileName]
(
		@OperationType varchar(1)
)
RETURNS varchar(255)
AS
BEGIN
	-- Declare the return variable here
	declare @result varchar(255)

	Set @result = ('d:\Temp\' + @OperationType + '_' + Replace(Replace(REPLACE(convert(varchar, getdate(), 21),' ','T'),'.','-'),':','-') + '.json');
	
	RETURN @result

END
GO


