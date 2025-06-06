IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Inventory_Sales]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_All_Inventory_Sales]
        AS
        BEGIN
            SELECT 
                a.*, 
                b.*,  
                CASE 
                    WHEN a.empStud = ''Employee'' THEN 
                        (SELECT Employee_FName + '' '' + Employee_LName 
                         FROM dbo.Tbl_Employee 
                         WHERE Employee_Id = a.Inventory_Customer_Id)  
                    WHEN a.empStud = ''Student'' THEN 
                        (SELECT Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname 
                         FROM dbo.Tbl_Candidate_Personal_Det 
                         WHERE Candidate_Id = a.Inventory_Customer_Id)  
                    WHEN a.empStud = ''Cash'' THEN 
                        ''Cash'' 
                    ELSE a.empStud 
                END AS CustomerName,  
                IC.Invoice_Code_Prefix + a.Inventory_Invoice_Code + IC.Invoice_Code_Suffix AS Inventory_Sales_Code,
                P.Product_Name  
            FROM 
                dbo.Tbl_Inventory_Sales a 
            LEFT JOIN dbo.Tbl_Inventory_Sales_Products b 
                ON a.Inventory_Sales_Id = b.Inventory_Sales_Id 
            LEFT JOIN dbo.Tbl_Inventory_Invoice_Code IC 
                ON a.Invoice_Code_Id = IC.Invoice_Code_Id 
            LEFT JOIN dbo.Tbl_Products P 
                ON P.Product_Id = b.Product_Id  
            WHERE 
                b.Inventory_Sales_Status = 0 
                AND a.Inventory_Del_Status = 0
        END
    ')
END
