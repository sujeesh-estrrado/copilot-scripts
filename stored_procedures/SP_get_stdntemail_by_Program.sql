IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_get_stdntemail_by_Program]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   
CREATE PROCEDURE [dbo].[SP_get_stdntemail_by_Program]   
   @ProgramId VARCHAR(MAX) = ''''                        
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @Pos INT = 0;
    DECLARE @Item VARCHAR(100);
    DECLARE @ProgramList TABLE (ProgramId BIGINT);

    -- Split @ProgramId into @ProgramList
    IF @ProgramId <> ''''
    BEGIN
        WHILE CHARINDEX('','', @ProgramId) > 0
        BEGIN
            SET @Pos = CHARINDEX('','', @ProgramId);
            SET @Item = SUBSTRING(@ProgramId, 1, @Pos - 1);
            INSERT INTO @ProgramList (ProgramId) VALUES (CAST(@Item AS BIGINT));
            SET @ProgramId = SUBSTRING(@ProgramId, @Pos + 1, LEN(@ProgramId));
        END;

        -- Insert the last value
        IF LEN(@ProgramId) > 0
            INSERT INTO @ProgramList (ProgramId) VALUES (CAST(@ProgramId AS BIGINT));
    END;

    -- Retrieve students by Program
    SELECT DISTINCT
        CPD.Candidate_Id,  
        n.Department_Id AS ProgramId,
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS CandidateName,
        CC.Candidate_Email  
    FROM 
        dbo.Tbl_Candidate_Personal_Det AS CPD
        LEFT JOIN Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id = CPD.Candidate_Id
        LEFT OUTER JOIN tbl_New_Admission n ON n.New_Admission_Id = CPD.New_Admission_Id
    WHERE
        -- Program Filter
        (@ProgramId = '''' OR n.Department_Id IN (SELECT ProgramId FROM @ProgramList))

        -- Valid Admission Check
        AND CPD.ApplicationStatus IS NOT NULL 
        AND CPD.Candidate_DelStatus = 0 

    ORDER BY n.Department_Id;
END;
    ');
END;
