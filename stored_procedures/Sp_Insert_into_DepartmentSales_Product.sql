IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_into_DepartmentSales_Product]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_into_DepartmentSales_Product]    
(    
@DeptSales_Id bigint,    
@Product_Id bigint,    
@SalesQty decimal(18,2),     
@UnitPrice Decimal(18,2),    
@TotalPrice Decimal(18,2)    
)    
As    
Begin    
  
Insert into Tbl_DepartmentStoreProducts    
(    
DeptSales_Id,    
Product_Id,    
Sales_Quantity,    
Unit_price,    
Total_Price    
)    
values    
(    
@DeptSales_Id,    
@Product_Id,    
@SalesQty,     
@UnitPrice,    
@TotalPrice    
)    
End');
END;
