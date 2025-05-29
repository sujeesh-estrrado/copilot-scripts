IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_all_Admission_approval_request]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_all_Admission_approval_request]
        (@flag BIGINT = 0)    
        AS    
        BEGIN    
            IF (@flag = 0)    
            BEGIN    
                SELECT DISTINCT 
                    CPD.Candidate_Id,   
                    ST.Request_type AS Types, 
                    AAR.candidate_id AS ID, 
                    AAR.Approval_id,
                    AAR.Verification_status AS Status,     
                    AAR.create_date AS Date,
                    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
                    CPD.AdharNumber AS ICNO,    
                    CPD.IDMatrixNo AS MatrixNo    
                FROM dbo.Tbl_admission_approval_request AAR
                INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD 
                    ON AAR.candidate_id = CPD.Candidate_Id 
                INNER JOIN Tbl_Student_Tc_request ST 
                    ON ST.Candidate_id = CPD.Candidate_Id 
                    AND AAR.request_id = ST.tc_request_id    
                WHERE CPD.Candidate_DelStatus = 0 
                  AND AAR.Verification_status NOT IN (''Approved'', ''Rejected'')    
            END    
            ELSE    
            BEGIN     
                SELECT DISTINCT 
                    CPD.Candidate_Id,   
                    ST.Request_type AS Types, 
                    AAR.candidate_id AS ID, 
                    AAR.Approval_id,
                    AAR.Verification_status AS Status,     
                    AAR.create_date AS Date,
                    CONCAT(CPD.Candidate_Fname, '' '', CPD.Candidate_Lname) AS Candidate_Name,
                    CPD.AdharNumber AS ICNO,    
                    CPD.IDMatrixNo AS MatrixNo    
                FROM dbo.Tbl_admission_approval_request AAR
                INNER JOIN dbo.Tbl_Candidate_Personal_Det CPD 
                    ON AAR.candidate_id = CPD.Candidate_Id 
                INNER JOIN Tbl_Student_Tc_request ST 
                    ON ST.Candidate_id = CPD.Candidate_Id 
                    AND AAR.request_id = ST.tc_request_id    
                WHERE CPD.Candidate_DelStatus = 0  
                  AND AAR.Verification_status = ''Rejected''    
            END    
        END
    ');
END;
