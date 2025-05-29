IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Insert_StudentExam_SerialNo]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Insert_StudentExam_SerialNo]  
  
@Exam_Candidate_Attendance_Marks_Id bigint ,
@Student_Exam_No varchar(50)
    
AS     
Begin   
  
INSERT INTO Tbl_Student_Exam_SerialNo   
           ( Exam_Candidate_Attendance_Marks_Id , Student_Exam_No)    
     VALUES    
           (@Exam_Candidate_Attendance_Marks_Id    
           ,@Student_Exam_No)    
 
End


   ')
END;
