IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_PurchaseRetun_GetLatestInvoiceNo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Inventory_PurchaseRetun_GetLatestInvoiceNo]              
        AS              
        BEGIN              
            DECLARE @SalesReturnCode varchar(100), 
                    @InvoiceCodeStartNo varchar(100),      
                    @code varchar(100), 
                    @Invoice_Code_Id bigint                  

            SET @SalesReturnCode = (
                SELECT TOP 1 Purchase_Return_Code 
                FROM dbo.Tbl_Purchase_Return      
                ORDER BY Purchase_return_Id DESC
            )                  

            SET @InvoiceCodeStartNo = (
                SELECT Invoice_Code_StartNo 
                FROM Tbl_Inventory_Invoice_Code      
                WHERE Invoice_Code_Name = ''Purchase Return'' 
                  AND Invoice_Code_Current_Status = 1
            )                   

            SET @code = ISNULL(@SalesReturnCode + 1, @InvoiceCodeStartNo)           

            SET @Invoice_Code_Id = (
                SELECT Invoice_Code_Id 
                FROM Tbl_Inventory_Invoice_Code       
                WHERE Invoice_Code_Name = ''Purchase Return'' 
                  AND Invoice_Code_Current_Status = 1
            )             

            SELECT Invoice_Code_Prefix, 
                   @code AS Invoice_Code, 
                   Invoice_Code_Suffix   
            FROM Tbl_Inventory_Invoice_Code 
            WHERE Invoice_Code_Id = @Invoice_Code_Id
        END
    ')
END
