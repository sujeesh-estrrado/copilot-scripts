IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_AllParent_Menus_By_User_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_Get_AllParent_Menus_By_User_Id] 
        @User_Ids BIGINT    
        AS
        BEGIN
            DECLARE @ErrorStatus VARCHAR(100)    
            DECLARE @Role_Id BIGINT    
        
            SET @Role_Id = 0    
        
            IF (@User_Ids > 0)    
            BEGIN    
                SET @Role_Id = (SELECT role_Id FROM [dbo].[Tbl_User] WHERE [user_Id] = @User_Ids)    
                SET @ErrorStatus = ''Success''    
            END    
            ELSE    
            BEGIN    
                SET @ErrorStatus = ''Invalid User''    
            END    
        
            IF (@ErrorStatus = ''Success'')    
            BEGIN    
                -- Select Roleid    
                SELECT 
                    Tbl_Role_Privilage.role_Id,
                    Tbl_Role_Privilage.Menu_Id,
                    tbl_Menu.menu_Name,
                    Tbl_Role_Privilage.Save_Status,
                    Tbl_Role_Privilage.Update_Status,
                    Tbl_Role_Privilage.Delete_Status,
                    Tbl_Role_Privilage.View_Status,
                    [dbo].[tbl_Menu].[menu_AndroidImage] AS menu_ImageName,
                    [dbo].[tbl_Menu].[LeftPannelMenuForAndroit]
                FROM 
                    Tbl_Role_Privilage
                LEFT JOIN 
                    tbl_Menu ON Tbl_Role_Privilage.Menu_Id = tbl_Menu.menu_Id
                WHERE 
                    Tbl_Role_Privilage.role_Id = @Role_Id 
                    AND tbl_Menu.[menu_ParentId] = 0
            END    
            ELSE    
            BEGIN    
                SELECT @ErrorStatus AS ErrorStatus    
            END    
        END
    ')
END
