IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_AgentID_by_UserID]')
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[sp_Get_AgentID_by_UserID] 

(@User_Id bigint)

AS

BEGIN 

SELECT*FROM dbo.Tbl_Agent_User

WHERE User_Id=@User_Id

ORDER BY user_Id DESC

END

    ')
END;
