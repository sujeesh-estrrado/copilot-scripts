IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Tabs_By_Ids]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[sp_Get_Tabs_By_Ids]
    @TabIds VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;
    
    SELECT TabName, Faculty, Programme, Batch
    FROM tbl_Counsilor_Custom_Filter
    WHERE ID IN (SELECT value FROM dbo.SplitStringFunction(@TabIds, '',''))
    AND Dashboard = ''CounsellorLead''
    and DeleteStatus=0;
END;

');
END;
