IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Update_DepartmentAllocation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Update_DepartmentAllocation]
(@Employee_Id bigint,@Allocated_CourseDepartment_Id bigint,@Emp_DepartmentAllocation_Id bigint)
AS
BEGIN
UPDATE Tbl_Emp_CourseDepartment_Allocation 
SET Employee_Id=@Employee_Id,Allocated_CourseDepartment_Id=@Allocated_CourseDepartment_Id
WHERE Emp_DepartmentAllocation_Id=@Emp_DepartmentAllocation_Id

END

    ')
END
