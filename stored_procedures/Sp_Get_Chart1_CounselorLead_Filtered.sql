IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_Chart1_CounselorLead_Filtered]') 
    AND type = N'P'
)
BEGIN
    EXEC('
   
CREATE PROCEDURE [dbo].[Sp_Get_Chart1_CounselorLead_Filtered]
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

DECLARE @Month int
DECLARE @Year int
declare @from datetime;
declare @to datetime;
set @Month = month(getdate());
set @Year = year(getdate());

set @from = DATEADD(month,@Month-1,DATEADD(year,@Year-1900,0)) /*First*/

set @to= DATEADD(day,-1,DATEADD(month,@Month,DATEADD(year,@Year-1900,0)))

select COUNT(cpd.Candidate_Id) AS COUNT,isnull(CC.Course_Category_Name,''Others'') Course_Category_Name from Tbl_Candidate_Personal_Det cpd 
left join tbl_New_Admission na on na.new_admission_id= cpd.new_admission_id
LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON NA.Batch_Id=CDP.Batch_Id

left join Tbl_Course_Batch_Duration cbd on cbd.batch_id = na.batch_id
left join tbl_department d on d.department_id = cbd.duration_id
left join Tbl_Course_Category cc on cc.Course_Category_Id = d.Program_Type_Id
where   cpd.RegDate >=  @from and @to >=cpd.RegDate 
     AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
           AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
           AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
  
     --  AND (NA.Course_Level_Id IN (SELECT FacultyId FROM @FacultyTable) OR @FacultyId = ''0'')
     --      AND (NA.Department_Id IN (SELECT ProgrammeId FROM @ProgrammeTable) OR @ProgrammeId = ''0'')
           
     --      AND (CDP.Duration_Period_Id IN (SELECT IntakeId FROM @IntakeTable) OR @IntakeId = ''0'')
     ---- AND (CPD.CounselorEmployee_id = @CounselorEmployeeId OR @CounselorEmployeeId = 0)
GROUP BY Course_Category_Name order by Course_Category_Name
END
    ');
END;
