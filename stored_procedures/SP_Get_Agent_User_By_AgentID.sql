IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Agent_User_By_AgentID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Get_Agent_User_By_AgentID]

(@Agent_Id bigint)

AS

BEGIN 

SELECT*FROM dbo.Tbl_Agent_User

WHERE Agent_Id=@Agent_Id

ORDER BY user_Id DESC

END
    ')
END
