IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_StudentBatchWise_Review]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_StudentBatchWise_Review]   --45,446,''2017/02/09''              
  @Candidate_Id  bigint,  
  @Date datetime                               
AS                                            
BEGIN                                            
SELECT distinct                                  
cpd.Candidate_Id,                   
cpd.Candidate_Fname+'' ''+cpd.Candidate_Mname+'' ''+cpd.Candidate_Lname As CandidateName,     
Batch_Code+''-''+Semester_Code AS BatchSemester ,Tbl_Student_Semester.Duration_Mapping_Id,JD.Category,JD.Date  
FROM Tbl_Student_Registration sr                             
left Join Tbl_Candidate_Personal_Det cpd On cpd.Candidate_Id=sr.Candidate_Id                            
left Join Tbl_Course_Category cc on cc.Course_Category_Id=sr.Course_Category_Id                                       
left join Tbl_Student_Semester on Tbl_Student_Semester.Candidate_Id = cpd.Candidate_Id                                      
left join Tbl_Course_Duration_Mapping on Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id                           
Inner Join Tbl_Course_Duration_PeriodDetails CP On Tbl_Course_Duration_Mapping.Duration_Period_Id=CP.Duration_Period_Id                           
inner join Tbl_Course_Batch_Duration CBD On CBD.Batch_Id=CP.Batch_Id                          
Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id    
inner join LMS_Tbl_JobDiary JD on cpd.Candidate_Id=JD.User_Id  
where Tbl_Student_Semester.Student_Semester_Current_Status=1 and cpd.Candidate_DelStatus=0       
and cpd.Candidate_Id=@Candidate_Id  and JD.Date=@Date  
END
    ')
END
