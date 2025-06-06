IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_updateSheduleTime]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE procedure [dbo].[SP_updateSheduleTime](@candidate_id bigint,@date date,@facultyid bigint,@Venue varchar(500),@Time varchar(50),@ScheduledBy bigint=0,@intLink varchar(max))
as
begin
update Tbl_Interview_Schedule_Log 
set reschedule_date=@date,Staff_id=@facultyid,Interview_status='''',Interview_venue=@Venue,Interview_Time=@Time,rechedule_count=rechedule_count+1
where candidate_id=@candidate_id;
 insert Tbl_Interview_log(Candidate_id,Schedule_date,scheduled_by)
 values(@candidate_id,@date,@ScheduledBy);
  update Tbl_Interview_log
 set Interview_Link=@intLink
 where Candidate_id=@candidate_id;
end
    ')
END;
