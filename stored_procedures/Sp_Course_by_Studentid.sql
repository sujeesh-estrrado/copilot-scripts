IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Course_by_Studentid]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Course_by_Studentid] 
        (@id bigint)
        AS
        BEGIN
            SELECT 
                SNA.Candidate_Id,
                SNA.New_Admission_Id,
                A.Department_Id,
                A.Batch_Id,
                A.Course_Category_Id,
                A.Course_Level_Id,
                TypeOfStudent,
                SNA.ApplicationStatus
            FROM 
                Tbl_Student_NewApplication SNA
            LEFT OUTER JOIN dbo.tbl_New_Admission AS A 
                ON SNA.New_Admission_Id = A.New_Admission_Id
            LEFT OUTER JOIN dbo.Tbl_Department AS D 
                ON A.Department_Id = D.Department_Id
            LEFT OUTER JOIN Tbl_Candidate_Personal_Det CPD 
                ON CPD.Candidate_Id = SNA.Candidate_Id
            WHERE 
                SNA.Candidate_Id = @id
        END
    ')
END
