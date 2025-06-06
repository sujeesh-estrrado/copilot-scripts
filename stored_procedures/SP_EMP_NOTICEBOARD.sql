IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_EMP_NOTICEBOARD]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_EMP_NOTICEBOARD]   
        @Dept_Id VARCHAR(MAX) = NULL,                       
        @Role_Id VARCHAR(MAX) = NULL  
        AS      
        BEGIN      
            -- Declare variables to hold the split values
            DECLARE @Pos INT = 0;
            DECLARE @Item VARCHAR(100);
            DECLARE @DeptList TABLE (Dept_Id INT);
            DECLARE @RoleList TABLE (Role_Id INT);

            -- Split @Dept_Id into @DeptList
            IF @Dept_Id IS NOT NULL AND @Dept_Id <> ''''
            BEGIN
                WHILE CHARINDEX('','', @Dept_Id) > 0
                BEGIN
                    SET @Pos = CHARINDEX('','', @Dept_Id);
                    SET @Item = SUBSTRING(@Dept_Id, 1, @Pos - 1);
                    INSERT INTO @DeptList (Dept_Id) VALUES (CAST(@Item AS INT));
                    SET @Dept_Id = SUBSTRING(@Dept_Id, @Pos + 1, LEN(@Dept_Id));
                END;

                -- Insert the last value
                IF LEN(@Dept_Id) > 0
                    INSERT INTO @DeptList (Dept_Id) VALUES (CAST(@Dept_Id AS INT));
            END;

            -- Split @Role_Id into @RoleList
            IF @Role_Id IS NOT NULL AND @Role_Id <> ''''
            BEGIN
                WHILE CHARINDEX('','', @Role_Id) > 0
                BEGIN
                    SET @Pos = CHARINDEX('','', @Role_Id);
                    SET @Item = SUBSTRING(@Role_Id, 1, @Pos - 1);
                    INSERT INTO @RoleList (Role_Id) VALUES (CAST(@Item AS INT));
                    SET @Role_Id = SUBSTRING(@Role_Id, @Pos + 1, LEN(@Role_Id));
                END;

                -- Insert the last value
                IF LEN(@Role_Id) > 0
                    INSERT INTO @RoleList (Role_Id) VALUES (CAST(@Role_Id AS INT));
            END;

            -- Fetch Employee Details with User_Id from Tbl_Employee_User
            SELECT DISTINCT 
                e.Employee_Id, 
                CONCAT(e.Employee_FName, '' '', e.Employee_LName) AS Employee_Name,
                e.Employee_Mail,
                ISNULL(d.Dept_Id, '''') AS Dept_Id,   -- Department ID added
                ISNULL(d.Dept_Name, '''') AS Dept_Name,
                ra.Role_Id,
                ISNULL(r.Role_Name, '''') AS Role_Name,
                eu.User_Id  -- Fetch User_Id from Tbl_Employee_User
            FROM dbo.Tbl_Employee AS e
            LEFT JOIN dbo.Tbl_Employee_Official AS eo ON e.Employee_Id = eo.Employee_Id
            LEFT JOIN dbo.Tbl_Emp_Department AS d ON eo.Department_Id = d.Dept_Id    
            LEFT JOIN dbo.Tbl_RoleAssignment AS ra ON e.Employee_Id = ra.Employee_Id
            LEFT JOIN dbo.Tbl_Role AS r ON ra.Role_Id = r.Role_Id
            LEFT JOIN dbo.Tbl_Employee_User AS eu ON e.Employee_Id = eu.Employee_Id  -- Added LEFT JOIN to get User_Id
            WHERE 
                e.Employee_Status = 0
                -- Fetch all employees if both Role_Id and Dept_Id are NULL or empty
                AND (
                    (@Dept_Id IS NULL OR @Dept_Id = '''' OR d.Dept_Id IN (SELECT Dept_Id FROM @DeptList))
                    OR
                    (@Role_Id IS NULL OR @Role_Id = '''' OR ra.Role_Id IN (SELECT Role_Id FROM @RoleList))
                );
        END
    ')
END
