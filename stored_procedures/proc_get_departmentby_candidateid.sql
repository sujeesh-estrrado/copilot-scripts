IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[proc_get_departmentby_candidateid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[proc_get_departmentby_candidateid]-- 9     
(        
@CandidateId bigint        
)        
        
as        
        
begin        
        
select        
 CPD.Candidate_Fname+'' ''+CPD.Candidate_Mname+'' ''+CPD.Candidate_Lname as CANDIDNAME,D.Department_Id,D.Department_Name,            
        
Batch_Code+''-''+Semester_Code AS BatchSemester              
FROM dbo.Tbl_Student_Semester SS       
INNER JOIN Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SS.Candidate_Id      
INNER JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id           
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id              
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id               
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id    
  
left JOIN Tbl_Course_Department Cdep on Department_Id=CDM.Course_Department_Id                   
left JOIN Tbl_Course_Category CC on CC.Course_Category_Id=Cdep.Course_Category_Id                    
left JOIN Tbl_Department D on D.Department_Id=Cdep.Department_Id       
where SS.Candidate_Id=@CandidateId and SS.Student_Semester_Delete_Status=0 and ss.student_semester_current_status=1        
end 
    ')
END
