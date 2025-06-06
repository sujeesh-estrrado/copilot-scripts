-- Check if the stored procedure [dbo].[Proc_GetAll_Registered_Students] exists, if not, create it
IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Proc_GetAll_Registered_Students]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Proc_GetAll_Registered_Students]
        AS
        BEGIN
            SELECT 
                dbo.Tbl_Registered_Students.Registered_Students_Id, 
                dbo.Tbl_Registered_Students.Candidate_Id,
                dbo.Tbl_Candidate_Personal.Candidate_FName + '' '' +
                dbo.Tbl_Candidate_Personal.Candidate_MName + '' '' +
                dbo.Tbl_Candidate_Personal.Candidate_LName + '' '' AS [Candidate Name],
                dbo.Tbl_Registered_Students.Stream,
                dbo.Tbl_Course_Department.Course_Department_Name,
                dbo.Tbl_Registered_Students.Student_Registration_Number,
                Tbl_Student_Registration_Number.Course_Suffix + ''/'' + Tbl_Student_Registration_Number.Course_From + ''-'' +
                Tbl_Student_Registration_Number.Course_To + ''/'' + 
                CAST(dbo.Tbl_Registered_Students.Student_Registration_Number AS VARCHAR(100)) + ''/'' +
                Tbl_Student_Registration_Number.Course_Prefix AS RegNo
            FROM dbo.Tbl_Candidate_Personal 
            INNER JOIN dbo.Tbl_Registered_Students 
                ON dbo.Tbl_Candidate_Personal.Candidate_Id = dbo.Tbl_Registered_Students.Candidate_Id 
            INNER JOIN dbo.Tbl_Course_Department 
                ON dbo.Tbl_Registered_Students.Stream = dbo.Tbl_Course_Department.Course_Department_Id
            INNER JOIN dbo.Tbl_Student_Registration_Number 
                ON dbo.Tbl_Course_Department.Course_Department_Id = dbo.Tbl_Student_Registration_Number.Course
            WHERE 
                dbo.Tbl_Candidate_Personal.Candidate_Status = 0 
                AND dbo.Tbl_Registered_Students.Registered_Students_Status = 0
                AND dbo.Tbl_Course_Department.Course_Department_Status = 0
        END
    ')
END
