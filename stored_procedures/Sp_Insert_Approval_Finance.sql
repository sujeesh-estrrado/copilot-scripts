IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Approval_Finance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_Approval_Finance]
@Candidate_Id bigint,
@approvalstatus int,
@empid bigint,
@remark varchar(500),
@requestid bigint,
@Flag int=0
as
begin
if(@Flag=0)
begin
update Approval_Request set ApprovalStatus=@approvalstatus,ApprovalBy=@empid,ApprovalDate=GETDATE(),ApprovalRemark=@remark where RequestId=@requestid

update Tbl_Visa_Renewal set Finance_Approval=1 where Candidate_Id=@Candidate_Id and Finance_Approval=0
end
else if(@Flag=1)
begin
update Tbl_Student_Tc_request set Delete_status=1 where Tc_request_id=@requestid

update Tbl_Visa_Renewal set Registrar_Approval=1 where Candidate_Id=@Candidate_Id and Registrar_Approval=0
end
else if(@flag=2)
begin
update Approval_Request set ApprovalStatus=@approvalstatus,ApprovalBy=@empid,ApprovalDate=GETDATE(),ApprovalRemark=@remark where RequestId=@requestid
update Tbl_Visa_Renewal set Finance_Approval=2 where Candidate_Id=@Candidate_Id and Finance_Approval=0

end
else if(@flag=3)
begin
update Tbl_Student_Tc_request set Delete_status=1 where Tc_request_id=@requestid
update Tbl_Visa_Renewal set Registrar_Approval=2 where Candidate_Id=@Candidate_Id and Registrar_Approval=0

end
end');
END;
