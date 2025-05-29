IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_DepartmentAllocation_ByEmployeeId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_DepartmentAllocation_ByEmployeeId]
(@Employee_Id bigint)
AS
BEGIN

SELECT * FROM Tbl_Emp_CourseDepartment_Allocation 

Where Employee_Id=@Employee_Id and Emp_DepartmentAllocation_Status=0

END
	');
END;
