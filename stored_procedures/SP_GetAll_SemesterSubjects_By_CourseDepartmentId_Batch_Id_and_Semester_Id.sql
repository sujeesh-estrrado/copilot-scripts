IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_SemesterSubjects_By_CourseDepartmentId_Batch_Id_and_Semester_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_GetAll_SemesterSubjects_By_CourseDepartmentId_Batch_Id_and_Semester_Id]   
@Course_Department_Id bigint,    
@Batch_Id bigint,  
@Semester_Id bigint  
AS        
BEGIN        
SELECT         
SS.Duration_Mapping_Id,
Department_Subjects_Id,   
cs.Semester_Id ,     
Semester_Code AS Semester           
FROM Tbl_Semester_Subjects SS
INNER JOIN Tbl_Course_Duration_Mapping cdm ON cdm.Duration_Mapping_Id=SS.Duration_Mapping_Id         
INNER JOIN Tbl_Course_Duration_PeriodDetails cdp ON cdm.Duration_Period_Id=cdp.Duration_Period_Id        
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id         
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id        
WHERE cdm.Course_Department_Id =@Course_Department_Id and  cdp.Batch_Id=@Batch_Id and  cdm.Duration_Mapping_Id<>@Semester_Id  
END
    
    ')
END
