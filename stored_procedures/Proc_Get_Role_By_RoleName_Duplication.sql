IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Role_By_RoleName_Duplication]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Get_Role_By_RoleName_Duplication] 
        (@role_Name VARCHAR(50))
        AS
        BEGIN
            SELECT role_Id, role_Name, role_status, role_dtTime
            FROM [dbo].[tbl_Role]
            WHERE role_Name = @role_Name 
            AND role_status = 1 
            AND role_DeleteStatus = 0
        END
    ')
END
