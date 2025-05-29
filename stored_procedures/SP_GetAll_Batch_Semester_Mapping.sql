IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Batch_Semester_Bydepartment_candidate]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_GetAll_Batch_Semester_Bydepartment_candidate] --129        
(   
@candidateId bigint)              
AS                
BEGIN                
--SELECT Tbl_Course_Duration_Mapping.Duration_Mapping_Id,                
--Batch_Code+''-''+Semester_Code AS BatchSemester                
-- FROM Tbl_Student_Registration sr     
-- left Join Tbl_Candidate_Personal_Det cpd On cpd.Candidate_Id=sr.Candidate_Id
-- inner join tbl_New_Admission NA On NA.New_Admission_Id=CPD.New_Admission_Id              
----inner JOIN Tbl_Course_Batch_Duration bd On cd.Batch_Id=bd.Batch_Id                
----inner JOIN Tbl_Course_Semester cs on cs.Semester_Id=cd.Semester_Id        
------inner JOIN Tbl_Course_Duration_Mapping CDM on CDM.Duration_Period_Id=cd.Duration_Period_Id  
----left join Tbl_Student_Semester on Tbl_Student_Semester.Candidate_Id = cpd.Candidate_Id               
---- left join Tbl_Course_Duration_Mapping CDM on  CDM.Duration_Mapping_Id=ss.Duration_Mapping_Id
--left join Tbl_Student_Semester on Tbl_Student_Semester.Candidate_Id = cpd.Candidate_Id                      
--left join Tbl_Course_Duration_Mapping on Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id           
--Inner Join Tbl_Course_Duration_PeriodDetails CP On Tbl_Course_Duration_Mapping.Duration_Period_Id=CP.Duration_Period_Id           
--inner join Tbl_Course_Batch_Duration CBD On CBD.Batch_Id=NA.Batch_Id          
--Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id   
----left join Tbl_Student_Registration S on S.Department_Id=CDM.Course_Department_Id      
--where sr.Candidate_Id=@candidateId and Tbl_Student_Semester.Student_Semester_Current_Status=1 and cpd.Candidate_DelStatus=0      


  --select * from Tbl_Course_Duration_PeriodDetails
  --select * from  Tbl_Course_Batch_Duration
   --select * from  Tbl_Course_Semester
   --select * from Tbl_Student_Semester
   --select * from  Tbl_Course_Duration_Mapping
   --select * from  Tbl_Student_Registration


SELECT cdm.Duration_Mapping_Id,                
Batch_Code+''-''+Semester_Code AS BatchSemester   
          
FROM dbo.Tbl_Student_Semester SS   
INNER JOIN Tbl_Candidate_Personal_Det CPD on CPD.Candidate_Id=SS.Candidate_Id  
INNER JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id       
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id          
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id           
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id         
where SS.Candidate_Id=@candidateId and SS.Student_Semester_Delete_Status=0 and ss.student_semester_current_status=1
  and cpd.Candidate_DelStatus=0  
       
END

    ')
END
GO
