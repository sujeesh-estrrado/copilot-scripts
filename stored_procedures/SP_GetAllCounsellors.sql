IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAllCounsellors]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAllCounsellors]  
        AS  
        BEGIN  
            SELECT DISTINCT 
                E.Employee_Id AS Employee_Id,
                CONCAT(Employee_FName, '' '', Employee_LName) AS Employee_Name,
                E.Employee_Mail
            FROM Tbl_Employee E
            INNER JOIN Tbl_Employee_User EU ON EU.Employee_Id = E.Employee_Id
            INNER JOIN Tbl_User U ON U.user_Id = EU.User_Id
            INNER JOIN Tbl_RoleAssignment RA ON RA.employee_id = E.Employee_Id
            LEFT JOIN Tbl_Employee_Official EO ON EO.Employee_Id = E.Employee_Id
            LEFT JOIN Tbl_Emp_Department ED ON ED.Dept_Id = EO.Department_Id AND ED.Dept_Id = 10
            INNER JOIN tbl_Role R ON R.role_Id = RA.role_id
            WHERE  
                (R.role_Name = ''Counsellor'' 
                 OR R.role_Name = ''Counsellor Lead''
                 OR R.role_Name = ''Marketing Manager''
                 OR R.role_Name = ''PSO'')  
                AND Employee_Status = 0
            ORDER BY CONCAT(Employee_FName, '' '', Employee_LName)
        END
    ')
END
