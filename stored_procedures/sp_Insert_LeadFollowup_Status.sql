IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Insert_LeadFollowup_Status]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_Insert_LeadFollowup_Status]
@status varchar(max)
as 
begin
insert into tbl_leadfollowupstatus values(@status,0)
end
    ');
END;
