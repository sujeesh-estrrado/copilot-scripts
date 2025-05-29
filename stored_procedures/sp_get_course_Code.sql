IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_get_course_Code]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_get_course_Code] --1
 @Org_Id bigint  =0,
 @facultyid bigint=0
As
Begin
if(@facultyid=0)
begin
   Select  Department_Id,Course_Code,Department_Name from Tbl_Department where Department_Status=0 and 
   Active_Status=''Active'' and Delete_Status=0 and Org_Id=@Org_Id
  end
  else
  begin
    Select  Department_Id,Course_Code,Department_Name from Tbl_Department D inner join Tbl_Emp_CourseDepartment_Allocation EC on D.GraduationTypeId=EC.Allocated_CourseDepartment_Id  where Department_Status=0 and 
   Active_Status=''Active'' and Delete_Status=0 and Org_Id=@Org_Id and EC.Employee_Id=@facultyid
End
end
    ');
END;
