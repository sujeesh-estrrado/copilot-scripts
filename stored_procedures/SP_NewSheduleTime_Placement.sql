IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_NewSheduleTime_Placement]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    
CREATE procedure [dbo].[SP_NewSheduleTime_Placement]
(
@candidate_id bigint=0,
@date date='''',
@interview_time varchar(50)='''',
@Venue varchar(500)='''',
@uid bigint='''',
@interviewed_by bigint=0,
@flag bigint=0,
@remark varchar(max),
@placLink varchar(max)
)
as
begin
if(@flag=0)
    begin
        if not exists(select * from Tbl_Placement_Schedule_Log where candidate_id=@candidate_id and delete_status=0)
            begin
                insert into Tbl_Placement_Schedule_Log(Placement_date,candidate_id,Placement_Time,Placement_venue,Scheduled_by,Staff_id,rechedule_count,delete_status)
                 values(@date,@candidate_id,@interview_time,@Venue,@interviewed_by,@uid,0,0);
                 insert Tbl_Placement_log(Candidate_id,Schedule_date,scheduled_by,Remark,Placement_Link)
                 values(@candidate_id,@date,@interviewed_by,@remark,@placLink);
             end
    end
if(@flag=1)
    begin
        Update  Tbl_Placement_Schedule_Log set delete_status=1 where candidate_id=@candidate_id  
    end
 end');
END;
