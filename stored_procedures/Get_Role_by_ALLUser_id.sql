IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Role_by_ALLUser_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure  [dbo].[Get_Role_by_ALLUser_id](@userid bigint=0)
as
begin
select role_Id from tbl_user where user_id=@userid;

end
    ')
END;