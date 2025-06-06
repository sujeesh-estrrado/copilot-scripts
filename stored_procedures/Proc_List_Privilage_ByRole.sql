IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_List_Privilage_ByRole]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_List_Privilage_ByRole] (@role_Id INT)
        AS
        BEGIN
            SELECT 
                Tbl_Role_Privilage.role_Id,
                Tbl_Role_Privilage.Menu_Id,
                tbl_Menu.menu_Name,
                Tbl_Role_Privilage.Save_Status,
                Tbl_Role_Privilage.Update_Status,
                Tbl_Role_Privilage.Delete_Status,
                Tbl_Role_Privilage.View_Status
            FROM 
                Tbl_Role_Privilage
            INNER JOIN 
                tbl_Menu 
            ON 
                Tbl_Role_Privilage.Menu_Id = tbl_Menu.menu_Id
            WHERE 
                Tbl_Role_Privilage.role_Id = @role_Id
        END
    ')
END
