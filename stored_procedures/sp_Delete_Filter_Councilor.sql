IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Delete_Filter_Councilor]') 
    AND type = N'P'
)
BEGIN
    EXEC('

create PROCEDURE [dbo].[sp_Delete_Filter_Councilor]
    @TabId BIGINT = NULL 
AS
BEGIN
    SET NOCOUNT ON;

     DELETE FROM tbl_Counsilor_Custom_Filter
     WHERE Id = @TabId  
     AND Dashboard = ''Counsellor''
END;
');
END;
