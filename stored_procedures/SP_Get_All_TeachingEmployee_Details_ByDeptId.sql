IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_TeachingEmployee_Details_ByDeptId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_All_TeachingEmployee_Details_ByDeptId]
        @Dept_Id BIGINT
        AS
        BEGIN
            SELECT * 
            FROM (
                SELECT 
                    ROW_NUMBER() OVER (
                        PARTITION BY Tbl_Employee.Employee_Id 
                        ORDER BY Tbl_Employee.Employee_Id
                    ) AS num,
                    Tbl_Employee.Employee_Id,
                    Tbl_Employee.Employee_FName + '' '' + Tbl_Employee.Employee_LName AS [Name],
                    Tbl_Grade_Mapping.Emp_Grade_Id,
                    Tbl_Employee_Grade.Emp_Grade_Name,
                    Tbl_Grade_Salary.Basic_Salary,
                    Tbl_Grade_Salary.Total_Salary,
                    Tbl_Emp_Department.Dept_Id,
                    Tbl_Emp_Department.Dept_Name,
                    Tbl_Employee.Employee_Status
                FROM 
                    Tbl_Employee
                INNER JOIN 
                    Tbl_Grade_Mapping ON Tbl_Employee.Employee_Id = Tbl_Grade_Mapping.Employee_Id
                INNER JOIN 
                    Tbl_Employee_Grade ON Tbl_Grade_Mapping.Emp_Grade_Id = Tbl_Employee_Grade.Emp_Grade_Id
                INNER JOIN 
                    Tbl_Grade_Salary ON Tbl_Employee_Grade.Emp_Grade_Id = Tbl_Grade_Salary.Grade_Id
                INNER JOIN 
                    Tbl_Salary_Head ON Tbl_Grade_Salary.Salary_Head_ID = Tbl_Salary_Head.Salary_Head_Id
                INNER JOIN 
                    Tbl_Employee_Official ON Tbl_Employee.Employee_Id = Tbl_Employee_Official.Employee_Id
                INNER JOIN 
                    Tbl_Emp_Department ON Tbl_Emp_Department.Dept_Id = Tbl_Employee_Official.Department_Id
                WHERE 
                    Tbl_Emp_Department.Dept_Id = @Dept_Id 
                    AND Tbl_Employee.Employee_Status = ''False'' 
                    AND Employee_Type = ''Teaching''
            ) AS tbl
            WHERE tbl.num = 1
            ORDER BY Employee_Id DESC
        END
    ')
END
