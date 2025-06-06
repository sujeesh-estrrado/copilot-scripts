IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_designation]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_designation]
        (
            @employee_id BIGINT = 0
        )
        AS
        BEGIN
            SELECT dbo.Tbl_Emp_DeptDesignation.Dept_Designation_Name AS Designation
            FROM dbo.Tbl_Employee_Official
            LEFT JOIN dbo.Tbl_Employee ON dbo.Tbl_Employee_Official.Employee_Id = dbo.Tbl_Employee.Employee_Id
            LEFT JOIN Tbl_Emp_DeptDesignation ON Tbl_Employee_Official.Designation_Id = Tbl_Emp_DeptDesignation.Dept_Designation_Id
            WHERE (dbo.Tbl_Employee_Official.Delete_status = 0)  
                AND (dbo.Tbl_Employee.Employee_Status = 0)  
                AND Tbl_Employee.Employee_Id = @employee_id
        END
    ')
END
