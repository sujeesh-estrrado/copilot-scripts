IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_NOTICE_MAPING]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_NOTICE_MAPING]   
@NoticeId bigint,
@FacultyId bigint
AS
BEGIN

insert into Notice_Faculty_Maping(Notice_Id,Faculty_Id)
values(@NoticeId,@FacultyId)
end ');
END;
