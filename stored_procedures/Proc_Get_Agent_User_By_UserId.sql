IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_Agent_User_By_UserId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Proc_Get_Agent_User_By_UserId] --1
(
@User_Id int
)

AS

BEGIN

    select eu.Agent_User_Id,eu.Agent_Id,eu.User_Id,e.Agent_Name as [Agent_Name],u.user_name
    from Tbl_Agent_User eu 
    left join dbo.Tbl_Agent e on eu.Agent_Id=e.Agent_ID 
    left join dbo.Tbl_User u on u.user_Id=eu.User_Id
    where eu.User_Id=@User_Id
END




--select * from Tbl_Agent_User
--select * from Tbl_Agent
--select * from Tbl_User
    ')
END
