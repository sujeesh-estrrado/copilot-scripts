IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_CandidateCoursePriorityDet]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[SP_Get_CandidateCoursePriorityDet](@Candidate_Id bigint)
as
begin
select Tbl_Candidate_CoursePriority.Course_Priority_Id as ID,Tbl_Candidate_CoursePriority.Candidate_Id as CandidateID,Tbl_Candidate_CoursePriority.Course_Level_Id as Level,Tbl_Course_Level.Course_Level_Name as Levelname,
Tbl_Candidate_CoursePriority.Course_Category_Id as Category,
Tbl_Candidate_CoursePriority.Department_Id as Department,Tbl_Candidate_CoursePriority.Cand_Selected_Priority as PriorityNo
from  dbo.Tbl_Candidate_CoursePriority
inner join Tbl_Course_Level on Tbl_Candidate_CoursePriority.Course_Level_Id=Tbl_Course_Level.Course_Level_Id

where Tbl_Candidate_CoursePriority.Candidate_Id=@Candidate_Id and Tbl_Candidate_CoursePriority.Priority_DelStatus=0

end    ');
END;