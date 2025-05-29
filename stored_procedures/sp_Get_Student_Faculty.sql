IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Student_Faculty]') 
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE procedure [dbo].[sp_Get_Student_Faculty] --30073
(
@Candidateid bigint
)
As 
Begin
select  P.Candidate_Id, D.Department_Name,C.Course_Category_Name as Course_Level_Name,C.Course_level_Id as Course_level_Id,N.Course_Category_Id,P.New_Admission_Id,
D.Course_Code, N.Department_Id  
from Tbl_Candidate_Personal_Det P
inner join tbl_New_Admission N on N.New_Admission_Id=P.New_Admission_Id
inner join Tbl_Department D on N.Department_Id=D.Department_Id 
inner join Tbl_Course_Category C on N.Course_Category_Id=C.Course_Category_Id
where P.Candidate_Id=@Candidateid

End    ');
END;
