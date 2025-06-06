IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_get_stdntemail_by_Candidate]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[SP_get_stdntemail_by_Candidate]   
   @CandidateIdList VARCHAR(MAX) = NULL                        
AS
BEGIN
    SET NOCOUNT ON;

    -- Declare variables
    DECLARE @Pos INT = 0;
    DECLARE @Item VARCHAR(100);
    DECLARE @CandidateList TABLE (Candidate_Id BIGINT);

    -- Check if @CandidateIdList is NOT NULL and NOT empty, then split values
    IF @CandidateIdList IS NOT NULL AND @CandidateIdList <> ''''
    BEGIN
        WHILE CHARINDEX('','', @CandidateIdList) > 0
        BEGIN
            SET @Pos = CHARINDEX('','', @CandidateIdList);
            SET @Item = SUBSTRING(@CandidateIdList, 1, @Pos - 1);
            INSERT INTO @CandidateList (Candidate_Id) VALUES (CAST(@Item AS BIGINT));
            SET @CandidateIdList = SUBSTRING(@CandidateIdList, @Pos + 1, LEN(@CandidateIdList));
        END;

        -- Insert the last value
        IF LEN(@CandidateIdList) > 0
            INSERT INTO @CandidateList (Candidate_Id) VALUES (CAST(@CandidateIdList AS BIGINT));
    END;

    -- Retrieve students using Candidate_Id filter or retrieve all if NULL
    SELECT 
        CPD.Candidate_Id,  
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
        CC.Candidate_Email  
    FROM dbo.Tbl_Candidate_Personal_Det AS CPD
    LEFT JOIN dbo.Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id = CPD.Candidate_Id
    WHERE 
        -- Fetch all candidates if @CandidateIdList is NULL or empty
        (@CandidateIdList IS NULL OR NOT EXISTS (SELECT 1 FROM @CandidateList) OR CPD.Candidate_Id IN (SELECT Candidate_Id FROM @CandidateList))

        -- Valid Admission Check
        AND CPD.ApplicationStatus IS NOT NULL 
        AND CPD.Candidate_DelStatus = 0 

    ORDER BY CPD.Candidate_Id;
END;

   ')
END;
