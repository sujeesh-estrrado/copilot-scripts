IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_followupExist_Or_not]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[Sp_followupExist_Or_not]
@FollowupstatusName varchar(150)
as
begin
select count(*) as followupcount from Tbl_FollowupStatus_Master where Followup_Name=@FollowupstatusName and Followup_DelStatus=0
end
    ')
END
