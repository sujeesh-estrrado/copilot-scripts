IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_SalesReportBySalesID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_SalesReportBySalesID]  
@Inventory_Sales_Id bigint   
AS  
BEGIN  
Select         
s.Inventory_Sales_Id,        
s.Inventory_Customer_Id,        
s.Invoice_Code_Id,     
i. Invoice_Code_Prefix+s.Inventory_Invoice_code+i.Invoice_Code_Suffix as Inventory_Invoice_code,    
s.Inventory_Sales_Quote_DtTime,        
s.Inventory_Sales_Order_DtTime,        
s.Inventory_Sales_Status,  
sp.[Inventory_Sales_Product_Id]            
,sp.[Product_Id]            
,p.[Product_Name]          
,sp.[Quantity]
,sp.[Inventory_Sales_Tax_Amount]      
,sp.[Inventory_Sales_Discount]            
,sp.[Inventory_Sales_SubTotal],
customer_name=
case s.empStud when ''Employee'' then  (select Employee_FName+'' ''+Employee_LName as customer_name from dbo.Tbl_Employee where Employee_Id =s.Inventory_Customer_Id)
when ''Student'' then  (select Candidate_Fname+'' ''+Candidate_Mname+'' ''+Candidate_Lname as customer_name from dbo.Tbl_Candidate_Personal_Det where Candidate_Id=s.Inventory_Customer_Id)
else ''Not-Specified'' end
,s.empStud            
from          
[Tbl_Inventory_Sales]  s        
INNER JOIN Tbl_Inventory_Sales_Products sp ON sp.Inventory_Sales_Id=s.Inventory_Sales_Id    
   
Inner Join Tbl_Inventory_Invoice_Code i on s.Invoice_Code_Id=i.Invoice_Code_Id     
INNER JOIN Tbl_Products p ON sp.Product_Id=p.Product_Id  
WHERE  s.Inventory_Sales_Id = @Inventory_Sales_Id AND Inventory_Del_Status=0  and sp.Inventory_Sales_Status=0   
END

						 ');
END;
