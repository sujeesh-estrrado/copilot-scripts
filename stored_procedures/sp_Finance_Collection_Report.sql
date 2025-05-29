IF NOT EXISTS (
    SELECT 1 FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_Collection_Report]')
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE PROCEDURE [dbo].[sp_Finance_Collection_Report] 
(    
@flag BIGINT = 0,    
@Cashier BIGINT = 0,    
@MethodofPayment BIGINT = 0,    
@reportType VARCHAR(MAX) = '''',    
@fromdate DATETIME = NULL,    
@Todate DATETIME = NULL,    
@CurrentPage INT = 1,                                     
@PageSize INT = 10,
@DeptId BIGINT = 0
)    
AS    
BEGIN    
    IF (@flag = 0)    
    BEGIN    
        IF (@reportType = ''1'')    
        BEGIN    
            SELECT CAST(ISNULL(SUM(sp.amount), 0) AS DECIMAL(18, 2)) AS amount,
                   sp.cashierid,
                   CONVERT(VARCHAR(50), sp.datetimeissued, 105) AS datetimeissued,    
                   CASE WHEN sp.cashierid = ''1'' THEN ''Admin'' ELSE CONCAT(e.Employee_FName, '' '', Employee_LName) END AS Cashiername,    
                   pm.name AS paymentmethod,    
                   '''' AS docno, 
                   0 AS adjustmentamount,
                   ''-NA-'' AS refno,
                   '''' AS remarks,
                   '''' AS description,
                   '''' AS bankname
            FROM student_transaction sp    
            LEFT JOIN Tbl_Employee e ON e.Employee_Id = sp.cashierid     
            LEFT JOIN fixed_payment_method pm ON pm.id = sp.paymentmethod    
            WHERE transactiontype = 1 
              AND (sp.cashierid = @Cashier OR @Cashier = 0) 
              AND (sp.paymentmethod = @MethodofPayment OR @MethodofPayment = 0)   
              AND sp.courseid = @DeptId 
              AND (((CONVERT(date, sp.datetimeissued)) >= @fromdate AND (CONVERT(date, sp.datetimeissued)) < DATEADD(day, 1, @Todate))     
                   OR (@fromdate IS NULL AND @Todate IS NULL)    
                   OR (@fromdate IS NULL AND (CONVERT(date, sp.datetimeissued)) < DATEADD(day, 1, @Todate))    
                   OR (@Todate IS NULL AND (CONVERT(date, sp.datetimeissued)) >= @fromdate))    
            GROUP BY sp.cashierid, CONVERT(VARCHAR(50), sp.datetimeissued, 105), Employee_FName, Employee_LName, pm.name      
            ORDER BY CONVERT(VARCHAR(50), sp.datetimeissued, 105)    
            OFFSET @PageSize * (@CurrentPage - 1) ROWS    
            FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);    
        END    
        IF (@reportType = ''2'')    
        BEGIN    
            SELECT DISTINCT st.transactionid,  
                   CONVERT(VARCHAR(50), st.datetimeissued, 105) AS datetimeissued,    
                   CASE WHEN st.cashierid = ''0'' THEN ''System'' WHEN st.cashierid = ''1'' THEN ''Admin'' ELSE CONCAT(e.Employee_FName, '' '', Employee_LName) END AS Cashiername,    
                   st.remarks AS description,    
                   CAST(ISNULL(st.amount, 0) AS DECIMAL(18, 2)) AS amount,
                   st.docno,    
                   CAST(ISNULL(st.adjustmentamount, 0) AS DECIMAL(18, 2)) AS adjustmentamount,    
                   CASE WHEN sp.refno IS NULL THEN ''-NA-'' WHEN sp.refno = '''' THEN ''-NA-'' ELSE sp.refno END AS refno,    
                   CASE WHEN rb.name IS NULL THEN ''-NA-'' WHEN rb.name = '''' THEN ''-NA-'' ELSE rb.name END AS bankname,    
                   pm.name AS paymentmethod    
            FROM student_transaction st    
            INNER JOIN student_payment sp ON st.transactionid = sp.transactionid    
            LEFT JOIN fixed_payment_method pm ON pm.id = st.paymentmethod    
            LEFT JOIN ref_bank rb ON rb.id = sp.bankname    
            LEFT JOIN Tbl_Employee e ON e.Employee_Id = sp.cashierid    
            WHERE transactiontype = 1 
              AND (st.cashierid = @Cashier OR @Cashier = 0) 
              AND (st.paymentmethod = @MethodofPayment OR @MethodofPayment = 0)   
              AND st.courseid = @DeptId    
              AND (((CONVERT(date, st.datetimeissued)) >= @fromdate AND (CONVERT(date, st.datetimeissued)) < DATEADD(day, 1, @Todate))     
                   OR (@fromdate IS NULL AND @Todate IS NULL)    
                   OR (@fromdate IS NULL AND (CONVERT(date, st.datetimeissued)) < DATEADD(day, 1, @Todate))    
                   OR (@Todate IS NULL AND (CONVERT(date, st.datetimeissued)) >= @fromdate))    
            ORDER BY st.transactionid    
            OFFSET @PageSize * (@CurrentPage - 1) ROWS    
            FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);    
        END    
    END    
    IF (@flag = 1)    
    BEGIN    
        IF (@reportType = ''1'')    
        BEGIN    
            WITH level1 AS (    
                SELECT CAST(ISNULL(SUM(sp.amount), 0) AS DECIMAL(18, 2)) AS amount,
                       sp.cashierid,    
                       CONVERT(VARCHAR(50), sp.datetimeissued, 105) AS datetimeissued,    
                       CASE WHEN sp.cashierid = ''1'' THEN ''Admin'' ELSE CONCAT(e.Employee_FName, '' '', Employee_LName) END AS Cashiername,    
                       pm.name AS paymentmethod,    
                       '''' AS docno, 
                       0 AS adjustmentamount, 
                       ''-NA-'' AS refno, 
                       '''' AS remarks, 
                       '''' AS description, 
                       '''' AS bankname    
                FROM student_transaction sp    
                LEFT JOIN Tbl_Employee e ON e.Employee_Id = sp.cashierid     
                LEFT JOIN fixed_payment_method pm ON pm.id = sp.paymentmethod    
                WHERE transactiontype = 1 
                  AND (sp.cashierid = @Cashier OR @Cashier = 0) 
                  AND (sp.paymentmethod = @MethodofPayment OR @MethodofPayment = 0)    
                  AND sp.courseid = @DeptId 
                  AND (((CONVERT(date, sp.datetimeissued)) >= @fromdate AND (CONVERT(date, sp.datetimeissued)) < DATEADD(day, 1, @Todate))     
                       OR (@fromdate IS NULL AND @Todate IS NULL)    
                       OR (@fromdate IS NULL AND (CONVERT(date, sp.datetimeissued)) < DATEADD(day, 1, @Todate))    
                       OR (@Todate IS NULL AND (CONVERT(date, sp.datetimeissued)) >= @fromdate))    
                GROUP BY sp.cashierid, CONVERT(VARCHAR(50), sp.datetimeissued, 105), Employee_FName, Employee_LName, pm.name      
            )    
            SELECT COUNT(*) AS counts, SUM(amount) AS totamount FROM level1;    
        END    
        IF (@reportType = ''2'')    
        BEGIN    
            WITH level1 AS (    
                SELECT DISTINCT CONVERT(VARCHAR(50), st.datetimeissued, 105) AS datetimeissued,    
                       CASE WHEN st.cashierid = ''0'' THEN ''System'' WHEN st.cashierid = ''1'' THEN ''Admin'' ELSE CONCAT(e.Employee_FName, '' '', Employee_LName) END AS Cashiername,    
                       st.remarks AS description,    
                       CAST(ISNULL(st.amount, 0) AS DECIMAL(18, 2)) AS amount,
                       st.docno,    
                       CAST(ISNULL(st.adjustmentamount, 0) AS DECIMAL(18, 2)) AS adjustmentamount,    
                       CASE WHEN sp.refno IS NULL THEN ''-NA-'' WHEN sp.refno = '''' THEN ''-NA-'' ELSE sp.refno END AS refno,    
                       CASE WHEN rb.name IS NULL THEN ''-NA-'' WHEN rb.name = '''' THEN ''-NA-'' ELSE rb.name END AS bankname,    
                       pm.name AS paymentmethod    
                FROM student_transaction st    
                INNER JOIN student_payment sp ON st.transactionid = sp.transactionid    
                LEFT JOIN fixed_payment_method pm ON pm.id = st.paymentmethod    
                LEFT JOIN ref_bank rb ON rb.id = sp.bankname    
                LEFT JOIN Tbl_Employee e ON e.Employee_Id = sp.cashierid    
                WHERE transactiontype = 1 
                  AND (st.cashierid = @Cashier OR @Cashier = 0) 
                  AND (st.paymentmethod = @MethodofPayment OR @MethodofPayment = 0)    
                  AND st.courseid = @DeptId     
                  AND (((CONVERT(date, st.datetimeissued)) >= @fromdate AND (CONVERT(date, st.datetimeissued)) < DATEADD(day, 1, @Todate))     
                       OR (@fromdate IS NULL AND @Todate IS NULL)    
                       OR (@fromdate IS NULL AND (CONVERT(date, st.datetimeissued)) < DATEADD(day, 1, @Todate))    
                       OR (@Todate IS NULL AND (CONVERT(date, st.datetimeissued)) >= @fromdate))    
            )    
            SELECT COUNT(*) AS counts, 
                   SUM(amount) AS totamount, 
                   SUM(adjustmentamount) AS totadjustmentamount 
            FROM level1;    
        END    
    END    
END    
    ')
END
GO
