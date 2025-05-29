IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_TransactionDelete_Report]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Finance_TransactionDelete_Report]
        (
            @flag BIGINT = 0,
            @IntakeId VARCHAR(MAX) = '''',
            @PgmID VARCHAR(MAX) = '''',
            @TransavtionType VARCHAR(MAX) = '''',
            @fromdate DATETIME = NULL,
            @Todate DATETIME = NULL,
            @PageSize BIGINT = 10,
            @CurrentPage BIGINT = 1
        )
        AS
        BEGIN
            IF (@flag = 0)
            BEGIN
                IF (@TransavtionType = ''All'')
                BEGIN
                    SELECT DISTINCT 
                        Pd.Candidate_Id, Pd.Candidate_Id AS ID,
                        CONCAT(Pd.Candidate_Fname, '' '', Pd.Candidate_Lname) AS CandidateName, 
                        st.billcancel, Pd.AdharNumber, Pd.IDMatrixNo, 
                        bd.Batch_Code, IM.intake_no AS IntakeID, D.Department_Name, 
                        Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
                        st.docno AS Documentno, CAST(st.amount AS DECIMAL(18, 2)) AS amount,
                        fpm.name AS paymentmethod,
                        CASE 
                            WHEN transactiontype = ''0'' THEN ''Invoice''
                            WHEN transactiontype = ''1'' THEN ''Receipt''
                            WHEN transactiontype = ''2'' THEN ''Debit Note''
                            WHEN transactiontype = ''3'' THEN ''Credit Note''
                            WHEN transactiontype = ''4'' THEN ''Refund''
                            WHEN transactiontype = ''5'' THEN ''Group Receipt''
                        END AS transactiontype,
                        CONVERT(VARCHAR(10), datetimeissued, 105) AS datetimeissued,
                        CONCAT(st.description, '' '', st.remarks) AS transactiondescription,
                        CASE 
                            WHEN cashierid = 0 THEN ''System''
                            WHEN cashierid = 1 THEN ''Admin''
                            ELSE CONCAT(e.Employee_FName, '' '', Employee_LName) 
                        END AS Issuedby
                    FROM student_transaction st
                    LEFT JOIN fixed_payment_method fpm ON fpm.id = paymentmethod
                    LEFT JOIN Tbl_Employee e ON e.Employee_Id = st.cashierid
                    LEFT JOIN Tbl_Candidate_Personal_Det pd ON st.studentid = pd.Candidate_Id
                    LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
                    LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id
                    LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID
                    LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id
                    LEFT JOIN student_bill_group bg ON st.studentid = bg.studentid
                    LEFT JOIN student_bill AS B ON B.billgroupid = BG.billgroupid
                    WHERE 
                        (IM.id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) OR @IntakeId = '''')
                        AND (Ad.Department_Id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) OR @PgmID = '''')
                        AND (
                            (CONVERT(DATE, datetimeissued) >= @fromdate AND CONVERT(DATE, datetimeissued) < DATEADD(DAY, 1, @Todate))
                            OR (@fromdate IS NULL AND @Todate IS NULL)
                            OR (@fromdate IS NULL AND CONVERT(DATE, datetimeissued) < DATEADD(DAY, 1, @Todate))
                            OR (@Todate IS NULL AND CONVERT(DATE, datetimeissued) >= @fromdate)
                        )
                        AND ApplicationStatus != ''Old Data''
                        AND st.billcancel = 1
                    ORDER BY ID
                    OFFSET @PageSize * (@CurrentPage - 1) ROWS
                    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
                END
                ELSE
                BEGIN
                    SELECT DISTINCT 
                        Pd.Candidate_Id, Pd.Candidate_Id AS ID,
                        CONCAT(Pd.Candidate_Fname, '' '', Pd.Candidate_Lname) AS CandidateName, 
                        st.billcancel, Pd.AdharNumber, Pd.IDMatrixNo,
                        bd.Batch_Code, IM.intake_no AS IntakeID, D.Department_Name, 
                        Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
                        st.docno AS Documentno, CAST(st.amount AS DECIMAL(18, 2)) AS amount,
                        fpm.name AS paymentmethod,
                        CASE 
                            WHEN transactiontype = ''0'' THEN ''Invoice''
                            WHEN transactiontype = ''1'' THEN ''Receipt''
                            WHEN transactiontype = ''2'' THEN ''Debit Note''
                            WHEN transactiontype = ''3'' THEN ''Credit Note''
                            WHEN transactiontype = ''4'' THEN ''Refund''
                            WHEN transactiontype = ''5'' THEN ''Group Receipt''
                        END AS transactiontype,
                        CONVERT(VARCHAR(10), datetimeissued, 105) AS datetimeissued,
                        CONCAT(st.description, '' '', st.remarks) AS transactiondescription,
                        CASE 
                            WHEN cashierid = 0 THEN ''System''
                            WHEN cashierid = 1 THEN ''Admin''
                            ELSE CONCAT(e.Employee_FName, '' '', Employee_LName) 
                        END AS Issuedby
                    FROM student_transaction st
                    LEFT JOIN fixed_payment_method fpm ON fpm.id = paymentmethod
                    LEFT JOIN Tbl_Employee e ON e.Employee_Id = st.cashierid
                    LEFT JOIN Tbl_Candidate_Personal_Det pd ON st.studentid = pd.Candidate_Id
                    LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
                    LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id
                    LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID
                    LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id
                    LEFT JOIN student_bill_group bg ON st.studentid = bg.studentid
                    LEFT JOIN student_bill AS B ON B.billgroupid = BG.billgroupid
                    WHERE 
                        transactiontype = @TransavtionType
                        AND (IM.id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) OR @IntakeId = '''')
                        AND (Ad.Department_Id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) OR @PgmID = '''')
                        AND (
                            (CONVERT(DATE, datetimeissued) >= @fromdate AND CONVERT(DATE, datetimeissued) < DATEADD(DAY, 1, @Todate))
                            OR (@fromdate IS NULL AND @Todate IS NULL)
                            OR (@fromdate IS NULL AND CONVERT(DATE, datetimeissued) < DATEADD(DAY, 1, @Todate))
                            OR (@Todate IS NULL AND CONVERT(DATE, datetimeissued) >= @fromdate)
                        )
                        AND st.billcancel = 1
                        AND ApplicationStatus != ''Old Data''
                    ORDER BY ID
                    OFFSET @PageSize * (@CurrentPage - 1) ROWS
                    FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
                END
            END
            IF (@flag = 1)
            BEGIN
                WITH level1 AS
                (
                    SELECT DISTINCT 
                        Pd.Candidate_Id, Pd.Candidate_Id AS ID,
                        CONCAT(Pd.Candidate_Fname, '' '', Pd.Candidate_Lname) AS CandidateName, 
                        st.billcancel, Pd.AdharNumber, Pd.IDMatrixNo,
                        bd.Batch_Code, IM.intake_no AS IntakeID, D.Department_Name, 
                        Ad.Department_Id AS ProgrammeID, D.GraduationTypeId AS FacultyID,
                        st.docno AS Documentno, CAST(st.amount AS DECIMAL(18, 2)) AS amount,
                        fpm.name AS paymentmethod,
                        CASE 
                            WHEN transactiontype = ''0'' THEN ''Invoice''
                            WHEN transactiontype = ''1'' THEN ''Receipt''
                            WHEN transactiontype = ''2'' THEN ''Debit Note''
                            WHEN transactiontype = ''3'' THEN ''Credit Note''
                            WHEN transactiontype = ''4'' THEN ''Refund''
                            WHEN transactiontype = ''5'' THEN ''Group Receipt''
                        END AS transactiontype,
                        CONVERT(VARCHAR(10), datetimeissued, 105) AS datetimeissued,
                        CONCAT(st.description, '' '', st.remarks) AS transactiondescription,
                        CASE 
                            WHEN cashierid = 0 THEN ''System''
                            WHEN cashierid = 1 THEN ''Admin''
                            ELSE CONCAT(e.Employee_FName, '' '', Employee_LName) 
                        END AS Issuedby
                    FROM student_transaction st
                    LEFT JOIN fixed_payment_method fpm ON fpm.id = paymentmethod
                    LEFT JOIN Tbl_Employee e ON e.Employee_Id = st.cashierid
                    LEFT JOIN Tbl_Candidate_Personal_Det pd ON st.studentid = pd.Candidate_Id
                    LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
                    LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = ad.Batch_Id
                    LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID
                    LEFT JOIN Tbl_Department AS D ON D.Department_Id = ad.Department_Id
                    LEFT JOIN student_bill_group bg ON st.studentid = bg.studentid
                    LEFT JOIN student_bill AS B ON B.billgroupid = BG.billgroupid
                    WHERE 
                        (IM.id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@IntakeId, '','')) OR @IntakeId = '''')
                        AND (Ad.Department_Id IN (SELECT CAST(Item AS INTEGER) FROM dbo.SplitString(@PgmID, '','')) OR @PgmID = '''')
                        AND (
                            (CONVERT(DATE, datetimeissued) >= @fromdate AND CONVERT(DATE, datetimeissued) < DATEADD(DAY, 1, @Todate))
                            OR (@fromdate IS NULL AND @Todate IS NULL)
                            OR (@fromdate IS NULL AND CONVERT(DATE, datetimeissued) < DATEADD(DAY, 1, @Todate))
                            OR (@Todate IS NULL AND CONVERT(DATE, datetimeissued) >= @fromdate)
                        )
                        AND st.billcancel = 1
                        AND ApplicationStatus != ''Old Data''
                )
                SELECT COUNT(*) AS counts, SUM(amount) AS totamount FROM level1;
            END
        END
    ')
END
