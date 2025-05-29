IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Batch_Semester_Mapping_By_CourseDepartmentId]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_GetAll_Batch_Semester_Mapping_By_CourseDepartmentId] --12                  
@Course_Department_Id bigint                       
AS                        
BEGIN                        
SELECT      cd.Duration_Period_Id as Duration_Mapping_Id, bd.Batch_From, bd.Batch_To, concat(bd.Batch_Code , ''-'' , cs.Semester_Code) AS BatchSemester, D.Department_Name, D.Department_Id      
FROM            dbo.Tbl_Course_Duration_PeriodDetails AS cd LEFT OUTER JOIN      
                         dbo.Tbl_Course_Batch_Duration AS bd ON cd.Batch_Id = bd.Batch_Id LEFT OUTER JOIN      
                         dbo.Tbl_Course_Semester AS cs ON cs.Semester_Id = cd.Semester_Id LEFT OUTER JOIN      
                         dbo.Tbl_Course_Duration_Mapping AS CDM ON CDM.Duration_Period_Id = cd.Duration_Period_Id LEFT OUTER JOIN      
                         dbo.Tbl_Course_Department AS Cdep ON Cdep.Department_Id = CDM.Course_Department_Id LEFT OUTER JOIN      
                         dbo.Tbl_Course_Category AS CC ON CC.Course_Category_Id = Cdep.Course_Category_Id LEFT OUTER JOIN      
                         dbo.Tbl_Department AS D ON D.Department_Id = Cdep.Department_Id         
--where      Cdep.Course_Department_Id=@Course_Department_Id --Cdep.Department_Id=@Course_Department_Id          
 where D.Department_Id=@Course_Department_Id       
 END 
    ')
END
GO
