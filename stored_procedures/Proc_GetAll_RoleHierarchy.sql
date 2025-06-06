-- Check if the stored procedure [dbo].[Proc_GetAll_RoleHierarchy] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_RoleHierarchy]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_RoleHierarchy]
        AS
        BEGIN
            SELECT  
                A.role_hierarchy_Id,
                A.role_Id,
                A.reporting_role_Id,
                (SELECT role_Name FROM tbl_Role WHERE role_Id = A.reporting_role_Id) AS ReportingRole,
                B.role_Name    
            FROM   
                Tbl_Role_hierarchy A    
            INNER JOIN 
                tbl_Role B ON A.role_Id = B.role_Id    
            WHERE   
                role_hierarchy_DelStatus = 0   
            ORDER BY  
                role_Name
        END
    ')
END
