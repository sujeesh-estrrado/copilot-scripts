IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Update_User]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Update_User](@user_Id int,@role_Id int)    

    
AS    
    
BEGIN    
    
 UPDATE [dbo].[Tbl_User]    
  SET    role_Id      = @role_Id     

  WHERE  [user_Id] = @user_Id    
    
END
    ')
END
