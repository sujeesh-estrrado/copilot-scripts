IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_NOTICE_DEPARTMENT_MAPING]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_NOTICE_DEPARTMENT_MAPING]   
@NoticeId bigint,
@DepartmentId bigint
AS
BEGIN

insert into Notice_Department_Maping(Notice_Id,Department_Id)
values(@NoticeId,@DepartmentId)
end

   ')
END;
