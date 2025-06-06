IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Sales_Return_SelectById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Sales_Return_SelectById]  
            @Sales_Return_Id bigint  
        AS  
        BEGIN  
            SELECT 
                [Sales_Return_Id],
                [Inventory_Sales_Id],
                s.[Invoice_Code_Id],
                i.Invoice_Code_Prefix + s.Sales_Return_Code + i.Invoice_Code_Suffix AS [Sales_Return_Code],
                [Sales_Return_CreatedDate],
                [Sales_Return_LastUpdatedDate],
                [Sales_Return_Comment],
                [Sales_Return_Del_Status]
            FROM [Tbl_Sales_Return] s
            INNER JOIN Tbl_Inventory_Invoice_Code i ON s.Invoice_Code_Id = i.Invoice_Code_Id
            WHERE Sales_Return_Id = @Sales_Return_Id  
        END
    ')
END;
