IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_AttendedExamList]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_AttendedExamList] --299     
@Teacher_Id bigint ,
@Exam_Id bigint             
AS                          
BEGIN                    

select distinct OE.Exam_Id,    
CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as StudentName ,convert(varchar(50),EA.Created_Date,103) as AttendedDate,(select count(AttendExam_Id)  from LMS_Tbl_ExamAnswers where Markedanswer is null and Exam_Id=OE.Exam_Id and Student_Id=CPD.Candidate_Id    
) as NotAnswered,(select count(AttendExam_Id) from LMS_Tbl_ExamAnswers where  Exam_Id=OE.Exam_Id and Student_Id=CPD.Candidate_Id    
)  as TotalAnswered,(select count(EA.AttendExam_Id) from LMS_Tbl_ExamAnswers EA     
inner join LMS_Tbl_Questions Q on EA.Question_Id=Q.Question_Id     
where  EA.MarkedAnswer=Q.Answer and    
 EA.Exam_Id=OE.Exam_Id and EA.Student_Id=CPD.Candidate_Id)  as CorrectAnswer,  
(select count(EA.AttendExam_Id) from LMS_Tbl_ExamAnswers EA     
inner join LMS_Tbl_Questions Q on EA.Question_Id=Q.Question_Id     
where Markedanswer is not null and  EA.MarkedAnswer!=Q.Answer and    
 EA.Exam_Id=OE.Exam_Id and EA.Student_Id=CPD.Candidate_Id)  as WrongAnswered from LMS_Tbl_OnlineExams OE      
inner join LMS_Tbl_Questions Q on OE.Exam_Id=Q.Exam_Id     
inner join LMS_Tbl_ExamAnswers EA on Q.Question_Id=EA.Question_Id     
inner join Tbl_Student_Semester SS on OE.DurationMapping_Id=SS.Duration_Mapping_Id      
inner join Tbl_Semester_Subjects SSS on OE.Semster_Subject_Id=SSS.Semester_Subject_Id      
inner join Tbl_Department_Subjects DS on SSS.Department_Subjects_Id=DS.Department_Subject_Id         
inner join Tbl_Subject S on DS.Subject_Id=S.Subject_Id       
inner join Tbl_Candidate_Personal_Det CPD on EA.Student_Id=CPD.Candidate_Id
where OE.Status=0 and SS.Student_Semester_Current_Status=1 and OE.User_Id=@Teacher_Id
 and OE.Exam_Id=@Exam_Id   
    
               
                
END
    ')
END
