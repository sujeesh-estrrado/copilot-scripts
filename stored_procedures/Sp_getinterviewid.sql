IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_getinterviewid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_getinterviewid](@Candidateid bigint)
as
begin
select schedule_id from Tbl_Interview_Schedule_Log where candidate_id=@Candidateid and delete_status=0;
end
');
END;