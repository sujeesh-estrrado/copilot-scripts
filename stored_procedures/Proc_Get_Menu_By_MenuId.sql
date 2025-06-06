IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Menu_By_MenuId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Get_Menu_By_MenuId] (@menu_Id INT)
        AS
        BEGIN
            SELECT menu_Id, menu_Name, menu_dtTime
            FROM [dbo].[tbl_Menu]
            WHERE menu_Id = @menu_Id
        END
    ')
END
