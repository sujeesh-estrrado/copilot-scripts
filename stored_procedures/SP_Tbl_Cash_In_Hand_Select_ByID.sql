IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Cash_In_Hand_Select_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[SP_Tbl_Cash_In_Hand_Select_ByID]           
 @Cash_Id bigint          
AS          
BEGIN          
SELECT          
(Select dbo.GetInvoiceCodeById_Code(Cash_Invoice_Code_Id,Cash_Invoice_Code)) As Inventory_Invoice_code,              
Cash_Id,Cash_Title,Cash_Description,Cash_Amount,Cash_Date          
   
  FROM Tbl_Cash_In_Hand CH    
WHERE Cash_Id=@Cash_Id         
END
    ')
END;
