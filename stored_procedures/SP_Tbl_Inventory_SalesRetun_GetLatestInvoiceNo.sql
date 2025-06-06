IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_SalesRetun_GetLatestInvoiceNo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Inventory_SalesRetun_GetLatestInvoiceNo]              
        AS              
        BEGIN            
            DECLARE @SalesReturnCode varchar(100),
                    @InvoiceCodeStartNo varchar(100),
                    @code varchar(100),
                    @Invoice_Code_Id bigint
              
            SET @SalesReturnCode = (
                SELECT TOP 1 Sales_Return_Code 
                FROM Tbl_Sales_Return 
                ORDER BY Sales_Return_Id DESC
            )
              
            SET @InvoiceCodeStartNo = (
                SELECT Invoice_Code_StartNo 
                FROM Tbl_Inventory_Invoice_Code      
                WHERE Invoice_Code_Name = ''Sales Return'' 
                  AND Invoice_Code_Current_Status = 1 
                  AND GETDATE() BETWEEN Invoice_Code_From_Date AND Invoice_Code_To_Date 
                  AND Invoice_Code_Del_Status = 0
            )              
              
            SET @code = ISNULL(@SalesReturnCode + 1, @InvoiceCodeStartNo)           
              
            SET @Invoice_Code_Id = (
                SELECT Invoice_Code_Id 
                FROM Tbl_Inventory_Invoice_Code       
                WHERE Invoice_Code_Name = ''Sales Return'' 
                  AND Invoice_Code_Current_Status = 1 
                  AND GETDATE() BETWEEN Invoice_Code_From_Date AND Invoice_Code_To_Date 
                  AND Invoice_Code_Del_Status = 0
            )              
              
            SELECT Invoice_Code_Prefix + @code + Invoice_Code_Suffix AS Invoice_Code       
            FROM Tbl_Inventory_Invoice_Code 
            WHERE Invoice_Code_Id = @Invoice_Code_Id
        END
    ')
END
