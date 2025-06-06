IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_StudentInvoiceDocUpload]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_StudentInvoiceDocUpload]
        (
            @Flag bigint = 0,
            @id bigint = 0,
            @StudentId bigint = 0,
            @DocType varchar(50) = '''',
            @DocumentName varchar(500) = '''',
            @DocumentLoc varchar(MAX) = '''',
            @DeleteStatus bit = 0,
            @PaymentLink varchar(500) = ''''
        )
        AS
        BEGIN
            IF (@Flag = 1) -- Insert
            BEGIN
                INSERT INTO [dbo].[Tbl_Student_InvoiceUpload]
                    ([StudentId], [DocType], [InvoiceDescription], [DocumentLoc], [CreatedDate], [LastUpdate], [DeleteStatus], [PaymentLink])
                VALUES
                    (@StudentId, @DocType, @DocumentName, @DocumentLoc, GETDATE(), GETDATE(), 0, @PaymentLink)
            END

            IF (@Flag = 2) -- Select
            BEGIN
                SELECT [id], [StudentId], [DocType], [DocumentName], [DocumentLoc], [DeleteStatus]
                FROM [dbo].[tbl_StudentDocUpload]
                WHERE [StudentId] = @StudentId
            END

            -- IF(@Flag = 3) -- Delete
            -- BEGIN
            --     UPDATE [tbl_StudentDocUpload] 
            --     SET [DeleteStatus] = 1 
            --     WHERE [id] = @id
            -- END

            -- IF(@Flag = 4) -- Check DocName Existence
            -- BEGIN
            --     SELECT COUNT(*) 
            --     FROM [tbl_StudentDocUpload] 
            --     WHERE [DocumentName] = @DocumentName 
            --     AND [StudentId] = @StudentId 
            --     AND [DeleteStatus] = 0
            -- END

            -- IF(@Flag = 5) -- Marketing reject check status
            -- BEGIN
            --     SELECT * 
            --     FROM [tbl_StudentDocUpload] 
            --     WHERE DocType = @DocType 
            --     AND MarketingVerify != 1 
            --     AND StudentId = @StudentId
            -- END

            -- IF(@Flag = 6) -- Admission reject check status
            -- BEGIN
            --     SELECT * 
            --     FROM [tbl_StudentDocUpload] 
            --     WHERE DocType = @DocType 
            --     AND AdmissionVerify != 1 
            --     AND StudentId = @StudentId
            -- END
        END
    ')
END
