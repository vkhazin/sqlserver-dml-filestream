SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

create TRIGGER [dbo].[Cqrs]
   ON  [dbo].[FareTypes]
   For insert, update, delete
AS 
BEGIN
	Set NOCOUNT ON;

	Declare @FileName nvarchar(255);
	Declare @data     nvarchar(max);
	Declare @event    nvarchar(100);

	set @event = IIF (
		(exists(select * from inserted) and exists (select * from deleted)), 
		'update',
		IIF (
				(exists (select * from inserted) and not exists(select * from deleted)),
				'insert',
				'delete'
			)
	)  

	Set @data = (
		select t.*,
		SYSUTCDATETIME () as Timestamp
		from (
		  select i.*  
		  from inserted i
      
		  union all
		  select d.*
		  from deleted d
		  where not exists (
			select null
			from inserted i
			where i.FareTypeId = d.FareTypeId
		  )
		) t FOR JSON AUTO
	)
	
	Declare @Result varchar(max);
	

	Set @Filename = (select dbo.CqrsGenerateFileName('FareTypes', @event))
	
	Set @Result = (select dbo.[CqrsWriteFile](@Filename, @data))
		
	if (@Result <> '0')
	Begin 
	
		Declare @ErrorMessage nvarchar(max)	
		Set @ErrorMessage = (select Right(@Result,(Len(@Result)+1) - (CHARINDEX('#',@Result)+1)))
		exec [dbo].[CqrsLogError] 'FareTypes', @ErrorMessage, @data, @event
	End 
END
