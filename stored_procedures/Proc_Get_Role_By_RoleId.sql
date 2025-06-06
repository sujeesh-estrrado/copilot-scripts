IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Role_By_RoleId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Get_Role_By_RoleId] 
        (@role_Id INT)
        AS
        BEGIN
            SELECT role_Id, role_Name, role_status, role_dtTime, Is_Authority, Is_PrimeAuthority, Approval_limit_amount
            FROM [dbo].[tbl_Role]
            WHERE role_Id = @role_Id
        END
    ')
END
