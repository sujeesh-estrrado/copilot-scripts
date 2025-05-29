IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetExamScheduleByMasterID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetExamScheduleByMasterID](@master_id bigint=0,@course_id bigint=0)
as begin
select * from Tbl_Exam_Schedule where Exam_Master_Id=@master_id and Course_id=@course_id and Exam_Schedule_Status=0
end
 ');
END;