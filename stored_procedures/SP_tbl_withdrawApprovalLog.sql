IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_tbl_withdrawApprovalLog]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       CREATE procedure [dbo].[SP_tbl_withdrawApprovalLog](@flag bigint=0,@empid bigint=0,@candidateid bigint=0,@remark varchar(max)='''')
as
begin
if(@flag=1)
begin
if not exists(select * from tbl_withdrawApprovalLog where candidate_id=@candidateid and Employee_id=@empid and Request_id=(select Tc_request_id from Tbl_Student_Tc_request where Candidate_id=@candidateid and Request_type=''Withdraw'' and Delete_status=0))
begin
insert into tbl_withdrawApprovalLog(Employee_id,candidate_id,remark,createdate,Request_id) 
values(@empid,@candidateid,@remark,GETDATE(),(select Tc_request_id from Tbl_Student_Tc_request 
where Candidate_id=@candidateid and Request_type=''Withdraw'' and Delete_status=0))
update Tbl_Student_Tc_request set Counselling_Status=1 where Candidate_id=@candidateid and Request_type=''Withdraw'';
end
end
if(@flag=2)--select by candidate id
begin

select concat(E.Employee_FName,'' '',E.Employee_LName) as CounsellorName,W.remark from tbl_withdrawApprovalLog W inner join Tbl_Student_Tc_request AR on Ar.Candidate_id=W.candidate_id  and W.Request_id=ar.Tc_request_id 
left join  Tbl_Employee E on W.Employee_id=E.Employee_Id
 where w.candidate_id=@candidateid and AR.Delete_status=0
end

if(@flag=3)--select by employee id
begin

select * from tbl_withdrawApprovalLog where Employee_id=@empid
end
if(@flag=4)--select by employee id candidate id
begin

select * from tbl_withdrawApprovalLog WL inner join Tbl_Student_Tc_request AR on Ar.Candidate_id=WL.candidate_id and AR.tc_request_id =WL.request_id where Employee_id=@empid and AR.candidate_id=@candidateid and AR.Delete_status=0;
end

end
    ')
END;
