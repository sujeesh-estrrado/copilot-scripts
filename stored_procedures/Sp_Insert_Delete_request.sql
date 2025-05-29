IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Insert_Delete_request]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Insert_Delete_request]
	-- Add the parameters for the stored procedure here
	@Candidate_id bigint,@Senter BIGINT,@Remarks varchar(MAX),@Rejectremark varchar(max)
AS
BEGIN
if not exists (select * from Tbl_Delete_Request where Candidate_id=@Candidate_id  and Delete_status=0)
begin
	iNSERT INTO Tbl_Delete_Request(Candidate_id,Create_date,Delete_request_status,Request_date,Requested_by,Delete_status,Remarks,Reject_remark)
	values(@Candidate_id,GETDATE(),0,GETDATE(),@Senter,0,@Remarks,@Rejectremark)
	end
END
');
END;
