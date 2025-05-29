IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Employee_User_By_UserId]')
    AND type = N'P'
)
BEGIN
    EXEC('
  
CREATE procedure [dbo].[Proc_Get_Employee_User_By_UserId](@User_Id int)

AS

BEGIN

    select eu.Employee_User_Id,eu.Employee_Id,eu.User_Id,e.Employee_FName+'' ''+e.Employee_LName+'' '' as [Employee_Name],
u.user_name
    from Tbl_Employee_User eu left join dbo.Tbl_Employee e on eu.Employee_Id=e.Employee_Id 
left join dbo.Tbl_User u on u.user_Id=eu.User_Id
where
    eu.User_Id=@User_Id
END
    ')
END
