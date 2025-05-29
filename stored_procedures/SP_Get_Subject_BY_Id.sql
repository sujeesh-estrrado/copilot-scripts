IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Subject_BY_Id]')
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE procedure [dbo].[SP_Get_Subject_BY_Id]  
 (@Subject_Id bigint)      
      
AS      
      
BEGIN      
      
      
      
 SELECT B.Subject_Id,    
 B.Subject_Name,B.Assessment_Code ,   
 B.Parent_Subject_Id,      
ISNULL(A.Subject_Name, '''') AS [Parent Subject],      
B.Subject_Code,B.Subject_Descripition,B.Subject_Date  ,    
Course_Department_Id,    
Duration_Mapping_Id    
  FROM Tbl_Subject B      
        LEFT JOIN Tbl_Subject A on A.Subject_Id=B.Subject_Id    
INNER JOIN Tbl_Department_Subjects DS on DS.Subject_Id=B.Subject_Id    
INNER JOIN Tbl_Semester_Subjects SS on SS.Department_Subjects_Id=DS.Department_Subject_Id    
where B.Subject_Status=0 and B.subject_Id=@Subject_Id      
      
         
END
    ')
END;
