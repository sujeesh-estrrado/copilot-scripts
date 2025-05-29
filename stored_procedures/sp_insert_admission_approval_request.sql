IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_insert_admission_approval_request]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[sp_insert_admission_approval_request](@type bigint,@studentid bigint)
as
begin 
if not exists (select * from Tbl_admission_approval_request  ad inner join Tbl_Student_Tc_request st  on st.Tc_request_id=ad.approval_type where ad.candidate_id=@studentid and approval_type=@type and st.Delete_status=0)
begin
insert into Tbl_admission_approval_request(approval_type,candidate_id,create_date,Verification_status,Delete_status,request_id)values(@type,@studentid,GETDATE(),''Pending'',0,(select Tc_request_id from Tbl_Student_Tc_request 
where Candidate_id=@studentid and Request_type=(select types from Approval_Request_Type where id=@type) and Delete_status=0))
update Tbl_Student_Tc_request set Request_status=''Approved'' where Candidate_id=@studentid and Delete_status=0
end
end
    ');
END;
