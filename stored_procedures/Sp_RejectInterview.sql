IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_RejectInterview]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_RejectInterview] (@candidate_id bigint)
as
begin
update Tbl_Interview_Schedule_Log set Interview_status=''Rejected'' where candidate_id=@candidate_id;
end
');
END;