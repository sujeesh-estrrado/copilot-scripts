IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_user_id_by_candidate_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[Sp_Get_user_id_by_candidate_id](@candidateid bigint)
as
begin
Select * from dbo.Tbl_Student_User where Candidate_Id=@candidateid;
end
    ')
END
