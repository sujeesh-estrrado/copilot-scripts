IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Exam_Attendance_report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Exam_Attendance_report]
            @flag BIGINT = 0,
            @PageSize BIGINT = 10,
            @CurrentPage BIGINT = 1,
            @Department_id BIGINT = 0,
            @intake_id BIGINT = 0
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                SELECT 
                    CPD.Batch_Id,
                    EM.Exam_Master_id,
                    CONCAT(D.department_name, ''-'', D.Course_Code) AS Program,
                    CBD.Batch_Code AS Intake,
                    D.Department_Id,
                    EA.Student_Id,
                    CONCAT(Candidate_Fname, '' '', candidate_Lname) AS CandidateName,
                    IDMatrixNo,
                    EA.Present,
                    ES.Exam_Schedule_Id,
                    ES.Exam_Name
                FROM Tbl_Exam_Master EM
                INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EM.Exam_Master_id
                INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id
                INNER JOIN Tbl_Exam_Attendance_Master EAM ON EAM.Exam_Schedule_Id = ES.Exam_Schedule_Id
                INNER JOIN Tbl_Exam_Attendance EA ON EA.Attendance_Master_Id = EAM.Attendance_Master_Id
                LEFT JOIN Tbl_Course_Duration_PeriodDetails CPD ON CPD.Duration_Period_Id = EM.Duration_Period_id
                INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CPD.Batch_Id
                    AND CBD.Batch_DelStatus = 0 
                    AND CPD.Delete_Status = 0
                INNER JOIN Tbl_Department D ON D.Department_Id = CBD.Duration_Id
                INNER JOIN Tbl_Candidate_Personal_Det CAD ON CAD.Candidate_Id = EA.Student_Id
                INNER JOIN Tbl_Course_Semester S ON S.Semester_Id = CPD.Semester_Id
                    AND S.Semester_DelStatus = 0
                WHERE 
                    (D.Department_Id = @Department_id OR @Department_id = ''0'' OR @Department_id = 0)
                    AND (CPD.Batch_Id = @intake_id OR @intake_id = ''0'' OR @intake_id = 0)
                ORDER BY EM.Exam_Master_id DESC
                OFFSET @PageSize * (@CurrentPage - 1) ROWS
                FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
            END
            IF (@flag = 1)
            BEGIN
                -- Pagination count get
                SELECT * INTO #temp
                FROM (
                    SELECT 
                        CPD.Batch_Id,
                        EM.Exam_Master_id,
                        CONCAT(D.department_name, ''-'', D.Course_Code) AS Program,
                        CBD.Batch_Code AS Intake,
                        D.Department_Id,
                        EA.Student_Id,
                        CONCAT(Candidate_Fname, '' '', candidate_Lname) AS CandidateName,
                        IDMatrixNo,
                        EA.Present,
                        ES.Exam_Schedule_Id,
                        ES.Exam_Name
                    FROM Tbl_Exam_Master EM
                    INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EM.Exam_Master_id
                    INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id
                    INNER JOIN Tbl_Exam_Attendance_Master EAM ON EAM.Exam_Schedule_Id = ES.Exam_Schedule_Id
                    INNER JOIN Tbl_Exam_Attendance EA ON EA.Attendance_Master_Id = EAM.Attendance_Master_Id
                    LEFT JOIN Tbl_Course_Duration_PeriodDetails CPD ON CPD.Duration_Period_Id = EM.Duration_Period_id
                    INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CPD.Batch_Id
                        AND CBD.Batch_DelStatus = 0
                        AND CPD.Delete_Status = 0
                    INNER JOIN Tbl_Department D ON D.Department_Id = CBD.Duration_Id
                    INNER JOIN Tbl_Candidate_Personal_Det CAD ON CAD.Candidate_Id = EA.Student_Id
                    INNER JOIN Tbl_Course_Semester S ON S.Semester_Id = CPD.Semester_Id
                        AND S.Semester_DelStatus = 0
                    WHERE 
                        (D.Department_Id = @Department_id OR @Department_id = ''0'' OR @Department_id = 0)
                        AND (CPD.Batch_Id = @intake_id OR @intake_id = ''0'' OR @intake_id = 0)
                ) base
                SELECT COUNT(*) AS totcount FROM #temp;
            END
        END
    ')
END
