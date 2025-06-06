IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Subjects_By_Duration_MappingId_ForCR]') 
    AND type = N'P'
)
BEGIN
    EXEC('
               
CREATE procedure [dbo].[SP_Get_All_Subjects_By_Duration_MappingId_ForCR]          
@Duration_Mapping_Id bigint              
As              
Begin              
 Select   distinct CDP.Batch_Id as BatchID,Batch_Code+''-''+CS.Semester_Code as BatchName         ,            
 SS.Semester_Subject_Id,              
 SS.Duration_Mapping_Id,              
 SS.Department_Subjects_Id,              
 CDP.Batch_Id,              
 CDP.Semester_Id,              
 CDM.Course_Department_Id ,            
 S.Subject_Name as SubjectName,      
CS.Semester_Code,      
C.Course_Category_Name+''-''+D.Department_Name  as [Department Name]       
      
            
 FROM Tbl_Semester_Subjects SS              
 INNER JOIN Tbl_Course_Duration_Mapping CDM On SS.Duration_Mapping_Id=CDM.Duration_Mapping_Id              
 INNER JOIN Tbl_Course_Duration_PeriodDetails CDP On CDM.Duration_Period_Id=CDP.Duration_Period_Id              
 INNER JOIN Tbl_Department_Subjects DS On SS.Department_Subjects_Id=DS.Department_Subject_Id            
 INNER JOIN Tbl_Subject S on DS.Subject_Id=S.Subject_Id           
 INNER JOIN Tbl_Course_Department CD on DS.Course_Department_Id=CD.Department_Id --DS.Course_Department_Id       
 INNER JOIN Tbl_Department D ON CD.Department_Id=D.Department_Id         
 INNER JOIN Tbl_Course_Category C On C.Course_Category_Id=CD.Course_Category_Id         
 INNER JOIN Tbl_Course_Semester CS ON CS.Semester_Id=CDP.Semester_Id        
INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id=CDP.Batch_Id         
            
 Where SS.Semester_Subjects_Status=0 and SS.Duration_Mapping_Id=@Duration_Mapping_Id             
    order by SubjectName        
End    
    ');
END
