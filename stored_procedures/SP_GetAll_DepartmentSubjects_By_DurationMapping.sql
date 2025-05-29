IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_DepartmentSubjects_By_DurationMapping]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_DepartmentSubjects_By_DurationMapping]                 
@Course_Department_Id bigint                      
As                      
Begin                      
Select  distinct                     
DS.Department_Subject_Id,                      
DS.Course_Department_Id,ss.Duration_Mapping_Id,                      
DS.Subject_Id ,                     
S.Subject_Name,                
S.Subject_Code,                    
--C.Course_Category_Name+''-''+              
D.Department_Name  as [Department Name]                
                
--From Tbl_Department_Subjects DS                      
----INNER JOIN Tbl_Course_Department CD On CD.Course_Department_Id=DS.Course_Department_Id                     
--Inner Join Tbl_Subject S On DS.Subject_Id=S.Subject_Id                      
--INNER JOIN Tbl_Department D ON D.Department_Id=DS.Course_Department_Id--D.Department_Id                      
----INNER JOIN Tbl_Course_Category C On C.Course_Category_Id=CD.Course_Category_Id                              
--Where S.Parent_Subject_Id=0 and D.Department_Id= @Course_Department_Id and Subject_Status=0            
          
From Tbl_Semester_Subjects SS                      
INNER JOIN Tbl_Department_Subjects ds On ds.Department_Subject_Id=SS.Department_Subjects_Id                     
Inner Join Tbl_Subject S On DS.Subject_Id=S.Subject_Id                      
INNER JOIN Tbl_Department D ON D.Department_Id=DS.Course_Department_Id--D.Department_Id                      
--INNER JOIN Tbl_Course_Category C On C.Course_Category_Id=CD.Course_Category_Id                    
                    
Where S.Parent_Subject_Id=0 and --ss.Duration_Mapping_Id=@Course_Department_Id         
ss.Duration_Mapping_Id=@Course_Department_Id and Subject_Status=0                              
End  
');
END;