IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_get_stdnt]') 
    AND type = N'P'
)
BEGIN
    EXEC('
  
CREATE PROCEDURE [dbo].[SP_get_stdnt]   
   @FacultyId VARCHAR(MAX) = NULL,                        
   @ProgramId VARCHAR(MAX) = NULL,                                           
   @Intakeid VARCHAR(MAX) = NULL 
AS
BEGIN
    DECLARE @Pos INT, @Item VARCHAR(100);

    DECLARE @FacultyList TABLE (FacultyId BIGINT);
    DECLARE @ProgramList TABLE (ProgramId BIGINT);
    DECLARE @IntakeList TABLE (IntakeId BIGINT);

    -- Faculty Split
    WHILE CHARINDEX('','', @FacultyId) > 0
    BEGIN
        SET @Pos = CHARINDEX('','', @FacultyId);
        SET @Item = LTRIM(RTRIM(SUBSTRING(@FacultyId, 1, @Pos - 1)));
        INSERT INTO @FacultyList VALUES (CAST(@Item AS BIGINT));
        SET @FacultyId = SUBSTRING(@FacultyId, @Pos + 1, LEN(@FacultyId));
    END
    IF ISNULL(@FacultyId, '''') <> ''''
        INSERT INTO @FacultyList VALUES (CAST(@FacultyId AS BIGINT));

    -- Program Split
    WHILE CHARINDEX('','', @ProgramId) > 0
    BEGIN
        SET @Pos = CHARINDEX('','', @ProgramId);
        SET @Item = LTRIM(RTRIM(SUBSTRING(@ProgramId, 1, @Pos - 1)));
        INSERT INTO @ProgramList VALUES (CAST(@Item AS BIGINT));
        SET @ProgramId = SUBSTRING(@ProgramId, @Pos + 1, LEN(@ProgramId));
    END
    IF ISNULL(@ProgramId, '''') <> ''''
        INSERT INTO @ProgramList VALUES (CAST(@ProgramId AS BIGINT));

    -- Intake Split
    WHILE CHARINDEX('','', @Intakeid) > 0
    BEGIN
        SET @Pos = CHARINDEX('','', @Intakeid);
        SET @Item = LTRIM(RTRIM(SUBSTRING(@Intakeid, 1, @Pos - 1)));
        INSERT INTO @IntakeList VALUES (CAST(@Item AS BIGINT));
        SET @Intakeid = SUBSTRING(@Intakeid, @Pos + 1, LEN(@Intakeid));
    END
    IF ISNULL(@Intakeid, '''') <> ''''
        INSERT INTO @IntakeList VALUES (CAST(@Intakeid AS BIGINT));

    -- Final Query
    SELECT DISTINCT
        CPD.Candidate_Id,
        n.Batch_Id AS IntakeId,
        n.Course_Level_Id AS FacultyId,
        n.Department_Id AS ProgramId,
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS CandidateName
    FROM 
        dbo.Tbl_Candidate_Personal_Det AS CPD
        INNER JOIN Tbl_Student_status S ON S.id = CPD.active
        LEFT JOIN Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id = CPD.Candidate_Id
        LEFT OUTER JOIN tbl_New_Admission n ON n.New_Admission_Id = CPD.New_Admission_Id
    WHERE
        (NOT EXISTS (SELECT 1 FROM @FacultyList) OR n.Course_Level_Id IN (SELECT FacultyId FROM @FacultyList))
        AND (NOT EXISTS (SELECT 1 FROM @ProgramList) OR n.Department_Id IN (SELECT ProgramId FROM @ProgramList))
        AND (NOT EXISTS (SELECT 1 FROM @IntakeList) OR n.Batch_Id IN (SELECT IntakeId FROM @IntakeList))
        AND CPD.ApplicationStatus in(''Completed'',''Approved'')
        AND CPD.active = 3
        AND CPD.Candidate_DelStatus = 0 
        AND ISNULL(CPD.New_Admission_Id, 0) <> 0

    ORDER BY 
        n.Batch_Id, 
        n.Course_Level_Id, 
        n.Department_Id;
END
');
END;
