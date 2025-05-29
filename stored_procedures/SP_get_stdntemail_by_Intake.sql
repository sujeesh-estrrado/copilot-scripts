IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_get_stdntemail_by_Intake]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   CREATE PROCEDURE [dbo].[SP_get_stdntemail_by_Intake]   
   @Intakeid VARCHAR(MAX) = ''0''                        
AS
BEGIN
    SET NOCOUNT ON;

    -- Exit if @Intakeid is NULL, empty or ''0''
    IF @Intakeid IS NULL OR @Intakeid = ''0'' OR @Intakeid = ''''
    BEGIN
        -- No data should be fetched if @Intakeid is NULL, empty, or ''0''
        SELECT NULL AS IntakeId, NULL AS Candidate_Id, NULL AS Candidate_Name, NULL AS Emails;
        RETURN;
    END

    DECLARE @Pos INT = 0;
    DECLARE @Item VARCHAR(100);
    DECLARE @IntakeList TABLE (IntakeId BIGINT);

    -- Split @Intakeid into @IntakeList
    WHILE CHARINDEX('','', @Intakeid) > 0
    BEGIN
        SET @Pos = CHARINDEX('','', @Intakeid);
        SET @Item = SUBSTRING(@Intakeid, 1, @Pos - 1);
        INSERT INTO @IntakeList (IntakeId) VALUES (CAST(@Item AS BIGINT));
        SET @Intakeid = SUBSTRING(@Intakeid, @Pos + 1, LEN(@Intakeid));
    END;

    -- Insert the last value if any
    IF LEN(@Intakeid) > 0
        INSERT INTO @IntakeList (IntakeId) VALUES (CAST(@Intakeid AS BIGINT));

    -- Retrieve students by Intake
    SELECT 
        n.Batch_Id AS IntakeId,
        CPD.Candidate_Id,
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
        STRING_AGG(CC.Candidate_Email, '', '') AS Emails  
    FROM 
        dbo.Tbl_Candidate_Personal_Det AS CPD
        LEFT JOIN Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id = CPD.Candidate_Id
        LEFT OUTER JOIN tbl_New_Admission n ON n.New_Admission_Id = CPD.New_Admission_Id
    WHERE
        -- Intake Filter: Only fetch data if IntakeId is valid and not empty
        n.Batch_Id IN (SELECT IntakeId FROM @IntakeList)
        -- Valid Admission Check
        AND CPD.ApplicationStatus IS NOT NULL 
        AND CPD.Candidate_DelStatus = 0 

    GROUP BY n.Batch_Id, CPD.Candidate_Id, CPD.Candidate_Fname, CPD.Candidate_Lname
    ORDER BY n.Batch_Id;
END;
    ');
END;
