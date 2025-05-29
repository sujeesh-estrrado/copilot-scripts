IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GETFOLLOWUPLeadDETAILS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GETFOLLOWUPLeadDETAILS]
(
    @Candidate_Id BIGINT = 0,
    @Flag BIGINT = 0
)
AS
BEGIN
    IF (@Flag = 0)
    BEGIN
        SELECT DISTINCT 
            CONCAT(cpd.Candidate_Fname, '' '', cpd.Candidate_Lname) AS CandidateName,
            cpd.AdharNumber,
            ccd.Candidate_PermAddress,
            ccd.Candidate_Mob1,
            ccd.Candidate_Email,
            cpd.RegDate,
            fd.Follow_Up_Detail_Id,
            CONCAT(E.Employee_fname, '' '', E.Employee_Lname) AS Counselor_Employee,
            CONVERT(VARCHAR(50), fd.Followup_Date, 103) AS Followup_Date,
            fd.Followup_time,
            fd.Remarks,
            fd.Respond_Type,
            fd.Action_to_Be_Taken,
            fd.Action_Taken,
            CONVERT(VARCHAR(50), fd.Next_Date, 103) AS Next_Date,
            fd.Medium,
            D.Department_Name,
            fd.Call_Duration
        FROM dbo.Tbl_Lead_Personal_Det cpd
        LEFT JOIN dbo.Tbl_Lead_ContactDetails ccd ON ccd.Candidate_Id = cpd.Candidate_Id
        INNER JOIN dbo.Tbl_FollowUpLead_Detail fd ON fd.Candidate_Id = cpd.Candidate_Id
        LEFT JOIN dbo.tbl_New_Admission na ON na.New_Admission_Id = cpd.New_Admission_Id
        LEFT JOIN dbo.Tbl_Department D ON D.Department_Id = na.Department_Id
        LEFT JOIN Tbl_Employee E ON E.Employee_Id = fd.Counselor_Employee
        WHERE cpd.Candidate_Id = @Candidate_Id 
        AND (fd.Delete_Status = 0 OR fd.Delete_Status IS NULL)
    END
    
    IF (@Flag = 1) --Hold Status
    BEGIN
        SELECT * 
        FROM Tbl_Status_change_by_Marketing 
        WHERE status = ''Hold'' 
        AND (delete_status = 0 OR delete_status IS NULL)
        AND Candidate_id = @Candidate_Id
    END
    
    IF (@Flag = 2)
    BEGIN
        SELECT DISTINCT 
            cpd.Candidate_Fname + '' '' + cpd.Candidate_Mname + '' '' + cpd.Candidate_Lname AS CandidateName,
            cpd.AdharNumber,
            ccd.Candidate_PermAddress,
            ccd.Candidate_Mob1,
            ccd.Candidate_Email,
            NP.RegDate,
            fd.Follow_Up_Detail_Id,
            fd.Counselor_Employee,
            CONVERT(VARCHAR(50), fd.Followup_Date, 103) AS Followup_Date,
            fd.Followup_time,
            fd.Remarks,
            fd.Respond_Type,
            fd.Action_to_Be_Taken,
            fd.Action_Taken,
            fd.Next_Date,
            fd.Medium,
            fd.Call_Duration
        FROM Tbl_Student_NewApplication NP
        INNER JOIN dbo.Tbl_Candidate_Personal_Det cpd ON NP.Candidate_Id = cpd.Candidate_Id
        LEFT JOIN dbo.Tbl_Candidate_ContactDetails ccd ON ccd.Candidate_Id = NP.Candidate_Id
        INNER JOIN dbo.Tbl_FollowUpLead_Detail fd ON fd.Candidate_Id = NP.Candidate_Id
        WHERE cpd.Candidate_Id = @Candidate_Id 
        AND (fd.Delete_Status = 0 OR fd.Delete_Status IS NULL)
    END
    
    IF (@Flag = 3)
    BEGIN
        UPDATE dbo.Tbl_FollowUpLead_Detail
        SET Delete_Status = 1
        WHERE Candidate_Id = @Candidate_Id
    END
    
    IF (@Flag = 4)
    BEGIN
        UPDATE Tbl_Status_change_by_Marketing
        SET delete_status = 1
        WHERE Candidate_id = @Candidate_Id
    END
END
');
END;