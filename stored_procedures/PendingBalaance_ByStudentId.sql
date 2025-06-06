IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[PendingBalance_ByStudentId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[PendingBalance_ByStudentId]
            @StudentId BIGINT
        AS
        BEGIN
          

            SELECT 
                accountcodeid,
                bg.docno,
                totalamount,
                totalamountpaid,
                totalamountpayable,
                b.[description],
                name AS AccountCode,
                B.outstandingbalance,
                Bg.billgroupid,
                b.billid,
                b.studentid
            FROM student_bill b
            LEFT JOIN student_bill_group bg ON b.billgroupid = bg.billgroupid
            LEFT JOIN ref_accountcode A ON b.accountcodeid = A.id
            WHERE b.studentid = @StudentId 
                AND outstandingbalance > 0;
        END
    ')
END
