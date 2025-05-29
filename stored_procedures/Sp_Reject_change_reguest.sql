IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Reject_change_reguest]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Reject_change_reguest](@Candidate_id bigint ,@userid bigint)
as

begin

update Tbl_Program_change_request set Application_status=''Rejected'', delete_status=1,Updated_by=@userid where Candidate_id=@Candidate_id;
end
');
END;