IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Subjects_By_Semester_Batch]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Get_All_Subjects_By_Semester_Batch]  --2,1
@Batch_Id Bigint =0,
@Semester_id Bigint =0
AS    
Begin    
    
Select * from     
(Select      
S.Duration_Mapping_Id as DurationMappingID,    
S.Semester_Subject_Id,  
S.Department_Subjects_Id,  
CP.Batch_Id,    
CP.Semester_Id,    
B.Batch_Code as BatchName,  
Batch_Code+''-''+Semester_Code AS BatchSemester,    
B.Batch_Id as BatchID,    
DM.Course_Department_Id as CourseDepartmentID,    
CC.Course_Category_Name+''-''+D.Department_Name as DepartmentName,   
  
SE.Semester_Name as SemesterName    
From Tbl_Semester_Subjects S     
Inner Join Tbl_Course_Duration_Mapping DM On S.Duration_Mapping_Id=DM.Duration_Mapping_Id    
Inner Join Tbl_Course_Duration_PeriodDetails CP On DM.Duration_Period_Id=CP.Duration_Period_Id    
Inner Join Tbl_Course_Batch_Duration B On Cp.Batch_Id=B.Batch_Id    
Inner Join Tbl_Course_Semester SE On CP.Semester_Id=SE.Semester_Id    
Inner Join Tbl_Course_Department CD On CD.Department_Id=DM.Course_Department_Id   
Inner Join Tbl_Course_Category CC On CC.Course_Category_Id=CD.Course_Category_Id  
Inner Join Tbl_Department D on CD.Department_Id=D.Department_Id)Temp_Tbl
 where Batch_Id=@Batch_Id and Semester_id=@Semester_id
 
 
 end
--select * from Tbl_Course_Department
    ')
END
