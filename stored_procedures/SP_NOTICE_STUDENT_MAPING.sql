IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_NOTICE_STUDENT_MAPING]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_NOTICE_STUDENT_MAPING]   
@NoticeId bigint,
@StudentId bigint
AS
BEGIN

insert into Notice_Student_Maping(Notice_Id,Student_Id)
values(@NoticeId,@StudentId)
end');
END;
