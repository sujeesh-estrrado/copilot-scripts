IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Check_TerminationReqest]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Check_TerminationReqest](@type varchar(500),@candidateid bigint)
as
begin

select * from Tbl_Student_Tc_request where Candidate_id=@candidateid and Delete_status=0 and request_type=@type;

end
    ')
END
