IF NOT EXISTS (SELECT * FROM sys.objects WHERE type = 'P' AND name = 'SP_GET_CANDIDATE_ATTENDANCE_ISSO')
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_GET_CANDIDATE_ATTENDANCE_ISSO]
    @Candidate_Id BIGINT,
    @Semester_Id BIGINT = 0,  -- Allow NULL for all semesters
    @Batch_Id BIGINT          -- Mandatory batch filter
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @SQL NVARCHAR(MAX) = '''';
    DECLARE @DynamicColumns NVARCHAR(MAX) = '''';
    DECLARE @Semesters TABLE (Semester_Id BIGINT);

    -- If semester ID is NULL or 0, get all semesters for the specified batch
    IF @Semester_Id IS NULL OR @Semester_Id = 0
    BEGIN
        INSERT INTO @Semesters
        SELECT DISTINCT Semester_Id FROM Tbl_Course_Duration_PeriodDetails
        WHERE Batch_Id = @Batch_Id;
    END
    ELSE
    BEGIN
        INSERT INTO @Semesters VALUES (@Semester_Id);
    END

    -- Generate dynamic column names for subjects
    SELECT @DynamicColumns = STRING_AGG(QUOTENAME(Course_code), '','')
    FROM (
        SELECT DISTINCT NC.Course_code
        FROM Tbl_Student_Absence SA
        INNER JOIN Tbl_New_Course NC ON SA.Subject_Id = NC.Course_Id
        INNER JOIN Tbl_Course_Duration_PeriodDetails CDP ON SA.Duration_Mapping_Id = CDP.Duration_Period_Id
        WHERE SA.Candidate_Id = @Candidate_Id
        AND CDP.Batch_Id = @Batch_Id
    ) AS Subjects;

    -- If no subjects found, exit early
    IF @DynamicColumns IS NULL OR @DynamicColumns = ''''
    BEGIN
        PRINT ''No attendance records found.'';
        RETURN;
    END;

    -- Construct dynamic SQL
    SET @SQL = ''
WITH AttendanceData AS (
    SELECT 
        FORMAT(SA.Absent_Date, ''''yyyy-MM-dd'''') AS AbsentDate,
        NC.Course_code AS Course_code,
        CAST(CC.Customize_ClassTimingId AS NVARCHAR) AS ClassHour,
        CS.Semester_Name,
        SA.Remarks,
        CASE 
            WHEN SA.Absent_Type = ''''Both'''' THEN ''''A''''
            WHEN SA.Absent_Type = ''''DL'''' THEN ''''DL''''
            WHEN SA.Absent_Type = ''''present'''' THEN ''''P''''
            WHEN SA.Absent_Type = ''''Medical'''' THEN ''''A(M)''''
            WHEN SA.Absent_Type = ''''absent'''' THEN ''''A''''
            ELSE ''''N/A''''
        END AS IsAbsent
    FROM Tbl_Student_Absence SA
    INNER JOIN Tbl_New_Course NC ON SA.Subject_Id = NC.Course_Id
    INNER JOIN Tbl_Customize_ClassTiming CC ON SA.Class_Timings_Id = CC.Customize_ClassTimingId
    INNER JOIN Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id = SA.Duration_Mapping_Id
    INNER JOIN Tbl_Course_Semester CS ON CS.Semester_Id = CDP.Semester_Id
    WHERE SA.Candidate_Id = @Candidate_Id
    AND CDP.Batch_Id = @Batch_Id
),
GroupedAttendance AS (
    SELECT 
        AbsentDate, 
        Course_code,
        Semester_Name,
        Remarks,
        STRING_AGG(IsAbsent + '''': '''' + ClassHour, '''', '''') 
            WITHIN GROUP (ORDER BY CAST(ClassHour AS INT)) AS AttendanceDetails  -- Ensuring order by Class Timing ID
    FROM AttendanceData
    GROUP BY AbsentDate, Course_code, Semester_Name, Remarks
),
PivotedData AS (
    SELECT *
    FROM (
        SELECT AbsentDate, Course_code, Semester_Name, Remarks, AttendanceDetails
        FROM GroupedAttendance
    ) AS SourceTable
    PIVOT (
        MAX(AttendanceDetails)
        FOR Course_code IN ('' + @DynamicColumns + '')
    ) AS PivotTable
)
SELECT * FROM PivotedData
ORDER BY AbsentDate;'';

    -- Execute the dynamic SQL
    EXEC sp_executesql @SQL, 
        N''@Candidate_Id BIGINT, @Batch_Id BIGINT'', 
        @Candidate_Id, @Batch_Id;
END;
    ');
END
