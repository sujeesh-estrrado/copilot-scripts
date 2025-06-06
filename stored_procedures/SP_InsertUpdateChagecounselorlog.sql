IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_InsertUpdateChagecounselorlog]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_InsertUpdateChagecounselorlog] --151806
(@flag bigint=0,
@Studentid bigint=0,
@Staffid bigint=0,
@oldcounsellor bigint=0,
@oldagent bigint=0,
@oldother bigint=0,
@newcounsellor bigint=0,
@newagent bigint=0,
@newother bigint=0,
@actionurl varchar(Max)='''',
@description varchar(Max)=''''

)
as
begin
if(@flag=0)
begin
        if not exists(select * from log_universal where studentid=@Studentid and Staffid=@Staffid)
        begin
                if exists(select * from log_universal where studentid=@Studentid and Staffid=@Staffid 
                                and (oldcounsellor=@oldcounsellor)or (oldagent=@oldagent) or  oldother=@oldother)
                        begin
                                Insert into log_universal(staffid,datelog,action,studentid,actionurl,description,oldcounsellor,oldagent,oldother,newcounsellor,newagent,newother)
                                values (@staffid,getdate(),''UPDATE'',@Studentid,@actionurl,@description,@oldcounsellor,@oldagent,@oldother,@newcounsellor,@newagent,@newother)
                        end

        end
end
end   
    ')
END
