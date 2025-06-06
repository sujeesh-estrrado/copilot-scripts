IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Grade_Deatails_ByCandidate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
                  
CREATE procedure [dbo].[Proc_Grade_Deatails_ByCandidate]-- 0
(@Candidate_Id bigint)                 
as              
begin    
              
select distinct EC.ExamCode,SC.SubjectName,SC.SubjectCode,SC.CurrentStatus,SC.Term Exam_Term,EC.Candidate_Id,                        
S.Contact_Hours timing,Credit_Points,EC.Grade,GSS.GradePoint,(S.Credit_Points)*(GSS.GradePoint) GradeValue, GSS.Pass,                             
(select top 1 ExamDate from  dbo.Tbl_Exam_Code_Master EE  inner join                               
Tbl_Exam_Code_Child EX on EE.Exam_Code_Master_Id=EX.Exam_Code_Master_Id                              
where EX.Exam_Code_final=EC.ExamCode ) as [Exam_date],              
--Tbl_Course_Category.Course_Category_Name+''-''+Batch_Code+''-''+Semester_Code AS BatchSemester,
EC.[Intake_Number]+''-''+EC.[Sem_Number] AS BatchSemester, 
cdm.Course_Department_Id,                    
Tbl_Course_Department.Course_Category_Id ,                   
Tbl_Course_Department.Department_Id,                    
Tbl_Department.Department_Name as new_dept,Batch_Code            
                            
 from  Tbl_Exam_Mark_Entry_Child EC                                
inner join Tbl_StudentExamSubjectsChild SC on EC.ExamCode=SC.ExamCode                                
inner join Tbl_GradingScheme GS on GS.Grade_Scheme=SC.GradingScherme                                
inner join Tbl_GradeSchemeSetup GSS on GSS.Grade_Scheme_Id=GS.Grade_Scheme_Id and EC.Grade=GSS.Grade                                
inner join Tbl_GroupChangeExamDates GD on GD.ExamCode=EC.ExamCode                              
inner join Tbl_Subject S on SC.SubjectId=S.Subject_Id                 
inner join Tbl_Student_Semester ss on ss.candidate_id=EC.candidate_id              
INNER JOIN Tbl_Course_Duration_Mapping cdm   on  SS.Duration_Mapping_Id=cdm.Duration_Mapping_Id                       
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                          
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                           
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                             
--left join Tbl_Course_Duration_Mapping on Tbl_Student_Semester.Duration_Mapping_Id = Tbl_Course_Duration_Mapping.Duration_Mapping_Id                    
left join Tbl_Course_Department on cdm.Course_Department_Id = Tbl_Course_Department.Course_Department_Id                    
left join Tbl_Course_Category on Tbl_Course_Department.Course_Category_Id = Tbl_Course_Category.Course_Category_Id                    
left join Tbl_Course_Level on  Tbl_Course_Category.Course_level_Id = Tbl_Course_Level.Course_level_Id                    
left join Tbl_Department on   Tbl_Course_Department.Department_Id =  Tbl_Department.Department_Id                    
INNER JOIN dbo.Tbl_Exam_Code_Child  ECC  ON GD.ExamCode=ECC.Exam_Code_Final                       
INNER JOIN dbo.Tbl_Assessment_Type AT  ON AT.Assesment_Type=ECC.AssesmentType      
INNER JOIN Tbl_Assessment_Code_Child ACC ON ACC.Assessment_Type_Id=AT.Assessment_Type_Id      
  
            
where EC.Candidate_Id=@Candidate_Id and ss.Student_Semester_Current_Status=1           
AND SC.CurrentStatus<>''--Select--'' and LAST=1 --and  EC.ExamCode like ''%FE%''            
             
end   
    ')
END;
