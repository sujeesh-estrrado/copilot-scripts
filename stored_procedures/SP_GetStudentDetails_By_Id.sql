IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetStudentDetails_By_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GetStudentDetails_By_Id]
(
    @StudentId BIGINT = 0
)
AS
BEGIN
    SELECT DISTINCT 
        CPD.Candidate_Id,
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS StudentName,
        CPD.AdharNumber,
        CPD.IDMatrixNo,
        D.Department_Name,
        D.Course_Code,
        NA.Department_Id,
        NA.Batch_Id,
        SS.SEMESTER_NO AS SemesterId,
        S.name AS StudentStatus,
        CL.Course_Level_Name,
        CC.Course_Category_Name,
        ISNULL(IM.intake_no, BD.Batch_Code) AS intake_no
    FROM 
        Tbl_Candidate_Personal_Det CPD
        LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id
        LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
        LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
        LEFT JOIN Tbl_Student_status S ON S.id = CPD.active
        LEFT JOIN Tbl_Student_Semester SS ON SS.Candidate_Id = CPD.Candidate_Id
        LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = NA.Course_Level_Id
        LEFT JOIN Tbl_Course_Category CC ON CC.Course_Category_Id = NA.Course_Category_Id
        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterID
    WHERE 
        CPD.Candidate_Id = @StudentId
END
');
END;