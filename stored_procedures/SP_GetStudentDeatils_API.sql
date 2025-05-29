IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetStudentDeatils_API]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetStudentDeatils_API]
(
    @Candidate_Id BIGINT = 0
)
AS
BEGIN
    SELECT DISTINCT 
        CPD.Candidate_Id,
        CPD.AdharNumber,
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS CandidateName,
        CPD.IDMatrixNo,
        IM.intake_no AS Batch_Code,
        CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,
        D.Department_Id,
        CS.Semester_Name,
        SSS.name AS Status,
        CC.Candidate_Email AS EmailID
    FROM 
        Tbl_Candidate_Personal_Det CPD
        LEFT JOIN Tbl_Candidate_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
        LEFT JOIN Tbl_New_Admission NA ON CPD.New_Admission_Id = NA.New_Admission_Id
        LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
        LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterId
        LEFT JOIN Tbl_Student_semester SS ON SS.Candidate_Id = CPD.Candidate_Id
        LEFT JOIN Tbl_Course_Semester CS ON CS.Semester_Id = SS.SEMESTER_NO
        LEFT JOIN Tbl_Student_Status SSS ON SSS.id = CPD.active
    WHERE 
        CPD.active = 1
        AND CPD.Candidate_Id = @Candidate_Id
    ORDER BY 
        CPD.Candidate_Id DESC
END
');
END;