
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetInvoiceCodeByType]') 
      AND type IN (N'FN', N'IF', N'TF') -- FN = Scalar, IF = Inline table, TF = Multi-statement table
)
BEGIN
    EXEC('
CREATE FUNCTION [dbo].[GetInvoiceCodeByType]   
(  
 @Invoice_Code_Type varchar(100)  
)  
RETURNS @returnTable TABLE (Invoice_Code_Id bigint,  
      code bigint,  
                      Invoice_Code varchar(1000))  
AS  
BEGIN  
DECLARE @InvoiceCode varchar(100),@InvoiceCodeStartNo varchar(100),@code varchar(100),@Invoice_Code_Id bigint,@code_id bigint  
set @Invoice_Code_Id=(Select Invoice_Code_Id From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=@Invoice_Code_Type and Invoice_Code_Current_Status=1 and getdate() between Invoice_Code_From_Date and Invoice_Code_To_Date and Invoice_Code_Del_Status=0) 
            
If(@Invoice_Code_Type=''Sales'')  
 Begin  
  set @code_id=(Select top 1 Invoice_Code_Id From Tbl_Inventory_Sales Order By Inventory_Sales_Id DESC)  
 End  
Else If(@Invoice_Code_Type=''Purchase'')  
 Begin  
  set @code_id=(Select top 1 Invoice_Code_Id From Tbl_Inventory_Purchase Order By Inventory_Purchase_Id DESC)  
 End  
Else If(@Invoice_Code_Type=''Sales Return'')  
 Begin  
  set @code_id=(Select top 1 Invoice_Code_Id From Tbl_Sales_Return Order By Sales_Return_Id DESC)  
 End  
Else If(@Invoice_Code_Type=''Purchase Return'')  
 Begin  
  set @code_id=(Select top 1 Invoice_Code_Id From Tbl_Purchase_Return Order By Purchase_return_Id DESC)  
 End  
Else If(@Invoice_Code_Type=''Income'')  
 Begin  
  set @code_id=(Select top 1 Invoice_Code_Id From Tbl_Income_Head Order By Income_Id DESC)  
 End  
  
  
If(@Invoice_Code_Id=@code_id)  
 Begin  
  
If(@Invoice_Code_Type=''Sales'')  
 Begin  
   set @code=(Select top 1 Inventory_Invoice_code+1 From Tbl_Inventory_Sales Order By Inventory_Sales_Id DESC)   
 End  
Else If(@Invoice_Code_Type=''Purchase'')  
 Begin  
  set @code=(Select top 1 Inventory_Purchase_Code+1 From Tbl_Inventory_Purchase Order By Inventory_Purchase_Id DESC)  
 End  
Else If(@Invoice_Code_Type=''Sales Return'')  
 Begin  
  set @code=(Select top 1 Sales_Return_Code+1 From Tbl_Sales_Return Order By Sales_Return_Id DESC)  
 End  
Else If(@Invoice_Code_Type=''Purchase Return'')  
 Begin  
  set @code=(Select top 1 Purchase_Return_Code+1 From Tbl_Purchase_Return Order By Purchase_return_Id DESC)  
 End  
   
Else If(@Invoice_Code_Type=''Income'')  
 Begin  
  set @code=(Select top 1 Inventory_Invoice_code+1 From Tbl_Income_Head Order By Income_Id DESC)  
 End  
 End  
  
Else  
 Begin  
 set @code=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=@Invoice_Code_Type and Invoice_Code_Current_Status=1 and getdate() between Invoice_Code_From_Date and Invoice_Code_To_Date and Invoice_Code_Del_Status=0)      
 End  
--set @InvoiceCodeStartNo=(Select Invoice_Code_StartNo From Tbl_Inventory_Invoice_Code WHERE Invoice_Code_Name=@Invoice_Code_Type and Invoice_Code_Current_Status=1 and getdate() between Invoice_Code_From_Date and Invoice_Code_To_Date and Invoice_Code_Del_Status=0)      
               
--set @code=ISNULL(@InvoiceCode+1,@InvoiceCodeStartNo)      
  
 INSERT INTO @returnTable  
SELECT    
Invoice_Code_Id AS Invoice_Code_Id,  
@code As Code,  
Invoice_Code_Prefix+@code+Invoice_Code_Suffix AS Invoice_Code       
FROM Tbl_Inventory_Invoice_Code  
Where Invoice_Code_Id=@Invoice_Code_Id   
RETURN   
  
END
    ')
END
