IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[TESTPROC]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[TESTPROC]     
@Duration_Mapping_Id bigint    
As    
Begin    
 Select     
 SS.Semester_Subject_Id,    
 SS.Duration_Mapping_Id,    
 SS.Department_Subjects_Id,    
 CDP.Batch_Id,    
 CDP.Semester_Id,    
 CDM.Course_Department_Id ,  
 S.Subject_Name as SubjectName,  
 S.Subject_Id,  
 S.Parent_Subject_Id,  
CR.Candidate_Id,  
CR.RollNumber,  
(Case when S.Parent_Subject_Id=0 Then S.Subject_Name Else S.Subject_Name+''-(''+ (Select Subject_Name From Tbl_Subject Where Subject_Id=S.Parent_Subject_Id)+'')'' End) as Subject_Name  
  
 FROM Tbl_Semester_Subjects SS    
 INNER JOIN Tbl_Course_Duration_Mapping CDM On SS.Duration_Mapping_Id=CDM.Duration_Mapping_Id    
 INNER JOIN Tbl_Course_Duration_PeriodDetails CDP On CDM.Duration_Period_Id=CDP.Duration_Period_Id    
 INNER JOIN Tbl_Department_Subjects DS On SS.Department_Subjects_Id=DS.Department_Subject_Id  
 INNER JOIN Tbl_Subject S on DS.Subject_Id=S.Subject_Id  
 INNER JOIN  Tbl_Candidate_RollNumber  CR On CR.Duration_Mapping_Id=CDM.Duration_Mapping_Id    
  
 Where SS.Semester_Subjects_Status=0 and SS.Duration_Mapping_Id=@Duration_Mapping_Id and  
(select Count(Subject_Id) From Tbl_Subject Where Parent_Subject_Id=S.Subject_Id)=0  
end
    ')
END;
GO
