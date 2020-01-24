USE [FaresDB]
GO

/****** Object:  UserDefinedFunction [dbo].[WriteDataToFile]    Script Date: 07/01/2020 22:00:35 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		<Mahmoud Aleryan>
-- Create date: <06.01.2020>
-- Description:	<A fucntion to write record to file system>
-- =============================================
CREATE FUNCTION [dbo].[WriteDataToFile] 
  (
		@FullFilePath nvarchar(255),
		@String nvarchar(max)
    )
	RETURNS varchar(max)
AS 
    BEGIN
        DECLARE
            @objFileSystem INT,
            @objTextStream INT,
            @objErrorObject INT,
            @strErrorMessage VARCHAR(1000),
            @command VARCHAR(1000),
            @result INT

		
        SELECT
            @strErrorMessage = 'opening the File System Object'
        EXECUTE @result = sp_OACreate 
            'Scripting.FileSystemObject',
            @objFileSystem OUT

       
        IF @result = 0 
            SELECT
                @objErrorObject = @objFileSystem,
                @strErrorMessage = 'Creating file "' + @FullFilePath + '"'
        IF @result = 0 
            EXECUTE @result = sp_OAMethod 
                @objFileSystem,
                'CreateTextFile',
                @objTextStream OUT,
                @FullFilePath,
                2,
                True

        IF @result = 0 
            SELECT
                @objErrorObject = @objTextStream,
                @strErrorMessage = 'writing to the file "' + @FullFilePath + '"'
        IF @result = 0 
            EXECUTE @result = sp_OAMethod 
                @objTextStream,
                'Write',
                NULL,
                @String

        IF @result = 0 
            SELECT
                @objErrorObject = @objTextStream,
                @strErrorMessage = 'closing the file "' + @FullFilePath + '"'
        IF @result = 0 
            EXECUTE @result = sp_OAMethod 
                @objTextStream,
                'Close'

        IF @result <> 0 
            BEGIN
                DECLARE
                    @Source VARCHAR(255),
                    @MsgDescription VARCHAR(255),
                    @Helpfile VARCHAR(255),
                    @HelpID INT
	
                EXECUTE sp_OAGetErrorInfo 
                    @objErrorObject,
                    @source OUTPUT,
                    @MsgDescription OUTPUT,
                    @Helpfile OUTPUT,
                    @HelpID OUTPUT
                SELECT
                    @strErrorMessage = 'Error whilst ' + COALESCE(@strErrorMessage, 'doing something') + ', Description:' + COALESCE(@MsgDescription, '')
            declare @fullError nvarchar(max) 
			set @fullError = cast( @helpId  as nvarchar(max))+ '#' + @strErrorMessage
			return @fullError;
            END ;
        
        EXECUTE sp_OADestroy 
            @objTextStream ;
        EXECUTE sp_OADestroy 
            @objFileSystem ;

		return cast( @result as nvarchar(max))
    END ;

GO


