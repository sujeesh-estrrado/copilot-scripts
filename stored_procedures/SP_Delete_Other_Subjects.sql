IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Delete_Other_Subjects]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Delete_Other_Subjects]
(
@Cand_Id bigint = 1,
@Education_Type varchar =''''
)
as
begin
    update Tbl_Candidate_Education_Grade set Delete_status = 1 where Cand_Id = @Cand_Id and Education_Type = @Education_Type
end

    ')
END
