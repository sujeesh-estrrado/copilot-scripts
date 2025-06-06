IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Purchase_Return_SelectAll]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Purchase_Return_SelectAll]
            @Product_Id bigint
        AS
        BEGIN
            SELECT
                dbo.Tbl_Products.Product_Name,   
                dbo.Tbl_Purchase_Return_Products.Return_Product_Quantity,  
                dbo.Tbl_Purchase_Return_Products.Return_Product_TotalPrice,   
                dbo.Tbl_Purchase_Return.Inventory_Purchase_Code,  
                dbo.Tbl_Purchase_Return_Products.Product_Id, 
                dbo.Tbl_Purchase_Return.Purchase_return_Id,  
                dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Prefix +   
                    CAST(dbo.Tbl_Purchase_Return.Purchase_Return_Code AS varchar) +   
                    dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Suffix AS Purchase_Return_Code,
                Inventory_Purchase_Id
            FROM
                dbo.Tbl_Purchase_Return 
                INNER JOIN dbo.Tbl_Purchase_Return_Products 
                    ON dbo.Tbl_Purchase_Return.Purchase_return_Id = dbo.Tbl_Purchase_Return_Products.Purchase_return_Id
                INNER JOIN dbo.Tbl_Products 
                    ON dbo.Tbl_Purchase_Return_Products.Product_Id = dbo.Tbl_Products.Product_Id
                INNER JOIN dbo.Tbl_Inventory_Invoice_Code 
                    ON dbo.Tbl_Purchase_Return.Invoice_Code_Id = dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Id
            WHERE
                (dbo.Tbl_Purchase_Return_Products.Product_Id = @Product_Id)
                AND (dbo.Tbl_Purchase_Return.Purchase_Return_DelStatus = 0)
        END;
    ');
END;
