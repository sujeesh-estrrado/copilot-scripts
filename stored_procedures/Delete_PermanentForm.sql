IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Delete_PermanentForm]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[Delete_PermanentForm]
    @Permanent_FormId BIGINT
AS
BEGIN
    UPDATE Tbl_PermanentForm
    SET Delete_Status = 1  
    WHERE Permanent_FormId = @Permanent_FormId
END
   ')
END;
