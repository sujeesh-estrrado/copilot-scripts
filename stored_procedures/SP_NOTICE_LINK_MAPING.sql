IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_NOTICE_LINK_MAPING]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_NOTICE_LINK_MAPING]   
@NoticeId bigint ,
@Link NVARCHAR(255)
AS
BEGIN

insert into Notice_Link_Maping(Notice_Id,Link_Id)
values(@NoticeId,@Link)
end

   ')
END;
