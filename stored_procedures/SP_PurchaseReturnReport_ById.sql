IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_PurchaseReturnReport_ById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_PurchaseReturnReport_ById]      
 @Purchase_Return_Id bigint      
AS      
BEGIN      
SELECT [Return_Product_Id]              
      ,RP.[Product_Id]              
      ,RP.[Purchase_Return_Id]            
      ,I.Invoice_Code_Prefix+Cast(R.Purchase_Return_Code as varchar(100))+I.Invoice_Code_Suffix as [Purchase_Return_Code]        
      ,[Return_Product_Quantity]       
      ,RP.[UnitID]             
      ,[Return_Product_Price]              
      ,[Return_Product_TotalPrice]              
      ,[Purchase_Return_Comment]             
      ,[Product_Name]         
      ,P.[Product_Id]  
      ,[Purchase_Return_CreatedDate]  
   ,[Units_Name]  
  FROM Tbl_Purchase_Return_Products RP          
INNER JOIN Tbl_Purchase_Return  R ON RP.Purchase_Return_Id=R.Purchase_Return_Id          
INNER JOIN Tbl_Inventory_Purchase_Products SP ON RP.Product_Id=SP.Product_Id          
INNER JOIN Tbl_Products P ON P.Product_Id=SP.Product_Id          
Inner Join Tbl_Inventory_Invoice_Code I on R.Invoice_Code_Id=I.Invoice_Code_Id     
Inner Join Tbl_Product_Units U On RP.UnitID=U.Units_id                   
WHERE RP.Purchase_Return_Id=@Purchase_Return_Id              
END
');
END;