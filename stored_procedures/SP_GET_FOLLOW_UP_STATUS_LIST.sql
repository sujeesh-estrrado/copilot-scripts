IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GET_FOLLOW_UP_STATUS_LIST]')
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_GET_FOLLOW_UP_STATUS_LIST]
AS
BEGIN
    -- SET NOCOUNT ON added to prevent extra result sets from
    -- interfering with SELECT statements.
    SET NOCOUNT ON;

    -- Insert statements for procedure here
--Select Distinct(Respond_Type) As Follow_Up_Status from Tbl_FollowUpLead_Detail
Select Distinct(Followup_Name) As Follow_Up_Status from Tbl_FollowupStatus_Master WHERE Followup_DelStatus = 0
END
    ')
END
