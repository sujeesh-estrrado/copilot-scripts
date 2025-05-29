IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_STUDENTS_Marked_Attendance]')
    AND type = N'P'
)
BEGIN
    EXEC('
    
CREATE PROCEDURE [dbo].[SP_GET_STUDENTS_Marked_Attendance] 
(
    @Course_department_id BIGINT,
    @BatchId BIGINT,
    @PageSize BIGINT = 0,    
    @CurrentPage BIGINT = 0,
    @Employee_Id BIGINT,
    @DateofAttendance DATETIME,
    @SemesterSubjectId BIGINT,              
    @Class_Timings_Id BIGINT,
    @TotalRecords INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT DISTINCT
            @TotalRecords = COUNT(DISTINCT CPD.Candidate_Id)
        FROM 
            Tbl_Student_Absence SA
            INNER JOIN Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = SA.Candidate_Id 
            INNER JOIN Tbl_Course_Duration_PeriodDetails CDP ON SA.Duration_Mapping_Id = CDP.Duration_Period_Id
            
        WHERE
             SA.Course_Department_Id = @Course_department_id
            AND SA.Duration_Mapping_Id = @BatchId
             AND SA.Subject_Id = @SemesterSubjectId        
            AND SA.Class_Timings_Id = @Class_Timings_Id    
            AND SA.employee_Id=@Employee_Id
            AND SA.Absent_Date = CONVERT(DATETIME, @DateofAttendance, 103);

    WITH StudentData AS
    (
        SELECT DISTINCT
            CPD.Candidate_Id,
            ISNULL(CPD.Candidate_Fname, '''') + '' '' + ISNULL(CPD.Candidate_Mname, '''') + '' '' + ISNULL(CPD.Candidate_Lname, '''') AS CandidateName,
            CPD.AdharNumber,
             CASE 
                WHEN SA.Absent_Type = ''Both'' THEN ''A''
                WHEN SA.Absent_Type = ''DL'' THEN ''DL''
                WHEN SA.Absent_Type = ''present'' THEN ''P''
                WHEN SA.Absent_Type = ''absent'' THEN ''A''
                ELSE ''N/A''
            END AS AttendanceStatus
        FROM 
            Tbl_Student_Absence SA
            INNER JOIN Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = SA.Candidate_Id 
            INNER JOIN Tbl_Course_Duration_PeriodDetails CDP ON SA.Duration_Mapping_Id = CDP.Duration_Period_Id
            
        WHERE
            SA.Course_Department_Id = @Course_department_id
            AND SA.Duration_Mapping_Id = @BatchId
             AND SA.Subject_Id = @SemesterSubjectId        
            AND SA.Class_Timings_Id = @Class_Timings_Id    
            AND SA.employee_Id=@Employee_Id
            AND SA.Absent_Date = CONVERT(DATETIME, @DateofAttendance, 103)

    )
    SELECT  
        ROW_NUMBER() OVER (ORDER BY CandidateName) AS SlNo, 
        Candidate_Id,
        CandidateName,
        AdharNumber,
        AttendanceStatus
    FROM StudentData
    ORDER BY CandidateName
    OFFSET @PageSize * (@CurrentPage - 1) ROWS    
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END;
    ')
END;
