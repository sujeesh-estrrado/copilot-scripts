IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_Purchase_SelectById]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Inventory_Purchase_SelectById]              
        @Inventory_Purchase_Id bigint              
        AS              
        BEGIN              
            SELECT     
                dbo.Tbl_Inventory_Purchase.Inventory_Purchase_Id, 
                dbo.Tbl_Inventory_Purchase.Ventor_Id,    
                dbo.Tbl_Inventory_Purchase.Inventory_Purchase_CreatedDate, 
                dbo.Tbl_Inventory_Purchase.Inventory_Purchase_LastUpdatedDate,    
                dbo.Tbl_Inventory_Purchase.Inventory_Purchase_DelStatus,   
                dbo.Tbl_Inventory_Purchase.Orginal_Amount,
                dbo.Tbl_Inventory_Purchase.Deduction,  
                dbo.Tbl_Inventory_Purchase.Final_Amount, 
                dbo.Tbl_Inventory_Purchase.Extra_Charge,  
                dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Prefix + 
                dbo.Tbl_Inventory_Purchase.Inventory_Purchase_Code + 
                dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Suffix AS Inventory_Purchase_Code, 
                dbo.Tbl_Inventory_Purchase.Inventory_Purchase_Code as P_Code,     
                Tbl_Inventory_Purchase.BillNo,
                Tbl_Inventory_Purchase.StoreID,
                Tbl_Inventory_Purchase.AuthorisedPerson,    
                dbo.Tbl_Store.Store_Name,
                Tbl_Inventory_Purchase.Store_Category    
            FROM   
                dbo.Tbl_Inventory_Purchase 
            INNER JOIN  
                dbo.Tbl_Inventory_Invoice_Code 
                ON dbo.Tbl_Inventory_Purchase.Invoice_Code_ID = dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Id     
            INNER JOIN 
                dbo.Tbl_Store 
                ON Tbl_Inventory_Purchase.StoreID = dbo.Tbl_Store.Store_Id    
            WHERE 
                Inventory_Purchase_Id = @Inventory_Purchase_Id              
        END
    ')
END
