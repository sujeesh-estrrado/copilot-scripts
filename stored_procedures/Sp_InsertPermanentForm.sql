IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_InsertPermanentForm]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_InsertPermanentForm]
    @Flag INT,
    @Form_Title VARCHAR(200) = NULL,
    @Form_Type INT = NULL,
    @Permanent_FormId BIGINT,
    @Question_type TINYINT = NULL,
    @Question VARCHAR(200) = NULL,
    @Options VARCHAR(1000) = NULL,
    @Upload_Type TINYINT = NULL
AS
BEGIN
    SET NOCOUNT ON;


    IF @Flag = 0
    BEGIN
        INSERT INTO Tbl_PermanentForm (
            Form_Title,
            Form_Type,
            Created_Date,
            Delete_Status,
            Status
        )
        VALUES (
            @Form_Title,
            @Form_Type,
            GETDATE(),
            0,
            2
        );

        SELECT SCOPE_IDENTITY();
    END
    
    
    IF @Flag = 1 AND @Permanent_FormId IS NOT NULL
    BEGIN
        IF @Question_type = 1
        BEGIN
            SET @Options = NULL;
            SET @Upload_Type = NULL;
        END
        ELSE IF @Question_type = 2
        BEGIN
            SET @Upload_Type = NULL; 
        END
        ELSE IF @Question_type = 3
        BEGIN
            SET @Options = NULL; 
        END

        INSERT INTO tbl_PermanentFormMapping (
            Permanent_FormId,
            Question_type,
            Question,
            Options,
            Upload_Type,
            Created_Date,
            Delete_Status
        )
        VALUES (
            @Permanent_FormId,
            @Question_type,
            @Question,
            @Options,
            @Upload_Type,
            GETDATE(),
            0
        );
    END

    RETURN 0;
END
    ')
END;
