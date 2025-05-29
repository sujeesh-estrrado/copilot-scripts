IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_SubbMenuCountBy_By_RoleIdAndPMenuID]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE PROCEDURE [dbo].[SP_Get_SubbMenuCountBy_By_RoleIdAndPMenuID] --Parent Menu with SubMenu only
	(@Role_Id Bigint = 0,
	@PMenuId  Bigint = 0)
	AS    
	BEGIN    
		SELECT COALESCE(COUNT(*), 0) SubMenuCount
		FROM (Tbl_Role_Privilage INNER JOIN tbl_Role    
				ON Tbl_Role_Privilage.role_Id = tbl_Role.role_Id) 
				INNER JOIN tbl_Menu ON Tbl_Role_Privilage.Menu_Id = tbl_Menu.menu_Id 
		WHERE Tbl_Role_Privilage.role_Id = @Role_Id 
		AND tbl_Menu.menu_ParentId = @PMenuId 
		AND Tbl_Role_Privilage.View_Status = ''true'' 
	END
    ')
END;
