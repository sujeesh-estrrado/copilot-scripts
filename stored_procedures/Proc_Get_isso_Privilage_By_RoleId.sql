IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_isso_Privilage_By_RoleId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[Proc_Get_isso_Privilage_By_RoleId](@Role_name  nvarchar(25))    
    
AS    
    
BEGIN    
    
 SELECT Tbl_Role_Privilage.Privilege_Id,Tbl_Role_Privilage.role_Id,Tbl_Role_Privilage.View_Status,Tbl_Role_Privilage.Save_Status,      
 Tbl_Role_Privilage.Update_Status,Tbl_Role_Privilage.Delete_Status,tbl_Role.role_Name ,tbl_Menu.menu_Id,tbl_Menu.menu_Name,tbl_Menu.menu_ParentId,      
tbl_Menu.menu_ToPage,tbl_Menu.menu_tooltip,tbl_Menu.menu_ImageName,tbl_Menu.menu_color,tbl_Menu.menu_description,tbl_Menu.menu_SImage      
FROM (Tbl_Role_Privilage  INNER JOIN tbl_Role      
ON Tbl_Role_Privilage.role_Id=tbl_Role.role_Id) INNER JOIN tbl_Menu ON       
Tbl_Role_Privilage.Menu_Id=tbl_Menu.menu_Id WHERE       
Tbl_Role.role_Name=''ISSO'' and Tbl_Role_Privilage.View_Status=1 and menu_name in (''Management Dashboard'',''ISSO Dashboard'')  ORDER BY  tbl_Menu.menu_Name  


       
END
    ')
END
