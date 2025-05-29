IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[changeExamOpenStatus]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[changeExamOpenStatus]
(@Status bit,@ExamCode varchar(100))
as
begin
update Tbl_GroupChangeExamDates
set OpenStatus=@Status
where ExamCode=@ExamCode
end
    ')
END;
