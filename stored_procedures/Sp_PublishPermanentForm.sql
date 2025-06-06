IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_PublishPermanentForm]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[Sp_PublishPermanentForm]
    @Permanent_FormId BIGINT
AS
BEGIN
    DECLARE @Result INT = 0;

    -- Check if at least one employee or student is assigned
    IF EXISTS (
        SELECT 1 FROM tbl_PermanentFormEmployee WHERE Permanent_FormId = @Permanent_FormId
    )
    OR EXISTS (
        SELECT 1 FROM tbl_PermanentFormAddStudent WHERE Permanent_FormId = @Permanent_FormId
    )
    BEGIN
        -- Update form status to ''Published'' (1)
        UPDATE Tbl_PermanentForm
        SET Status = 1
        WHERE Permanent_FormId = @Permanent_FormId;

        -- Indicate success
        SET @Result = 1;
    END

    -- Return result
    SELECT @Result AS Result;
END
   ')
END;
