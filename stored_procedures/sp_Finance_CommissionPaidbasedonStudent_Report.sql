IF EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_CommissionPaidbasedonStudent_Report]') 
    AND type = N'P'
)
DROP PROCEDURE [dbo].[sp_Finance_CommissionPaidbasedonStudent_Report]
GO

CREATE PROCEDURE [dbo].[sp_Finance_CommissionPaidbasedonStudent_Report]  
-- Example: EXEC sp_Finance_CommissionPaidbasedonStudent_Report 0,0,0,10556,NULL,NULL
(
    @Course_Category_Id BIGINT = 0,
    @intake BIGINT = 0,
    @program BIGINT = 0,
    @Student BIGINT = 0,
    @fromdate DATETIME = NULL,
    @Todate DATETIME = NULL
)
AS
BEGIN
    SELECT 
        ASE.studentid,
        CONCAT(Candidate_Fname, ' ', Candidate_Lname) AS studentName,
        AG.Agent_Name,
        CONCAT(D.Course_Code, '-', D.Department_Name) AS Department_Name,
        IM.intake_no AS Batch_Code,
        IDMatrixNo,
        AdharNumber,
        CASE 
            WHEN ASE.cashierid = '0' THEN 'System'
            WHEN ASE.cashierid = '1' THEN 'Admin'
            ELSE CONCAT(e.Employee_FName, ' ', e.Employee_LName)
        END AS Cashiername,
        pm.name AS paymentmethod,
        CONVERT(VARCHAR(50), ASE.dateissued, 105) AS datetimeissued,
        ASE.refno,
        ASE.Amount
    FROM 
        Tbl_Agent_Settlement ASE
        LEFT JOIN Tbl_Agent AG ON AG.Agent_ID = ASE.AgentId
        LEFT JOIN tbl_Candidate_Personal_Det PD ON ASE.studentid = PD.Candidate_Id
        LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = PD.New_Admission_Id
        LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
        LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterID
        LEFT JOIN Tbl_Employee E ON E.Employee_Id = ASE.cashierid
        LEFT JOIN fixed_payment_method pm ON pm.id = ASE.paymentmethod
        LEFT JOIN Tbl_Agent_Invoice AI ON AI.AgenInvoiceId = ASE.Invoice_Id
    WHERE 
        (NA.Department_Id = @program OR @program = 0)
        AND (@Course_Category_Id = 0 OR NA.Course_Category_Id = @Course_Category_Id)
        AND (NA.Batch_Id = @intake OR @intake = 0) -- Corrected for intake
        AND (ASE.studentid = @Student OR @Student = 0)
        AND (
            ((CONVERT(DATE, ASE.dateissued)) >= @fromdate AND (CONVERT(DATE, ASE.dateissued)) < DATEADD(DAY, 1, @Todate))
            OR (@fromdate IS NULL AND @Todate IS NULL)
            OR (@fromdate IS NULL AND (CONVERT(DATE, ASE.dateissued)) < DATEADD(DAY, 1, @Todate))
            OR (@Todate IS NULL AND (CONVERT(DATE, ASE.dateissued)) >= @fromdate)
        )
    ORDER BY 
        ASE.dateissued
END
