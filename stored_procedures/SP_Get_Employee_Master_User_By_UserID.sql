IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Employee_Master_User_By_UserID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
 CREATE procedure [dbo].[SP_Get_Employee_Master_User_By_UserID]

(@user_Id bigint)

AS

BEGIN 

SELECT*FROM dbo.tbl_User

WHERE user_Id=@user_Id

END
    ');
END;
