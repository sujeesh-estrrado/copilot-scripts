IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_AgentId]')
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[SP_Get_AgentId] 
	@Agent_userId int=0
AS
BEGIN
	select [User_Id] from Tbl_Agent_User where Agent_User_Id=@Agent_userId
END


    ')
END;
