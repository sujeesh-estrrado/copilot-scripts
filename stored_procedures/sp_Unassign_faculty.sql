IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Unassign_faculty]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
  CREATE procedure [dbo].[sp_Unassign_faculty](@Emp_DepartmentAllocation_Id bigint=0)
  as
  begin
  update Tbl_Emp_CourseDepartment_Allocation set Emp_DepartmentAllocation_Status=1 where Emp_DepartmentAllocation_Id=@Emp_DepartmentAllocation_Id;


  UPDATE Tbl_Emp_Intake_Program_Course_Mapping 
    SET Del_Status = 1
    WHERE Emp_DepartmentAllocation_Id IN (
        SELECT Emp_DepartmentAllocation_Id 
        FROM Tbl_Emp_CourseDepartment_Allocation
        WHERE Emp_DepartmentAllocation_Id = @Emp_DepartmentAllocation_Id
    );
  end
    ')
END
