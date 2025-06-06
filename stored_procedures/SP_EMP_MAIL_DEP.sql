IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_EMP_MAIL_DEP]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_EMP_MAIL_DEP]   
        @Dept_Id VARCHAR(MAX)                      
        AS
        BEGIN      
            -- Declare variables
            DECLARE @Pos INT;
            DECLARE @Item VARCHAR(100);
            DECLARE @DeptList TABLE (Dept_Id INT);

            -- Check if @Dept_Id is NULL or empty
            IF @Dept_Id IS NOT NULL AND @Dept_Id <> ''''
            BEGIN
                -- Split @Dept_Id into @DeptList
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

            -- Select Employee_Id, Full Name, and Emails grouped by Department
            SELECT 
                d.Dept_Id,
                e.Employee_Id,
                CONCAT(e.Employee_FName, '' '', e.Employee_LName) AS Employee_Name,
                STRING_AGG(e.Employee_Mail, '', '') AS Emails
            FROM dbo.Tbl_Employee AS e
            INNER JOIN dbo.Tbl_Employee_Official AS eo ON e.Employee_Id = eo.Employee_Id
            INNER JOIN dbo.Tbl_Emp_Department AS d ON eo.Department_Id = d.Dept_Id  
            WHERE e.Employee_Status = 0
                AND (@Dept_Id IS NULL OR EXISTS (SELECT 1 FROM @DeptList WHERE d.Dept_Id = Dept_Id))
            GROUP BY d.Dept_Id, e.Employee_Id, e.Employee_FName, e.Employee_LName;
        END
    ')
END
