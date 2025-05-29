IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetScheduleDetails_by_CourseidAndMaster_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetScheduleDetails_by_CourseidAndMaster_Id](@masterId BIGINT=0,@courseid bigint=0)  
as  
begin  
  
select * from Tbl_Exam_Schedule where Course_id=@courseid and Exam_Master_Id=@masterId and Exam_Schedule_Status=0  
end
');
END;