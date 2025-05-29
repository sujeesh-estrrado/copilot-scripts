IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_all_Active_Faculty]')
    AND type = N'P'
)
BEGIN
    EXEC sp_executesql N'
    CREATE PROCEDURE [dbo].[Sp_Get_all_Active_Faculty]
    @FacultyId VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    -- If FacultyId is NULL or empty, return all active faculties
    IF @FacultyId IS NULL OR @FacultyId = ''''
    BEGIN
        SELECT 
            D.Department_Id, 
            CONCAT(D.Department_Name, ''-'', D.Course_Code) AS Department_Name, 
            D.Course_Code, 
            D.Intro_Date, 
            CL.Course_Level_Name, 
            D.Org_Id, 
            D.Expiry_Date, 
            CL.Course_Level_Id, 
            D.Delete_Status
        FROM dbo.Tbl_Department AS D
        LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL 
            ON CL.Course_Level_Id = D.GraduationTypeId
        WHERE D.Delete_Status = 0 
          AND D.Active_Status = ''Active''
        ORDER BY D.Department_Name;
    END
    ELSE
    BEGIN
        -- Declare variables to handle the string splitting
        DECLARE @Pos INT = 0;
        DECLARE @Id INT;
        DECLARE @FacultyIdList TABLE (FacultyId INT);

        -- Loop through the comma-separated string and insert values into the table
        WHILE CHARINDEX('','', @FacultyId) > 0
        BEGIN
            SET @Pos = CHARINDEX('','', @FacultyId);
            SET @Id = CAST(SUBSTRING(@FacultyId, 1, @Pos - 1) AS INT);
            INSERT INTO @FacultyIdList (FacultyId) VALUES (@Id);
            SET @FacultyId = SUBSTRING(@FacultyId, @Pos + 1, LEN(@FacultyId));
        END;

        -- Insert the last value (after the final comma)
        IF LEN(@FacultyId) > 0
            INSERT INTO @FacultyIdList (FacultyId) VALUES (CAST(@FacultyId AS INT));

        -- Now use the FacultyIdList in the query
        SELECT 
            D.Department_Id, 
            CONCAT(D.Department_Name, ''-'', D.Course_Code) AS Department_Name, 
            D.Course_Code, 
            D.Intro_Date, 
            CL.Course_Level_Name, 
            D.Org_Id, 
            D.Expiry_Date, 
            CL.Course_Level_Id, 
            D.Delete_Status
        FROM dbo.Tbl_Department AS D
        LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL 
            ON CL.Course_Level_Id = D.GraduationTypeId
        WHERE D.Delete_Status = 0 
          AND D.Active_Status = ''Active'' 
          AND CL.Course_Level_Id IN (SELECT FacultyId FROM @FacultyIdList)
        ORDER BY D.Department_Name;
    END
END';
END;
