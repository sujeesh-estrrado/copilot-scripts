IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_check_Request_Delete]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[Sp_check_Request_Delete](@candidate_id bigint=0)
as
begin
select * from Tbl_Delete_Request where Candidate_id=@candidate_id and Delete_status=0
end
    ')
END
