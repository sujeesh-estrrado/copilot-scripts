IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_UpdateactiveStatus_by_candidate_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[sp_UpdateactiveStatus_by_candidate_id](
@candidateID bigint,
@staus bigint,
@Flag bigint=0
)
as
begin
if(@Flag=0)
    begin
        update  tbl_candidate_personal_det set active=@staus where Candidate_Id=@candidateID
    end
if(@Flag=1)
    begin
        update  Tbl_Student_NewApplication set active=@staus where Candidate_Id=@candidateID
    end
end
    ')
END;
