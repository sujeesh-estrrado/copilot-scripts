IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_all_department_id_byCandidate_id]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_all_department_id_byCandidate_id] 
        (@Candidate_Id BIGINT)
        AS
        BEGIN
            ;WITH CandidateDepartmentData AS (
                SELECT 
                    tbl_New_Admission_1.Department_Id AS pgm1, 
                    dbo.tbl_New_Admission.Department_Id AS pgm2, 
                    tbl_New_Admission_2.Department_Id AS pgm3,
                    D.Department_Name, 
                    dbo.Tbl_Candidate_Personal_Det.Candidate_Id, 
                    CONCAT(Tbl_Candidate_Personal_Det.candidate_fname, '' '', Tbl_Candidate_Personal_Det.Candidate_Lname) AS studentname, 
                    Tbl_Candidate_Personal_Det.active, 
                    Tbl_Candidate_Personal_Det.New_Admission_Id AS New_Admission_Id
                FROM 
                    dbo.tbl_New_Admission AS tbl_New_Admission_2 
                RIGHT OUTER JOIN 
                    dbo.tbl_New_Admission 
                RIGHT OUTER JOIN 
                    dbo.Tbl_Candidate_Personal_Det 
                INNER JOIN 
                    dbo.tbl_New_Admission AS tbl_New_Admission_1 
                ON dbo.Tbl_Candidate_Personal_Det.New_Admission_Id = tbl_New_Admission_1.New_Admission_Id 
                ON dbo.tbl_New_Admission.New_Admission_Id = dbo.Tbl_Candidate_Personal_Det.Option2 
                ON tbl_New_Admission_2.New_Admission_Id = dbo.Tbl_Candidate_Personal_Det.Option3  
                LEFT JOIN 
                    Tbl_Department D ON D.Department_Id = tbl_New_Admission_1.Department_Id
                WHERE 
                    Tbl_Candidate_Personal_Det.Candidate_Id = @Candidate_Id
            )
            -- Final Select from the CTE
            SELECT * FROM CandidateDepartmentData;
        END
    ')
END
