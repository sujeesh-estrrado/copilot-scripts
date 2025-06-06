IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[LMS_SP_Get_All_Student_By_Employee_Id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE procedure [dbo].[LMS_SP_Get_All_Student_By_Employee_Id]
@Emp_Id bigint
AS
BEGIN
SELECT
Distinct Candidate_Id, 
Candidate_Fname+'' ''+Candidate_Lname As CandidateName
From LMS_Tbl_Class c
Inner Join LMS_Tbl_Emp_Class ec On c.Class_Id=ec.Class_Id
Inner Join LMS_Tbl_Student_Class sc on c.Class_Id=sc.Class_Id
Inner Join Tbl_Candidate_Personal_Det cp On sc.Student_id=cp.Candidate_Id
Where c.Active_Status=1 and c.Delete_Status=0 and sc.Approval_Status=1 and sc.Status=0
and ec.Emp_Id=@Emp_Id
End

    ')
END
