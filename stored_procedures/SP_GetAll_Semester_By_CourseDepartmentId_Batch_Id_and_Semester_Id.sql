IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Semester_By_CourseDepartmentId_Batch_Id_and_Semester_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE  procedure [dbo].[SP_GetAll_Semester_By_CourseDepartmentId_Batch_Id_and_Semester_Id]     
@Course_Department_Id bigint,      
@Batch_Id bigint,    
@Semester_Id bigint    
AS          
BEGIN          
SELECT           
cdp.Duration_Period_Id as Duration_Mapping_Id,     
cs.Semester_Id ,       
Semester_Code AS Semester          
FROM 
--Tbl_Course_Duration_Mapping cdm           
--INNER JOIN 
Tbl_Course_Duration_PeriodDetails cdp         
INNER JOIN Tbl_Course_Batch_Duration cbd ON cbd.Batch_Id=cdp.Batch_Id           
INNER JOIN Tbl_Course_Semester cs ON cs.Semester_Id=cdp.Semester_Id          
WHERE cbd.Duration_Id =@Course_Department_Id and  cdp.Batch_Id=@Batch_Id and  cdp.Duration_Period_Id<>@Semester_Id  order by   
cs.Semester_Id   
  
END  
    
    ')
END
