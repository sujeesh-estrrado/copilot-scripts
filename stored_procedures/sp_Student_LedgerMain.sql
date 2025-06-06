IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Student_LedgerMain]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Student_LedgerMain]
        @StudentID BIGINT, 
        @FlagLedger CHAR = ''''
        AS
        BEGIN
            SELECT 
                ST.transactionid, 
                CONVERT(VARCHAR, ST.dateissued, 105) AS dateissued, 
                CASE 
                    WHEN (ST.transactiontype = 0) THEN SBG.docno 
                    ELSE ST.docno 
                END AS docno, 
                CONCAT(AC.name, ''-'', ST.description) AS Description, 
                (SELECT ST.amount WHERE ST.transactiontype = 0 OR ST.transactiontype = 4 OR ST.transactiontype = 2) AS Debit, 
                (SELECT ST.amount WHERE ST.transactiontype = 1 OR ST.transactiontype = 3 OR ST.transactiontype = 5) AS Credit, 
                ST.transactiontype, 
                CASE 
                    WHEN (SBG.billgroupid IS NULL OR SBG.billgroupid = '''') THEN 0 
                    ELSE SBG.billgroupid 
                END AS billgroupid, 
                ST.canadjust, 
                0 AS Approvalstatus, 
                COALESCE(relatedid, 0) AS relatedid
            FROM dbo.student_bill AS SB
            INNER JOIN dbo.ref_accountcode AS AC ON SB.accountcodeid = AC.id
            RIGHT OUTER JOIN dbo.student_transaction AS ST ON SB.billid = ST.billid
            LEFT OUTER JOIN dbo.student_bill_group AS SBG ON ST.billgroupid = SBG.billgroupid
            WHERE 
                ST.studentid = @StudentID 
                AND (ST.flagledger = @FlagLedger OR @FlagLedger IS NULL OR @FlagLedger = ''A'') 
                AND ST.billcancel = 0
            ORDER BY ST.dateissued
        END
    ')
END
