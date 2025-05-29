IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Assign_Faculty]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_GetAll_Assign_Faculty] 
@Employee_Id bigint=0
  
AS  
  
BEGIN  
  if exists(select * from Tbl_Emp_CourseDepartment_Allocation where Employee_Id= @Employee_Id)
  begin
 SELECT DISTINCT Course_Level_Id,Course_Level_Name,Course_Level_Descripition,Course_Level_Date,ABCD.Employee_Id 
  FROM [dbo].[Tbl_Course_Level] as ABC left join
  Tbl_Emp_CourseDepartment_Allocation as ABCD on ABCD.Allocated_CourseDepartment_Id=ABC.Course_Level_Id where (Employee_Id=@Employee_Id or @Employee_Id=0 or @Employee_Id is null) and Course_Level_Status=0 
order by  Course_Level_Name
end
else
begin
select * from [Tbl_Course_Level] CL    where Course_Level_Status=0   and Course_Level_Id in (select Allocated_CourseDepartment_Id from Tbl_Emp_CourseDepartment_Allocation)
end 
     
END


select * from Tbl_Emp_CourseDepartment_Allocation


    
    ')
END
GO
