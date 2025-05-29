IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_role_by_candidate_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[Sp_Get_role_by_candidate_id](@userid bigint)
as
begin
SELECT        dbo.Tbl_User.role_Id, dbo.Tbl_Student_User.Candidate_Id
FROM            dbo.Tbl_Student_User INNER JOIN
                         dbo.Tbl_User ON dbo.Tbl_Student_User.User_Id = dbo.Tbl_User.user_Id where Tbl_Student_User.User_Id=@userid;
						 end');
END;
