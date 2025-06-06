IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_UpdatePermanentForm]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Sp_UpdatePermanentForm]
    @Flag INT,  
    @Permanent_FormId BIGINT,
    @Form_Title NVARCHAR(150) = NULL,
    @Form_Type INT = NULL,
    @Mapping_Id BIGINT = NULL,
    @Question_type TINYINT = NULL,
    @Question VARCHAR(200) = NULL,
    @Options VARCHAR(1000) = NULL,
    @Upload_Type TINYINT = NULL
AS
BEGIN
    SET NOCOUNT ON;
    

    IF @Flag = 0
    BEGIN
        UPDATE Tbl_PermanentForm
        SET 
            Form_Title = @Form_Title,
            Form_Type = @Form_Type,
            Updated_Date = GETDATE()
        WHERE Permanent_FormId = @Permanent_FormId;
        
        SELECT @Permanent_FormId AS Permanent_FormId;
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
