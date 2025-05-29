IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_PassInterview]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_PassInterview](@candidate_id bigint,@status varchar(50))
as
begin
declare @test date
update Tbl_Interview_Schedule_Log
set Interview_status=@status
where candidate_id=@candidate_id
if((select reschedule_date from Tbl_Interview_Schedule_Log where candidate_id=@candidate_id) is not null)
begin

update Tbl_Interview_log set result=@status where Candidate_id=@candidate_id and Schedule_date=(select reschedule_date from Tbl_Interview_Schedule_Log where candidate_id=@candidate_id);
end
else
begin
update Tbl_Interview_log set result=@status where Candidate_id=@candidate_id and Schedule_date=(select Interview_date from Tbl_Interview_Schedule_Log where candidate_id=@candidate_id);

end
end
');
END