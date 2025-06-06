IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Admission_StudentRecruitedBy_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[SP_Admission_StudentRecruitedBy_Report] --0,0,0,0,0,1
(
@MarketingStaff bigint=0,
@Agent bigint=0,
@ProgramType bigint=0,
@Program  bigint=0,
@Faculty bigint=0,
@Status bigint=0
)
AS      
BEGIN 

select ROW_NUMBER() OVER(ORDER BY D.Candidate_Id ASC) AS slno,
Candidate_Fname+'' ''+Candidate_Lname as Candidatename,IDMatrixNo,

E.Employee_FName+'' ''+Employee_LName as CounselorName,Course_Level_Name,
A.Agent_Name,Department_Name,P.Course_Code
from Tbl_Candidate_Personal_Det D
Inner join Tbl_Candidate_ContactDetails  C on C.Candidate_Id=D.Candidate_Id
Left join tbl_New_Admission N on N.New_Admission_Id=D.New_Admission_Id
Left join Tbl_Department P on P.Department_Id=N.Department_Id
Left join Tbl_Agent A on A.Agent_ID=D.Agent_ID 
left join Tbl_Employee E on E.Employee_Id=D.CounselorEmployee_id
left join Tbl_Course_Level CL on CL.Course_Level_Id=N.Course_Level_Id

where (@MarketingStaff=0 or CounselorEmployee_id=@MarketingStaff) 
and (@ProgramType=0 or N.Course_Category_Id=@ProgramType) and (@Program=0 or N.Department_Id=@Program)
and (@Faculty=0 or N.Course_Level_Id=@Faculty)
and (@Status='''' or D.active=@Status ) or N.Batch_Id IN (SELECT Intake_Id FROM Tbl_reportRecruited_IntakeList)

END

    ')
END
