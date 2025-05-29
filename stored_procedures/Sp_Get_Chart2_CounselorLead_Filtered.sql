IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Chart2_CounselorLead_Filtered]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   
CREATE PROCEDURE [dbo].[Sp_Get_Chart2_CounselorLead_Filtered]
    @FacultyId NVARCHAR(MAX), 
    @ProgrammeId NVARCHAR(MAX), 
    @IntakeId NVARCHAR(MAX), 
    @CounselorEmployeeId BIGINT
AS
BEGIN

      DECLARE @FacultyTable TABLE (FacultyId INT);
    DECLARE @ProgrammeTable TABLE (ProgrammeId INT);
    DECLARE @IntakeTable TABLE (IntakeId INT);

    -- Declare helper variables
    DECLARE @HasZeroIntake BIT = CASE WHEN @IntakeId = ''0'' OR @IntakeId LIKE ''%0%'' THEN 1 ELSE 0 END;
    DECLARE @HasZeroProgram BIT = CASE WHEN @ProgrammeId = ''0'' OR @ProgrammeId LIKE ''%0%'' THEN 1 ELSE 0 END;
    DECLARE @HasZeroFaculty BIT = CASE WHEN @FacultyId = ''0'' OR @FacultyId LIKE ''%0%'' THEN 1 ELSE 0 END;

    -- Populate Intake Table
    IF @HasZeroIntake = 1
    BEGIN
        INSERT INTO @IntakeTable (IntakeId)
        SELECT DISTINCT Duration_Period_Id FROM Tbl_Course_Duration_PeriodDetails;
    END
    ELSE
    BEGIN
        INSERT INTO @IntakeTable (IntakeId)
        SELECT DISTINCT value FROM dbo.SplitStringFunction(@IntakeId, '','') WHERE value <> ''0'';
    END

    -- Populate Program Table
    IF @HasZeroProgram = 1
    BEGIN
        INSERT INTO @ProgrammeTable (ProgrammeId)
        SELECT DISTINCT ProgramId FROM Tbl_Programs;
    END
    ELSE
    BEGIN
        INSERT INTO @ProgrammeTable (ProgrammeId)
        SELECT DISTINCT value FROM dbo.SplitStringFunction(@ProgrammeId, '','') WHERE value <> ''0'';
    END
     
    IF @HasZeroFaculty = 1
    BEGIN
        INSERT INTO @FacultyTable (FacultyId)
        SELECT DISTINCT FacultyId FROM Tbl_Faculties;
    END
    ELSE
    BEGIN
        INSERT INTO @FacultyTable (FacultyId)
        SELECT DISTINCT value FROM dbo.SplitStringFunction(@FacultyId, '','') WHERE value <> ''0'';
    END
    -- Declare variables for date range
    DECLARE @Month INT;
    DECLARE @Year INT;
    DECLARE @from DATETIME;
    DECLARE @to DATETIME;

    SET @Month = MONTH(GETDATE());
    SET @Year = YEAR(GETDATE());

    SET @from = DATEADD(MONTH, @Month - 1, DATEADD(YEAR, @Year - 1900, 0)); -- First day of the current month
    SET @to = DATEADD(DAY, -1, DATEADD(MONTH, @Month, DATEADD(YEAR, @Year - 1900, 0))); -- Last day of the current month

    -- Main query
    SELECT 
        COUNT(CPD.SourceofInformation) AS COUNT, 
        SourceofInformation AS Categories
    FROM 
        Tbl_Candidate_Personal_Det CPD
    LEFT JOIN 
        tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id
    WHERE 
        CPD.SourceofInformation IS NOT NULL 
        AND CPD.SourceofInformation <> '''' 
        AND CPD.SourceofInformation <> ''--select--'' 
        AND CPD.RegDate >= @from 
        AND CPD.RegDate <= @to
  --      AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
  --      AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
        --AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
      AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
      AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
           AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
  
   GROUP BY 
        SourceofInformation
    ORDER BY 
        Categories DESC;
END
    ');
END;
