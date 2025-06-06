IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_ApplicationFeeBalance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_ApplicationFeeBalance]
        (@studentid bigint = 0)
        AS
        BEGIN
            SELECT SUM(outstandingbalance) 
            FROM student_bill 
            WHERE billgroupid IN (
                SELECT billgroupid 
                FROM student_transaction 
                WHERE studentid = @studentid 
                AND semesterno = -1
            );
        END
    ')
END
