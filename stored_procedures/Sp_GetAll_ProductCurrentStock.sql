IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetAll_ProductCurrentStock]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_GetAll_ProductCurrentStock]             
        AS              
        BEGIN              
              
            SELECT 
                P.Product_Name,
                P.Product_Id,
                P.Prod_Cat_Id,
                -- Purchase Stock          
                ISNULL(
                    (
                        SELECT SUM(Product_Current_Stock) 
                        FROM dbo.Tbl_Product_Stocks 
                        WHERE Product_Stock_Type = ''PURCHASE'' AND Tbl_Product_Stocks.Product_Id = P.Product_Id
                    ), 0
                ) AS Purchase_Stock,          
                
                -- Sales Stock          
                ISNULL(
                    (
                        SELECT SUM(Product_Current_Stock) 
                        FROM dbo.Tbl_Product_Stocks 
                        WHERE Product_Stock_Type = ''SALES'' AND Tbl_Product_Stocks.Product_Id = P.Product_Id
                    ), 0
                ) AS Sales_Stock,          
                
                -- Sales Return          
                ISNULL(
                    (
                        SELECT SUM(Product_Current_Stock) 
                        FROM dbo.Tbl_Product_Stocks 
                        WHERE Product_Stock_Type = ''SALES RETURN'' AND Tbl_Product_Stocks.Product_Id = P.Product_Id
                    ), 0
                ) AS Sales_Return,          
                
                -- Purchase Return          
                ISNULL(
                    (
                        SELECT SUM(Product_Current_Stock) 
                        FROM dbo.Tbl_Product_Stocks 
                        WHERE Product_Stock_Type = ''PURCHASE RETURN'' AND Tbl_Product_Stocks.Product_Id = P.Product_Id
                    ), 0
                ) AS PurchaseReturn,          
                
                -- General Store Return From Dept        
                ISNULL(
                    (
                        SELECT SUM(RQuantity) 
                        FROM dbo.Tbl_Department_General_Return 
                        WHERE Tbl_Department_General_Return.Product_Id = P.Product_Id
                    ), 0
                ) AS GStoreReturn,        
                
                -- General Store to Department Transfer        
                ISNULL(
                    (
                        SELECT SUM(TQuantity) 
                        FROM dbo.Tbl_General_Department_Transfer 
                        WHERE Tbl_General_Department_Transfer.Product_Id = P.Product_Id
                    ), 0
                ) AS GStore_To_Dept,        
                
                -- General Store to Store        
                ISNULL(
                    (
                        SELECT SUM(TransferQuantity) 
                        FROM dbo.Tbl_GeneralStore_to_Store 
                        WHERE Tbl_GeneralStore_to_Store.Product_Id = P.Product_Id
                    ), 0
                ) AS GStore_To_Store,        
                
                -- Current Stock          
                ISNULL(
                    ISNULL(
                        (
                            SELECT SUM(Product_Current_Stock) 
                            FROM dbo.Tbl_Product_Stocks 
                            WHERE Product_Stock_Type = ''PURCHASE'' AND Tbl_Product_Stocks.Product_Id = P.Product_Id
                        ), 0
                    ) +          
                    ISNULL(
                        (
                            SELECT SUM(Product_Current_Stock) 
                            FROM dbo.Tbl_Product_Stocks 
                            WHERE Product_Stock_Type = ''SALES RETURN'' AND Tbl_Product_Stocks.Product_Id = P.Product_Id
                        ), 0
                    ) +        
                    ISNULL(
                        (
                            SELECT SUM(RQuantity) 
                            FROM dbo.Tbl_Department_General_Return 
                            WHERE Tbl_Department_General_Return.Product_Id = P.Product_Id
                        ), 0
                    )          
                    -           
                    ISNULL(
                        ISNULL(
                            (
                                SELECT SUM(Product_Current_Stock) 
                                FROM dbo.Tbl_Product_Stocks 
                                WHERE Product_Stock_Type = ''SALES'' AND Tbl_Product_Stocks.Product_Id = P.Product_Id
                            ), 0
                        ) +         
                        ISNULL(
                            (
                                SELECT SUM(TQuantity) 
                                FROM dbo.Tbl_General_Department_Transfer 
                                WHERE Tbl_General_Department_Transfer.Product_Id = P.Product_Id
                            ), 0
                        ) +        
                        ISNULL(
                            (
                                SELECT SUM(TransferQuantity) 
                                FROM dbo.Tbl_GeneralStore_to_Store 
                                WHERE Tbl_GeneralStore_to_Store.Product_Id = P.Product_Id
                            ), 0
                        ) +         
                        ISNULL(
                            (
                                SELECT SUM(Product_Current_Stock) 
                                FROM dbo.Tbl_Product_Stocks 
                                WHERE Product_Stock_Type = ''PURCHASE RETURN'' AND Tbl_Product_Stocks.Product_Id = P.Product_Id
                            ), 0
                        ), 0
                    ), 0
                ) AS Current_Stock          
            FROM 
                dbo.Tbl_Products P 
            WHERE 
                P.Product_Del_Status = 0           
        END
    ')
END
