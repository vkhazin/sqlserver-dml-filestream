SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TRIGGER [dbo].[CqrsDelete]
   ON  [dbo].[FareTypes]
   For Delete
AS 
BEGIN
	Set NOCOUNT ON;

	Declare @FileName nvarchar(255);
	Declare @String nvarchar(max);
	
	Set @String = (select * from deleted FOR JSON AUTO)
	
	Declare @Result varchar(max);
	
	Set @Filename = (select dbo.CqrsGenerateFileName('FareTypes', 'D'))
	
	Set @Result = (select dbo.[CqrsWriteFile](@Filename, @String))

	if (@Result <> '0')
	Begin 
		
		Declare @ErrorMessage nvarchar(max)	
		Set @ErrorMessage = (select Right(@Result,(Len(@Result)+1) - (CHARINDEX('#',@Result)+1)))

		Declare @LogString nvarchar(max); 
		Set @LogString = (select * from deleted FOR JSON AUTO);

		Exec [dbo].[CqrsLogError] 'FareTypes',@ErrorMessage,@LogString,'Delete'
		
	End 
END



GO

ALTER TABLE [dbo].[FareTypes] ENABLE TRIGGER [CqrsDelete]
GO


