IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Inventory_Purchase_SelectAllPurchaseOrderCOMPLETE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Tbl_Inventory_Purchase_SelectAllPurchaseOrderCOMPLETE]                    
        AS                    
        BEGIN                    
            SELECT     
                IP.Inventory_Purchase_Id, 
                IP.Ventor_Id, 
                v.Vender_Name, 
                IP.Inventory_Purchase_CreatedDate, 
                IP.Inventory_Purchase_LastUpdatedDate,                   
                IP.Inventory_Purchase_DelStatus, 
                IP.Invoice_Code_ID, 
                IP.Order_Status, 
                IP.Final_Amount,                   
                dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Prefix + 
                IP.Inventory_Purchase_Code + 
                dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Suffix AS Inventory_Purchase_Code,
                CASE IP.Store_Category               
                    WHEN 1 THEN ''ASSET''              
                    ELSE ''GENERAL''              
                END AS [Category], 
                ISNULL(pr.Purchase_return_Id, 0) AS Purchase_Return_Id         
            FROM         
                dbo.Tbl_Inventory_Purchase AS IP 
            INNER JOIN 
                dbo.Tbl_Venders AS v 
                ON IP.Ventor_Id = v.Vender_id 
            INNER JOIN 
                dbo.Tbl_Inventory_Invoice_Code 
                ON IP.Invoice_Code_ID = dbo.Tbl_Inventory_Invoice_Code.Invoice_Code_Id     
            LEFT JOIN  
                dbo.Tbl_Purchase_Return pr    
                ON pr.Inventory_Purchase_Id = IP.Inventory_Purchase_Id       
            WHERE     
                (IP.Inventory_Purchase_DelStatus = 0 
                AND IP.Order_Status = ''ORDER COMPLETE'')                    
        END
    ')
END
