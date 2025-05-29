IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_ExamPublish]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE Procedure [dbo].[Sp_Insert_ExamPublish]
@Exam_Id bigint=0,
@Exam_ScheduleId bigint=0,
@courseid bigint=0,
@Exam_Date Date=null,
@exam_time_from time(7)=null,
@exam_time_to time(7)=null,
@Venue bigint=0
as
begin
if not exists(select * from Tbl_ExamPublish where Exam_Master_Id=@Exam_Id and Exam_Schedule_Id=@Exam_ScheduleId)
begin
insert into Tbl_ExamPublish values(@Exam_Id,@Exam_ScheduleId,@courseid,@Exam_Date,@exam_time_from,@exam_time_to,@Venue,0)
end
else
begin
update Tbl_ExamPublish set Exam_Date=@Exam_Date,Exam_Time_from=@exam_time_from,Exam_Time_To=@exam_time_to,Venue=@Venue where Exam_Master_Id=@Exam_Id and Exam_Schedule_Id=@Exam_ScheduleId
end
end
    ')
END;
