IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_NOTICE_PROGRAM_MAPING]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_NOTICE_PROGRAM_MAPING]   
@NoticeId bigint,
@ProgramId bigint
AS
BEGIN

insert into Notice_Program_Maping(Notice_Id,Program_Id)
values(@NoticeId,@ProgramId)
end');
END;
