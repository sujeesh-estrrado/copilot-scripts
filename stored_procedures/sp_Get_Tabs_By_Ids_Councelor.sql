IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Tabs_By_Ids_Councelor]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[sp_Get_Tabs_By_Ids_Councelor]
    @TabIds VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TabName, Faculty, Programme, Batch
    FROM tbl_Counsilor_Custom_Filter
    WHERE ID IN (SELECT value FROM dbo.SplitStringFunction(@TabIds, '',''))
    AND Dashboard = ''CounsellorLead ''
    and DeleteStatus=0;
END;

');
END;
