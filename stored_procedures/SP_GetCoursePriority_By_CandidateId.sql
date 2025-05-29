IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetCoursePriority_By_CandidateId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE procedure [dbo].[SP_GetCoursePriority_By_CandidateId]
@Candidate_Id bigint
AS
BEGIN
SELECT
d.Department_Id,
d.Department_Name 
From Tbl_Candidate_Personal_Det cpd
Inner Join Tbl_Candidate_CoursePriority cp On cpd.Candidate_Id=cp.Candidate_Id
Inner Join Tbl_Department d on cp.Department_Id=d.Department_Id
Where cpd.Candidate_Id=@Candidate_Id
Order By Course_Priority_Id


END');
END;

