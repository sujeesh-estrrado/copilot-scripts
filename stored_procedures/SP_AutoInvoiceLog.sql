IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_AutoInvoiceLog]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_AutoInvoiceLog]
        (
            @Flag int = 0,
            @StudentId bigint = 0,
            @Feegroupid bigint = 0,
            @Semester int = 0,
            @InvoiceDate datetime = NULL,
            @Billid bigint = 0,
            @BillGroupID bigint = 0,
            @TransactionID bigint = 0
        )
        AS
        BEGIN
            IF (@Flag = 1)
            BEGIN 
                INSERT INTO [dbo].[Tbl_AutoInvoiceLog]
                (
                    [StudentId],
                    [Feegroupid],
                    [Semester],
                    [InvoiceDate],
                    [Billid],
                    [BillGroupID],
                    [TransactionID]
                )
                VALUES
                (
                    @StudentId,
                    @Feegroupid,
                    @Semester,
                    GETDATE(),
                    @Billid,
                    @BillGroupID,
                    @TransactionID
                )
            END

            IF (@Flag = 2)
            BEGIN 
                SELECT * 
                FROM Tbl_AutoInvoiceLog 
                WHERE 
                    (@StudentId = 0 OR StudentId = @StudentId) AND
                    (@Feegroupid = 0 OR Feegroupid = @Feegroupid) AND
                    (@Semester = 0 OR Semester = @Semester)
            END

            IF (@Flag = 3) -- Get ApplicationFeeInv TransactionID
            BEGIN 
                SELECT * 
                FROM Tbl_AutoInvoiceLog 
                WHERE 
                    (@StudentId = 0 OR StudentId = @StudentId) AND
                    (@TransactionID = @TransactionID)
            END
        END
    ')
END
