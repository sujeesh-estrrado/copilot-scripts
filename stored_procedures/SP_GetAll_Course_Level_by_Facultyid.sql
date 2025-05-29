IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Course_Level_by_Facultyid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetAll_Course_Level_by_Facultyid]
 (@facultyid bigint) 
AS  
  
BEGIN  
  
 SELECT  Course_Level_Id,Course_Level_Name,Course_Level_Descripition,Course_Level_Date  
  FROM [dbo].[Tbl_Course_Level] CL inner join Tbl_Emp_CourseDepartment_Allocation EC on EC.Allocated_CourseDepartment_Id=CL.Course_Level_Id
   where Course_Level_Status=0  and EC.Employee_Id=@facultyid
order by  Course_Level_Name
     
END 
');
END;