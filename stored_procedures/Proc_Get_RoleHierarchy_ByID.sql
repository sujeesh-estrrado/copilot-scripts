IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_RoleHierarchy_ByID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Get_RoleHierarchy_ByID]
        (@role_hierarchy_Id BIGINT)
        AS
        BEGIN
            SELECT  
                A.role_hierarchy_Id,
                A.role_Id,
                A.reporting_role_Id,
                B.role_Name
            FROM   
                Tbl_Role_hierarchy A
            INNER JOIN 
                tbl_Role B 
            ON 
                A.role_Id = B.role_Id
            WHERE   
                role_hierarchy_DelStatus = 0 
            AND 
                role_hierarchy_Id = @role_hierarchy_Id
        END
    ')
END
