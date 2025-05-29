IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_GetStudent_ApplicationDetails_byStudentid_New]') 
    AND type = N'P'
)
BEGIN
    EXEC('
create procedure [dbo].[sp_GetStudent_ApplicationDetails_byStudentid_New] --43460
(@Student_Id bigint)
as
Begin
SELECT ISNULL(CPD.New_Admission_Id,0) New_Admission_Id,ISNULL(CPD.Option2,0) Option2,ISNULL(CPD.Option3,0) Option3

FROM Tbl_Candidate_Personal_Det CPD 


WHERE (CPD.Candidate_Id = @Student_Id)-- and P.Candidate_DelStatus=0
end
    ')
END
