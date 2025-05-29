IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_Transaction_Report_ByAccountcode]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Finance_Transaction_Report_ByAccountcode]
        (
            @Accountcode BIGINT = 0,
            @TransactionType VARCHAR(MAX) = '''',
            @fromdate DATETIME = NULL,
            @Todate DATETIME = NULL,
            @flag BIGINT = 0,
            @CurrentPage INT = 1,
            @PageSize INT = 10
        )
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                IF (@TransactionType = ''1'') -- Receipt
                BEGIN
                    SELECT DISTINCT Pd.Candidate_Id, t.transactionid,
                        st.receiptnumber AS docno, refa.name AS accountcode, st.description AS billdescription, IM.Batch_Code AS Batch,
                        CONCAT(Pd.Candidate_Fname, '' '', Pd.Candidate_Lname) AS CandidateName,
                        Pd.AdharNumber, Pd.IDMatrixNo, '''' AS SPONSOR, IM.intake_no AS Batch_Code, CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,
                        CONVERT(VARCHAR(50), st.dateissued, 105) AS dateissued, ME.name AS methodofpay,
                        CASE WHEN st.cashierid = 0 THEN ''System'' WHEN st.cashierid = 1 THEN ''Admin'' 
                        ELSE CONCAT(e.Employee_FName, '' '', e.Employee_LName) END AS Issuedby,
                        CAST(st.amount AS DECIMAL(18, 2)) AS amount, st.refno, st.remarks
                    FROM dbo.student_payment AS st
                    INNER JOIN Tbl_Candidate_Personal_Det pd ON st.studentid = pd.Candidate_Id
                    LEFT JOIN dbo.ref_accountcode AS A ON st.accountcodeid = A.id
                    LEFT JOIN dbo.student_transaction AS t ON st.transactionid = t.transactionid
                    LEFT JOIN fixed_payment_method AS ME ON t.paymentmethod = ME.id
                    LEFT JOIN ref_bank AS BAN ON st.bankname = BAN.id
                    LEFT JOIN Tbl_Employee e ON e.Employee_Id = st.cashierid
                    LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
                    LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id
                    LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID
                    LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id
                    LEFT JOIN student_bill_group bg ON st.studentid = bg.studentid
                    LEFT JOIN student_bill AS B ON B.billgroupid = BG.billgroupid
                    LEFT JOIN ref_accountcode refa ON refa.id = st.accountcodeid
                    WHERE (A.id = @Accountcode OR @Accountcode = 0) AND t.billcancel = 0
                    AND (
                        ((CONVERT(DATE, st.dateissued)) >= @fromdate AND (CONVERT(DATE, st.dateissued)) < DATEADD(day, 1, @Todate))
                        OR (@fromdate IS NULL AND @Todate IS NULL)
                        OR (@fromdate IS NULL AND (CONVERT(DATE, st.dateissued)) < DATEADD(day, 1, @Todate))
                        OR (@Todate IS NULL AND (CONVERT(DATE, st.dateissued)) >= @fromdate)
                    )
                    ORDER BY Pd.Candidate_Id
                    OFFSET @PageSize * (@CurrentPage - 1) ROWS
                    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
                END
                
                IF (@TransactionType = ''0'') -- Invoice
                BEGIN
                    SELECT DISTINCT Pd.Candidate_Id,
                        BG.docno, t.docno AS IVX, t.transactionid,
                        refa.name AS accountcode, B.description AS billdescription,
                        CONCAT(Pd.Candidate_Fname, '' '', Pd.Candidate_Lname) AS CandidateName, IM.Batch_Code AS Batch,
                        Pd.AdharNumber, Pd.IDMatrixNo, '''' AS SPONSOR,
                        IM.intake_no AS Batch_Code, CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,
                        CONVERT(VARCHAR(50), B.dateissue, 105) AS dateissued, '''' AS methodofpay,
                        CASE WHEN B.createdby = 0 THEN ''System'' WHEN B.createdby = 1 THEN ''Admin''
                        ELSE CONCAT(e.Employee_FName, '' '', e.Employee_LName) END AS Issuedby,
                        T.amount, '''' AS refno, '''' AS remarks
                    FROM Tbl_Candidate_Personal_Det pd
                    INNER JOIN student_bill AS B ON B.studentid = pd.Candidate_Id
                    LEFT JOIN student_bill_group bg ON bg.billgroupid = B.billgroupid
                    LEFT JOIN dbo.ref_accountcode AS A ON B.accountcodeid = A.id
                    LEFT JOIN dbo.student_transaction AS t ON t.billid = B.billid
                    LEFT JOIN dbo.student_payment AS st ON st.transactionid = t.transactionid
                    LEFT JOIN fixed_payment_method AS ME ON t.paymentmethod = ME.id
                    LEFT JOIN Tbl_Employee e ON e.Employee_Id = B.createdby
                    LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
                    LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id
                    LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID
                    LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id
                    LEFT JOIN ref_accountcode refa ON refa.id = B.accountcodeid
                    WHERE (A.id = @Accountcode OR @Accountcode = 0) AND B.totalamountpayable > 0 AND t.billcancel = 0
                    AND (
                        ((CONVERT(DATE, T.dateissued)) >= @fromdate AND (CONVERT(DATE, T.dateissued)) < DATEADD(day, 1, @Todate))
                        OR (@fromdate IS NULL AND @Todate IS NULL)
                        OR (@fromdate IS NULL AND (CONVERT(DATE, T.dateissued)) < DATEADD(day, 1, @Todate))
                        OR (@Todate IS NULL AND (CONVERT(DATE, T.dateissued)) >= @fromdate)
                    )
                    ORDER BY dateissued
                    OFFSET @PageSize * (@CurrentPage - 1) ROWS
                    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
                END
            END

            IF (@flag = 1)
            BEGIN
                IF (@TransactionType = ''1'') -- Receipt Summary
                BEGIN
                    SELECT * INTO #temp FROM (
                        SELECT DISTINCT Pd.Candidate_Id, t.transactionid,
                            st.receiptnumber AS docno, refa.name AS accountcode, st.description AS billdescription,
                            CONCAT(Pd.Candidate_Fname, '' '', Pd.Candidate_Lname) AS CandidateName,
                            Pd.AdharNumber, Pd.IDMatrixNo, '''' AS SPONSOR, IM.intake_no AS Batch_Code, CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,
                            CONVERT(VARCHAR(50), st.dateissued, 105) AS dateissued, ME.name AS methodofpay,
                            CASE WHEN st.cashierid = 0 THEN ''System'' WHEN st.cashierid = 1 THEN ''Admin'' 
                            ELSE CONCAT(e.Employee_FName, '' '', e.Employee_LName) END AS Issuedby,
                            CAST(st.amount AS DECIMAL(18, 2)) AS amount, st.refno, st.remarks
                        FROM dbo.student_payment AS st
                        INNER JOIN Tbl_Candidate_Personal_Det pd ON st.studentid = pd.Candidate_Id
                        LEFT JOIN dbo.ref_accountcode AS A ON st.accountcodeid = A.id
                        LEFT JOIN dbo.student_transaction AS t ON st.transactionid = t.transactionid
                        LEFT JOIN fixed_payment_method AS ME ON t.paymentmethod = ME.id
                        LEFT JOIN ref_bank AS BAN ON st.bankname = BAN.id
                        LEFT JOIN Tbl_Employee e ON e.Employee_Id = st.cashierid
                        LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
                        LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id
                        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID
                        LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id
                        LEFT JOIN student_bill_group bg ON st.studentid = bg.studentid
                        LEFT JOIN student_bill AS B ON B.billgroupid = BG.billgroupid
                        LEFT JOIN ref_accountcode refa ON refa.id = st.accountcodeid
                        WHERE (A.id = @Accountcode OR @Accountcode = 0) AND t.billcancel = 0
                        AND (
                            ((CONVERT(DATE, st.dateissued)) >= @fromdate AND (CONVERT(DATE, st.dateissued)) < DATEADD(day, 1, @Todate))
                            OR (@fromdate IS NULL AND @Todate IS NULL)
                            OR (@fromdate IS NULL AND (CONVERT(DATE, st.dateissued)) < DATEADD(day, 1, @Todate))
                            OR (@Todate IS NULL AND (CONVERT(DATE, st.dateissued)) >= @fromdate)
                        )
                    ) AS Base
                    SELECT COUNT(*) AS counts, SUM(amount) AS totamount FROM #temp
                END
                
                IF (@TransactionType = ''0'') -- Invoice Summary
                BEGIN
                    SELECT * INTO #temp1 FROM (
                        SELECT DISTINCT Pd.Candidate_Id,
                            BG.docno, t.docno AS IVX, t.transactionid,
                            refa.name AS accountcode, B.description AS billdescription,
                            CONCAT(Pd.Candidate_Fname, '' '', Pd.Candidate_Lname) AS CandidateName,
                            Pd.AdharNumber, Pd.IDMatrixNo, '''' AS SPONSOR,
                            IM.intake_no AS Batch_Code, CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name,
                            CONVERT(VARCHAR(50), B.dateissue, 105) AS dateissued, '''' AS methodofpay,
                            CASE WHEN B.createdby = 0 THEN ''System'' WHEN B.createdby = 1 THEN ''Admin''
                            ELSE CONCAT(e.Employee_FName, '' '', e.Employee_LName) END AS Issuedby,
                            T.amount, '''' AS refno, '''' AS remarks
                        FROM Tbl_Candidate_Personal_Det pd
                        INNER JOIN student_bill AS B ON B.studentid = pd.Candidate_Id
                        LEFT JOIN student_bill_group bg ON bg.billgroupid = B.billgroupid
                        LEFT JOIN dbo.ref_accountcode AS A ON B.accountcodeid = A.id
                        LEFT JOIN dbo.student_transaction AS t ON t.billid = B.billid
                        LEFT JOIN dbo.student_payment AS st ON st.transactionid = t.transactionid
                        LEFT JOIN fixed_payment_method AS ME ON t.paymentmethod = ME.id
                        LEFT JOIN Tbl_Employee e ON e.Employee_Id = B.createdby
                        LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
                        LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id
                        LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID
                        LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id
                        LEFT JOIN ref_accountcode refa ON refa.id = B.accountcodeid
                        WHERE (A.id = @Accountcode OR @Accountcode = 0) AND B.totalamountpayable > 0 AND t.billcancel = 0
                        AND (
                            ((CONVERT(DATE, T.dateissued)) >= @fromdate AND (CONVERT(DATE, T.dateissued)) < DATEADD(day, 1, @Todate))
                            OR (@fromdate IS NULL AND @Todate IS NULL)
                            OR (@fromdate IS NULL AND (CONVERT(DATE, T.dateissued)) < DATEADD(day, 1, @Todate))
                            OR (@Todate IS NULL AND (CONVERT(DATE, T.dateissued)) >= @fromdate)
                        )
                    ) AS Base
                    SELECT COUNT(*) AS counts, SUM(amount) AS totamount FROM #temp1
                END
            END
        END
    ')
END
