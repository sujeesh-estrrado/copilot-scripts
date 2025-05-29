IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_NewSheduleTime]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    
CREATE procedure [dbo].[SP_NewSheduleTime]
(
@candidate_id bigint=0,
@date date='''',
@interview_time varchar(50)='''',
@Venue varchar(500)='''',
@uid bigint='''',
@interviewed_by bigint=0,
@flag bigint=0,
@remark varchar(max),
@intLink varchar(max)
)
as
begin
if(@flag=0)
    begin
        if not exists(select * from Tbl_Interview_Schedule_Log where candidate_id=@candidate_id and delete_status=0)
            begin
                insert into Tbl_Interview_Schedule_Log(Interview_date,candidate_id,Interview_Time,Interview_venue,Scheduled_by,Staff_id,rechedule_count,delete_status)
                 values(@date,@candidate_id,@interview_time,@Venue,@interviewed_by,@uid,0,0);
                 insert Tbl_Interview_log(Candidate_id,Schedule_date,scheduled_by,Remark,Interview_Link)
                 values(@candidate_id,@date,@interviewed_by,@remark,@intLink);
             end
    end
if(@flag=1)
    begin
        Update  Tbl_Interview_Schedule_Log set delete_status=1 where candidate_id=@candidate_id  
    end
 end');
END;
