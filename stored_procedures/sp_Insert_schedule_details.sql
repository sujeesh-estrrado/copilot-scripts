IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Insert_schedule_details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Insert_schedule_details](@scheduleid bigint=0,@venue bigint=0,@chef bigint=0,@totalstudent bigint=0)  
as  
begin  
--if not exists (select * from Tbl_Exam_Schedule_Details where Exam_Schedule_Id=@scheduleid and Exam_Schedule_Details_Status=0)  
--begin  
insert into Tbl_Exam_Schedule_Details(Exam_Schedule_Id,ChiefInvigilator,Total_student_requested,Venue,Exam_Schedule_Details_Status)  
values(@scheduleid,@chef,@totalstudent,@venue,0)  
SELECT @@IDENTITY    
--end  
--else  
--begin  
--select Exam_Schedule_Details_Id from Tbl_Exam_Schedule_Details where Exam_Schedule_Id=@scheduleid and Exam_Schedule_Details_Status=0  
--end  
end
    ');
END;
