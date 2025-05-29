IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Refund_Request_Payee_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_Refund_Request_Payee_Details]
(
    @flag INT = 0,
    @ID BIGINT = 0,
    @ApprovalRequestId BIGINT = 0,
    @StudentID BIGINT = 0,
    @PaymentRegion INT = 0,
    @PayMethod INT = 0,
    @StudentName VARCHAR(MAX) = '''',
    @BankName VARCHAR(MAX) = '''',
    @AccountNumber VARCHAR(MAX) = '''',
    @BankAddress VARCHAR(MAX) = '''',
    @BankCity VARCHAR(MAX) = '''',
    @BankCountry VARCHAR(MAX) = '''',
    @BankCode VARCHAR(MAX) = '''',
    @Status INT = 0,
    @CreateDate DATE = NULL,
    @UpdateDate DATE = NULL
)
AS
BEGIN
    IF (@flag = 1)  -- Insert Into Refund_Request_Payee_Details
    BEGIN
        INSERT INTO [dbo].[Refund_Request_Payee_Details]
        (
            [ApprovalRequestId],
            [StudentID],
            [PaymentRegion],
            [PayMethod],
            [StudentName],
            [BankName],
            [AccountNumber],
            [BankAddress],
            [BankCity],
            [BankCountry],
            [BankCode],
            [Status],
            [CreateDate],
            [UpdateDate]
        )
        VALUES
        (
            @ApprovalRequestId,
            @StudentID,
            @PaymentRegion,
            @PayMethod,
            @StudentName,
            @BankName, 
            @AccountNumber, 
            @BankAddress, 
            @BankCity,
            @BankCountry,
            @BankCode,
            1,  -- Default status to 1 (Active/Approved)
            GETDATE(),
            GETDATE()
        )
    END
    
    IF (@flag = 2)  -- Select Refund_Request_Payee_Details
    BEGIN
        SELECT 
            [ID],
            [ApprovalRequestId],
            [StudentID],
            [PaymentRegion],
            [PayMethod],
            [StudentName],
            [BankName],
            [AccountNumber],
            [BankAddress],
            [BankCity],
            [BankCountry],
            [BankCode],
            [Status],
            [CreateDate],
            [UpdateDate]
        FROM [dbo].[Refund_Request_Payee_Details]
        WHERE ApprovalRequestId = @ApprovalRequestId
    END
END
');
END;