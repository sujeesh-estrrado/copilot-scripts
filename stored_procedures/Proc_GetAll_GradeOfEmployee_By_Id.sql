IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_GradeOfEmployee_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_GradeOfEmployee_By_Id]
        (
            @Emp_Grade_Mapping_Id Bigint
        )
        AS
        BEGIN
            SELECT 
                dbo.Tbl_Grade_Mapping.Emp_Grade_Mapping_Id, 
                dbo.Tbl_Grade_Mapping.Emp_Grade_From_Date, 
                dbo.Tbl_Grade_Mapping.Emp_Grade_To_Date, 
                dbo.Tbl_Employee_Grade.Emp_Grade_Name, 
                dbo.Tbl_Employee.Employee_FName + dbo.Tbl_Employee.Employee_LName AS Employee, 
                dbo.Tbl_Employee_Grade.Emp_Grade_Id, 
                dbo.Tbl_Employee.Employee_Id,
                dbo.Tbl_Emp_DeptDesignation.Dept_Designation_Id as Designation
            FROM dbo.Tbl_Grade_Mapping 
            INNER JOIN dbo.Tbl_Employee 
                ON dbo.Tbl_Grade_Mapping.Employee_Id = dbo.Tbl_Employee.Employee_Id 
            INNER JOIN Tbl_Emp_DeptDesignation 
                ON Tbl_Grade_Mapping.Dept_Designation_Id = Tbl_Emp_DeptDesignation.Dept_Designation_Id
            INNER JOIN dbo.Tbl_Employee_Grade 
                ON dbo.Tbl_Grade_Mapping.Emp_Grade_Id = dbo.Tbl_Employee_Grade.Emp_Grade_Id
            WHERE 
                dbo.Tbl_Grade_Mapping.Emp_Grade_Mapping_Id = @Emp_Grade_Mapping_Id 
                AND dbo.Tbl_Grade_Mapping.Emp_Grade_Mapping_Status = 0 
                AND dbo.Tbl_Employee_Grade.Emp_Grade_Status = 0 
                AND dbo.Tbl_Employee.Employee_Status = 0
        END
    ')
END
