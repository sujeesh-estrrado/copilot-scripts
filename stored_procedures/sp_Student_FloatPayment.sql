IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Student_FloatPayment]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Student_FloatPayment]
        @StudentId BIGINT = 0, 
        @flagledger VARCHAR = '''', 
        @accountcodeid BIGINT = -1
        AS
        BEGIN
            SELECT * 
            FROM student_payment_float
            WHERE 
                studentid = @StudentId
                AND (@flagledger = '''' OR flagLedger = @flagledger)
                AND (@accountcodeid = -1 OR accountcodeid = @accountcodeid)
            ORDER BY floatamount DESC
        END
    ')
END
