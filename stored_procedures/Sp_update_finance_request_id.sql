IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_update_finance_request_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
       create procedure [dbo].[Sp_update_finance_request_id](@Candidate_Id bigint,@type varchar(100),@flag bigint)
as
begin
update Tbl_Student_Tc_request set Finance_approval_requestID=@flag where candidate_id=@Candidate_Id and Delete_status=0 and Request_type=@type 

end
    ')
END
