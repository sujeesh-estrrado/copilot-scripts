IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Delete_Temp_Password_By_User_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[Proc_Delete_Temp_Password_By_User_Id](@user_Id int)

AS

BEGIN

        delete from  TblTemp_Password where user_Id=@user_Id

END
    ')
END
