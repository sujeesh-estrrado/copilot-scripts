IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[FN_SP_Tbl_Expense_Head_GetLatestInvoiceNo1]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[FN_SP_Tbl_Expense_Head_GetLatestInvoiceNo1]                
    AS               
    BEGIN              
        DECLARE @InvoiceCodeStartNo VARCHAR(100),
                @code VARCHAR(100),
                @Invoice_Code_Id BIGINT;

        SET @code = (SELECT TOP 1 Inventory_Invoice_code 
                     FROM FN_Tbl_Expense_Head1 
                     ORDER BY Expense_Id DESC);                    

        SET @InvoiceCodeStartNo = (SELECT Invoice_Code_StartNo 
                                   FROM Tbl_Inventory_Invoice_Code 
                                   WHERE Invoice_Code_Name = ''Expense'' 
                                   AND Invoice_Code_Current_Status = 1 
                                   AND GETDATE() BETWEEN Invoice_Code_From_Date AND Invoice_Code_To_Date 
                                   AND Invoice_Code_Del_Status = 0);  

        SET @code = ISNULL(@code + 1, @InvoiceCodeStartNo);                    

        SET @Invoice_Code_Id = (SELECT Invoice_Code_Id 
                                FROM Tbl_Inventory_Invoice_Code 
                                WHERE Invoice_Code_Name = ''Expense'' 
                                AND Invoice_Code_Current_Status = 1 
                                AND GETDATE() BETWEEN Invoice_Code_From_Date AND Invoice_Code_To_Date 
                                AND Invoice_Code_Del_Status = 0);          

        SELECT Invoice_Code_Prefix + @code + Invoice_Code_Suffix AS Invoice_Code         
        FROM Tbl_Inventory_Invoice_Code 
        WHERE Invoice_Code_Id = @Invoice_Code_Id;        
    END
    ')
END
ELSE
BEGIN
EXEC('
              
ALTER procedure [dbo].[FN_SP_Tbl_Expense_Head_GetLatestInvoiceNo1]                
              
AS               
begin              
              
DECLARE @InvoiceCodeStartNo varchar(100),@code varchar(100),@Invoice_Code_Id bigint                
set @Code=(Select top 1 Inventory_Invoice_code From FN_Tbl_Expense_Head1 Order By Expense_Id DESC)                    
set @InvoiceCodeStartNo=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Expense'' and Invoice_Code_Current_Status=1 and getdate() between Invoice_Code_From_Date and Invoice_Code_To_Date and Invoice_Code_Del_Status=0)  
                   
set @code=ISNULL(@Code+1,@InvoiceCodeStartNo)                    
set @Invoice_Code_Id=(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Expense'' and Invoice_Code_Current_Status=1 and getdate() between Invoice_Code_From_Date and Invoice_Code_To_Date and Invoice_Code_Del_Status=0)          
     
SELECT  Invoice_Code_Prefix+@code+Invoice_Code_Suffix AS Invoice_Code         
FROM Tbl_Inventory_Invoice_Code Where Invoice_Code_Id=@Invoice_Code_Id        
end



')
END
