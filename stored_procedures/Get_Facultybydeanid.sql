
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Get_Facultybydeanid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Get_Facultybydeanid](@Employee_Id bigint)
as
begin

--select * from Tbl_Emp_CourseDepartment_Allocation
--select * from tbl_employee
select distinct  E.Employee_Id,Concat(E.Employee_FName,'' '',E.employee_Lname) as Employee_Name from tbl_employee  E inner join Tbl_Emp_CourseDepartment_Allocation EC on EC.employee_id=E.employee_id left join Tbl_Course_level CL on  EC.Allocated_CourseDepartment_Id=CL.course_level_id
 where CL.faculty_dean_id=@Employee_Id and E.employee_status=0 and EC.Emp_DepartmentAllocation_Status=0


end
    ')
END;
GO
