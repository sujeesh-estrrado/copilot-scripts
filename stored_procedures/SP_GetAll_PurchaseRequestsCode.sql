IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_PurchaseRequestsCode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_PurchaseRequestsCode]    
        AS    
        BEGIN    
            SELECT *                    
            FROM                        
            (    
                SELECT                       
                    ROW_NUMBER() OVER                        
                    (PARTITION BY pr.Purchase_Request_Code ORDER BY pr.Purchase_Request_Code) AS num,                      
                    pr.Purchase_Request_Id,  
                    pr.Purchase_Request_Code,  
                    pr.Requested_User_Id,  
                    pr.Purchase_Request_Date,  
                    pr.Status_Remarks,  
                    pr.Request_Status, 
                    u.user_name,
                    (
                        SELECT 
                            STUFF(
                                (SELECT '', '' + CAST(r.role_Name AS VARCHAR(MAX)) + ''-'' + t2.[Status]
                                 FROM dbo.Purchase_Request_Approval t2 
                                 LEFT JOIN dbo.tbl_Role r ON r.role_Id = t2.Approval_Role_Id
                                 WHERE t1.Purchase_Request_Code = t2.Purchase_Request_Code
                                 FOR XML PATH('''')), 1, 1, ''''
                            ) AS PRStatus 
                        FROM Purchase_Request_Approval t1 
                        WHERE t1.Purchase_Request_Code = pr.Purchase_Request_Code
                        GROUP BY t1.Purchase_Request_Code
                    ) AS PRStatus                        
                FROM 
                    dbo.Tbl_Purchase_Request pr     
                LEFT JOIN dbo.Tbl_User u ON pr.Requested_User_Id = u.user_Id    
                LEFT JOIN dbo.tbl_Role r ON r.role_Id = u.role_Id
            ) tbl                      
            WHERE tbl.num = 1                       
            ORDER BY Purchase_Request_Id DESC  
        END
    ')
END
