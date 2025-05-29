IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_NOTICE_Employee_MAPING]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_NOTICE_Employee_MAPING]   
@NoticeId bigint,
@employeeId bigint
AS
BEGIN

insert into Notice_Employee_Maping(Notice_Id,Employee_Id)
values(@NoticeId,@employeeId)
end ');
END;
