IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_request_tc]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_request_tc](@Candidate_Id bigint,@type varchar(50),@remark varchar(max),@Faculty bigint)
as
begin
if not exists(select * from Tbl_Student_Tc_request where Candidate_id=@Candidate_Id and Delete_status=0 and Request_type=@type)
begin
insert into Tbl_Student_Tc_request(Candidate_id,Create_date,Remark,Request_type,Faculty_id,Request_status,Delete_status) values(@Candidate_Id,GETDATE(),@remark,@type,@Faculty,''Pending'',0);
end
end
');
END;