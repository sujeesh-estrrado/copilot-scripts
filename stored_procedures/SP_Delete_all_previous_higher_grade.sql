IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_all_previous_higher_grade]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure  [dbo].[SP_Delete_all_previous_higher_grade](@Candidate_Id BIGINT)
AS 
begin
if exists(select * from Tbl_Candidate_Education_Grade where Cand_Id=@Candidate_Id)
begin
update Tbl_Candidate_Education_Grade set delete_status=1 where Cand_Id=@Candidate_Id and Sub_other is not null;
end
end
    ')
END
