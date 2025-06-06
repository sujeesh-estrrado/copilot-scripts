IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[FN_SP_Tbl_Income_Head_GetLatestInvoiceNo1]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[FN_SP_Tbl_Income_Head_GetLatestInvoiceNo1]                
              
AS               
begin              
              
DECLARE @InvoiceCodeStartNo varchar(100),@code varchar(100),@Invoice_Code_Id bigint                
set @Code=(Select top 1 Inventory_Invoice_code From FN_Tbl_Income_Head1  Order By Income_Id DESC)                    
set @InvoiceCodeStartNo=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Income'' and Invoice_Code_Current_Status=1 and getdate() between Invoice_Code_From_Date and Invoice_Code_To_Date and Invoice_Code_Del_Status=0)   
                  
set @code=ISNULL(@Code+1,@InvoiceCodeStartNo)                    
set @Invoice_Code_Id=(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Income'' and Invoice_Code_Current_Status=1 and getdate() between Invoice_Code_From_Date and Invoice_Code_To_Date and Invoice_Code_Del_Status=0)           
    
SELECT  Invoice_Code_Prefix+@code+Invoice_Code_Suffix AS Invoice_Code         
FROM Tbl_Inventory_Invoice_Code Where Invoice_Code_Id=@Invoice_Code_Id        
end
    ')
END
ELSE
BEGIN
EXEC('
             
ALTER procedure [dbo].[FN_SP_Tbl_Income_Head_GetLatestInvoiceNo1]                
              
AS               
begin              
              
DECLARE @InvoiceCodeStartNo varchar(100),@code varchar(100),@Invoice_Code_Id bigint                
set @Code=(Select top 1 Inventory_Invoice_code From FN_Tbl_Income_Head1  Order By Income_Id DESC)                    
set @InvoiceCodeStartNo=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Income'' and Invoice_Code_Current_Status=1 and getdate() between Invoice_Code_From_Date and Invoice_Code_To_Date and Invoice_Code_Del_Status=0)   
                  
set @code=ISNULL(@Code+1,@InvoiceCodeStartNo)                    
set @Invoice_Code_Id=(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=''Income'' and Invoice_Code_Current_Status=1 and getdate() between Invoice_Code_From_Date and Invoice_Code_To_Date and Invoice_Code_Del_Status=0)           
    
SELECT  Invoice_Code_Prefix+@code+Invoice_Code_Suffix AS Invoice_Code         
FROM Tbl_Inventory_Invoice_Code Where Invoice_Code_Id=@Invoice_Code_Id        
end



')
END
