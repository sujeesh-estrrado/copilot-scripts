IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetCurrentStock_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[Sp_GetCurrentStock_By_Id] (@product_id bigint)      
As      
Begin      
      
      
select P.Product_Name,p.Product_Id,p.Prod_Cat_Id,    
--Purchase Stock    
isnull((    
    
select sum(Product_Current_Stock) from dbo.Tbl_Product_Stocks where Product_Stock_Type = ''PURCHASE'' and Tbl_Product_Stocks.Product_Id=P.Product_Id    
    
),0) as Purchase_Stock,    
--Sales Stock    
isnull((    
    
select sum(Product_Current_Stock) from dbo.Tbl_Product_Stocks where Product_Stock_Type = ''SALES'' and Tbl_Product_Stocks.Product_Id=P.Product_Id    
    
),0) as SALES_Stock,    
    
--Sales Return    
isnull((    
select sum(Product_Current_Stock) from dbo.Tbl_Product_Stocks where Product_Stock_Type=''SALES RETURN'' and Tbl_Product_Stocks.Product_Id=p.Product_Id    
),0)as Sales_Return,    
--Purchase Return    
isnull((    
select sum(Product_Current_Stock) from dbo.Tbl_Product_Stocks where Product_Stock_Type=''PURCHASE RETURN'' and Tbl_Product_Stocks.Product_Id=p.Product_Id    
),0)as PurchaseReturn,    
  
--General Store Return From Dept  
isnull((  
select sum(RQuantity) from dbo.Tbl_Department_General_Return where Tbl_Department_General_Return.Product_Id=p.Product_Id  
),0) as GStoreReturn,  
-- General Store to Department Transfer  
isnull((  
select sum(TQuantity) from dbo.Tbl_General_Department_Transfer where Tbl_General_Department_Transfer.Product_Id=p.Product_Id  
),0)as GStore_To_Dept,  
--General Store to Store  
isnull((  
select sum(TransferQuantity)from dbo.Tbl_GeneralStore_to_Store where Tbl_GeneralStore_to_Store.Product_Id=p.Product_Id  
),0)as GStore_To_Store,  
--Current Stock    
    
isnull(    
isnull(    
(    
select sum(Product_Current_Stock) from dbo.Tbl_Product_Stocks where Product_Stock_Type = ''PURCHASE'' and Tbl_Product_Stocks.Product_Id=P.Product_Id    
    
),0) +    
isnull(    
(    
select sum(Product_Current_Stock) from dbo.Tbl_Product_Stocks where Product_Stock_Type=''SALES RETURN'' and Tbl_Product_Stocks.Product_Id=p.Product_Id    
),0)    
,0)  +  
  
isnull((  
select sum(RQuantity) from dbo.Tbl_Department_General_Return where Tbl_Department_General_Return.Product_Id=p.Product_Id  
),0)   
   -     
    
isnull(    
isnull(    
(    
select sum(Product_Current_Stock) from dbo.Tbl_Product_Stocks where Product_Stock_Type = ''SALES'' and Tbl_Product_Stocks.Product_Id=P.Product_Id    
    
),0) +   
isnull((  
select sum(TQuantity) from dbo.Tbl_General_Department_Transfer where Tbl_General_Department_Transfer.Product_Id=p.Product_Id  
),0)+  
isnull((  
select sum(TransferQuantity)from dbo.Tbl_GeneralStore_to_Store where Tbl_GeneralStore_to_Store.Product_Id=p.Product_Id  
),0)+   
isnull(    
(    
select sum(Product_Current_Stock) from dbo.Tbl_Product_Stocks where Product_Stock_Type=''PURCHASE RETURN'' and Tbl_Product_Stocks.Product_Id=p.Product_Id    
),0)    
,0)    
  
  
    
as Current_Stock       
 from dbo.Tbl_Products p where p.Product_Id=@product_id;      
End');
END;
