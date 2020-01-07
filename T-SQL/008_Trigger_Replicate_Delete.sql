USE [FaresDB]
GO

/****** Object:  Trigger [dbo].[Trigger_Replicate_Delete]    Script Date: 07/01/2020 22:02:38 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE TRIGGER [dbo].[Trigger_Replicate_Delete]
   ON  [dbo].[FareTypes]
   For Delete
AS 
BEGIN
	-- Set NOCOUNT ON added to prevent extra Result Sets from
	-- interfering with SELECT statements.
	Set NOCOUNT ON;

    -- Insert statements for trigger here
	Declare @FileName nvarchar(255);
	Declare @String nvarchar(max);
	
	Set @String = (select * from deleted FOR JSON AUTO)
	
	Declare @Result varchar(max);
	
	Set @Filename =  (select dbo.GenerateFileName('D'))
	
	Set @Result = (select dbo.[WriteDataToFile](@Filename, @String))

	if (@Result <> '0')
	Begin 
		
		Declare @ErrorMessage nvarchar(max)	
		Set @ErrorMessage = (select Right(@Result,(Len(@Result)+1) - (CHARINDEX('#',@Result)+1)))

		Declare @LogString nvarchar(max); 
		Set @LogString = (select * from deleted FOR JSON AUTO);


		Exec [dbo].[LogError] '[FareTypes]',@ErrorMessage,@LogString,'Delete'
		
	End 
END



GO

ALTER TABLE [dbo].[FareTypes] ENABLE TRIGGER [Trigger_Replicate_Delete]
GO


