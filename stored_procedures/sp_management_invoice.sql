IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_management_invoice]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[sp_management_invoice]  
(
    @id BIGINT,
    @year BIGINT = NULL  -- Optional year filter
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Default @year to the current year if NULL or 0
    IF @year IS NULL OR @year = 0
        SET @year = YEAR(GETDATE());

    -- Fetch Total Amount Payable for the Given Year
    IF @id = 24
    BEGIN
        SELECT 
            COUNT(*) AS counts, 
            SUM(amount) AS totamount 
        FROM (
            SELECT 
                Pd.Candidate_Id,
                CONCAT(Pd.Candidate_Fname, '' '', Pd.Candidate_Lname) AS CandidateName,
                st.billcancel,
                Pd.AdharNumber, Pd.IDMatrixNo, 
                IM.intake_no AS Batch_Code, 
                Ad.Batch_Id AS IntakeID, 
                CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name, 
                Ad.Department_Id AS ProgrammeID, 
                D.GraduationTypeId AS FacultyID,
                st.docno AS Documentno, 
                SBG.docno AS invoiceNo,
                CAST(st.amount AS DECIMAL(18, 2)) AS amount,
                fpm.name AS paymentmethod,
                CASE 
                    WHEN st.transactiontype = ''0'' THEN ''Invoice'' 
                    WHEN st.transactiontype = ''1'' THEN ''Receipt'' 
                    WHEN st.transactiontype = ''2'' THEN ''Debit Note'' 
                    WHEN st.transactiontype = ''3'' THEN ''Credit Note'' 
                    WHEN st.transactiontype = ''4'' THEN ''Refund'' 
                    WHEN st.transactiontype = ''5'' THEN ''Group Receipt'' 
                END AS transactiontype,
                CONVERT(DATE, st.datetimeissued) AS datetimeissued,
                CONCAT(st.description, '' '', st.remarks) AS transactiondescription,
                CASE 
                    WHEN st.cashierid = 0 THEN ''System'' 
                    WHEN st.cashierid = 1 THEN ''Admin'' 
                    ELSE CONCAT(e.Employee_FName, '' '', e.Employee_LName) 
                END AS Issuedby,
                sb.totalamountpaid AS PaidAmount,
                CASE 
                    WHEN sb.totalamountpayable = sb.totalamountpaid THEN ''Fully Paid'' 
                    WHEN sb.totalamountpayable > sb.totalamountpaid AND sb.totalamountpaid > 0 THEN ''Partially Paid''
                    WHEN sb.totalamountpaid = 0 THEN ''Not Paid'' 
                END AS Payment_Status
            FROM Tbl_Candidate_Personal_Det pd  
            INNER JOIN student_transaction st ON st.studentid = pd.Candidate_Id
            LEFT JOIN fixed_payment_method fpm ON fpm.id = st.paymentmethod
            LEFT JOIN Tbl_Employee e ON e.Employee_Id = st.cashierid
            LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
            LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = Ad.Batch_Id
            LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID 
            LEFT JOIN Tbl_Department AS D ON D.Department_Id = Ad.Department_Id
            LEFT JOIN student_bill_group AS SBG ON SBG.billgroupid = st.billgroupid
            LEFT JOIN student_bill sb ON sb.billgroupid = SBG.billgroupid
            WHERE st.transactiontype = ''0''  -- Only Invoice Transactions
            AND YEAR(st.datetimeissued) = @year
        ) AS InvoiceData; -- Subquery to allow aggregation
    END

    -- Fetch Total Outstanding Balance (All Years)
    ELSE IF @id = 25
    BEGIN
WITH base1 AS (
    SELECT  
        Pd.Candidate_Id,
        CONCAT(Pd.Candidate_Fname, '' '', Pd.Candidate_Lname) AS CandidateName, 
        st.billcancel,
        Pd.AdharNumber, 
        Pd.IDMatrixNo, 
        IM.intake_no AS Batch_Code, 
        Ad.Batch_Id AS IntakeID,
        CONCAT(D.Course_Code, ''-'', D.Department_Name) AS Department_Name, 
        Ad.Department_Id AS ProgrammeID, 
        D.GraduationTypeId AS FacultyID,
        st.docno AS Documentno,
        SBG.docno AS invoiceNo,
        CAST(st.amount AS DECIMAL(18, 2)) AS amount,
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
        END AS Issuedby,
        sb.totalamountpaid AS PaidAmount,
        CASE 
            WHEN sb.totalamountpayable = sb.totalamountpaid THEN ''Fully Paid'' 
            WHEN sb.totalamountpayable > sb.totalamountpaid AND sb.totalamountpaid > 0 THEN ''Partially Paid''
            WHEN sb.totalamountpaid = 0 THEN ''Not Paid'' 
        END AS Payment_Status
    FROM Tbl_Candidate_Personal_Det pd  
    INNER JOIN student_transaction st ON st.studentid = pd.Candidate_Id
    LEFT JOIN fixed_payment_method fpm ON fpm.id = st.paymentmethod
    LEFT JOIN Tbl_Employee e ON e.Employee_Id = st.cashierid
    LEFT JOIN tbl_New_Admission Ad ON pd.New_Admission_Id = Ad.New_Admission_Id
    LEFT JOIN Tbl_Course_Batch_Duration bd ON bd.Batch_Id = Ad.Batch_Id
    LEFT JOIN Tbl_IntakeMaster IM ON IM.id = bd.IntakeMasterID 
    LEFT JOIN Tbl_Department AS D ON D.Department_Id = Ad.Department_Id
    LEFT JOIN student_bill_group SBG ON SBG.billgroupid = st.billgroupid
    LEFT JOIN student_bill sb ON sb.billgroupid = SBG.billgroupid
    WHERE 
        st.transactiontype = 0  -- Only Invoices
        AND sb.totalamountpaid = 0  -- Only Not Paid Transactions
        AND st.amount > 0
        AND YEAR(datetimeissued) = @year  -- Filter by year
)
SELECT 
    COUNT(*) AS counts, 
    SUM(amount) AS totamount
FROM base1;
END

    -- Fetch Outstanding Balance for the Given Year
    ELSE IF @id = 26
    BEGIN
    SELECT 
    YEAR(st.datetimeissued) AS Year,
    COUNT(st.docno) AS counts, 
    SUM(st.amount) AS totamount,  -- Total invoice amount
    SUM(sb.totalamountpayable - sb.totalamountpaid) AS outstanding_amount, -- Remaining unpaid amount
    SUM(CASE 
            WHEN sb.totalamountpayable = sb.totalamountpaid THEN st.amount 
            ELSE 0 
        END) AS fully_paid_amount,  -- Sum of fully paid invoices
    SUM(CASE 
            WHEN sb.totalamountpayable > sb.totalamountpaid AND sb.totalamountpaid > 0 THEN st.amount 
            ELSE 0 
        END) AS partially_paid_amount, -- Sum of partially paid invoices
    SUM(CASE 
            WHEN sb.totalamountpayable = sb.totalamountpaid THEN st.amount 
            WHEN sb.totalamountpayable > sb.totalamountpaid AND sb.totalamountpaid > 0 THEN st.amount 
            ELSE 0 
        END) AS total_paid_amount -- Sum of fully paid + partially paid invoices
FROM student_transaction st
INNER JOIN student_bill sb ON sb.billgroupid = st.billgroupid
WHERE st.transactiontype = ''0'' -- Only Invoice Transactions
AND YEAR(st.datetimeissued) = @year
GROUP BY YEAR(st.datetimeissued)
ORDER BY Year DESC;

    END
END;
    ')
END;
