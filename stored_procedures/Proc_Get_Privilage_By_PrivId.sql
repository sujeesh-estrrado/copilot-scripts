IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Privilage_By_PrivId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Get_Privilage_By_PrivId](@Privilege_Id INT)
        AS
        BEGIN
            SELECT Tbl_Role_Privilage.Privilege_Id,
                   Tbl_Role_Privilage.role_Id,
                   tbl_Role.role_Name,
                   tbl_Menu.menu_Id,
                   tbl_Menu.menu_Name
            FROM (Tbl_Role_Privilage INNER JOIN tbl_Role
                  ON Tbl_Role_Privilage.role_Id = tbl_Role.role_Id)
            INNER JOIN tbl_Menu ON Tbl_Role_Privilage.Menu_Id = tbl_Menu.menu_Id
            WHERE Tbl_Role_Privilage.Privilege_Id = @Privilege_Id
        END
    ')
END
