IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_LeadStatus_change_by_Marketing_by_Candidate_id]')
    AND type = N'P'
)
BEGIN
    EXEC('
   create procedure [dbo].[Sp_Get_LeadStatus_change_by_Marketing_by_Candidate_id]
(
@flag bigint=0,
@candidate_id bigint
)
as
begin
	if(@flag=0)
		begin
			select * from Tbl_LeadStatus_Change_by_Marketing where Candidate_id=@candidate_id and delete_status=0;
		end
	if(@flag=1)
		begin
			Update Tbl_LeadStatus_Change_by_Marketing set delete_status=1 where Candidate_id=@candidate_id 
		end
end
    ')
END
