IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_all_CounsellorLead]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_all_CounsellorLead]
        @flag BIGINT = 0,
        @Employee BIGINT = 0
AS
BEGIN
    IF (@flag = 0)
    BEGIN
        SELECT DISTINCT 
            E.Employee_Id AS Employee_Id,
            CONCAT(Employee_FName, '' '', Employee_LName) AS Employee_Name,
            E.Employee_Mail
        FROM Tbl_Employee E
        INNER JOIN Tbl_Employee_User EU ON EU.Employee_Id = E.Employee_Id
        INNER JOIN Tbl_User U ON U.user_Id = EU.User_Id
        INNER JOIN Tbl_RoleAssignment RA ON RA.employee_id = E.Employee_Id
        INNER JOIN Tbl_Role R ON R.role_Id = RA.role_id
        WHERE (R.role_Name = ''Counsellor Lead'' OR R.role_Name = ''Marketing Manager'')
        AND Employee_Status = 0
        AND E.Employee_Id NOT IN (
            SELECT TeamLead
            FROM Tbl_Counsellor_Teamforming
            WHERE Delstatus = 0
        )
        ORDER BY CONCAT(Employee_FName, '' '', Employee_LName)
    END

    IF (@flag = 1)
    BEGIN
        SELECT DISTINCT 
            E.Employee_Id AS Employee_Id,
            CONCAT(Employee_FName, '' '', Employee_LName) AS Employee_Name,
            E.Employee_Mail
        FROM Tbl_Employee E
        INNER JOIN Tbl_Employee_User EU ON EU.Employee_Id = E.Employee_Id
        INNER JOIN Tbl_User U ON U.user_Id = EU.User_Id
        INNER JOIN Tbl_RoleAssignment RA ON RA.employee_id = E.Employee_Id
        INNER JOIN Tbl_Role R ON R.role_Id = RA.role_id
        WHERE E.Employee_Id = @Employee
        AND Employee_Status = 0
    END

    IF (@flag = 2)
    BEGIN
        SELECT DISTINCT 
            E.Employee_Id AS Employee_Id,
            CONCAT(Employee_FName, '' '', Employee_LName) AS Employee_Name,
            E.Employee_Mail
        FROM Tbl_Employee E
        INNER JOIN Tbl_Employee_User EU ON EU.Employee_Id = E.Employee_Id
        INNER JOIN Tbl_User U ON U.user_Id = EU.User_Id
        INNER JOIN Tbl_RoleAssignment RA ON RA.employee_id = E.Employee_Id
        INNER JOIN Tbl_Role R ON R.role_Id = RA.role_id
        WHERE (R.role_Name = ''Counsellor'')
        AND Employee_Status = 0
        AND E.Employee_Id NOT IN (
            SELECT TeamMembers
            FROM Tbl_Counsellor_Teamforming
            WHERE Delstatus = 0
        )
        ORDER BY CONCAT(Employee_FName, '' '', Employee_LName)
    END

    IF (@flag = 3)
    BEGIN
        SELECT DISTINCT 
            E.Employee_Id AS Employee_Id,
            CONCAT(Employee_FName, '' '', Employee_LName) AS Employee_Name,
            E.Employee_Mail
        FROM Tbl_Employee E
        INNER JOIN Tbl_Employee_User EU ON EU.Employee_Id = E.Employee_Id
        INNER JOIN Tbl_User U ON U.user_Id = EU.User_Id
        INNER JOIN Tbl_RoleAssignment RA ON RA.employee_id = E.Employee_Id
        INNER JOIN Tbl_Role R ON R.role_Id = RA.role_id
        WHERE (R.role_Name = ''Counsellor'')
        AND Employee_Status = 0
        ORDER BY CONCAT(Employee_FName, '' '', Employee_LName)
    END

    IF (@flag = 4)
    BEGIN
        SELECT DISTINCT 
            E.Employee_Id AS Employee_Id,
            CONCAT(Employee_FName, '' '', Employee_LName) AS Employee_Name,
            E.Employee_Mail
        FROM Tbl_Employee E
        INNER JOIN Tbl_Employee_User EU ON EU.Employee_Id = E.Employee_Id
        INNER JOIN Tbl_User U ON U.user_Id = EU.User_Id
        INNER JOIN Tbl_RoleAssignment RA ON RA.employee_id = E.Employee_Id
        INNER JOIN Tbl_Role R ON R.role_Id = RA.role_id
        WHERE R.role_Name NOT IN (''Counsellor'', ''PSO'', ''Director'')
        AND Employee_Status = 0
        ORDER BY CONCAT(Employee_FName, '' '', Employee_LName)
    END

    IF (@flag = 5)
    BEGIN
        SELECT 
            E.Employee_Id AS Employee_Id,
            CONCAT(Employee_FName, '' '', Employee_LName) AS Employee_Name
        FROM Tbl_Employee E
        LEFT JOIN Tbl_Counsellor_Teamforming TF ON E.Employee_Id = TF.TeamMembers
        INNER JOIN Tbl_RoleAssignment RA ON RA.employee_id = E.Employee_Id
        INNER JOIN Tbl_Role R ON R.role_Id = RA.role_id
        WHERE (R.role_Name = ''Counsellor'')
        AND (E.Employee_Status = 0 OR TF.DelStatus = 0)
        AND (TF.TeamLead = @Employee OR TF.TeamLead IS NULL)
    END
END
    ')
END
