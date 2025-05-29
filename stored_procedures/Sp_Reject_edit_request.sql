IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Reject_edit_request]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Reject_edit_request]
@Candidate_Id bigint,
@flag bigint=0
AS
BEGIN
if(@flag=0)
begin
	update Tbl_Candidate_Personal_Det set Edit_status=null,Edit_request=null,Editable=null
	where Candidate_Id=@Candidate_Id;
end
if(@flag=1)
begin
	update Tbl_Student_NewApplication set Edit_status=null,Edit_request=null,Editable=null
	where Candidate_Id=@Candidate_Id;
end
END
');
END;