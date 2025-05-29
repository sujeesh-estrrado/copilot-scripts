IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Inventory_Sales]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_Inventory_Sales]                  
        AS                  
        BEGIN                  
                  
        SELECT                 
            s.Inventory_Sales_Id,                
            s.Inventory_Customer_Id,             
            s.Invoice_Code_Id,             
            i.Invoice_Code_Prefix + s.Inventory_Invoice_code + i.Invoice_Code_Suffix AS Inventory_Invoice_code,            
            s.Inventory_Sales_Quote_DtTime,                
            s.Inventory_Sales_Order_DtTime,                
            s.Inventory_Sales_Status,     
            
            ISNULL(sr.Sales_Return_Id, 0) AS Sales_Return_Id,   
            ISNULL((  
                SELECT SUM(Inventory_Sales_SubTotal)  
                FROM Tbl_Inventory_Sales_Products    
                WHERE Inventory_Sales_Id = s.Inventory_Sales_Id  
                GROUP BY Inventory_Sales_Id  
            ), 0) AS Inventory_Sales_SubTotal,    
            
            customer_name =          
            CASE s.empStud 
                WHEN ''Employee'' THEN  
                    (SELECT Employee_FName + '' '' + Employee_LName AS customer_name 
                     FROM dbo.Tbl_Employee 
                     WHERE Employee_Id = s.Inventory_Customer_Id)          
                WHEN ''Student'' THEN  
                    (SELECT Candidate_Fname + '' '' + ISNULL(Candidate_Mname, '''') + '' '' + Candidate_Lname AS customer_name 
                     FROM dbo.Tbl_Candidate_Personal_Det 
                     WHERE Candidate_Id = s.Inventory_Customer_Id)          
                WHEN ''Cash'' THEN 
                    ''Cash'' 
                ELSE 
                    s.empStud 
            END,          
            
            s.empStud 
        FROM                  
            [Tbl_Inventory_Sales] s        
        INNER JOIN Tbl_Inventory_Invoice_Code i ON s.Invoice_Code_Id = i.Invoice_Code_Id            
        LEFT JOIN Tbl_Sales_Return sr ON sr.Inventory_Sales_Id = s.Inventory_Sales_Id       
        WHERE Inventory_Del_Status = 0                   
        END
    ')
END
