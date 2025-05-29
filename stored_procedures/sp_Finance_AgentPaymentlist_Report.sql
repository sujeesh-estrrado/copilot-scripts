IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_AgentPaymentlist_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[sp_Finance_AgentPaymentlist_Report]
    (
        @AgentId bigint = 0,
        @fromdate datetime = NULL,
        @Todate datetime = NULL,
        @PageSize bigint = 10,
        @CurrentPage bigint = 1
    )
    AS
    BEGIN
        DECLARE @UpperBand int
        DECLARE @LowerBand int

        SET @LowerBand = (@CurrentPage - 1) * @PageSize
        SET @UpperBand = (@CurrentPage * @PageSize) + 1

        SELECT 
            ROW_NUMBER() OVER (ORDER BY ASE.studentid) AS RowNum,
            ASE.studentid,
            ASE.studentid AS ID,
            CONCAT(Candidate_Fname, '' '', Candidate_Lname) AS studentName,
            AG.Agent_Name,
            CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,
            IM.intake_no AS Batch_Code,
            IDMatrixNo,
            AdharNumber,
            CASE 
                WHEN ASE.cashierid = ''0'' THEN ''System'' 
                WHEN ASE.cashierid = ''1'' THEN ''Admin'' 
                ELSE CONCAT(e.Employee_FName, '' '', Employee_LName)
            END AS Cashiername,
            pm.name AS paymentmethod,
            CONVERT(varchar(50), ASE.dateissued, 103) AS datetimeissued,
            ASE.refno,
            ASE.Amount 
        FROM Tbl_Agent_Settlement ASE 
        LEFT JOIN Tbl_Agent AG ON AG.Agent_ID = ASE.AgentId
        LEFT JOIN tbl_Candidate_Personal_Det PD ON ASE.studentid = PD.Candidate_Id
        LEFT JOIN tbl_New_Admission NA ON NA.New_Admission_Id = PD.New_Admission_Id
        LEFT JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
        LEFT JOIN Tbl_Course_Batch_Duration BD ON BD.Batch_Id = NA.Batch_Id
        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = BD.IntakeMasterID
        LEFT JOIN Tbl_Employee E ON E.Employee_Id = ASE.cashierid 
        LEFT JOIN fixed_payment_method pm ON pm.id = ASE.paymentmethod
        LEFT JOIN Tbl_Agent_Invoice AI ON AI.AgenInvoiceId = ASE.Invoice_Id
        WHERE (ASE.AgentId = @AgentId OR @AgentId = 0)
        AND (
            (CONVERT(date, ASE.dateissued) >= @fromdate AND CONVERT(date, ASE.dateissued) < DATEADD(day, 1, @Todate)) 
            OR (@fromdate IS NULL AND @Todate IS NULL)
            OR (@fromdate IS NULL AND CONVERT(date, ASE.dateissued) < DATEADD(day, 1, @Todate))
            OR (@Todate IS NULL AND CONVERT(date, ASE.dateissued) >= @fromdate)
        )
        ORDER BY ID
        OFFSET @LowerBand ROWS
        FETCH NEXT @PageSize ROWS ONLY
    END
    ')
END
GO