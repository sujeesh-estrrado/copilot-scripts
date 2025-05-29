IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Semester_By_CourseDepartmentId_And_Batch_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_GetAll_Semester_By_CourseDepartmentId_And_Batch_Id]   --2,27               
@Course_Department_Id bigint,                  
@Batch_Id bigint                  
AS                      
BEGIN                      
SELECT                       
cdp.Duration_Period_Id as Duration_Mapping_Id, cdp.Semester_Id as Semester_Id,                     
Semester_Code AS Semester                      
FROM           
--Tbl_Course_Duration_Mapping cdm    INNER JOIN          
Tbl_Course_Duration_PeriodDetails cdp           
--ON cdm.Duration_Period_Id=cdp.Duration_Period_Id                      
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id                       
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id                 
                
--INNER JOIN dbo.Tbl_Course_Department CD ON Department_Id=cbd.Duration_Id                
INNER JOIN  Tbl_Department D ON D.Department_Id = cbd.Duration_Id                      
                     
WHERE D.Department_Id =@Course_Department_Id and  cdp.Batch_Id=@Batch_Id and cdp.Delete_Status=0   order by cdp.Semester_Id               
END               
    
    ')
END
