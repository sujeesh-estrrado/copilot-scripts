IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Block_By_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Block_By_id] (@Block_Id bigint)

AS

BEGIN

    SELECT  Block_Id,Block_Name,Block_Code
        FROM [dbo].[Tbl_Block] where Block_DelStatus=0 and Block_Id= @Block_Id;
            
END
   ')
END;
