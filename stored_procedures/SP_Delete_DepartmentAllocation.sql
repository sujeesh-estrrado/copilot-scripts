IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_DepartmentAllocation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Delete_DepartmentAllocation]    
(@Allocated_CourseDepartment_Id bigint,@Employee_Id bigint)    
AS    
BEGIN    
--UPDATE Tbl_Emp_CourseDepartment_Allocation     
--SET Emp_DepartmentAllocation_Status=1   
Delete From  Tbl_Emp_CourseDepartment_Allocation
WHERE Allocated_CourseDepartment_Id=@Allocated_CourseDepartment_Id   
and Employee_Id=@Employee_Id  
    
END
    ')
END
