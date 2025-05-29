IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_EXAM_Result_NEW_1]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_GET_EXAM_Result_NEW_1]  --93         
    (@Candidate_Id BIGINT)            
    
    AS
    BEGIN            
    
    SELECT DISTINCT 
        CPD.Candidate_Id,
        CPD.Candidate_Fname + '' '' + ISNULL(CPD.Candidate_Mname, '''') + '' '' + CPD.Candidate_Lname AS CANDIDNAME,
        ECM.Exam_Term,
        CC.Candidate_Nationality,
        CC.AdharNumber,
        CBD.Batch_Code,
        D.Department_Name,
        CS.Semester_Name,
        CPD.Candidate_idNo
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
    WHERE 
        CPD.Candidate_Id = @Candidate_Id
        AND GC.OpenStatus = 1
    END
    ')
END
ELSE
BEGIN
    EXEC('
    ALTER PROCEDURE [dbo].[SP_GET_EXAM_Result_NEW_1]  --93         
    (@Candidate_Id BIGINT)            
    
    AS
    BEGIN            
    
    SELECT DISTINCT 
        CPD.Candidate_Id,
        CPD.Candidate_Fname + '' '' + ISNULL(CPD.Candidate_Mname, '''') + '' '' + CPD.Candidate_Lname AS CANDIDNAME,
        ECM.Exam_Term,
        CC.Candidate_Nationality,
        CC.AdharNumber,
        CBD.Batch_Code,
        D.Department_Name,
        CS.Semester_Name,
        CPD.Candidate_idNo
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
    WHERE 
        CPD.Candidate_Id = @Candidate_Id
        AND GC.OpenStatus = 1
    END
    ')
END
