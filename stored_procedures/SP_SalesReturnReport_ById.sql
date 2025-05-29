IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_SalesReturnReport_ById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_SalesReturnReport_ById]        
 @Sales_Return_Id bigint        
AS        
BEGIN        
SELECT [Sales_Return_Prod_Id]                
      ,RP.[Inventory_Sales_Product_Id]                
      ,RP.[Sales_Return_Id]              
      ,I.Invoice_Code_Prefix+R.Sales_Return_Code+I.Invoice_Code_Suffix as [Sales_Return_Code]          
      ,[Sales_Prod_Rturn_Quantity]         
      ,RP.[Units_id]               
      ,[Sales_Prod_Return_price]                
      ,[Sales_Prod_Return_TotalPrice]                
      ,[Sales_Prod_Return_Del_Status]             
      ,[Sales_Return_Comment]               
      ,[Product_Name]           
      ,P.[Product_Id]    
      ,[Sales_Return_CreatedDate]    
   ,[Units_Name]    
,[dbo].[GetInvoiceCodeById_Code](s.Invoice_Code_Id,Inventory_Invoice_code) As SalesCode     
  FROM Tbl_Sales_Return_Products RP            
left JOIN Tbl_Sales_Return  R ON RP.Sales_Return_Id=R.Sales_Return_Id            
left JOIN Tbl_Inventory_Sales_Products SP ON RP.Inventory_Sales_Product_Id=SP.Inventory_Sales_Product_Id            
left JOIN Tbl_Products P ON P.Product_Id=SP.Product_Id            
left Join Tbl_Inventory_Invoice_Code I on R.Invoice_Code_Id=I.Invoice_Code_Id       
left Join Tbl_Product_Units U On RP.Units_id=U.Units_id        
left JOIN  Tbl_Inventory_Sales S on S.Inventory_Sales_Id=sp.Inventory_Sales_Id                       
WHERE RP.Sales_Return_Id=@Sales_Return_Id                
END
');
END;