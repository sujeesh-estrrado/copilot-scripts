IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Display_PipeLine_Data]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Display_PipeLine_Data] 
            @flag INT = 0,
            @Pipeline_Id INT = '''',
            @pipelinename VARCHAR(255) = '''',
            @priority BIGINT = '''',
            @Leadstatus VARCHAR(255) = '''',
            @LeadstatusID BIGINT = 0,
            @CandidateId BIGINT = NULL
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                -- Select Pipeline details with linked lead status
                SELECT  
                    ps.Pipeline_Id AS PipeLineID,
                    Pipeline_Name AS PipeLineName,
                    STRING_AGG(lsm_map.Lead_Satus_Id, '', '') AS PipeLineLinkedStatus,
                    ISNULL(Colour, ''#CCCCCC'') AS PipeLineHeadColour,
                    STRING_AGG(ms.Lead_Status_Name, '', '') AS PipeLineLinkedStatusName
                FROM Tbl_Pipeline_Settings ps
                LEFT JOIN tbl_Lead_Status_Maping lsm_map ON ps.Pipeline_Id = lsm_map.Pipeline_Id
                LEFT JOIN Tbl_Lead_Status_Master ms ON lsm_map.Lead_Satus_Id = ms.Lead_Status_Id
                WHERE ps.Delete_Status = 0 AND ms.Lead_Status_DelStatus = 0
                GROUP BY ps.Pipeline_Id, ps.Pipeline_Name, ps.priority, ps.Colour, Linked_Lead_Status;

                -- Select Lead details
                SELECT DISTINCT 
                    CPD.Candidate_Id AS LeadId,
                    CONCAT(LTRIM(RTRIM(CPD.Candidate_Fname)), '' '', LTRIM(RTRIM(CPD.Candidate_Lname))) AS LeadName,
                    CASE 
                        WHEN NA.Department_Id = 0 THEN ''Unspecified'' 
                        ELSE (SELECT D.Department_Name FROM Tbl_Department D WHERE D.Department_Id = NA.Department_Id) 
                    END AS LeadProgrammeName,
                    CC.Candidate_ContAddress AS LeadAddress,
                    CC.Candidate_Mob1 AS LeadMobileNumber,
                    CC.Candidate_Email AS LeadEmail,
                    LM.Lead_Status_Name AS LeadStatus,
                    ISNULL(LM.Lead_Status_Id, 0) AS LeadStatusId,
                    FORMAT(FD.Next_Date, ''dd/MM/yyyy'') AS LeadFollowupDate,
                    CONCAT(EC.Employee_FName, '' '', EC.Employee_LName) AS LeadCounsellorName
                FROM Tbl_Lead_Personal_Det CPD  
                LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CPD.New_Admission_Id 
                LEFT JOIN Tbl_Lead_ContactDetails CC ON CPD.Candidate_Id = CC.Candidate_Id
                LEFT JOIN Tbl_Lead_Status_Master LM ON LM.Lead_Status_Id = CPD.LeadStatus_Id
                LEFT JOIN Tbl_Employee EC ON EC.Employee_Id = CPD.CounselorEmployee_id    
                LEFT JOIN (                              
                    SELECT Candidate_Id, Next_Date, Respond_Type 
                    FROM Tbl_FollowUpLead_Detail 
                    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
                    AND Follow_Up_Detail_Id IN                              
                    (SELECT MAX(Follow_Up_Detail_Id)  
                    FROM Tbl_FollowUpLead_Detail 
                    WHERE (Delete_Status = 0 OR Delete_Status IS NULL) 
                    GROUP BY Candidate_Id) 
                    AND Action_Taken = 0
                ) AS FD ON FD.Candidate_Id = CPD.Candidate_Id  
                WHERE CPD.Candidate_DelStatus = 0 AND CPD.LeadStatus_Id IS NOT NULL;
            END
            ELSE IF (@flag = 1)
            BEGIN
                -- Update Lead Status based on the provided CandidateId
                UPDATE Tbl_Lead_Personal_Det
                SET LeadStatus_Id = @LeadstatusID
                WHERE Candidate_Id = @CandidateId;
                SELECT SCOPE_IDENTITY();
            END
        END
    ')
END
