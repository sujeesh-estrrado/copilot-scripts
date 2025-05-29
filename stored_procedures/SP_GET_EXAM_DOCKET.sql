IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_EXAM_DOCKET]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_GET_EXAM_DOCKET]
    (
        @Candidate_Id BIGINT,
        @ExamTerm VARCHAR(50)
    )
    AS
    BEGIN
        SELECT DISTINCT 
            CPD.Candidate_Id,
            CPD.Candidate_Fname + '' '' + CPD.Candidate_Mname + '' '' + CPD.Candidate_Lname AS CANDIDNAME,
            CPD.AdharNumber,
            ECM.Campus,
            D.Course_Code,
            CS.Semester_Code,
            CC.Candidate_idNo AS Student_Id,
            SEM.Last,
            CBD.Batch_Code,
            ECM.Exam_Term,
            ECC.Exam_Code_final,
            CONVERT(VARCHAR(50), ECM.ExamDate, 103) AS ExamDate,
            GC.ExamDescription,
            GC.Venue,
            DATENAME(WEEKDAY, ECM.ExamDate) AS ExamDay,
            CC.Candidate_PermAddress,
            CONVERT(VARCHAR(5), [From], 108) + ''-'' + CONVERT(VARCHAR(5), [to], 108) AS Exam_Duration,
            S.Subject_name,
            S.subject_code,
            S.Subject_ID
        FROM 
            dbo.Tbl_StudentExamSubjectMaster SEM
            INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD ON CPD.Candidate_Id = SEM.Candidate_Id
            INNER JOIN dbo.Tbl_StudentExamSubjectsChild SEC ON SEM.StudentExamSubjectMasterId = SEC.StudentExamSubjectMasterId
            INNER JOIN dbo.Tbl_Department D ON D.Department_Id = SEM.Department_Id
            INNER JOIN dbo.Tbl_Course_Duration_Mapping CDM ON CDM.Duration_Mapping_Id = SEM.Duration_Mapping_Id
            INNER JOIN dbo.Tbl_Course_Duration_PeriodDetails CDP ON CDP.Duration_Period_Id = CDM.Duration_Period_Id
            INNER JOIN dbo.Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = CDP.Batch_Id
            INNER JOIN dbo.Tbl_Course_Semester CS ON CS.Semester_Id = CDP.Semester_Id
            INNER JOIN dbo.Tbl_Exam_Code_Child ECC ON ECC.Exam_Code_final = SEC.ExamCode
            INNER JOIN dbo.Tbl_Exam_Code_Master ECM ON ECM.Exam_Code_Master_Id = ECC.Exam_Code_Master_Id
            INNER JOIN dbo.Tbl_GroupChangeExamDates GC ON GC.ExamCode = ECC.Exam_Code_final
            INNER JOIN dbo.Tbl_Candidate_ContactDetails CC ON CC.Candidate_Id = CPD.Candidate_Id
            INNER JOIN dbo.Tbl_Assessment_Type AT ON AT.Assesment_Type = ECC.AssesmentType
            INNER JOIN Tbl_Assessment_Code_Child ACD ON ACD.AssesSment_Type_iD = AT.Assessment_Type_iD
            INNER JOIN dbo.tbl_Subject S ON S.Subject_Id = SEC.SubjectId
        WHERE 
            SEM.Last = 1
            AND CPD.Candidate_Id = @Candidate_Id
            AND GC.OpenStatus = 1
            AND GC.ExamTerm = @ExamTerm
    END
    ')
END
