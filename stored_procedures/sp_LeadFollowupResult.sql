IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_LeadFollowupResult]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_LeadFollowupResult]
(
    @Fromdate datetime = NULL,
    @todate datetime = NULL
)
AS
BEGIN
    SELECT DISTINCT 
        CPD.Candidate_Id, 
        CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS CandidateName,
        CPD.AdharNumber,
        CC.Candidate_Mob1 AS MobileNumber,
        CC.Candidate_Email AS EmailID,
        CASE 
            WHEN CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) > 0 AND CHARINDEX('', Nationality:'', CPD.Scolorship_Remark) > 0
            THEN SUBSTRING(
                CPD.Scolorship_Remark,
                CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''),
                CHARINDEX('', Nationality:'', CPD.Scolorship_Remark) - (CHARINDEX(''Course Opted :'', CPD.Scolorship_Remark) + LEN(''Course Opted :''))
            )
            ELSE NULL
        END AS optedProgramme,
        CASE 
            WHEN CPD.Page_Id = 0 OR CPD.Page_Id IS NULL THEN ''Landing''
            ELSE (SELECT LandingiURL_Name FROM Tbl_LandingiURL WHERE LandingiURL_Id = CPD.Page_Id) 
        END AS PageName, 
        CPD.Source_name,
        CONVERT(VARCHAR(50), RegDate, 105) AS RegDate,
        CONVERT(VARCHAR(10), CAST(RegDate AS TIME), 0) AS RegDatetime,
        CASE 
            WHEN CPD.ApplicationStatus = ''Lead'' THEN ''Lead''
            WHEN CPD.ApplicationStatus = ''rejected'' THEN CONCAT(''Rejected due to :'', CPD.Reject_remark)
            ELSE ''Moved To Enquiry''
        END AS ApplicationStatus,
        CONVERT(VARCHAR(50), FD.Followup_Date, 105) AS Followup_Date,
        CONVERT(VARCHAR(10), CAST(FD.Followup_time AS TIME), 0) AS Followup_Time,
        CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS CounsellorEmployee, 
        FD.Respond_Type, 
        CPD.Scolorship_Remark
    FROM 
        Tbl_Lead_Personal_Det CPD                                
        LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id                                                 
        INNER JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id  
        LEFT JOIN (
            SELECT 
                Candidate_Id, 
                Next_Date,
                Respond_Type,
                Followup_Date,
                Followup_time,
                Remarks
            FROM 
                Tbl_FollowUpLead_Detail
            WHERE 
                (Delete_Status = 0 OR Delete_Status IS NULL)
                AND Follow_Up_Detail_Id IN (
                    SELECT MAX(Follow_Up_Detail_Id)
                    FROM Tbl_FollowUpLead_Detail
                    WHERE (Delete_Status = 0 OR Delete_Status IS NULL)
                    GROUP BY Candidate_Id
                )
                AND Action_Taken = 0
        ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id  
    WHERE 
        (@Fromdate IS NULL OR CONVERT(date, CPD.RegDate) >= CONVERT(date, @Fromdate))
        AND (@todate IS NULL OR CONVERT(date, CPD.RegDate) <= CONVERT(date, @todate))
END
');
END;