IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_CANDIDATE_ATTENDANCE_PIVOT]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_GET_CANDIDATE_ATTENDANCE_PIVOT]
    @Candidate_Id BIGINT
    --@FromDate DATETIME,
    --@ToDate DATETIME
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DynamicColumns NVARCHAR(MAX) = '''';
    DECLARE @SQL NVARCHAR(MAX);

    -- Generate dynamic column names (date + session/timing to avoid duplicates)
    SELECT @DynamicColumns = STRING_AGG(QUOTENAME(FORMAT(Absent_Date, ''dd-MM'') + ''_'' + CAST(Class_Timings_Id AS NVARCHAR)), '','')
    FROM (
        SELECT DISTINCT CAST(Absent_Date AS DATE) AS Absent_Date, Class_Timings_Id
        FROM Tbl_Student_Absence
        WHERE Candidate_Id = @Candidate_Id
       -- AND Absent_Date BETWEEN @FromDate AND @ToDate
    ) AS Dates;

    -- If no attendance records exist, return an empty result
    IF @DynamicColumns IS NULL OR @DynamicColumns = ''''
    BEGIN
        SELECT ''No attendance records found for the given date range'' AS Message;
        RETURN;
    END;

    -- Construct dynamic SQL for PIVOT
    SET @SQL = ''WITH AttendanceData AS (
        SELECT 
            SA.Candidate_Id,
            NC.Course_Name AS SubjectName,
            FORMAT(SA.Absent_Date, ''''dd-MM'''') + ''''_'''' + CAST(SA.Class_Timings_Id AS NVARCHAR) AS AttendanceDate,
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
        WHERE SA.Candidate_Id = @Candidate_Id
      
    )
    , AttendanceMetrics AS (
        SELECT 
            SubjectName,
            COUNT(DISTINCT AttendanceDate) AS TotalDays,
            SUM(CASE WHEN IsAbsent = ''''P'''' THEN 1 ELSE 0 END) AS PresentDays,
            CASE 
                WHEN COUNT(DISTINCT AttendanceDate) > 0 
                THEN (CAST(SUM(CASE WHEN IsAbsent = ''''P'''' THEN 1 ELSE 0 END) AS DECIMAL) / 
                      COUNT(DISTINCT AttendanceDate)) * 100 
                ELSE 0 
            END AS Percentage
        FROM AttendanceData
        GROUP BY SubjectName
    )
    SELECT 
        Results.*,
        m.TotalDays,
        m.PresentDays,
        m.Percentage
    FROM (
        SELECT 
            SubjectName,
            '' + @DynamicColumns + ''
        FROM AttendanceData
        PIVOT (
            MAX(IsAbsent)
            FOR AttendanceDate IN ('' + @DynamicColumns + '')
        ) AS pvt
    ) Results
    INNER JOIN AttendanceMetrics m ON m.SubjectName = Results.SubjectName
    ORDER BY Results.SubjectName;'';

    -- Execute the dynamic SQL
    EXEC sp_executesql @SQL, 
        N''@Candidate_Id BIGINT'', 
        @Candidate_Id;
END;');
END;
