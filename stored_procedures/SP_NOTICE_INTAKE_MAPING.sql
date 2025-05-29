IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_NOTICE_INTAKE_MAPING]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_NOTICE_INTAKE_MAPING]   
@NoticeId bigint,
@IntakeId bigint
AS
BEGIN

insert into Notice_Intake_Maping(Notice_Id,Intake_Id)
values(@NoticeId,@IntakeId)
end ');
END;
