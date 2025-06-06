IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_updateSheduleTime_Placement]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       
CREATE procedure [dbo].[SP_updateSheduleTime_Placement](@candidate_id bigint,@date date,@facultyid bigint,@Venue varchar(500),@Time varchar(50),@ScheduledBy bigint=0,@placLink varchar(max))
as
begin
update Tbl_Placement_Schedule_Log 
set reschedule_date=@date,Staff_id=@facultyid,Placement_status='''',Placement_venue=@Venue,Placement_Time=@Time,rechedule_count=rechedule_count+1
where candidate_id=@candidate_id;
 insert Tbl_Placement_log(Candidate_id,Schedule_date,scheduled_by)
 values(@candidate_id,@date,@ScheduledBy);
 update Tbl_Placement_log
 set Placement_Link=@placLink
 where Candidate_id=@candidate_id;
end
    ')
END
