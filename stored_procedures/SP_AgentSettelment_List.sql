IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_AgentSettelment_List]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_AgentSettelment_List]
        @flag BIGINT = 0,  
        @Agent_Id BIGINT = 0,  
        @invoice VARCHAR(MAX) = ''''  
        AS  
        BEGIN
            IF (@flag = 0)
            BEGIN
                SELECT DISTINCT 
                    Invoiceno, 
                    CONVERT(VARCHAR(10), Invoice_Date, 103) AS Invoice_Date,
                    0 AS NoofCandidates,
                    0 AS CommissionAmount,
                    0 AS Student_TotalAmount_Paid,
                    0 AS Amount_Paid,
                    A.Agent_Name,
                    Agent_RegNo,
                    AI.Agent_Id,
                    0 AS Balance,
                    Upload,
                    0 AS verification
                FROM Tbl_Agent_Invoice AI
                LEFT JOIN Tbl_Candidate_Personal_Det CPD ON CPD.Agent_ID = AI.Agent_Id
                LEFT JOIN Tbl_Agent A ON A.Agent_ID = AI.Agent_Id
                WHERE Approval_status = 1
            END

            IF (@flag = 1)
            BEGIN
                SELECT COUNT(Candidate_Id) AS NoofCandidates
                FROM Tbl_Agent_Invoice
                WHERE Agent_Id = @Agent_Id AND Invoiceno = @invoice
            END

            IF (@flag = 2)
            BEGIN
                SELECT * INTO #temp
                FROM (
                    SELECT 
                        I.Candidate_Id,
                        TypeOfStudent,
                        Local_Amount,
                        International_Amount,
                        CASE 
                            WHEN TypeOfStudent = ''INTERNATIONAL'' THEN International_Amount
                            WHEN TypeOfStudent = ''LOCAL'' THEN Local_Amount
                        END AS Commission_Amount
                    FROM Tbl_Agent_Invoice I        
                    LEFT JOIN Tbl_Candidate_Personal_Det P ON P.Candidate_Id = I.Candidate_Id         
                    LEFT JOIN tbl_New_Admission Na ON Na.New_Admission_Id = P.New_Admission_Id        
                    LEFT JOIN Tbl_CommissionGroup CG ON CG.ProgrammeId = NA.Department_Id 
                        AND CG.FacultyId = Na.Course_Level_Id AND CG.IntakeId = NA.Batch_Id
                    LEFT JOIN Tbl_CommissionMapping CM ON CM.Commission_Group_Id = CG.Commission_GroupId   
                    WHERE I.Agent_Id = @Agent_Id AND I.Invoiceno = @invoice
                ) b

                SELECT CAST(COALESCE(SUM(Commission_Amount), 0) AS DECIMAL(18,2)) AS Commission_Amount
                FROM #temp
            END

            IF (@flag = 3)
            BEGIN
                DECLARE @pay1 BIGINT
                DECLARE @pay2 BIGINT

                SET @pay1 = (
                    SELECT CAST(COALESCE(SUM(totalamountpaid), 0) AS DECIMAL(18,2)) AS totalamountpaid
                    FROM Tbl_Candidate_Personal_Det D
                    INNER JOIN student_bill b ON b.studentid = D.Candidate_Id
                    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = D.New_Admission_Id
                    LEFT JOIN Tbl_CommissionGroup CG ON CG.ProgrammeId = NA.Department_Id 
                        AND CG.FacultyId = Na.Course_Level_Id AND CG.IntakeId = NA.Batch_Id
                    LEFT JOIN Tbl_CommissionMapping CM ON CM.Commission_Group_Id = CG.Commission_GroupId
                    INNER JOIN Tbl_Agent_Invoice AI ON AI.Agent_ID = CM.Agent_Employee_Id AND AI.Candidate_Id = b.studentid   
                    WHERE AI.Agent_Id = @Agent_Id AND Invoiceno = @invoice
                )

                SET @pay2 = (
                    SELECT CAST(COALESCE(SUM(floatamount), 0) AS DECIMAL(18,2)) AS totalamountpaid
                    FROM Tbl_Candidate_Personal_Det D
                    INNER JOIN student_payment_float b ON b.studentid = D.Candidate_Id
                    LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = D.New_Admission_Id
                    LEFT JOIN Tbl_CommissionGroup CG ON CG.ProgrammeId = NA.Department_Id 
                        AND CG.FacultyId = Na.Course_Level_Id AND CG.IntakeId = NA.Batch_Id
                    LEFT JOIN Tbl_CommissionMapping CM ON CM.Commission_Group_Id = CG.Commission_GroupId
                    INNER JOIN Tbl_Agent_Invoice AI ON AI.Agent_ID = CM.Agent_Employee_Id AND AI.Candidate_Id = b.studentid   
                    WHERE AI.Agent_Id = @Agent_Id AND Invoiceno = @invoice
                )

                SELECT SUM(@pay1 + @pay2) AS totalamountpaid
            END

            IF (@flag = 4)
            BEGIN
                SELECT CAST(COALESCE(SUM(Amount), 0) AS DECIMAL(18,2)) AS Amount_Paid
                FROM Tbl_Agent_Settlement S
                LEFT JOIN Tbl_Agent_Invoice A ON S.Invoice_Id = A.AgenInvoiceId   
                WHERE Agent_Id = @Agent_Id AND Invoiceno = @invoice
            END

            IF (@flag = 5)
            BEGIN
                DECLARE @paid1 BIGINT
                DECLARE @commission BIGINT

                SET @paid1 = (
                    SELECT CAST(COALESCE(SUM(Amount), 0) AS DECIMAL(18,2)) AS Amount_Paid
                    FROM Tbl_Agent_Settlement S
                    LEFT JOIN Tbl_Agent_Invoice A ON S.Invoice_Id = A.AgenInvoiceId   
                    WHERE Agent_Id = @Agent_Id AND Invoiceno = @invoice
                )

                SELECT * INTO #temp1
                FROM (
                    SELECT 
                        I.Candidate_Id,
                        TypeOfStudent,
                        Local_Amount,
                        International_Amount,
                        CASE 
                            WHEN TypeOfStudent = ''INTERNATIONAL'' THEN International_Amount
                            WHEN TypeOfStudent = ''LOCAL'' THEN Local_Amount
                        END AS Commission_Amount
                    FROM Tbl_Agent_Invoice I        
                    LEFT JOIN Tbl_Candidate_Personal_Det P ON P.Candidate_Id = I.Candidate_Id         
                    LEFT JOIN tbl_New_Admission Na ON Na.New_Admission_Id = P.New_Admission_Id        
                    LEFT JOIN Tbl_CommissionGroup CG ON CG.ProgrammeId = NA.Department_Id 
                        AND CG.FacultyId = Na.Course_Level_Id AND CG.IntakeId = NA.Batch_Id
                    LEFT JOIN Tbl_CommissionMapping CM ON CM.Commission_Group_Id = CG.Commission_GroupId   
                    WHERE I.Agent_Id = @Agent_Id AND I.Invoiceno = @invoice
                ) b

                SET @commission = (
                    SELECT CAST(COALESCE(SUM(Commission_Amount), 0) AS DECIMAL(18,2)) AS Commission_Amount
                    FROM #temp1
                )

                SELECT CAST(COALESCE((@commission - @paid1), 0) AS DECIMAL(18,2)) AS Balance
            END
        END
    ')
END
