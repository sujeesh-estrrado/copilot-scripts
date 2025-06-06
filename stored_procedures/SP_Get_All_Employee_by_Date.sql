IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Employee_by_Date]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_All_Employee_by_Date]    
        (@Date VARCHAR(15))
        AS
        BEGIN
            SELECT 
                Tbl_Emp_Department.Dept_Id,
                Tbl_Emp_Department.Dept_Name,
                Tbl_Emp_Department.Dept_Id,
                Tbl_Employee.Employee_Id,
                Tbl_Employee.Employee_FName + '' '' + Tbl_Employee.Employee_LName AS [Name],
                Tbl_Employee.Employee_Id_Card_No,
                Tbl_Employee_Official.Employee_DOJ,
                Tbl_Employee_Official.Employee_Esi_No,
                Tbl_Emp_DeptDesignation.Dept_Designation_Name,
                Tbl_Employee.Employee_Father_Name,
                Tbl_Employee.Employee_Nominee_Name,
                Tbl_Employee_Salary.Basic_Salary,
                Tbl_Employee_Salary.Gross_Salary,
                Tbl_Employee_Salary.Emp_Id,
                Tbl_Employee_Salary.Date,
                dbo.Tbl_Employee_Salary_Details.Grade_Sal_Value,
                Tbl_Employee_Salary_Details.Mode_Calculation,
                dbo.Tbl_Employee_Salary_Details.Salary_Type,
                Tbl_Salary_Head.Salary_Head_Name,
                CASE 
                    WHEN Tbl_Employee_Salary_Details.Mode_Calculation = ''Percentage'' THEN 
                        ((Tbl_Employee_Salary.Basic_Salary * Tbl_Employee_Salary_Details.Grade_Sal_Value) / 100)
                    ELSE 
                        dbo.Tbl_Employee_Salary_Details.Grade_Sal_Value 
                END AS Grade_Salary_Orginal_Value
            FROM 
                Tbl_Employee 
            INNER JOIN Tbl_Grade_Mapping ON Tbl_Employee.Employee_Id = Tbl_Grade_Mapping.Employee_Id 
            INNER JOIN Tbl_Employee_Grade ON Tbl_Grade_Mapping.Emp_Grade_Id = Tbl_Employee_Grade.Emp_Grade_Id
            INNER JOIN Tbl_Employee_Official ON Tbl_Employee.Employee_Id = Tbl_Employee_Official.Employee_Id
            INNER JOIN Tbl_Emp_Department ON Tbl_Emp_Department.Dept_Id = Tbl_Employee_Official.Department_Id
            INNER JOIN Tbl_Employee_Salary ON Tbl_Employee_Salary.Emp_Id = Tbl_Employee.Employee_Id
            INNER JOIN dbo.Tbl_Employee_Salary_Details ON dbo.Tbl_Employee_Salary_Details.Employee_Salary_Id = Tbl_Employee_Salary.Employee_Salary_Id
            INNER JOIN Tbl_Emp_DeptDesignation ON Tbl_Grade_Mapping.Dept_Designation_Id = Tbl_Emp_DeptDesignation.Dept_Designation_Id
            LEFT JOIN dbo.Tbl_Salary_Head ON Tbl_Salary_Head.Salary_Head_Id = Tbl_Employee_Salary_Details.Salary_Head_Id
            WHERE Tbl_Employee_Salary.Date = @Date
            ORDER BY Tbl_Employee.Employee_Id DESC
        END
    ')
END
