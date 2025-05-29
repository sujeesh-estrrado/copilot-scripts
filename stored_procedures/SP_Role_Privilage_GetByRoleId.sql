IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Role_Privilage_GetByRoleId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Role_Privilage_GetByRoleId]
	(@roleId BIGINT)
AS
BEGIN
	SELECT A.Privilege_Id, A.role_Id, A.Menu_Id, B.menu_Name, B.menu_ToPage, B.menu_ImageName, B.menu_color,
	B.menu_SImage, B.menu_ParentId FROM dbo.Tbl_Role_Privilage A	
	LEFT JOIN dbo.tbl_Menu B ON A.Menu_Id = B.menu_Id
	WHERE A.role_Id = @roleId AND B.menu_ParentId = 0
END
');
END;