IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_Invoice_Code_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Inventory_Invoice_Code_Delete]
 @Invoice_Code_Id bigint
AS
BEGIN
    UPDATE [Tbl_Inventory_Invoice_Code]
   SET [Invoice_Code_Del_Status] = 1
 WHERE Invoice_Code_Id=@Invoice_Code_Id
END
    ')
END
