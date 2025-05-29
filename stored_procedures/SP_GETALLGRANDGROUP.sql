IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAllExpiredInvoice]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAllExpiredInvoice]
AS
BEGIN
Select Invoice_Code_Name,Invoice_Code_To_Date from dbo.Tbl_Inventory_Invoice_Code 
where Invoice_Code_To_Date<=getdate() and Invoice_Code_Current_Status=1
END

    ')
END
