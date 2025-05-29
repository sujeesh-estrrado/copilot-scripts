-- Check if the procedure exists before creating it
IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_STUDENTS_DETAILS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GET_STUDENTS_DETAILS]
    @SemesterSubjectId BIGINT,                
    @Location_Id BIGINT = 0,
    @FromDate DATETIME,
    @ToDate DATETIME,
    @PageSize INT = NULL,
    @CurrentPage INT = NULL,
    @Employee_Id BIGINT =0,
    @Department_Id bigint,
    @Batch_Id bigint=0
AS
BEGIN

    SET NOCOUNT ON;
    DECLARE @DynamicColumns NVARCHAR(MAX) = '''';
    DECLARE @SQL NVARCHAR(MAX);
    DECLARE @PaginationSQL NVARCHAR(MAX);
    DECLARE @Offset INT = (@CurrentPage - 1) * @PageSize;
    if(@Employee_Id=0)
    begin
     -- Step 1: Check if we have any data for the given parameters
    IF NOT EXISTS (
        SELECT 1
        FROM Tbl_Student_Absence SA
        WHERE SA.Subject_Id = @SemesterSubjectId
        AND SA.Absent_Date BETWEEN @FromDate AND @ToDate
       -- AND SA.employee_Id = @Employee_Id
        AND SA.Course_Department_Id=@Department_Id
        AND SA.Duration_Mapping_Id=@Batch_Id
    )
    BEGIN
        -- Return empty result set with correct structure
        SELECT 
            0 AS TotalCount,
            0 AS SlNo,
            '''' AS CandidateName,
            '''' AS StudentId,
            '''' AS ICPassport,
            0 AS TotalDays,
            0 AS PresentDays,
            0 AS Percentage
        WHERE 1 = 0;
        RETURN;
    END

    -- Generate dynamic columns based on distinct absent dates and class timings
    SELECT @DynamicColumns = STRING_AGG(QUOTENAME(FORMAT(Absent_Date, ''dd-MM'') + ''_T'' + CAST(Class_Timings_Id AS NVARCHAR)), '', '')
    FROM (
        SELECT DISTINCT SA.Absent_Date, SA.Class_Timings_Id
        FROM Tbl_Student_Absence SA
        WHERE SA.Absent_Date BETWEEN @FromDate AND @ToDate
        AND SA.Subject_Id = @SemesterSubjectId
        --AND SA.employee_Id = @Employee_Id
        AND SA.Course_Department_Id=@Department_Id
        AND SA.Duration_Mapping_Id=@Batch_Id
    ) AS Dates;

    -- Check if we have any dates
    IF @DynamicColumns IS NULL OR @DynamicColumns = ''''
    BEGIN
        -- Return empty result set with correct structure
        SELECT 
            0 AS TotalCount,
            0 AS SlNo,
            '''' AS CandidateName,
            '''' AS StudentId,
            '''' AS ICPassport,
            0 AS TotalDays,
            0 AS PresentDays,
            0 AS Percentage
        WHERE 1 = 0;
        RETURN;
    END

    -- Set pagination SQL
    IF @PageSize > 0 AND @CurrentPage > 0
        SET @PaginationSQL = '' OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY'';
    ELSE
        SET @PaginationSQL = '''';

    -- Create dynamic SQL
    SET @SQL = ''
WITH AttendanceData AS (
    SELECT 
        SA.Candidate_Id,
        C.Candidate_Fname + '''' '''' + ISNULL(C.Candidate_Mname, '''''''') + '''' '''' + C.Candidate_Lname AS CandidateName,
        C.IDMatrixNo AS StudentId,
        C.AdharNumber AS ICPassport,
        FORMAT(SA.Absent_Date, ''''dd-MM'''') + ''''_T'''' + CAST(SA.Class_Timings_Id AS NVARCHAR) AS DateClassTime,
        CASE 
            WHEN SA.Absent_Type = ''''Both'''' THEN ''''A''''
            WHEN SA.Absent_Type = ''''DL'''' THEN ''''DL''''
            WHEN SA.Absent_Type = ''''present'''' THEN ''''P''''
            WHEN SA.Absent_Type = ''''Medical'''' THEN ''''A(M)''''
            WHEN SA.Absent_Type = ''''absent'''' THEN ''''A''''
            ELSE ''''N/A''''
        END AS IsAbsent,
        ROW_NUMBER() OVER (PARTITION BY SA.Candidate_Id, SA.Absent_Date, SA.Class_Timings_Id ORDER BY SA.Absent_Date) AS RowNum
    FROM Tbl_Student_Absence SA
    INNER JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = SA.Candidate_Id
    INNER JOIN Tbl_Student_Semester SS ON SS.Candidate_Id = C.Candidate_Id
    WHERE 
        SS.Student_Semester_Delete_Status = 0
        AND SS.Student_Semester_Current_Status = 1
        AND SA.Subject_Id = @SemesterSubjectId
        AND SA.Absent_Date BETWEEN @FromDate AND @ToDate
        AND SA.Course_Department_Id = @Department_Id
        AND SA.Duration_Mapping_Id=@Batch_Id
)
, FilteredAttendanceData AS (
    SELECT * FROM AttendanceData WHERE RowNum = 1
)
, AttendanceMetrics AS (
    SELECT 
        CandidateName,
        StudentId,
        ICPassport,
        COUNT(DISTINCT DateClassTime) AS TotalDays,
        SUM(CASE WHEN IsAbsent = ''''P'''' THEN 1 ELSE 0 END) AS PresentDays,
        CASE 
            WHEN COUNT(DISTINCT DateClassTime) > 0 
            THEN (CAST(SUM(CASE WHEN IsAbsent = ''''P'''' THEN 1 ELSE 0 END) AS DECIMAL) / 
                  COUNT(DISTINCT DateClassTime)) * 100 
            ELSE 0 
        END AS Percentage
    FROM FilteredAttendanceData
    GROUP BY CandidateName, StudentId, ICPassport
)
SELECT 
    TotalCount = COUNT(1) OVER(),
    Results.*
FROM (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY p.CandidateName) AS SlNo,
        p.CandidateName,
        m.StudentId,
        m.ICPassport,
        '' + @DynamicColumns + '',
        m.TotalDays,
        m.PresentDays,
        m.Percentage
    FROM (
        SELECT DISTINCT 
            CandidateName,
            '' + @DynamicColumns + ''
        FROM FilteredAttendanceData
        PIVOT (
            MAX(IsAbsent)
            FOR DateClassTime IN ('' + @DynamicColumns + '')  
        ) AS pvt
    ) p
    INNER JOIN AttendanceMetrics m ON m.CandidateName = p.CandidateName
) Results
ORDER BY Results.CandidateName '' + @PaginationSQL;

    -- Execute the dynamic SQL
    IF @PageSize > 0 AND @CurrentPage > 0
        EXEC sp_executesql @SQL, 
            N''@SemesterSubjectId BIGINT, @FromDate DATETIME, @ToDate DATETIME, @Offset INT, @PageSize INT, @Employee_Id BIGINT,@Department_Id bigint,@Batch_Id bigint'', 
            @SemesterSubjectId, @FromDate, @ToDate, @Offset, @PageSize, @Employee_Id,@Department_Id,@Batch_Id;
    ELSE
        EXEC sp_executesql @SQL, 
            N''@SemesterSubjectId BIGINT, @FromDate DATETIME, @ToDate DATETIME, @Employee_Id BIGINT,@Department_Id bigint,@Batch_Id bigint'', 
            @SemesterSubjectId, @FromDate, @ToDate, @Employee_Id,@Department_Id,@Batch_Id;
    end
    else
    begin
     -- Step 1: Check if we have any data for the given parameters
    IF NOT EXISTS (
        SELECT 1
        FROM Tbl_Student_Absence SA
        WHERE SA.Subject_Id = @SemesterSubjectId
        AND SA.Absent_Date BETWEEN @FromDate AND @ToDate
        AND SA.employee_Id = @Employee_Id
        AND SA.Course_Department_Id=@Department_Id
        AND SA.Duration_Mapping_Id=@Batch_Id
    )
    BEGIN
        -- Return empty result set with correct structure
        SELECT 
            0 AS TotalCount,
            0 AS SlNo,
            '''' AS CandidateName,
            '''' AS StudentId,
            '''' AS ICPassport,
            0 AS TotalDays,
            0 AS PresentDays,
            0 AS Percentage
        WHERE 1 = 0;
        RETURN;
    END

    -- Generate dynamic columns based on distinct absent dates and class timings
    SELECT @DynamicColumns = STRING_AGG(QUOTENAME(FORMAT(Absent_Date, ''dd-MM'') + ''_T'' + CAST(Class_Timings_Id AS NVARCHAR)), '', '')
    FROM (
        SELECT DISTINCT SA.Absent_Date, SA.Class_Timings_Id
        FROM Tbl_Student_Absence SA
        WHERE SA.Absent_Date BETWEEN @FromDate AND @ToDate
        AND SA.Subject_Id = @SemesterSubjectId
        AND SA.employee_Id = @Employee_Id
        AND SA.Course_Department_Id=@Department_Id
        AND SA.Duration_Mapping_Id=@Batch_Id
    ) AS Dates;

    -- Check if we have any dates
    IF @DynamicColumns IS NULL OR @DynamicColumns = ''''
    BEGIN
        -- Return empty result set with correct structure
        SELECT 
            0 AS TotalCount,
            0 AS SlNo,
            '''' AS CandidateName,
            '''' AS StudentId,
            '''' AS ICPassport,
            0 AS TotalDays,
            0 AS PresentDays,
            0 AS Percentage
        WHERE 1 = 0;
        RETURN;
    END

    -- Set pagination SQL
    IF @PageSize > 0 AND @CurrentPage > 0
        SET @PaginationSQL = '' OFFSET @Offset ROWS FETCH NEXT @PageSize ROWS ONLY'';
    ELSE
        SET @PaginationSQL = '''';

    -- Create dynamic SQL
    SET @SQL = ''WITH AttendanceData AS (
    SELECT 
        SA.Candidate_Id,
        C.Candidate_Fname + '''' '''' + ISNULL(C.Candidate_Mname, '''''''') + '''' '''' + C.Candidate_Lname AS CandidateName,
        C.IDMatrixNo AS StudentId,
        C.AdharNumber AS ICPassport,
        FORMAT(SA.Absent_Date, ''''dd-MM'''') + ''''_T'''' + CAST(SA.Class_Timings_Id AS NVARCHAR) AS DateClassTime,
        CASE 
            WHEN SA.Absent_Type = ''''Both'''' THEN ''''A''''
            WHEN SA.Absent_Type = ''''DL'''' THEN ''''DL''''
            WHEN SA.Absent_Type = ''''present'''' THEN ''''P''''
            WHEN SA.Absent_Type = ''''Medical'''' THEN ''''A(M)''''
            WHEN SA.Absent_Type = ''''absent'''' THEN ''''A''''
            ELSE ''''N/A''''
        END AS IsAbsent
    FROM Tbl_Student_Absence SA
    INNER JOIN Tbl_Candidate_Personal_Det C ON C.Candidate_Id = SA.Candidate_Id
    INNER JOIN Tbl_Student_Semester SS ON SS.Candidate_Id = C.Candidate_Id
    WHERE 
        SS.Student_Semester_Delete_Status = 0
        AND SS.Student_Semester_Current_Status = 1
        AND SA.Subject_Id = @SemesterSubjectId
        AND SA.Absent_Date BETWEEN @FromDate AND @ToDate
        AND SA.employee_Id = @Employee_Id
        AND SA.Course_Department_Id=@Department_Id
        AND SA.Duration_Mapping_Id=@Batch_Id
),
AttendanceMetrics AS (
    SELECT 
        CandidateName,
        StudentId,
        ICPassport,
        COUNT(DISTINCT DateClassTime) AS TotalDays,
        SUM(CASE WHEN IsAbsent = ''''P'''' THEN 1 ELSE 0 END) AS PresentDays,
        CASE 
            WHEN COUNT(DISTINCT DateClassTime) > 0 
            THEN (CAST(SUM(CASE WHEN IsAbsent = ''''P'''' THEN 1 ELSE 0 END) AS DECIMAL) / 
                  COUNT(DISTINCT DateClassTime)) * 100 
            ELSE 0 
        END AS Percentage
    FROM AttendanceData
    GROUP BY CandidateName, StudentId, ICPassport
)
SELECT 
    TotalCount = COUNT(1) OVER(),
    Results.*
FROM (
    SELECT 
        ROW_NUMBER() OVER (ORDER BY p.CandidateName) AS SlNo,
        p.CandidateName,
        m.StudentId,
        m.ICPassport,
        '' + @DynamicColumns + '',
        m.TotalDays,
        m.PresentDays,
        m.Percentage
    FROM (
        SELECT DISTINCT 
            CandidateName,
            '' + @DynamicColumns + ''
        FROM AttendanceData
        PIVOT (
            MAX(IsAbsent)
            FOR DateClassTime IN ('' + @DynamicColumns + '')  
        ) AS pvt
    ) p
    INNER JOIN AttendanceMetrics m ON m.CandidateName = p.CandidateName
) Results
ORDER BY Results.CandidateName '' + @PaginationSQL;

    -- Execute the dynamic SQL
    IF @PageSize > 0 AND @CurrentPage > 0
        EXEC sp_executesql @SQL, 
            N''@SemesterSubjectId BIGINT, @FromDate DATETIME, @ToDate DATETIME, @Offset INT, @PageSize INT, @Employee_Id BIGINT,@Department_Id bigint,@Batch_Id bigint'', 
            @SemesterSubjectId, @FromDate, @ToDate, @Offset, @PageSize, @Employee_Id,@Department_Id,@Batch_Id;
    ELSE
        EXEC sp_executesql @SQL, 
            N''@SemesterSubjectId BIGINT, @FromDate DATETIME, @ToDate DATETIME, @Employee_Id BIGINT,@Department_Id bigint,@Batch_Id bigint'', 
            @SemesterSubjectId, @FromDate, @ToDate, @Employee_Id,@Department_Id,@Batch_Id;
    end
   
END;
    ')
END;
GO
