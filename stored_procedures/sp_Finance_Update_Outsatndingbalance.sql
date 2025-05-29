IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Finance_Update_Outsatndingbalance]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[sp_Finance_Update_Outsatndingbalance]
    (
        @studentid BIGINT = 0
    )
    AS
    BEGIN
        UPDATE Tbl_Candidate_Personal_Det
        SET billoutstanding = (
            (
                SELECT ISNULL(SUM(ST.amount), 0.00)
                FROM dbo.student_transaction AS ST
                WHERE ST.studentid = @studentid
                AND ST.billcancel = 0
                AND transactiontype IN (0, 4, 2)
            ) -
            (
                SELECT ISNULL(SUM(ST.amount), 0.00)
                FROM dbo.student_transaction AS ST
                WHERE ST.studentid = @studentid
                AND ST.billcancel = 0
                AND transactiontype IN (1, 3, 5)
            )
        )
        WHERE Candidate_Id = @studentid
    END
    ')
END
