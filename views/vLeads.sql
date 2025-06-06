IF NOT EXISTS (
    SELECT 1 FROM sys.views WHERE object_id = OBJECT_ID(N'[dbo].[vLeads]')
)
BEGIN
    EXEC('
        CREATE VIEW [dbo].[vLeads] AS
        SELECT 
            cpd.Candidate_Id AS ID,
            TRIM(CONCAT(TRIM(cpd.Candidate_FName), '' '', TRIM(cpd.Candidate_LName))) AS fullName,
            cpd.AdharNumber AS IDNo,
            cc.Candidate_Mob1 AS mobileNo,
            cc.Candidate_Email AS email,
            cpd.Scolorship_Remark AS remark,
            cpd.RegDate,
            cpd.Source_name AS sourceName,
            cpd.SourceofInformation AS sourceType,
            cpd.CounselorEmployee_id AS counsellorID,
            cpd.ApplicationStage AS applicationStatus,
            cpd.ApplicationStatus AS marketingStatus,
            ISNULL(cpd.feeStatus, ''Not Paid'') AS feeStatus,
            fd.followupStatus
        FROM Tbl_Lead_Personal_Det AS cpd
        LEFT JOIN Tbl_Lead_ContactDetails AS cc 
            ON cpd.Candidate_Id = cc.Candidate_Id
        LEFT OUTER JOIN (
            SELECT 
                Candidate_Id, 
                Respond_Type AS followupStatus
            FROM Tbl_FollowUpLead_Detail
            WHERE ISNULL(Delete_Status, 0) = 0
                AND Follow_Up_Detail_Id IN (
                    SELECT MAX(Follow_Up_Detail_Id)
                    FROM Tbl_FollowUpLead_Detail
                    WHERE ISNULL(Delete_Status, 0) = 0
                    GROUP BY Candidate_Id
                )
                AND Action_Taken = 0
        ) AS fd 
            ON cpd.Candidate_Id = fd.Candidate_Id
        WHERE cpd.Candidate_DelStatus = 0
    ')
END
