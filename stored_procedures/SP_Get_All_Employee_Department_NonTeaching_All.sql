IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_All_Employee_Department_NonTeaching_All]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_All_Employee_Department_NonTeaching_All]
        AS
        BEGIN
            SELECT * 
            FROM (
                SELECT
                    ROW_NUMBER() OVER (PARTITION BY Tbl_Emp_Department.Dept_Id ORDER BY Tbl_Emp_Department.Dept_Id) AS num,
                    Tbl_Emp_Department.Dept_Id,
                    Tbl_Emp_Department.Dept_Name AS Department,
                    Tbl_Employee.Employee_Id,
                    Tbl_Employee.Employee_FName + '' '' + Tbl_Employee.Employee_LName AS [Name]
                FROM 
                    Tbl_Employee
                INNER JOIN Tbl_Employee_Official ON Tbl_Employee.Employee_Id = Tbl_Employee_Official.Employee_Id
                INNER JOIN Tbl_Emp_Department ON Tbl_Emp_Department.Dept_Id = Tbl_Employee_Official.Department_Id
                WHERE 
                    Tbl_Employee.Employee_Type = ''Non-Teaching''
            ) AS tbl
            WHERE tbl.num = 1
            ORDER BY Dept_Id DESC
        END
    ')
END
