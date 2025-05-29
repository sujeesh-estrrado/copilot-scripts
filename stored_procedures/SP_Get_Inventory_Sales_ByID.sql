IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Inventory_Sales_ByID]')
    AND type = N'P'
)
BEGIN
    EXEC('
    create procedure [dbo].[SP_Get_Inventory_Sales_ByID](@Inventory_Sales_Id BIGINT)          
          
AS          
          
BEGIN          
          
Select         
s.Inventory_Sales_Id,        
s.Inventory_Customer_Id,        

s.Invoice_Code_Id,     
i. Invoice_Code_Prefix+s.Inventory_Invoice_code+i.Invoice_Code_Suffix as Inventory_Invoice_code,    
s.Inventory_Sales_Quote_DtTime,        
s.Inventory_Sales_Order_DtTime,        
s.Inventory_Sales_Status  ,  
s.empStud      
from          
[Tbl_Inventory_Sales]  s        
      
Inner Join Tbl_Inventory_Invoice_Code i on s.Invoice_Code_Id=i.Invoice_Code_Id     
WHERE  Inventory_Sales_Id  = @Inventory_Sales_Id AND Inventory_Del_Status=0          
          
            
          
END



    ')
END
