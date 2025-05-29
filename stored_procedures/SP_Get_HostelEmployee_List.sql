IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_HostelEmployee_List]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_Get_HostelEmployee_List]
    AS
    BEGIN
        SELECT 
            HER.*,
            HR.*,
            E.Employee_FName + '' '' + E.Employee_LName AS Employeename,
            E.Employee_Mobile AS EmployeeContact,
            HR.Hostel_Name AS Hostelname,
            D.Dept_Name
        FROM 
            dbo.Tbl_Hstl_EmployeeRegistration HER
        INNER JOIN 
            Tbl_Employee E ON E.Employee_Id = HER.Employee_Id
        INNER JOIN 
            dbo.Tbl_HostelRegistration HR ON HER.Hostel_Id = HR.Hostel_Id
        RIGHT JOIN 
            dbo.Tbl_Employee_Official EO ON E.Employee_Id = EO.Employee_Id
        LEFT JOIN 
            dbo.Tbl_Emp_Department D ON EO.Department_Id = D.Dept_Id
        WHERE 
            E.Employee_Status = 0 AND HER.Status = 0
    END
    ')
END
