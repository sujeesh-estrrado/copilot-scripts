IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Update_finanace_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE Procedure  [dbo].[Update_finanace_id](@candidateid bigint=0,
@type varchar(100),@id bigint)
as
begin

update Tbl_Student_Tc_request set Finance_approval_requestID=@id where Candidate_id=@candidateid and Request_type=@type and Delete_status=0

end
    ')
END;
GO
