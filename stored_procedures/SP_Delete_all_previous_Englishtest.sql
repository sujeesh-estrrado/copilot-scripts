IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_all_previous_Englishtest]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Delete_all_previous_Englishtest](@Candidate_Id bigint)
as
begin
if exists (select * from Tbl_Candidate_Englishtest where Cand_Id=@Candidate_Id)
begin
update Tbl_Candidate_Englishtest set Delete_Status=1 where Cand_Id=@Candidate_Id;
end
end
    ')
END
