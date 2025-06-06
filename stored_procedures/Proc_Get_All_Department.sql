IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_Get_All_Department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure  [dbo].[Proc_Get_All_Department]  (@facultyid bigint)
as      
begin    
if(@facultyid=0 )
begin
select distinct D.Department_ID as Course_Department_Id,D.Department_ID,D.Department_Name,D.Course_Code from dbo.Tbl_Department D       
--inner join tbl_New_Admission NA on NA.Department_Id=D.Department_Id    
inner join Tbl_Course_Department CD on CD.Department_Id=D.Department_ID      
 where D.Department_Status=0       
order by D.Department_Name      
  end
  else
  begin
  select distinct D.Department_ID as Course_Department_Id,D.Department_ID,D.Department_Name,D.Course_Code from dbo.Tbl_Department D       
inner join Tbl_Emp_CourseDepartment_Allocation EA on D.GraduationTypeId=EA.Allocated_CourseDepartment_Id 
inner join Tbl_Course_Department CD on CD.Department_Id=D.Department_ID      
 where D.Department_Status=0   and EA.Employee_Id=@facultyid
  end    
end  
    ')
END
