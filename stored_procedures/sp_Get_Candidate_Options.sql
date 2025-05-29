IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Get_Candidate_Options]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE procedure [dbo].[sp_Get_Candidate_Options]
@Candidate_Id int
as
begin
    SELECT        CPD.Candidate_Id, CPD.Candidate_Fname, CPD.TypeOfStudent, Option1.Department_Id AS Opt1,Option1.Course_Category_Id as Course_Category_Id, Option3.Department_Id AS Opt2, Option2.Department_Id AS Opt3,CPD.ApplicationStatus
    FROM            dbo.Tbl_Candidate_Personal_Det AS CPD LEFT OUTER JOIN
                             dbo.ViewCandidateOption AS Option1 ON CPD.New_Admission_Id = Option1.New_Admission_Id LEFT OUTER JOIN
                             dbo.ViewCandidateOption AS Option2 ON CPD.Option2 = Option2.New_Admission_Id LEFT OUTER JOIN
                             dbo.ViewCandidateOption AS Option3 ON CPD.Option3 = Option3.New_Admission_Id
    where CPD.Candidate_Id = @Candidate_Id
end

    ')
END;
