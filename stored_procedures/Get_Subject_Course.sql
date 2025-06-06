-- Create Get_Subject_Course procedure if it does not exist
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Subject_Course]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[Get_Subject_Course]  --19    
@Department_Id bigint    
as    
begin    
       
      
select distinct D.Department_Id,D.Department_Name,Subject_name,Subject_Id,CBD.Batch_Id    
from Tbl_StudentExamSubjectsChild sec    
inner join dbo.Tbl_StudentExamSubjectMaster SEM ON SEM.StudentExamSubjectMasterId=SEC.StudentExamSubjectMasterId               
--INNER JOIN dbo.Tbl_StudentExamSubjectsChild SEC ON SEM.StudentExamSubjectMasterId=SEC.StudentExamSubjectMasterId              
INNER JOIN dbo.Tbl_Department D ON D.Department_Id =SEM.Department_Id    
    
INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Mapping_Id=SEM.Duration_Mapping_Id              
INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id=CDM.Duration_Period_Id              
INNER JOIN dbo.Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id=CDP.Batch_Id     
inner join  tbl_Subject s on s.Subject_Id=SEC.SubjectId     
where CBD.Batch_Id=@Department_Id     
--group by D.Department_Id,D.Department_Name,Subject_name,Subject_Id    
End

--////////////////////////////////////////////
    ')
END;
GO
