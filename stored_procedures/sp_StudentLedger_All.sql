IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_StudentLedger_All]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_StudentLedger_All]
        -- [dbo].[sp_StudentLedger_All] 2,1
        @flag bigint,
        @studentid bigint
        -- @FlagLedger char='' 
        AS
        BEGIN
            IF (@flag = 1)
            BEGIN
                SELECT 
                    b.description AS Item,
                    CONVERT(varchar, dateissue, 105) AS dateissued,
                    totalamountpayable,
                    totalamountpaid,
                    COALESCE(outstandingbalance, '''') AS balance
                FROM 
                    student_Bill b
                    LEFT JOIN ref_accountcode a ON a.id = b.accountcodeid
                WHERE 
                    studentid = @studentid 
                    AND b.billcancel = 0
            END

            IF (@flag = 2)
            BEGIN
                SELECT 
                    ST.transactionid,
                    CONVERT(varchar, ST.dateissued, 105) AS dateissued,
                    CASE 
                        WHEN (ST.transactiontype = 0) THEN SBG.docno 
                        ELSE ST.docno 
                    END AS docno,
                    CONCAT(AC.name, '' - '', ST.description) AS Description,
                    ST.amount,
                    ST.transactiontype,
                    CASE 
                        WHEN (SBG.billgroupid IS NULL OR SBG.billgroupid = '''') THEN 0 
                        ELSE SBG.billgroupid 
                    END AS billgroupid,
                    ST.canadjust,
                    0 AS Approvalstatus,
                    ST.flagledger,
                    CASE 
                        WHEN ST.flagledger = ''M'' THEN ''Main'' 
                        WHEN ST.flagledger = ''S'' THEN ''Sub'' 
                    END AS FLedger
                FROM 
                    dbo.student_bill AS SB 
                    INNER JOIN dbo.ref_accountcode AS AC ON SB.accountcodeid = AC.id 
                    RIGHT OUTER JOIN dbo.student_transaction AS ST ON SB.billid = ST.billid 
                    LEFT OUTER JOIN dbo.student_bill_group AS SBG ON ST.billgroupid = SBG.billgroupid
                WHERE 
                    ST.studentid = @studentid
            END
        END
    ')
END
