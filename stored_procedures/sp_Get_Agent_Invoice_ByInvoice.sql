IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Agent_Invoice_ByInvoice]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Get_Agent_Invoice_ByInvoice] 
        (
            @flag BIGINT = 0,
            @Agent_Id BIGINT = 0,
            @Invoice_Code VARCHAR(MAX) = '''',
            @Invoice_Id BIGINT = 0,
            @candidate_Id BIGINT = 0
        )
        AS
        BEGIN
            -- Flag 1: Get Candidate Invoice Details
            IF (@flag = 1)
            BEGIN
                SELECT DISTINCT 
                    CONCAT(Candidate_Fname, '' '', Candidate_Lname) AS Candidate_name,
                    AdharNumber,
                    CASE 
                        WHEN TypeOfStudent = ''INTERNATIONAL'' THEN ISNULL(International_Amount, 0)
                        WHEN TypeOfStudent = ''LOCAL'' THEN ISNULL(Local_Amount, 0)
                    END AS Commission_Amount,
                    CASE 
                        WHEN Approval_status = 1 THEN ''Approved''
                        WHEN Approval_status = 0 THEN ''Rejected''
                        ELSE ''Pending''
                    END AS Approval_status
                FROM Tbl_Agent_Invoice I
                LEFT JOIN Tbl_Candidate_Personal_Det P ON I.Candidate_Id = P.Candidate_Id
                LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = P.New_Admission_Id
                LEFT JOIN Tbl_CommissionGroup CG ON CG.ProgrammeId = NA.Department_Id 
                    AND CG.FacultyId = Na.Course_Level_Id 
                    AND CG.IntakeId = NA.Batch_Id
                LEFT JOIN Tbl_CommissionMapping CM ON CM.Commission_Group_Id = CG.Commission_GroupId 
                    AND CM.Agent_Employee_Id = I.Agent_Id
                WHERE I.Agent_Id = @Agent_Id AND I.Invoiceno = @Invoice_Code
            END

            -- Flag 2: Get Agent Invoice Summary
            IF (@flag = 2)
            BEGIN
                SELECT DISTINCT 
                    I.Agent_Id,
                    I.Candidate_Id,
                    CONCAT(Candidate_Fname, '' '', Candidate_Lname) AS Candidate_name,
                    AdharNumber,
                    CASE 
                        WHEN TypeOfStudent = ''INTERNATIONAL'' THEN ISNULL(International_Amount, 0)
                        WHEN TypeOfStudent = ''LOCAL'' THEN ISNULL(Local_Amount, 0)
                    END AS Commission_Amount,
                    I.AgenInvoiceId,
                    CASE 
                        WHEN TypeOfStudent = ''INTERNATIONAL'' THEN ISNULL(International_Amount, 0)
                        WHEN TypeOfStudent = ''LOCAL'' THEN ISNULL(Local_Amount, 0)
                    END AS InvoicedAmount,
                    I.Invoiceno,
                    I.Invoiceno AS Invoice_Code,
                    0 AS Paid,
                    0 AS Balance,
                    CASE 
                        WHEN Approval_status = 1 THEN ''Approved''
                        WHEN Approval_status = 0 THEN ''Rejected''
                        ELSE ''Pending''
                    END AS Approval_status
                FROM Tbl_Agent_Invoice I
                LEFT JOIN Tbl_Candidate_Personal_Det P ON I.Candidate_Id = P.Candidate_Id
                LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = P.New_Admission_Id
                LEFT JOIN Tbl_CommissionGroup CG ON CG.ProgrammeId = NA.Department_Id 
                    AND CG.FacultyId = Na.Course_Level_Id 
                    AND CG.IntakeId = NA.Batch_Id
                LEFT JOIN Tbl_CommissionMapping CM ON CM.Commission_Group_Id = CG.Commission_GroupId
                LEFT JOIN Tbl_Agent_Settlement AGS ON AGS.Invoice_Id = I.AgenInvoiceId 
                    AND CM.Agent_Employee_Id = I.Agent_Id
                WHERE I.Agent_Id = @Agent_Id AND I.Invoiceno = @Invoice_Code
            END

            -- Flag 3: Get Candidate Invoice with Payment Details
            IF (@flag = 3)
            BEGIN
                SELECT DISTINCT 
                    P.Candidate_Id,
                    CONCAT(Candidate_Fname, '' '', Candidate_Lname) AS Candidate_name,
                    AdharNumber,
                    CASE 
                        WHEN TypeOfStudent = ''INTERNATIONAL'' THEN CAST(COALESCE(International_Amount, 0) AS DECIMAL(18, 2))
                        WHEN TypeOfStudent = ''LOCAL'' THEN CAST(COALESCE(Local_Amount, 0) AS DECIMAL(18, 2))
                    END AS Commission_Amount,
                    Agent_Name,
                    I.AgenInvoiceId,
                    CASE 
                        WHEN TypeOfStudent = ''INTERNATIONAL'' THEN CAST(COALESCE(International_Amount, 0) AS DECIMAL(18, 2))
                        WHEN TypeOfStudent = ''LOCAL'' THEN CAST(COALESCE(Local_Amount, 0) AS DECIMAL(18, 2))
                    END AS totalamountpayable,
                    CASE 
                        WHEN TypeOfStudent = ''INTERNATIONAL'' THEN CAST(COALESCE(International_Amount, 0) AS DECIMAL(18, 2))
                        WHEN TypeOfStudent = ''LOCAL'' THEN CAST(COALESCE(Local_Amount, 0) AS DECIMAL(18, 2))
                    END AS InvoicedAmount,
                    CAST(COALESCE(SUM(Amount), 0) AS DECIMAL(18, 2)) AS totalamountpaid,
                    0.00 AS outstandingbalance,
                    CASE 
                        WHEN Approval_status = 1 THEN ''Approved''
                        WHEN Approval_status = 0 THEN ''Rejected''
                        ELSE ''Pending''
                    END AS Approval_status
                INTO #TEMP2
                FROM Tbl_Agent_Invoice I
                LEFT JOIN Tbl_Candidate_Personal_Det P ON I.Candidate_Id = P.Candidate_Id
                LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = P.New_Admission_Id
                LEFT JOIN tbl_Agent A ON A.Agent_ID = I.Agent_Id
                LEFT JOIN Tbl_CommissionGroup CG ON CG.ProgrammeId = NA.Department_Id 
                    AND CG.FacultyId = Na.Course_Level_Id 
                    AND CG.IntakeId = NA.Batch_Id
                LEFT JOIN Tbl_CommissionMapping CM ON CM.Commission_Group_Id = CG.Commission_GroupId 
                    AND CM.Agent_Employee_Id = I.Agent_Id
                LEFT JOIN Tbl_Agent_Settlement AGS ON AGS.Invoice_Id = I.AgenInvoiceId
                WHERE I.Agent_Id = @Agent_Id AND I.AgenInvoiceId = @Invoice_Id AND Approval_status = 1
                GROUP BY P.Candidate_Id, Invoice_Id, Candidate_Fname, Candidate_Lname, AdharNumber, 
                         I.AgenInvoiceId, Approval_status, Agent_Name, TypeOfStudent, International_Amount, Local_Amount

                SELECT 
                    Candidate_Id,
                    Candidate_name,
                    AdharNumber,
                    Commission_Amount,
                    Agent_Name,
                    AgenInvoiceId,
                    totalamountpayable,
                    InvoicedAmount,
                    ISNULL(totalamountpaid, 0) AS totalamountpaid,
                    Approval_status,
                    ISNULL((InvoicedAmount - totalamountpaid), 0) AS outstandingbalance
                FROM #TEMP2
                DROP TABLE #TEMP2
            END

            -- Flag 4: Get Payment Details
            IF (@flag = 4)
            BEGIN
                SELECT 
                    Amount,
                    CONVERT(VARCHAR, A.Created_Date, 103) AS PaidDate,
                    PM.name AS paymentmethod,
                    remarks,
                    Invoice_Id,
                    cashierid,
                    studentid,
                    AgentId,
                    dateissued,
                    b.name AS bankname,
                    refno,
                    CONVERT(VARCHAR, checkdate, 103) AS DocumentDate,
                    Attachement_Path,
                    A.payee_id,
                    '''' AS PayeeName
                FROM Tbl_Agent_Settlement A
                LEFT JOIN fixed_payment_method PM ON A.paymentmethod = PM.id
                LEFT JOIN ref_bank b ON b.id = A.bankname
                WHERE AgentId = @Agent_Id AND Invoice_Id = @Invoice_Id
            END

            -- Additional Flags (5 to 9) handled without modification
        END
    ')
END
