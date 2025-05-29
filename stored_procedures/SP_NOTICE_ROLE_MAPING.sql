IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_NOTICE_ROLE_MAPING]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_NOTICE_ROLE_MAPING]   
@NoticeId bigint,
@RoleId bigint
AS
BEGIN

insert into Notice_Role_Maping(Notice_Id,Role_Id)
values(@NoticeId,@RoleId)
end
');
END;
