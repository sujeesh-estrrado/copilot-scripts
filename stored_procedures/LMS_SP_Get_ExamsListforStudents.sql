IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_ExamsListforStudents]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[LMS_SP_Get_ExamsListforStudents] --299               
@Candidate_Id bigint                 
AS                        
BEGIN                  
                     
select OE.Exam_Id,OE.ExamName,OE.ExamDate,OE.ExamDuration,OE.ExamType,OE.Semster_Subject_Id,S.Subject_Name from LMS_Tbl_OnlineExams OE    
inner join Tbl_Student_Semester SS on OE.DurationMapping_Id=SS.Duration_Mapping_Id    
inner join Tbl_Semester_Subjects SSS on OE.Semster_Subject_Id=SSS.Semester_Subject_Id    
inner join Tbl_Department_Subjects DS on SSS.Department_Subjects_Id=DS.Department_Subject_Id       
inner join Tbl_Subject S on DS.Subject_Id=S.Subject_Id     
where OE.Status=0 and SS.Student_Semester_Current_Status=1 and SS.Candidate_Id=@Candidate_Id    
and SS.Candidate_Id not in(select Student_Id from LMS_Tbl_ExamAnswers where Student_Id=@Candidate_Id and   
Exam_Id=OE.Exam_Id)  and OE.Exam_Id in (select Exam_Id FROM LMS_Tbl_Questions where Status=0)
        
              
              
END
    ')
END
