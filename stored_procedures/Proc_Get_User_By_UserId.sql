IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_User_By_UserId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Proc_Get_User_By_UserId](@User_Id int)  
  
AS  
Set NoCount ON  
BEGIN  
  
 SELECT [user_Id],role_Id,[user_name],user_password,user_Status,user_Email FROM Tbl_User  
WHERE [user_Id]=@User_Id  
     
END
    ')
END
