IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Student_User_By_Candidate_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_Get_Student_User_By_Candidate_Id](
@Candidate_Id bigint
)
as 

begin

Select * from dbo.Tbl_Student_User where Candidate_Id=@Candidate_Id

end
    ')
END
