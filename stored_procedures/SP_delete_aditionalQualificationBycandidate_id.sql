IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_delete_aditionalQualificationBycandidate_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_delete_aditionalQualificationBycandidate_id](@candidateid bigint=0)
as
begin
update Tbl_Candidate_Additionalqualification set Delete_Status=1 where Candidate_Id=@candidateid;
end
    ')
END
