IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetStudentExam_belowGPA_CGPA]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetStudentExam_belowGPA_CGPA]
(
    @flag BIGINT = 0,
    @PageSize BIGINT = 10,
    @CurrentPage BIGINT = 1,
    @Department_id BIGINT = 0,
    @intake_id BIGINT = 0
)
AS
BEGIN
    DECLARE @MinGPA DECIMAL(3,2) = 2.00;
    
    IF (@flag = 0) -- Get paginated student data
    BEGIN
        SELECT DISTINCT 
            MA.Student_Id AS StudentId,
            CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS StudentName,
            CPD.AdharNumber,
            CPD.IDMatrixNo,
            S.SEMESTER_NO AS SemesterId,
            cs.Semester_Name,
            D.Course_Code,
            D.Department_Name,
            EXM.Exam_Master_id,
            SG.EntryType,
            ISNULL(SG.GPA, 0.00) AS GPA,
            ISNULL(SG.CGPA, 0.00) AS CGPA
        FROM 
            Tbl_Exam_Master EXM
            INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id
            INNER JOIN Tbl_Exam_Schedule_Details ESD ON ESD.Exam_Schedule_Id = ES.Exam_Schedule_Id
            INNER JOIN Tbl_MarkEntryMaster MA ON MA.Exam_Id = EXM.Exam_Master_id
            INNER JOIN Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = MA.Student_Id
            INNER JOIN Tbl_Student_Semester S ON S.Candidate_Id = MA.Student_Id
            LEFT JOIN Tbl_Course_Semester cs ON cs.Semester_Id = s.SEMESTER_NO
            LEFT JOIN Tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
            LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
            LEFT JOIN Tbl_Student_GradeStatus SG ON SG.Student_Id = CPD.Candidate_Id
                AND SG.Exam_Master_id = EXM.Exam_Master_id 
                AND SG.Semester_Id = cs.Semester_Id
        WHERE 
            SG.GPA < @MinGPA
            AND SG.CGPA < @MinGPA
            AND (NA.Department_Id = @Department_id OR @Department_id = 0)
            AND (NA.Batch_Id = @intake_id OR @intake_id = 0)
        ORDER BY 
            EXM.Exam_Master_id DESC
        OFFSET @PageSize * (@CurrentPage - 1) ROWS
        FETCH NEXT @PageSize ROWS ONLY
        OPTION (RECOMPILE);
    END
    
    IF (@flag = 1) -- Get total count for pagination
    BEGIN
        SELECT COUNT(*) AS totcount
        FROM (
            SELECT DISTINCT MA.Student_Id
            FROM 
                Tbl_Exam_Master EXM
                INNER JOIN Tbl_Exam_Schedule ES ON ES.Exam_Master_id = EXM.Exam_Master_id
                INNER JOIN Tbl_MarkEntryMaster MA ON MA.Exam_Id = EXM.Exam_Master_id
                INNER JOIN Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = MA.Student_Id
                INNER JOIN Tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
                INNER JOIN Tbl_Student_GradeStatus SG ON SG.Student_Id = CPD.Candidate_Id
                    AND SG.Exam_Master_id = EXM.Exam_Master_id
            WHERE 
                SG.GPA < @MinGPA
                AND SG.CGPA < @MinGPA
                AND (NA.Department_Id = @Department_id OR @Department_id = 0)
                AND (NA.Batch_Id = @intake_id OR @intake_id = 0)
        ) AS base;
    END
END
');
END;