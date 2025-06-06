IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_CourseGrade_student]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_CourseGrade_student]
        (
            @flag BIGINT = 0,
            @PageSize BIGINT = 10,
            @CurrentPage BIGINT = 1,
            @Department_id BIGINT = 0,
            @intake_id BIGINT = 0,
            @Course_Id BIGINT = 0
        )
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                SELECT DISTINCT 
                    MA.Student_Id AS StudentId1,
                    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Studentname,
                    EXM.Exam_Master_id,
                    SG.EntryType,
                    NC.Course_Name,
                    NC.Course_Code,
                    NC.Course_Id,
                    MA.Result_status,
                    CONCAT(CBD.Batch_Code, ''-'', D.department_name, ''-'', D.Course_Code) AS Program,
                    D.Department_Id,
                    CBD.Batch_Id
                FROM Tbl_Exam_Master EXM
                INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id
                INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id
                LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id = EXM.Duration_Period_id
                INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CDP.Batch_Id
                INNER JOIN Tbl_New_Course NC ON NC.Course_id = ES.Course_id
                INNER JOIN Tbl_MarkEntryMaster MA ON MA.Exam_Id = EXM.Exam_Master_id
                INNER JOIN Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = MA.Student_Id
                INNER JOIN Tbl_Student_Semester S ON S.Candidate_Id = MA.Student_Id
                LEFT JOIN Tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
                LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
                LEFT JOIN Tbl_Student_GradeStatus SG ON SG.Student_Id = CPD.Candidate_Id
                WHERE 
                    (NC.Course_Id = @Course_Id OR @Course_Id = ''0'' OR @Course_Id = 0) 
                    AND (NA.Department_Id = @Department_id OR @Department_id = ''0'' OR @Department_id = 0)
                    AND (NA.Batch_Id = @intake_id OR @intake_id = ''0'' OR @intake_id = 0)
                ORDER BY Exam_Master_id DESC
                OFFSET @PageSize * (@CurrentPage - 1) ROWS
                FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
            END
            
            IF (@flag = 1)
            BEGIN
                -- Pagination count get
                SELECT * INTO #temp FROM (
                    SELECT DISTINCT 
                        MA.Student_Id AS StudentId1,
                        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Studentname,
                        EXM.Exam_Master_id,
                        SG.EntryType,
                        NC.Course_Name,
                        NC.Course_Code,
                        NC.Course_Id,
                        MA.Result_status,
                        CONCAT(CBD.Batch_Code, ''-'', D.department_name, ''-'', D.Course_Code) AS Program,
                        D.Department_Id,
                        CBD.Batch_Id
                    FROM Tbl_Exam_Master EXM
                    INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id
                    INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id
                    LEFT JOIN Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id = EXM.Duration_Period_id
                    INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CDP.Batch_Id
                    INNER JOIN Tbl_New_Course NC ON NC.Course_id = ES.Course_id
                    INNER JOIN Tbl_MarkEntryMaster MA ON MA.Exam_Id = EXM.Exam_Master_id
                    INNER JOIN Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = MA.Student_Id
                    INNER JOIN Tbl_Student_Semester S ON S.Candidate_Id = MA.Student_Id
                    LEFT JOIN Tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
                    LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
                    LEFT JOIN Tbl_Student_GradeStatus SG ON SG.Student_Id = CPD.Candidate_Id
                    WHERE 
                        (NC.Course_Id = @Course_Id OR @Course_Id = ''0'' OR @Course_Id = 0)
                        AND (NA.Department_Id = @Department_id OR @Department_id = ''0'' OR @Department_id = 0)
                        AND (NA.Batch_Id = @intake_id OR @intake_id = ''0'' OR @intake_id = 0)
                ) base
                SELECT COUNT(*) AS totcount FROM #temp
            END
        END
    ')
END
