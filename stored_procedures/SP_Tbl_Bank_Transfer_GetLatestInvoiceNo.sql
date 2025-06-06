IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Bank_Transfer_GetLatestInvoiceNo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Tbl_Bank_Transfer_GetLatestInvoiceNo]                      
                    
AS                     
begin                    
                    
DECLARE @InvoiceCodeStartNo varchar(100),@code varchar(100),@Invoice_Code_Id bigint                      
set @Code=(Select top 1 Bank_Invoice_Code From Tbl_Bank_Transfer  Order By Bank_Id DESC)                          
set @InvoiceCodeStartNo=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Bank Transfer'' and Invoice_Code_Current_Status=1 and getdate() between Invoice_Code_From_Date and Invoice_Code_To_Date and Invoice_Code_Del_Status=0)  
   
      
                        
set @code=ISNULL(@Code+1,@InvoiceCodeStartNo)                          
set @Invoice_Code_Id=(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Bank Transfer'' and Invoice_Code_Current_Status=1 and getdate() between Invoice_Code_From_Date and Invoice_Code_To_Date and Invoice_Code_Del_Status=0)          
   
      
          
SELECT  Invoice_Code_Prefix+@code+Invoice_Code_Suffix AS Invoice_Code               
FROM Tbl_Inventory_Invoice_Code Where Invoice_Code_Id=@Invoice_Code_Id              
end
    ')
END
