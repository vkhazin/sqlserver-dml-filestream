SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[CqrsInsert]
   ON  [dbo].[FareTypes]
   For Insert
AS 
BEGIN
	Set NOCOUNT ON;

	Declare @FileName nvarchar(255);
	Declare @String nvarchar(max);
	
	Set @String = (select * from inserted FOR JSON AUTO)
	
	Declare @Result varchar(max);
	
	Set @Filename = (select dbo.CqrsGenerateFileName('FareTypes', 'I'))
	
	Set @Result = (select dbo.[CqrsWriteFile](@Filename, @String))
		
	if (@Result <> '0')
	Begin 
	
		Declare @ErrorMessage nvarchar(max)	
		Declare @LogString nvarchar(max); 
		Set @LogString = (select * from inserted FOR JSON AUTO);
		Set @ErrorMessage = (select Right(@Result,(Len(@Result)+1) - (CHARINDEX('#',@Result)+1)))

		exec [dbo].[CqrsLogError] 'FareTypes',@ErrorMessage,@LogString,'Insert'
	End 
END
GO

ALTER TABLE [dbo].[FareTypes] ENABLE TRIGGER CqrsInsert
GO

drop trigger CqrsInsert