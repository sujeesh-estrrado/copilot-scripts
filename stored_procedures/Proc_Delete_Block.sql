IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Block]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Proc_Delete_Block](@Block_Id bigint)

AS

BEGIN

    UPDATE [dbo].[Tbl_Block]
        SET     Block_DelStatus = 1
        WHERE  Block_Id = @Block_Id
END


   ')
END;
