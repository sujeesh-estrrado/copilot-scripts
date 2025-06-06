IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Display_pipeline_Filter]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Display_pipeline_Filter]
        @flag TINYINT,
        @LeadProgramme INT,
        @LeadStatus INT,
        @LeadFollowUpDate VARCHAR(15),
        @LeadCounsellor INT,
        @LeadSourceName INT,
        @LeadSourceType INT
        AS
        BEGIN
            SELECT DISTINCT 
                CPD.Candidate_Id AS LeadId,
                CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS LeadName,
                CPD.Scolorship_Remark AS LeadProgrammeName,
                CC.Candidate_ContAddress AS LeadAddress,
                CC.Candidate_Mob1 AS LeadMobileNumber,
                CC.Candidate_Email AS LeadEmail,
                LM.Lead_Status_Name AS LeadStatus,
                ISNULL(LM.Lead_Status_Id, 0) AS LeadStatusId,
                (CONVERT(nvarchar(10), FD.Next_Date, 105)) AS LeadFollowupDate
            FROM Tbl_Lead_Personal_Det CPD  
            LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id 
            LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
            LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
            LEFT JOIN (
                SELECT Candidate_Id, Next_Date, Respond_Type 
                FROM Tbl_FollowUpLead_Detail 
                WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
                AND Follow_Up_Detail_Id IN (
                    SELECT MAX(Follow_Up_Detail_Id) 
                    FROM Tbl_FollowUpLead_Detail 
                    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
                    GROUP BY Candidate_Id
                ) 
                AND Action_Taken = 0
            ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id  
            WHERE CPD.Candidate_DelStatus = 0 
            AND CPD.LeadStatus_Id IS NOT NULL
            AND (
                (ISNULL(LM.Lead_Status_Id, 0) = @LeadStatus) OR (@LeadStatus = 0)
            )
            AND 8 = 10
            --AND ((CPD.CounselorEmployee_id = @LeadCounsellor) OR (@LeadCounsellor = 0))
            --AND ((CPD.SourceofInformation = @LeadSourceType) OR (@LeadSourceType = 0))
            --AND ((NA.Department_Id = @LeadProgramme) OR (@LeadProgramme = 0))
            --AND ((@LeadSourceName))
            --AND (((CONVERT(nvarchar(10), FD.Next_Date, 105)) = @LeadFollowUpDate) OR @LeadFollowUpDate)
        END
    ')
END
