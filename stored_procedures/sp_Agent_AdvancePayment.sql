IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Agent_AdvancePayment]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Agent_AdvancePayment] 
        (
            @flag bigint = 0,  
            @AdvanceId bigint = 0,  
            @Agent_Id bigint = 0,  
            @Requested_Amount decimal(18, 2) = 0,  
            @Agent_Remarks varchar(max) = '',  
            @Approved_Amount decimal(18, 2) = 0,  
            @Approval_Status bigint = 0,  
            @Approval_Remarks varchar(max) = '', 
            @Rejection_Remarks varchar(max) = '', 
            @Approved_By varchar(max) = ''
        )  
        AS  
        BEGIN  
            -- Declare variables here to ensure they are recognized
            DECLARE @Approved_Amount decimal(18, 2), 
                    @Approval_Remarks varchar(max),
                    @Approved_By varchar(max),
                    @Approval_Status bigint;

            IF(@flag = 0)  
            BEGIN  
                INSERT INTO Tbl_Agent_AdvancePayment 
                    (Agent_Id, Requested_Amount, Agent_Remarks, Approved_Amount, Approval_Status, 
                    Approval_Remarks, Approved_By, created_Date, Delete_Status)  
                VALUES
                    (@Agent_Id, @Requested_Amount, @Agent_Remarks, @Approved_Amount, 
                    @Approval_Status, @Approval_Remarks, @Approved_By, GETDATE(), 0)  
            END  
            
            IF(@flag = 1) -- Update Approval process advance payment
            BEGIN  
                UPDATE Tbl_Agent_AdvancePayment  
                SET 
                    Approval_Remarks = @Approval_Remarks,
                    Updated_Date = GETDATE(),
                    Approved_By = @Approved_By,
                    Approved_Amount = @Approved_Amount,
                    Approval_Status = @Approval_Status  
                WHERE 
                    Delete_Status = 0 AND AdvanceId = @AdvanceId  
            END  
            
            IF(@flag = 2)  
            BEGIN  
                SELECT  
                    AP.AdvanceId, AP.Agent_Id, AP.Requested_Amount, AP.Agent_Remarks, 
                    AP.Approved_Amount, AP.Approval_Status, Approval_Remarks, Approved_By, 
                    AP.created_Date, A.Agent_Name,
                    CASE 
                        WHEN AP.Approval_Status = 0 THEN ''Pending''  
                        WHEN AP.Approval_Status = 1 THEN ''Approved''  
                        WHEN AP.Approval_Status = 2 THEN ''Rejected'' 
                    END AS ApprovalStatus,
                    CASE 
                        WHEN AP.Approval_Remarks IS NULL THEN ''N/A'' 
                        WHEN AP.Approval_Remarks = '''' THEN ''N/A''  
                        ELSE AP.Approval_Remarks 
                    END AS Approval_Remarks,
                    CASE 
                        WHEN AP.Rejection_Remarks IS NULL THEN ''N/A'' 
                        WHEN AP.Rejection_Remarks = '''' THEN ''N/A''  
                        ELSE AP.Rejection_Remarks 
                    END AS Rejection_Remarks,
                    CASE 
                        WHEN Ap.Approved_By = 1 THEN ''Admin''  
                        WHEN Ap.Approved_By = 0 THEN ''N/A'' 
                        ELSE CONCAT(Employee_Fname, '' '', Employee_Lname) 
                    END AS Approved_By
                FROM 
                    Tbl_Agent_AdvancePayment AP  
                LEFT JOIN 
                    Tbl_Agent A ON A.Agent_ID = AP.Agent_Id  
                LEFT JOIN 
                    Tbl_Employee E ON E.Employee_Id = AP.Approved_By  
                WHERE 
                    AP.Delete_Status = 0 AND AP.AdvanceId = @AdvanceId  
            END  
            
            IF(@flag = 3)  
            BEGIN  
                SELECT  
                    AP.AdvanceId, AP.Agent_Id, AP.Requested_Amount, AP.Agent_Remarks, AP.Approved_Amount, 
                    CASE 
                        WHEN AP.Approval_Status = 0 THEN ''Pending''  
                        WHEN AP.Approval_Status = 1 THEN ''Approved''  
                        WHEN AP.Approval_Status = 2 THEN ''Rejected'' 
                    END AS Approval_Status,
                    CASE 
                        WHEN AP.Approval_Remarks IS NULL THEN ''N/A'' 
                        WHEN AP.Approval_Remarks = '''' THEN ''N/A''  
                        ELSE AP.Approval_Remarks 
                    END AS Approval_Remarks,
                    CASE 
                        WHEN AP.Rejection_Remarks IS NULL THEN ''N/A'' 
                        WHEN AP.Rejection_Remarks = '''' THEN ''N/A''  
                        ELSE AP.Rejection_Remarks 
                    END AS Rejection_Remarks,
                    CASE 
                        WHEN Ap.Approved_By = 1 THEN ''Admin''  
                        WHEN Ap.Approved_By = 0 THEN ''N/A'' 
                        ELSE CONCAT(Employee_Fname, '' '', Employee_Lname) 
                    END AS Approved_By,  
                    CONVERT(VARCHAR, AP.created_Date, 103) AS created_Date, 
                    A.Agent_Name  
                FROM  
                    Tbl_Agent_AdvancePayment AP  
                LEFT JOIN  
                    Tbl_Agent A ON A.Agent_ID = AP.Agent_Id  
                LEFT JOIN  
                    Tbl_Employee E ON E.Employee_Id = AP.Approved_By  
                WHERE 
                    AP.Delete_Status = 0  
            END  

            IF(@flag = 4) -- Update rejection process advance payment
            BEGIN  
                UPDATE Tbl_Agent_AdvancePayment  
                SET 
                    Rejection_Remarks = @Rejection_Remarks,
                    Updated_Date = GETDATE(),
                    Approved_By = @Approved_By,
                    Approval_Status = @Approval_Status  
                WHERE 
                    Delete_Status = 0 AND AdvanceId = @AdvanceId  
            END  
        END  
    ')
END
