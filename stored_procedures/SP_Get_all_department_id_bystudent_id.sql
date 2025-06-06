IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_all_department_id_bystudent_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
      CREATE procedure [dbo].[SP_Get_all_department_id_bystudent_id] --53290
(@Candidate_Id bigint)
as
begin
    SELECT        tbl_New_Admission_1.Department_Id AS pgm1, dbo.tbl_New_Admission.Department_Id AS pgm2, 
    tbl_New_Admission_2.Department_Id AS pgm3,tbl_New_Admission_2.New_Admission_Id, 
        dbo.Tbl_Student_NewApplication.Candidate_Id,
        concat(Tbl_Candidate_Personal_Det.candidate_fname,'' '',Tbl_Candidate_Personal_Det.Candidate_Lname) as studentname
    FROM            dbo.tbl_New_Admission AS tbl_New_Admission_2 RIGHT OUTER JOIN
        dbo.tbl_New_Admission RIGHT OUTER JOIN
        dbo.Tbl_Student_NewApplication Inner join 
        Tbl_Candidate_Personal_Det on Tbl_Candidate_Personal_Det.Candidate_Id=Tbl_Student_NewApplication.Candidate_Id
        INNER JOIN
        dbo.tbl_New_Admission AS tbl_New_Admission_1 ON dbo.Tbl_Student_NewApplication.New_Admission_Id = tbl_New_Admission_1.New_Admission_Id ON 
        dbo.tbl_New_Admission.New_Admission_Id = dbo.Tbl_Student_NewApplication.Option2 
        ON tbl_New_Admission_2.New_Admission_Id = dbo.Tbl_Student_NewApplication.Option3
    where Tbl_Student_NewApplication.Candidate_Id=@Candidate_Id and Tbl_Student_NewApplication.Candidate_DelStatus=0;

                         end
    ')
END
