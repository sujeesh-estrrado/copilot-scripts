IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_Purchase_GetLatestInvoiceNo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Inventory_Purchase_GetLatestInvoiceNo]               
        AS               
        BEGIN              

            DECLARE @InventoryPurchaseCode bigint,              
                    @InvoiceCodeStartNo varchar(100), 
                    @Invoice_Code_Id bigint,             
                    @code varchar(100)              

            SET @InventoryPurchaseCode = (    
                -- Select TOP 1 Inventory_Purchase_Code FROM Tbl_Inventory_Purchase ORDER BY Inventory_Purchase_Id DESC    
                SELECT MAX(CAST(Inventory_Purchase_Code AS INT)) AS Inventory_Purchase_Code        
                FROM Tbl_Inventory_Purchase     
            )              

            SET @InvoiceCodeStartNo = (
                SELECT Invoice_Code_StartNo 
                FROM Tbl_Inventory_Invoice_Code               
                WHERE Invoice_Code_Name = ''Purchase'' 
                AND Invoice_Code_Current_Status = 1 
                AND GETDATE() BETWEEN Invoice_Code_From_Date AND Invoice_Code_To_Date 
                AND Invoice_Code_Del_Status = 0
            )               

            SET @code = ISNULL(@InventoryPurchaseCode + 1, @InvoiceCodeStartNo)              

            SET @Invoice_Code_Id = (
                SELECT Invoice_Code_Id 
                FROM Tbl_Inventory_Invoice_Code 
                WHERE Invoice_Code_Name = ''Purchase'' 
                AND Invoice_Code_Current_Status = 1 
                AND GETDATE() BETWEEN Invoice_Code_From_Date AND Invoice_Code_To_Date 
                AND Invoice_Code_Del_Status = 0
            )              

            SELECT  Invoice_Code_Prefix + @code + Invoice_Code_Suffix AS Invoice_Code, 
                    @code AS normalcode            
            FROM Tbl_Inventory_Invoice_Code 
            WHERE Invoice_Code_Id = @Invoice_Code_Id             

        END
    ')
END
