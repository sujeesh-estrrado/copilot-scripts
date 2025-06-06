IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Student_SponsorshipDetails]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Student_SponsorshipDetails]
        (
            @studentid bigint = 0
        )
        AS
        BEGIN
            SELECT  
                ISNULL(PerSemAmount, CAST(0 AS decimal(3,2))) AS PerSemAmount,
                SemID,
                SS.studentid,
                SS.sponsorid,
                ISNULL(SS.amount, CAST(0 AS decimal(3,2))) AS amount,
                SL.Amount AS paidAmount,
                SL.SponsorID
            FROM Tbl_SponsorshipPaymentLog SL
            LEFT JOIN student_sponsor SS ON SS.studentid = SL.StudentID
            LEFT JOIN tbl_SponsorshipSemDetails SD ON SD.SponsorshipID = SS.sponsorid
            WHERE SS.studentid = @studentid 
              AND SemID = 1
        END
    ')
END
