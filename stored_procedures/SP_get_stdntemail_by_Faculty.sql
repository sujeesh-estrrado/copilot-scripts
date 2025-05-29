IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_get_stdntemail_by_Faculty]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   
CREATE PROCEDURE [dbo].[SP_get_stdntemail_by_Faculty]   
   @FacultyId VARCHAR(MAX) = ''''                        
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare variables
    DECLARE @Pos INT = 0;
    DECLARE @Item VARCHAR(100);
    DECLARE @FacultyList TABLE (FacultyId INT);

    -- Split @FacultyId into @FacultyList
    IF @FacultyId IS NOT NULL AND @FacultyId <> ''''
    BEGIN
        WHILE CHARINDEX('','', @FacultyId) > 0
        BEGIN
            SET @Pos = CHARINDEX('','', @FacultyId);
            SET @Item = SUBSTRING(@FacultyId, 1, @Pos - 1);
            INSERT INTO @FacultyList (FacultyId) VALUES (CAST(@Item AS INT));
            SET @FacultyId = SUBSTRING(@FacultyId, @Pos + 1, LEN(@FacultyId));
        END;

        -- Insert the last value
        IF LEN(@FacultyId) > 0
            INSERT INTO @FacultyList (FacultyId) VALUES (CAST(@FacultyId AS INT));
    END;

    -- Fetch students associated with the given FacultyId
    SELECT 
        n.Course_Level_Id AS FacultyId,
        CPD.Candidate_Id,
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
        CC.Candidate_Email  
    FROM dbo.Tbl_Candidate_Personal_Det AS CPD
    LEFT JOIN dbo.Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id = CPD.Candidate_Id
    LEFT JOIN dbo.tbl_New_Admission n ON n.New_Admission_Id = CPD.New_Admission_Id
    WHERE
        -- Filter strictly by FacultyId
        n.Course_Level_Id IN (SELECT FacultyId FROM @FacultyList)

        -- Ensure the student has a valid admission
        AND CPD.ApplicationStatus IS NOT NULL 
        AND CPD.Candidate_DelStatus = 0 

    ORDER BY n.Course_Level_Id, CPD.Candidate_Id;
END;
    ');
END;
