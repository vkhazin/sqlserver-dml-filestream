SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE FUNCTION [dbo].[CqrsWriteFile] 
  (
		@fullFilePath nvarchar(255),
		@data nvarchar(max)
  )
	RETURNS varchar(max)
AS BEGIN
  DECLARE 
    @fileSystemToken INT,
    @textStreamToken INT,
    @strErrorMessage nvarchar(max),
    @command nvarchar(max),
    @result INT,
    @Source nvarchar(max),
		@MsgDescription nvarchar(max)

  set @strErrorMessage = 'Creating FileSystemObject'
  EXECUTE @result = sp_OACreate 
    'Scripting.FileSystemObject',
    @fileSystemToken OUT

  IF @result = 0
  begin
    set @strErrorMessage = 'CreateTextFile: "' + @fullFilePath + '"'
    EXECUTE @result = sp_OAMethod 
      @fileSystemToken,
      'CreateTextFile',
      @textStreamToken OUT,
      @fullFilePath,
      2,
      True
  end

  IF @result = 0 
  begin
    set @strErrorMessage = 'writing file: "' + @fullFilePath + '"'
    EXECUTE @result = sp_OAMethod 
      @textStreamToken,
      'Write',
      NULL,
      @data
  end

  IF @result = 0
  begin 
    set @strErrorMessage = 'closing the file "' + @fullFilePath + '"'
    EXECUTE @result = sp_OAMethod 
      @textStreamToken,
      'Close'
  end

  IF @result <> 0 
  BEGIN
		EXECUTE sp_OAGetErrorInfo 
			@fileSystemToken,
			@Source OUTPUT,
			@MsgDescription OUTPUT
        
		set @strErrorMessage = 'Error ' + @strErrorMessage + IsNull(', Description:' + @MsgDescription, '')

	END
  else
	BEGIN
		set @strErrorMessage = null
	END
  
  EXECUTE sp_OADestroy textStreamToken
  EXECUTE sp_OADestroy @fileSystemToken
  
	return @strErrorMessage
END