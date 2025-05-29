IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Purchase_RequestId_ByCode]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_Purchase_RequestId_ByCode] -- PUREQ0102     
        (      
            @Purchase_Request_Code VARCHAR(50)  
        )      
        AS      
        BEGIN      
            
            SELECT 
                pr.*, 
                p.Product_Name, 
                pu.Units_Name, 
                u.user_name, 
                u.role_Id, 
                r.role_Name 
            FROM       
                dbo.Tbl_Purchase_Request pr 
            LEFT JOIN 
                dbo.Tbl_Products p ON pr.Product_Id = p.Product_Id      
            LEFT JOIN 
                dbo.Tbl_Product_Units pu ON pr.Unit_Id = pu.Units_id 
            LEFT JOIN 
                dbo.Tbl_User u ON pr.Requested_User_Id = u.user_Id 
            LEFT JOIN 
                dbo.tbl_Role r ON r.role_Id = u.role_Id 
            WHERE      
                pr.Purchase_Request_Code = @Purchase_Request_Code  
                AND pr.Approval_Delete_Status = ''SAVED'' 
        END
    ')
END
