IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_GetdataByExamScheduleId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_GetdataByExamScheduleId](@schedule bigint=0)
 as
begin
select P.Batch_Id,D.Department_Id,C.Course_Level_Id,P.Semester_Id,ES.Exam_Type_Id from Tbl_Exam_Schedule ES inner join Tbl_Exam_Master EM on EM.Exam_Master_Id=ES.Exam_Master_Id
inner join  Tbl_Course_Duration_PeriodDetails P on P.Duration_Period_Id=Em.Duration_Period_id inner join 
Tbl_Course_Batch_Duration B on B.Batch_Id=P.Batch_Id
inner join Tbl_Department D on D.Department_Id=B.Duration_Id
inner join Tbl_Course_Level C on C.Course_Level_Id=D.GraduationTypeId where ES.Exam_Schedule_Id=@schedule and ES.Exam_Schedule_Status=0
end');
END;
