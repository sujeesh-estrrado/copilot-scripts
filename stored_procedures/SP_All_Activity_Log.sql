IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_All_Activity_Log]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_All_Activity_Log] -- 0,0,'''', '''', '''', null, 1
        (
            @CandidateID bigint = 0,  
            @EmployeeID bigint = 0,  
            @Date varchar(50) = '''',  
            @Descriptions Varchar(max) = '''',           
            @Type varchar(50) = ''all'',  
            @deptid bigint = 0,  
            @flag bigint = 0
        )
        AS 
        BEGIN
            IF (@flag = 0)
            BEGIN
                INSERT INTO Activity_Log (Student_Id, Createdby, DateCreated, Descriptions, Module, Deptid, Del_Status)
                VALUES (@CandidateID, @EmployeeID, GETDATE(), @Descriptions, @Type, @deptid, ''0'')
            END

            IF (@flag = 1)
            BEGIN
                SELECT 
                    CASE 
                        WHEN CC.Createdby = 0 THEN ''Admin'' 
                        ELSE CONCAT(Employee_FName, '' '', Employee_LName, '' ('', TR.role_Name, '')'') 
                    END AS EmployeeName,
                    CC.Descriptions,           
                    CONVERT(VARCHAR(10), CAST(CC.DateCreated AS DATETIME), 105) AS DateCreated  
                FROM Activity_Log AS CC           
                LEFT JOIN Tbl_Employee AS BB ON CC.Createdby = BB.Employee_Id 
                LEFT JOIN Tbl_RoleAssignment TRA ON TRA.employee_id = BB.Employee_Id
                LEFT JOIN tbl_Role TR ON TR.role_Id = TRA.role_id
                WHERE (CC.Module = ''all'' OR CC.Module = ''0'')          
                  AND Student_Id = @CandidateID
            END

            IF (@flag = 2)
            BEGIN
                SELECT 
                    CASE 
                        WHEN CC.Createdby = 0 THEN ''Admin'' 
                        ELSE CONCAT(Employee_FName, '' '', Employee_LName, '' ('', TR.role_Name, '')'') 
                    END AS EmployeeName, 
                    CC.Descriptions,          
                    CONVERT(VARCHAR(10), CAST(CC.DateCreated AS DATETIME), 105) AS DateCreated          
                FROM Activity_Log AS CC 
                LEFT JOIN Tbl_Employee AS BB ON CC.Createdby = BB.Employee_Id       
                LEFT JOIN Tbl_RoleAssignment TRA ON TRA.employee_id = BB.Employee_Id
                LEFT JOIN tbl_Role TR ON TR.role_Id = TRA.role_id
                WHERE Student_Id = @CandidateID  
                  AND (CC.Module = ''all'' OR CC.Module = ''finance'')           
            END

            IF (@flag = 3)
            BEGIN
                SELECT 
                    CASE 
                        WHEN CC.Createdby = 0 THEN ''Admin'' 
                        ELSE CONCAT(Employee_FName, '' '', Employee_LName, '' ('', TR.role_Name, '')'') 
                    END AS EmployeeName,           
                    CC.Descriptions,
                    CONVERT(VARCHAR(10), CAST(CC.DateCreated AS DATETIME), 105) AS DateCreated 
                FROM Activity_Log AS CC
                LEFT JOIN Tbl_Employee AS BB ON CC.Createdby = BB.Employee_Id 
                LEFT JOIN Tbl_RoleAssignment TRA ON TRA.employee_id = BB.Employee_Id
                LEFT JOIN tbl_Role TR ON TR.role_Id = TRA.role_id
                WHERE (CC.Module = ''all'' OR CC.Module = ''Registry'') 
                  AND Student_Id = @CandidateID
            END
        END
    ')
END
