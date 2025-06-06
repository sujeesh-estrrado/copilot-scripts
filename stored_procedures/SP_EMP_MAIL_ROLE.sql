IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_EMP_MAIL_ROLE]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_EMP_MAIL_ROLE]   
            @Role_Id VARCHAR(MAX)                      

        AS      
        BEGIN      
            -- Declare variables
            DECLARE @Pos INT;
            DECLARE @Item VARCHAR(100);
            DECLARE @RoleList TABLE (Role_Id INT);

            -- Check if @Role_Id is NULL or empty
            IF @Role_Id IS NOT NULL AND @Role_Id <> ''''
            BEGIN
                -- Split @Role_Id into @RoleList
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

            -- Select Employee_Id, Full Name, and Emails grouped by Role
            SELECT 
                r.Role_Id,
                e.Employee_Id,
                CONCAT(e.Employee_FName, '' '', e.Employee_LName) AS Employee_Name,
                STRING_AGG(e.Employee_Mail, '','' ) AS Emails
            FROM dbo.Tbl_Employee AS e
            INNER JOIN dbo.Tbl_RoleAssignment AS ra ON e.Employee_Id = ra.Employee_Id
            INNER JOIN dbo.Tbl_Role AS r ON ra.Role_Id = r.Role_Id  
            WHERE e.Employee_Status = 0
                AND (@Role_Id IS NULL OR EXISTS (SELECT 1 FROM @RoleList WHERE r.Role_Id = Role_Id))
            GROUP BY r.Role_Id, e.Employee_Id, e.Employee_FName, e.Employee_LName;
        END
    ')
END
