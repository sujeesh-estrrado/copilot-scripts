IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_FollowupLead_Status]')
    AND type = N'P'
)
BEGIN
    EXEC('
   create procedure [dbo].[Sp_Get_FollowupLead_Status]
as
begin
--select * from tbl_leadfollowupstatus
select Followp_Id as Status_Id,Followup_Name as Status from Tbl_FollowupStatus_Master where Followup_DelStatus=0
end
    ')
END
