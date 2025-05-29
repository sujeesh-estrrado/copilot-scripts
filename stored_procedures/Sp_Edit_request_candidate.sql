IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Edit_request_candidate]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Edit_request_candidate](@Candidate_id BIGINT=0,@flag bigint=0,@remark varchar(max)='''')
AS
begin
if(@flag=0)
begin
 update Tbl_Candidate_Personal_Det set Edit_request=1,Edit_request_remark=@remark where Candidate_Id=@Candidate_id;

 end
 else if(@flag=1)
 begin

 update Tbl_Candidate_Personal_Det set Edit_status=1,Edit_request=0,Editable=1 where Candidate_Id=@Candidate_id;
 end

 end
    ')
END;
