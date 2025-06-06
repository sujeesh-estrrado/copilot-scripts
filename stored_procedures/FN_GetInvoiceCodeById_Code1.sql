IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[FN_SP_Tbl_Expense_Head_Select_ByID1]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[FN_SP_Tbl_Expense_Head_Select_ByID1]     
        @Expense_Id BIGINT    
    AS    
    BEGIN    
        SELECT   
            (SELECT dbo.FN_GetInvoiceCodeById_Code1(Invoice_Code_Id, Inventory_Invoice_code)) AS Inventory_Invoice_code,    
            Expense_Id, Acc_Cat_Id, Expense_Title, Expense_Description,    
            Expense_Amount, Expense_Date    
        FROM dbo.FN_Tbl_Expense_Head1    
        WHERE Expense_Id = @Expense_Id    
    END
    ')
END
