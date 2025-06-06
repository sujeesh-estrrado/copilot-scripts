IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Sales_Return_Products_SelectBySalesId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Sales_Return_Products_SelectBySalesId]        
        @Inventory_Sales_Id bigint      
        AS        
        BEGIN        
            SELECT [Sales_Return_Prod_Id]      
                ,rp.[Inventory_Sales_Product_Id]    
                ,p.[Product_Id]        
                ,p.[Product_Name] 
                ,rp.[Units_id],
                 Units_Name    
                ,rp.[Sales_Return_Id]      
                ,s.[Inventory_Sales_Id]      
                ,i.Invoice_Code_Prefix + s.Sales_Return_Code + i.Invoice_Code_Suffix as [Sales_Return_Code]      
                ,[Sales_Prod_Rturn_Quantity]        
                ,[Sales_Prod_Return_price]        
                ,[Sales_Prod_Return_TotalPrice]        
                ,[Sales_Prod_Return_Del_Status]        
            FROM [Tbl_Sales_Return_Products] rp       
            INNER JOIN Tbl_Sales_Return s ON rp.Sales_Return_Id = s.Sales_Return_Id    
            INNER JOIN Tbl_Inventory_Sales_Products sp ON rp.Inventory_Sales_Product_Id = sp.Inventory_Sales_Product_Id    
            INNER JOIN Tbl_Products p ON sp.Product_Id = p.Product_Id      
            INNER JOIN Tbl_Inventory_Invoice_Code i ON s.Invoice_Code_Id = i.Invoice_Code_Id 
            INNER JOIN Tbl_Product_Units u ON u.Units_id = rp.Units_id
            WHERE Sales_Prod_Return_Del_Status = 0  
            AND s.Inventory_Sales_Id = @Inventory_Sales_Id      
        END
    ')
END
