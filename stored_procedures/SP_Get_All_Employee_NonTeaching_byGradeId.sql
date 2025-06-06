IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Employee_NonTeaching_byGradeId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_All_Employee_NonTeaching_byGradeId]
        @Dept_Id BIGINT,  
        @Emp_Grade_Id BIGINT
        AS
        BEGIN
            SELECT * 
            FROM (
                SELECT
                    ROW_NUMBER() OVER (PARTITION BY Tbl_Employee.Employee_Id ORDER BY Tbl_Employee.Employee_Id) AS num,
                    Tbl_Emp_Department.Dept_Name,
                    Tbl_Emp_Department.Dept_Id,
                    Tbl_Employee.Employee_Id,
                    Tbl_Employee.Employee_FName + '' '' + Tbl_Employee.Employee_LName AS [Name],
                    Tbl_Grade_Mapping.Emp_Grade_Id,
                    Tbl_Employee_Grade.Emp_Grade_Name,
                    Tbl_Grade_Salary.Total_Salary
                FROM
                    Tbl_Employee
                INNER JOIN Tbl_Grade_Mapping ON Tbl_Employee.Employee_Id = Tbl_Grade_Mapping.Employee_Id
                INNER JOIN Tbl_Employee_Grade ON Tbl_Grade_Mapping.Emp_Grade_Id = Tbl_Employee_Grade.Emp_Grade_Id
                INNER JOIN Tbl_Emp_CourseDepartment_Allocation ON Tbl_Employee.Employee_Id = Tbl_Emp_CourseDepartment_Allocation.Employee_Id
                INNER JOIN Tbl_Emp_Department ON Tbl_Emp_Department.Dept_Id = Tbl_Emp_CourseDepartment_Allocation.Allocated_CourseDepartment_Id
                INNER JOIN Tbl_Grade_Salary ON Tbl_Grade_Salary.Grade_Id = Tbl_Employee_Grade.Emp_Grade_Id
                WHERE
                    Tbl_Employee.Employee_Type = ''Non-Teaching''
                    AND Tbl_Emp_Department.Dept_Id = @Dept_Id
                    AND Tbl_Employee_Grade.Emp_Grade_Id = @Emp_Grade_Id
            ) AS tbl
            WHERE tbl.num = 1
            ORDER BY Employee_Id DESC
        END
    ')
END
