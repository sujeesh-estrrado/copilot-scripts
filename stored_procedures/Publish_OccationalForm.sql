IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Publish_OccationalForm]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[Publish_OccationalForm]
    @OccasionalForm_FormId BIGINT
AS
BEGIN
    DECLARE @Result INT = 0;

    -- Check if at least one employee or student is assigned
    IF EXISTS (
        SELECT 1 FROM OccationalForm_Employee WHERE OccasionalForm_FormId = @OccasionalForm_FormId
    )
    OR EXISTS (
        SELECT 1 FROM Occational_AddStudent WHERE OccasionalForm_FormId = @OccasionalForm_FormId
    )
    BEGIN
        -- Update form status to ''Published'' (1)
        UPDATE OccasionalForms
        SET OccasionalForm_StatusId = 1
        WHERE OccasionalForm_FormId = @OccasionalForm_FormId;

        -- Indicate success
        SET @Result = 1;
    END

    -- Return result
    SELECT @Result AS Result;
END
   ')
END;
