IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Tbl_Exam_Candidate_Attendance_Marks_Insert]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Tbl_Exam_Candidate_Attendance_Marks_Insert]    
 @Exam_Schedule_Details_Id bigint    
,@CandidateID bigint    
,@Attendance_Status bit    
,@Marks float    
AS     
Begin   
IF NOT EXISTS (SELECT * From Tbl_Exam_Candidate_Attendance_Marks Where   
            Exam_Schedule_Details_Id=@Exam_Schedule_Details_Id  and  
            Candidate_Id=@CandidateID)  
Begin 
INSERT INTO [Tbl_Exam_Candidate_Attendance_Marks]    
           ([Exam_Schedule_Details_Id]    
           ,[Candidate_Id]    
           ,[Attendance_Status]    
           ,[Marks])    
     VALUES    
           (@Exam_Schedule_Details_Id    
           ,@CandidateID    
           ,@Attendance_Status    
           ,@Marks)  
SELECT @@IDENTITY   
End  
ELSE  
Begin 
UPDATE Tbl_Exam_Candidate_Attendance_Marks  
SET   
 Attendance_Status=@Attendance_Status,  
 Marks=@Marks  
 Where Exam_Schedule_Details_Id=@Exam_Schedule_Details_Id and Candidate_Id=@CandidateID  

End  
END

   ')
END;
