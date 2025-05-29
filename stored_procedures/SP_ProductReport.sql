IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_ProductReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_ProductReport]      
@Product_ID BIGINT,                  
@FromDate DATETIME = NULL,                       
@ToDate DATETIME = NULL    
AS          
BEGIN     
    -- First query for Product Stocks
    SELECT            
        PS.Product_Id,          
        P.Product_Name,          
        U.Units_Name,   
        InvoiceCode,  
        ISNULL(Store_Name,''General Store'') AS StoreName,  
        CONVERT(VARCHAR(10), Product_Stock_DtTime, 101) AS Date,         
        CASE 
            WHEN Product_Stock_IsDamaged = 1 THEN ''DAMAGED'' 
            ELSE Product_Stock_Type 
        END AS [STOCK TYPE],          
        Product_Current_Stock AS Quantity,          
        Product_Stock_Total_Price AS TotalPrice          
    FROM Tbl_Product_Stocks PS          
    INNER JOIN Tbl_Products P ON PS.Product_Id = P.Product_Id                      
    INNER JOIN Tbl_Product_Units U ON P.Product_Units = U.Units_id  
    LEFT JOIN Tbl_Inventory_Purchase IP ON InvoiceCode = (SELECT dbo.GetInvoiceCodeById_Code(IP.Invoice_Code_ID, IP.Inventory_Purchase_Code))        
    LEFT JOIN Tbl_Store S ON IP.StoreID = S.Store_Id   
    WHERE          
        CONVERT(VARCHAR(10), Product_Stock_DtTime, 101) BETWEEN                 
        ISNULL(@FromDate, (SELECT MIN(CONVERT(VARCHAR(10), Product_Stock_DtTime, 101)) FROM Tbl_Product_Stocks)) AND                
        ISNULL(@ToDate, (SELECT MAX(CONVERT(VARCHAR(10), Product_Stock_DtTime, 101)) FROM Tbl_Product_Stocks))           
        AND PS.Product_Id = @Product_ID 
        AND Product_Stock_DelStatus = 0   
    
    UNION  
    
    -- Second query for Asset Stocks
    SELECT            
        PS.Product_Id,          
        P.Product_Name,          
        U.Units_Name,   
        InvoiceCode,  
        Store_Name AS StoreName,    
        CONVERT(VARCHAR(10), Product_Stock_DtTime, 101) AS Date,         
        CASE 
            WHEN Product_Stock_IsDamaged = 1 THEN ''DAMAGED'' 
            ELSE Product_Stock_Type 
        END AS [STOCK TYPE],          
        Product_Current_Stock AS Quantity,          
        Product_Stock_Total_Price AS TotalPrice          
    FROM Tbl_Asset_Stocks PS          
    INNER JOIN Tbl_Products P ON PS.Product_Id = P.Product_Id                      
    INNER JOIN Tbl_Product_Units U ON P.Product_Units = U.Units_id     
    INNER JOIN Tbl_Inventory_Purchase IP ON InvoiceCode = (SELECT dbo.GetInvoiceCodeById_Code(IP.Invoice_Code_ID, IP.Inventory_Purchase_Code))        
    INNER JOIN Tbl_Store S ON IP.StoreID = S.Store_Id        
    WHERE           
        CONVERT(VARCHAR(10), Product_Stock_DtTime, 101) BETWEEN                 
        ISNULL(@FromDate, (SELECT MIN(CONVERT(VARCHAR(10), Product_Stock_DtTime, 101)) FROM Tbl_Product_Stocks)) AND                
        ISNULL(@ToDate, (SELECT MAX(CONVERT(VARCHAR(10), Product_Stock_DtTime, 101)) FROM Tbl_Product_Stocks))           
        AND PS.Product_Id = @Product_ID                
        AND Product_Stock_DelStatus = 0   
END
');
END;