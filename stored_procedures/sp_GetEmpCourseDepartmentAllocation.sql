IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetEmpCourseDepartmentAllocation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_GetEmpCourseDepartmentAllocation]
    @EmpDeptAllocationID INT
AS
BEGIN
    SELECT 
        EmployeeId,
        SubDept,
        Allocated_CourseDepartment_Id,
        BatchId,
        Courses
    FROM EmpCourseDepartmentAllocation
    WHERE Emp_DepartmentAllocation_Id = @EmpDeptAllocationID
END');
END;
