IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_STUDENTS]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GET_STUDENTS] 
(
    @Course_department_id BIGINT,
    @BatchId BIGINT,
    @WeekdayName VARCHAR(50), 
    @Employee_Id BIGINT,                                   
    @DateofAttendance DATETIME,                         
    @SemesterSubjectId BIGINT,              
    @Class_Timings_Id BIGINT, 
    @TotalRecords INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Get the total number of records
    SELECT @TotalRecords = COUNT(DISTINCT CPD.Candidate_Id)
    FROM 
        Tbl_Semester_Subjects SS
        INNER JOIN Tbl_Student_Semester SSE 
            ON SSE.Duration_Mapping_Id = SS.Duration_Mapping_Id 
            AND SSE.Student_Semester_Current_Status = 1 
        INNER JOIN Tbl_Candidate_Personal_Det CPD 
            ON CPD.Candidate_Id = SSE.Candidate_Id 
        INNER JOIN Tbl_Course_Duration_PeriodDetails CDP 
            ON SSE.Duration_Mapping_Id = CDP.Duration_Period_Id
        INNER JOIN Tbl_Class_TimeTable CT 
            ON CT.Duration_Mapping_Id = CDP.Duration_Period_Id  
        LEFT JOIN Tbl_Student_Absence SA 
            ON SA.Candidate_Id = CPD.Candidate_Id
            AND SA.Employee_Id = @Employee_Id                
            AND SA.Subject_Id  = @SemesterSubjectId        
            AND SA.Class_Timings_Id = @Class_Timings_Id          
            AND SA.Absent_Date = CONVERT(DATETIME, @DateofAttendance, 103)
    WHERE
        CT.Department_Id = @Course_department_id
        AND CT.Duration_Mapping_Id = @BatchId
        AND CPD.ApplicationStatus = ''Completed'';

    -- Fetch all student data
    SELECT DISTINCT
        CPD.Candidate_Id,
        ISNULL(CPD.Candidate_Fname, '''') + '' '' + 
        ISNULL(CPD.Candidate_Mname, '''') + '' '' + 
        ISNULL(CPD.Candidate_Lname, '''') AS CandidateName,
        CPD.AdharNumber,
        CPD.IDMatrixNo AS StudentId,
        COALESCE(SA.Absent_Type, ''A'') AS AttendanceStatus,
        SA.Remark,
        @TotalRecords AS TotalRecords
    FROM 
        Tbl_Semester_Subjects SS
        INNER JOIN Tbl_Student_Semester SSE 
            ON SSE.Duration_Mapping_Id = SS.Duration_Mapping_Id 
            AND SSE.Student_Semester_Current_Status = 1 
        INNER JOIN Tbl_Candidate_Personal_Det CPD 
            ON CPD.Candidate_Id = SSE.Candidate_Id 
        INNER JOIN Tbl_Course_Duration_PeriodDetails CDP 
            ON SSE.Duration_Mapping_Id = CDP.Duration_Period_Id
        INNER JOIN Tbl_Class_TimeTable CT 
            ON CT.Duration_Mapping_Id = CDP.Duration_Period_Id  
        LEFT JOIN Tbl_Student_Absence SA 
            ON SA.Candidate_Id = CPD.Candidate_Id
            AND SA.Employee_Id = @Employee_Id                
            AND SA.Subject_Id  = @SemesterSubjectId        
            AND SA.Class_Timings_Id = @Class_Timings_Id          
            AND SA.Absent_Date = CONVERT(DATETIME, @DateofAttendance, 103)
    WHERE
        CT.Department_Id = @Course_department_id
        AND CT.Duration_Mapping_Id = @BatchId
        AND CPD.ApplicationStatus = ''Completed''
    ORDER BY CandidateName;
END;
    ')
END;
