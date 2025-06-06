IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Sales_Return_Products_SelectById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Sales_Return_Products_SelectById]  
            @Sales_Return_Id bigint  
        AS  
        BEGIN  
            SELECT 
                [Sales_Return_Prod_Id],
                RP.[Inventory_Sales_Product_Id],
                RP.[Sales_Return_Id],
                I.Invoice_Code_Prefix + R.Sales_Return_Code + I.Invoice_Code_Suffix AS [Sales_Return_Code],
                [Sales_Prod_Rturn_Quantity],
                RP.[Units_id],
                [Sales_Prod_Return_price],
                [Sales_Prod_Return_TotalPrice],
                [Sales_Prod_Return_Del_Status],
                [Sales_Return_Comment],
                [Product_Name],
                P.[Product_Id],
                RP.Sales_Prod_IsDamage,
                R.Inventory_Sales_Id,  
                [dbo].[GetInvoiceCodeById_Code](s.Invoice_Code_Id, Inventory_Invoice_code) AS SalesCode
            FROM Tbl_Sales_Return_Products RP
            INNER JOIN Tbl_Sales_Return R ON RP.Sales_Return_Id = R.Sales_Return_Id
            INNER JOIN Tbl_Inventory_Sales_Products SP ON RP.Inventory_Sales_Product_Id = SP.Inventory_Sales_Product_Id
            INNER JOIN Tbl_Products P ON P.Product_Id = SP.Product_Id
            INNER JOIN Tbl_Inventory_Invoice_Code I ON R.Invoice_Code_Id = I.Invoice_Code_Id
            INNER JOIN Tbl_Inventory_Sales S ON S.Inventory_Sales_Id = SP.Inventory_Sales_Id
            WHERE RP.Sales_Return_Id = @Sales_Return_Id  
        END
    ')
END;
