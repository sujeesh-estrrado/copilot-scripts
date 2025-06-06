IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Bind_Choosed_department]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Bind_Choosed_department]
        (@candidate_id BIGINT)
        AS
        BEGIN
            SELECT 
                dbo.Tbl_Candidate_Personal_Det.Option3, 
                dbo.Tbl_Candidate_Personal_Det.Option2, 
                dbo.Tbl_Candidate_Personal_Det.Candidate_Id, 
                dbo.Tbl_Candidate_Personal_Det.Candidate_Fname, 
                dbo.Tbl_Candidate_Personal_Det.Candidate_Lname, 
                dbo.Tbl_Department.Department_Name, 
                dbo.Tbl_Department.Department_Descripition, 
                Tbl_Department_1.Department_Name AS Expr1, 
                Tbl_Department_2.Department_Name AS Expr2, 
                dbo.Tbl_Department.Department_Id
            FROM 
                dbo.Tbl_Candidate_Personal_Det 
            INNER JOIN dbo.tbl_New_Admission ON dbo.Tbl_Candidate_Personal_Det.New_Admission_Id = dbo.tbl_New_Admission.New_Admission_Id 
            INNER JOIN dbo.Tbl_Department ON dbo.tbl_New_Admission.Department_Id = dbo.Tbl_Department.Department_Id 
            INNER JOIN dbo.tbl_New_Admission AS tbl_New_Admission_1 ON dbo.Tbl_Candidate_Personal_Det.Option2 = tbl_New_Admission_1.New_Admission_Id 
            INNER JOIN dbo.tbl_New_Admission AS tbl_New_Admission_2 ON dbo.Tbl_Candidate_Personal_Det.Option3 = tbl_New_Admission_2.New_Admission_Id 
            INNER JOIN dbo.Tbl_Department AS Tbl_Department_1 ON tbl_New_Admission_2.Department_Id = Tbl_Department_1.Department_Id 
            INNER JOIN dbo.Tbl_Department AS Tbl_Department_2 ON tbl_New_Admission_1.Department_Id = Tbl_Department_2.Department_Id
            WHERE dbo.Tbl_Candidate_Personal_Det.Candidate_Id = @candidate_id;
        END
    ')
END
