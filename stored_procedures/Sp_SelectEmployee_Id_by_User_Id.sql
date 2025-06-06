IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_SelectEmployee_Id_by_User_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_SelectEmployee_Id_by_User_Id](@user_Id bigint)
As
Begin
Select e.Employee_Id 
from dbo.Tbl_Employee_User e
where e.User_Id  = @user_Id;
End
    ')
END
