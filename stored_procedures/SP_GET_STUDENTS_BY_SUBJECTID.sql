IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_STUDENTS_BY_SUBJECTID]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       

CREATE PROCEDURE [dbo].[SP_GET_STUDENTS_BY_SUBJECTID] 
(
    @Course_department_id BIGINT,
    @BatchId BIGINT,
    @WeekdayName VARCHAR(50),
    @PageSize BIGINT = 0,   
    @Employee_Id BIGINT,                                   
    @DateofAttendance DATETIME,                         
    @SemesterSubjectId BIGINT,              
    @Class_Timings_Id BIGINT,
    @CurrentPage BIGINT = 0,
    @TotalRecords INT OUTPUT
)
AS
BEGIN
    SET NOCOUNT ON;
     
    SELECT @TotalRecords = COUNT(DISTINCT CPD.Candidate_Id)
    FROM 
        --Tbl_Semester_Subjects SS
        --INNER JOIN Tbl_Student_Semester SSE 
        --    ON SSE.Duration_Mapping_Id = SS.Duration_Mapping_Id 
        --    AND SSE.Student_Semester_Current_Status = 1 
        --INNER JOIN Tbl_Candidate_Personal_Det CPD 
        --    ON CPD.Candidate_Id = SSE.Candidate_Id 
        --INNER JOIN Tbl_Course_Duration_PeriodDetails CDP 
        --    ON SSE.Duration_Mapping_Id = CDP.Duration_Period_Id
            Tbl_Candidate_Personal_Det CPD 
            INNER JOIN TBL_New_Admission NA 
            ON CPD.New_Admission_Id=NA.New_Admission_Id
            INNER JOIN Tbl_Course_Batch_Duration CBD ON 
            NA.Batch_Id=CBD.Batch_Id
            INNER JOIN Tbl_Course_Duration_PeriodDetails CDP 
                    ON CBD.Batch_Id = CDP.Batch_Id
                    
            INNER JOIN Tbl_Course_Semester CS ON CDP.Semester_Id=CS.Semester_Id
            --INNER JOIN Tbl_Student_Semester SSE 
            -- ON CPD.Candidate_Id = SSE.Candidate_Id  AND (CDP.Semester_Id=SSE.Semester_NO)
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
        AND CT.Del_Status=0;
         
    WITH StudentData AS
    (
        SELECT DISTINCT
            CPD.Candidate_Id,
            ISNULL(CPD.Candidate_Fname, '''') + '' '' + 
            ISNULL(CPD.Candidate_Mname, '''') + '' '' + 
            ISNULL(CPD.Candidate_Lname, '''') AS CandidateName,
            CPD.AdharNumber,
            CPD.IDMatrixNo AS StudentId ,
            COALESCE(SA.Absent_Type, ''A'') AS AttendanceStatus,
            SA.Remark
        FROM 
            --Tbl_Semester_Subjects SS
            --INNER JOIN Tbl_Student_Semester SSE 
            --    ON SSE.Duration_Mapping_Id = SS.Duration_Mapping_Id 
            --    AND SSE.Student_Semester_Current_Status = 1 
            --INNER JOIN Tbl_Candidate_Personal_Det CPD 
            --    ON CPD.Candidate_Id = SSE.Candidate_Id 
            --INNER JOIN Tbl_Course_Duration_PeriodDetails CDP 
            --    ON SSE.Duration_Mapping_Id = CDP.Duration_Period_Id
            Tbl_Candidate_Personal_Det CPD 
            Inner Join TBL_New_Admission NA 
            On CPD.New_Admission_Id=NA.New_Admission_Id
            Inner join Tbl_Course_Batch_Duration CBD on 
            NA.Batch_Id=CBD.Batch_Id
            INNER JOIN Tbl_Course_Duration_PeriodDetails CDP 
                    ON CBD.Batch_Id = CDP.Batch_Id
                    
            INNER JOIN Tbl_Course_Semester CS ON CDP.Semester_Id=CS.Semester_Id
            --INNER JOIN Tbl_Student_Semester SSE 
            -- ON CPD.Candidate_Id = SSE.Candidate_Id  AND (CDP.Semester_Id=SSE.Semester_NO)
            INNER JOIN Tbl_Class_TimeTable CT 
                ON CT.Duration_Mapping_Id = CDP.Duration_Period_Id  
            LEFT JOIN Tbl_Student_Absence SA 
                ON SA.Candidate_Id = CPD.Candidate_Id
                AND SA.Employee_Id = @Employee_Id                
                AND SA.Subject_Id  = @SemesterSubjectId        
                AND SA.Class_Timings_Id = @Class_Timings_Id          
                AND SA.Absent_Date = CONVERT(DATETIME, @DateofAttendance, 103)
                AND SA.Deletestatus=0
        WHERE
            CT.Department_Id = @Course_department_id
            AND CT.Duration_Mapping_Id = @BatchId
            AND CT.Del_Status=0
            AND CPD.ApplicationStatus = ''Completed''
    )
    SELECT  
        ROW_NUMBER() OVER (ORDER BY CandidateName) AS SlNo, 
        Candidate_Id,
        CandidateName,
        AdharNumber,
        StudentId,
        AttendanceStatus,
         Remark,
        @TotalRecords AS TotalRecords
    FROM StudentData
    ORDER BY CandidateName
    OFFSET @PageSize * (@CurrentPage - 1) ROWS    
    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
END;

    ')
END
