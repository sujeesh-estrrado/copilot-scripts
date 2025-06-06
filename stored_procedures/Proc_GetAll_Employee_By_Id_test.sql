IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_Employee_By_Id_test]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_Employee_By_Id_test]
        (
            @Employee_Id BIGINT
        )
        AS
        BEGIN
            SELECT
                Tbl_Employee.Employee_Id,
                Tbl_Employee.Employee_FName,
                Tbl_Employee.Employee_LName,
                Tbl_Employee.Employee_FName + '' '' + Tbl_Employee.Employee_LName + '' '' AS [Employee Name],
                Tbl_Employee.Employee_DOB,
                Tbl_Employee.Employee_Type AS EmployeeType,
                Tbl_Employee.Employee_DOB AS DOB,
                Employee_Gender = CASE Tbl_Employee.Employee_Gender 
                    WHEN ''Male'' THEN ''Male'' 
                    ELSE ''Female'' 
                END,
                Tbl_Employee.Employee_Present_Address,
                Tbl_Employee.Employee_Type,
                Tbl_Employee.Employee_Permanent_Address,
                Tbl_Employee.Employee_Mail,
                Tbl_Employee.Employee_Img AS Photo,
                Tbl_Employee.Employee_Phone,
                Tbl_Employee.Employee_Mobile,
                Tbl_Employee.Employee_Martial_Status,
                Tbl_Employee.Blood_Group,
                Tbl_Employee.Employee_Id_Card_No,
                Tbl_Employee.Employee_Nationality,
                Tbl_Employee.Employee_Experience_If_Any,
                Tbl_Employee.Employee_Father_Name,
                Tbl_Employee.Employee_Nominee_Name,
                Tbl_Employee.Employee_Nominee_Relation,
                Tbl_Employee.Employee_Nominee_Phone,
                Tbl_Employee.Employee_Nominee_Address,
                Tbl_Employee_Official.Employee_Official_Id,
                Tbl_Employee_Official.Employee_DOJ,
                Tbl_Employee_Official.Employee_Probation_Period,
                Tbl_Employee_Official.Employee_Confirmation_Date,
                Tbl_Employee_Official.Employee_Pan_No,
                Tbl_Employee_Official.Employee_Esi_No,
                Tbl_Employee_Official.Employee_Payment_mode,
                Tbl_Employee_Official.Employee_Bank_Account_No,
                Tbl_Employee_Official.Employee_Bank_Name,
                Tbl_Employee_Official.Employee_Mode_Job,
                Tbl_Employee_Official.Employee_Reporting_Staff,
                Tbl_Employee_Official.Department_Id AS DepartmentID,
                Tbl_Emp_Department.Dept_Name AS [Department Name],
                Tbl_Employee_Education.Employee_Education_Id,
                Tbl_Employee_Experience.Employee_Experience_id,
                Tbl_Employee_Experience.Employee_Experience_Pre_College_Name,
                Tbl_Employee_Experience.Employee_Desigination
            FROM
                dbo.Tbl_Employee
            LEFT JOIN dbo.Tbl_Employee_Official ON dbo.Tbl_Employee_Official.Employee_Id = dbo.Tbl_Employee.Employee_Id
            LEFT JOIN dbo.Tbl_Emp_Department ON Tbl_Emp_Department.Dept_Id = dbo.Tbl_Employee_Official.Department_Id
            LEFT JOIN dbo.Tbl_Employee_Education ON Tbl_Employee_Education.Employee_Id = dbo.Tbl_Employee.Employee_Id
            LEFT JOIN dbo.Tbl_Employee_Experience ON dbo.Tbl_Employee_Experience.Employee_Id = dbo.Tbl_Employee.Employee_Id
            WHERE dbo.Tbl_Employee.Employee_Id = @Employee_Id
        END
    ')
END
