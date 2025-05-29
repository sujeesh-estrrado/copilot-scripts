IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Reject_request]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Reject_request](@id bigint,@Type varchar(50),@RejectRemark varchar(100))
as
begin
update Tbl_Student_Tc_request set Delete_status=1,Request_status=''Rejected'',Final_Approval_Remark=@RejectRemark where Candidate_id=@id and Request_type=@type 
end
select * from Tbl_Student_Tc_request
');
END;