IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DepartmentWise_Stock_List_ByProduct_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_DepartmentWise_Stock_List_ByProduct_Id]
        (@Department_Id bigint, @Product_Id bigint)        
        AS        
        BEGIN    
            SELECT 
                g.Product_Id,
                g.Department_Id,
                SUM(g.TQuantity) AS DepartmentStockWithoutSales,
                p.Product_Name,
                p.Prod_Cat_Id,
                ED.Dept_Name,  
                (  
                    SELECT Tbl_Product_Categories.Prod_Cat_Name   
                    FROM Tbl_Product_Categories   
                    WHERE Tbl_Product_Categories.Prod_Cat_Id = p.Prod_Cat_id   
                ) AS Category,  
              
                ISNULL((
                    SELECT ISNULL(SUM(S1.Sales_Quantity), 0)    
                    FROM Tbl_DepartmentStoreProducts S1    
                    LEFT JOIN dbo.Tbl_DepartmentSales S2 
                        ON S1.DeptSales_Id = S2.DeptSales_Id 
                        AND S2.Dept_Id = g.Department_Id    
                    WHERE S1.Product_Id = g.Product_Id 
                        AND S2.Dept_Id = g.Department_Id   
                    GROUP BY S1.Product_Id
                ), 0) AS SalesStock,  
              
                ISNULL((
                    SELECT SUM(R.RQuantity)  
                    FROM Tbl_Department_General_Return R  
                    WHERE R.Product_Id = g.Product_Id 
                        AND R.Department_Id = g.Department_Id   
                    GROUP BY R.Product_Id, R.Department_Id
                ), 0) AS ReturnedStock, 
                
                (SUM(g.TQuantity) -     
                    (   
                        ISNULL((
                            SELECT ISNULL(SUM(S1.Sales_Quantity), 0)        
                            FROM Tbl_DepartmentStoreProducts S1        
                            LEFT JOIN dbo.Tbl_DepartmentSales S2 
                                ON S1.DeptSales_Id = S2.DeptSales_Id 
                                AND S2.Dept_Id = g.Department_Id        
                            WHERE S1.Product_Id = g.Product_Id 
                                AND S2.Dept_Id = g.Department_Id       
                            GROUP BY S1.Product_Id
                        ), 0) +  
                      
                        ISNULL((
                            SELECT SUM(R.RQuantity)  
                            FROM Tbl_Department_General_Return R  
                            WHERE R.Product_Id = g.Product_Id 
                                AND R.Department_Id = g.Department_Id   
                            GROUP BY R.Product_Id, R.Department_Id
                        ), 0)  
                    )
                ) AS CurrentDepartmentStock     
            FROM dbo.Tbl_General_Department_Transfer g  
            LEFT JOIN Tbl_Products p 
                ON g.Product_Id = p.Product_Id      
            LEFT JOIN Tbl_Product_Categories 
                ON p.Prod_Cat_id = Tbl_Product_Categories.Prod_Cat_Id   
            LEFT JOIN Tbl_Emp_Department ED 
                ON g.Department_Id = ED.Dept_Id  
            WHERE g.Department_Id = @Department_Id  
                AND g.Product_Id = @Product_Id    
            GROUP BY 
                g.Product_Id,
                g.Department_Id,
                p.Product_Name,
                p.Prod_Cat_Id,
                ED.Dept_Name;
        END
    ')
END
