IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[FN_SP_Tbl_Income_Head_GetLatestInvoiceNo1]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[FN_SP_Tbl_Income_Head_GetLatestInvoiceNo1]
        AS
        BEGIN

            DECLARE @InvoiceCodeStartNo varchar(100), @code varchar(100), @Invoice_Code_Id bigint

            -- Retrieve the latest Inventory Invoice Code
            SET @Code = (
                SELECT TOP 1 Inventory_Invoice_code 
                FROM FN_Tbl_Income_Head1 
                ORDER BY Income_Id DESC
            )

            -- Get the starting Invoice Code number based on the current status and date range
            SET @InvoiceCodeStartNo = (
                SELECT Invoice_Code_StartNo 
                FROM Tbl_Inventory_Invoice_Code 
                WHERE Invoice_Code_Name = ''Income'' 
                  AND Invoice_Code_Current_Status = 1 
                  AND GETDATE() BETWEEN Invoice_Code_From_Date AND Invoice_Code_To_Date 
                  AND Invoice_Code_Del_Status = 0
            )

            -- Set the code, if NULL, use the start number
            SET @code = ISNULL(@Code + 1, @InvoiceCodeStartNo)

            -- Get the Invoice Code ID based on current status and date range
            SET @Invoice_Code_Id = (
                SELECT Invoice_Code_Id 
                FROM Tbl_Inventory_Invoice_Code 
                WHERE Invoice_Code_Name = ''Income'' 
                  AND Invoice_Code_Current_Status = 1 
                  AND GETDATE() BETWEEN Invoice_Code_From_Date AND Invoice_Code_To_Date 
                  AND Invoice_Code_Del_Status = 0
            )

            -- Construct and return the final invoice code
            SELECT Invoice_Code_Prefix + @code + Invoice_Code_Suffix AS Invoice_Code 
            FROM Tbl_Inventory_Invoice_Code 
            WHERE Invoice_Code_Id = @Invoice_Code_Id

        END
    ')
END
