IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Students_By_DeptID]')
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[SP_Get_Students_By_DeptID] 
(@Department_Id bigint)
AS
BEGIN

SELECT 
  dpt.Department_Id,
  dpt.Department_Name,
  sr.Student_Reg_Id,
  cpd.Candidate_Id,
  Candidate_Fname + '' '' + Candidate_Mname + '' '' + Candidate_Lname AS [CandidateName]    
FROM  Tbl_Department dpt 
INNER JOIN Tbl_Student_Registration sr ON dpt.Department_Id = sr.Department_Id
INNER JOIN Tbl_Candidate_Personal_Det cpd ON sr.Candidate_Id = cpd.Candidate_Id
WHERE dpt.Department_Id = @Department_Id
END
    ')
END;
