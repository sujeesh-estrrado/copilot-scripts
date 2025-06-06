IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_SubjectNew_By_Duration_MappingId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[SP_Get_All_SubjectNew_By_Duration_MappingId] (@Duration_Mapping_Id bigint)     
AS        
        
BEGIN        
        
        
        
 SELECT B.Subject_Id,      
 B.Subject_Name,      
 B.Parent_Subject_Id,        
 ISNULL((select  Subject_Name  from  Tbl_Subject where   Subject_Id=B.Parent_Subject_Id) , '''''''') AS [Parent Subject],            
 B.Subject_Code,B.Subject_Descripition,B.Subject_Date  ,     
DS.Department_Subject_Id ,    
SS.Semester_Subject_Id,    
CC.Course_Category_Name+'' ''+      
D.Department_Name as Department,      
CBD.Batch_Code+'' ''+      
CS.Semester_Code as Semester      
      
      
      
        
  FROM Tbl_Subject B        
LEFT JOIN Tbl_Subject A on A.Parent_Subject_Id=B.Subject_Id      
INNER JOIN Tbl_Department_Subjects DS on DS.Subject_Id=B.Subject_Id      
INNER JOIN Tbl_Semester_Subjects SS on SS.Department_Subjects_Id=DS.Department_Subject_Id      
INNER JOIN Tbl_Course_Department CD on CD.Course_Department_Id=DS.Course_Department_Id      
INNER JOIN Tbl_Course_Category CC on CC.Course_Category_Id=CD.Course_Category_Id      
INNER JOIN Tbl_Department D on D.Department_Id=CD.Department_Id      
INNER JOIN Tbl_Course_Duration_Mapping CDM on CDM.Duration_Mapping_Id=SS.Duration_Mapping_Id      
INNER JOIN Tbl_Course_Duration_PeriodDetails CDP on CDP.Duration_Period_Id=CDM.Duration_Period_Id      
INNER JOIN Tbl_Course_Batch_Duration CBD on CBD.Batch_Id=CDP.Batch_Id      
INNER JOIN Tbl_Course_Semester CS on CS.Semester_Id=CDP.Semester_Id      
      
      
        
              
        
where B.Subject_Status=0 and SS.Duration_Mapping_Id=@Duration_Mapping_Id    
           
END
    ');
END
