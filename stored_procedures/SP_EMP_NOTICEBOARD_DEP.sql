IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_EMP_NOTICEBOARD_DEP]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_EMP_NOTICEBOARD_DEP]   
            @Dept_Id VARCHAR(MAX)                        

        AS
        BEGIN      
            -- Declare variables to hold the split values
            DECLARE @Pos INT = 0;
            DECLARE @Item VARCHAR(100);
            DECLARE @DeptList TABLE (Dept_Id INT);

            -- Split @Dept_Id into @DeptList
            IF @Dept_Id <> ''''
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

            -- Remove duplicate role names across employees
            WITH EmployeeRoles AS (
                SELECT  
                    e.Employee_Id, 
                    CONCAT(e.Employee_FName, '' '', e.Employee_LName) AS Employee_Name, 
                    ISNULL(d.Dept_Id, '''') AS Dept_Id,  
                    ISNULL(d.Dept_Name, '''') AS Dept_Name,
                    ra.Role_Id,
                    r.Role_Name,
                    ROW_NUMBER() OVER (PARTITION BY r.Role_Name ORDER BY e.Employee_Id) AS RowNum
                FROM dbo.Tbl_Employee AS e
                LEFT JOIN dbo.Tbl_Employee_Official AS eo ON e.Employee_Id = eo.Employee_Id
                LEFT JOIN dbo.Tbl_Emp_Department AS d ON eo.Department_Id = d.Dept_Id    
                LEFT JOIN dbo.Tbl_RoleAssignment AS ra ON e.Employee_Id = ra.Employee_Id
                LEFT JOIN dbo.Tbl_Role AS r ON ra.Role_Id = r.Role_Id
                WHERE 
                    e.Employee_Status = 0
                    -- Remove NULL role names
                    AND r.Role_Name IS NOT NULL 
                    AND r.Role_Name <> ''''
                    -- Department Filter
                    AND (@Dept_Id = '''' OR d.Dept_Id IN (SELECT Dept_Id FROM @DeptList))
            )
            SELECT 
                Employee_Id, 
                Employee_Name, 
                Dept_Id,  
                Dept_Name,
                Role_Id,
                Role_Name
            FROM EmployeeRoles
            WHERE RowNum = 1  -- Ensures only one entry per role
            ORDER BY Employee_Id, Role_Name;

        END
    ')
END
