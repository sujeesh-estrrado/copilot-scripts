IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Delete_Tab_Counsellor_Dashboard]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_Delete_Tab_Counsellor_Dashboard]
    @TabId BIGINT
AS
BEGIN
   
    UPDATE tbl_Counsilor_Custom_Filter
    SET DeleteStatus = 1
    WHERE ID = @TabId
	and Dashboard=''Counsellor '';
	 
    SELECT @@ROWCOUNT AS RowsAffected;
END
');
END;
