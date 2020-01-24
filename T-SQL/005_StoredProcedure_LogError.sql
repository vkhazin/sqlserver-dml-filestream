USE [FaresDB]
GO

/****** Object:  StoredProcedure [dbo].[LogError]    Script Date: 07/01/2020 22:02:10 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[LogError]
	-- Add the parameters for the stored procedure here
	@TableName nvarchar(100),
	@ErrorMessage nvarchar(100),
	@Data nvarchar(max),
	@Event nvarchar(100)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	insert into [dbo].[ReplicationErrors] values (newid(), getdate(),@TableName , @ErrorMessage, @Data,@Event)

END
GO


