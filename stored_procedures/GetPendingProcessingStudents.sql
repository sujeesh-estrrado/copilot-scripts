IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetPendingProcessingStudents]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[GetPendingProcessingStudents]
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        DISTINCT CPD.Candidate_Id AS ID, 
        CPD.IDMatrixNo, 
        CPD.Candidate_Gender, 
        CPD.IdentificationNo, 
        CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS CandidateName, 
        CPD.Candidate_Fname, 
        CPD.AdharNumber, 
        CPD.TypeOfStudent, 
        CPD.Status, 
        CPD.Candidate_Dob AS DOB, 
        CPD.New_Admission_Id AS AdmnID, 
        CPD.ApplicationStatus, 
        CC.Candidate_idNo AS IdentificationNumber, 
        CC.Candidate_ContAddress AS Address, 
        CC.Candidate_Mob1 AS MobileNumber, 
        CC.Candidate_Email, 
        CCat.Course_Category_Id, 
        cbd.Batch_Id AS BatchID, 
        cbd.Batch_Code AS Batch, 
        NA.Batch_Id, 
        im.Batch_Code AS masterintake, 
        CASE 
            WHEN NA.Batch_Id = 0 THEN ''Unspecified'' 
            ELSE (SELECT cbd.Batch_Code FROM Tbl_Course_Batch_Duration cbd WHERE cbd.Batch_Id = NA.Batch_Id) 
        END AS Batch_Code, 
        CASE 
            WHEN SR.UserId IS NULL THEN '''' 
            ELSE ISNULL(E.Employee_FName, ''Admin'') 
        END AS UserName, 
        NA.Course_Level_Id AS LevelID, 
        CL.Course_Level_Name AS LevelName, 
        NA.Course_Category_Id AS CategoryID, 
        CCat.Course_Category_Name AS Category, 
        NA.Department_Id AS DepartmentID, 
        CASE 
            WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
            ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id) 
        END AS Department_Name, 
        dbo.tbl_approval_log.Offerletter_sent AS offerletter, 
        CASE 
            WHEN dbo.tbl_approval_log.offer_letter_accept_date IS NOT NULL 
            THEN CONVERT(VARCHAR(8), dbo.tbl_approval_log.offer_letter_accept_date, 3) 
            ELSE ''-NA-'' 
        END AS offerletter_acceptdate, 
        (SELECT TOP 1 Offerletter_status FROM tbl_approval_log 
         WHERE Candidate_id = CPD.Candidate_Id 
         ORDER BY Offerletter_status) AS offersentsts, 
        (SELECT TOP 1 Conditional_offerletter FROM Tbl_Offerlettre 
         WHERE Candidate_id = CPD.Candidate_Id 
         ORDER BY Conditional_offerletter) AS Conditional_offerletter, 
        (SELECT TOP 1 Resend_offerletter FROM Tbl_Offerlettre 
         WHERE Candidate_id = CPD.Candidate_Id 
         ORDER BY Resend_offerletter) AS Resend_offerletter, 
        cpd.verifiedby, 
        CASE 
            WHEN ApprovalStatus = 1 AND R.RefundStatus = 2 THEN ''Pending Processing'' 
            ELSE ''Other Status'' 
        END AS StatusApproval, 
        CONVERT(VARCHAR, R.RequestDate, 103) AS RequestDate, 
        CONVERT(VARCHAR, R.ApprovalDate, 103) AS ApprovalDate
 
    FROM 
        dbo.Tbl_Candidate_Personal_Det AS CPD 
        LEFT JOIN dbo.tbl_approval_log 
            ON CPD.Candidate_Id = dbo.tbl_approval_log.candidate_id 
            AND dbo.tbl_approval_log.delete_status = 0 
        LEFT JOIN Tbl_Offerlettre ol 
            ON ol.candidate_id = CPD.Candidate_Id 
            AND ol.delete_status = 0 
        LEFT JOIN Approval_Request R 
            ON CPD.candidate_id = R.StudentId 
        LEFT OUTER JOIN dbo.Tbl_Candidate_ContactDetails AS CC 
            ON CPD.Candidate_Id = CC.Candidate_Id 
        LEFT OUTER JOIN dbo.Tbl_Student_Semester AS SS 
            ON SS.Candidate_Id = CPD.Candidate_Id 
            AND SS.Student_Semester_Delete_Status = 0 
            AND SS.Student_Semester_Current_Status = 1 
        LEFT OUTER JOIN dbo.Tbl_Course_Duration_Mapping AS cdm 
            ON SS.Duration_Mapping_Id = cdm.Duration_Mapping_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Duration_PeriodDetails AS cdp 
            ON cdm.Duration_Period_Id = cdp.Duration_Period_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Semester AS cs 
            ON cs.Semester_Id = cdp.Semester_Id 
        LEFT OUTER JOIN dbo.tbl_New_Admission AS NA 
            ON NA.New_Admission_Id = CPD.New_Admission_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Batch_Duration AS cbd 
            ON cbd.Batch_Id = NA.Batch_Id 
        LEFT JOIN Tbl_IntakeMaster im 
            ON im.id = cbd.intakemasterid 
        LEFT OUTER JOIN dbo.Tbl_Course_Level AS CL 
            ON CL.Course_Level_Id = NA.Course_Level_Id 
        LEFT OUTER JOIN dbo.Tbl_Course_Category AS CCat 
            ON CCat.Course_Category_Id = NA.Course_Category_Id 
        LEFT OUTER JOIN dbo.Tbl_Department AS D 
            ON NA.Department_Id = D.Department_Id 
        LEFT OUTER JOIN dbo.Tbl_Student_Registration AS SR 
            ON CPD.Candidate_Id = SR.Candidate_Id 
        LEFT OUTER JOIN dbo.Tbl_Employee AS E 
            ON E.Employee_Id = SR.UserId 

    WHERE 
        ApprovalStatus = 1 
        AND R.RefundStatus = 2;

END;
    ')
END
