IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Get_all_change_request]')
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Get_all_change_request]
        AS
        BEGIN
            SELECT DISTINCT 
                dbo.Tbl_Program_change_request.Candidate_id,
                dbo.Tbl_Candidate_Personal_Det.Candidate_Fname + '' '' + dbo.Tbl_Candidate_Personal_Det.Candidate_Lname AS Candidate_Name,
                dbo.Tbl_Candidate_Personal_Det.ApplicationCategory,
                dbo.Tbl_Candidate_Personal_Det.AdharNumber,
                dbo.Tbl_Candidate_ContactDetails.Candidate_Mob1,
                dbo.Tbl_Candidate_ContactDetails.Candidate_Email,
                dbo.Tbl_Department.Department_Name
            FROM dbo.Tbl_Candidate_Personal_Det
            INNER JOIN dbo.Tbl_Program_change_request 
                ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Program_change_request.Candidate_id
            INNER JOIN dbo.Tbl_Candidate_ContactDetails 
                ON dbo.Tbl_Candidate_Personal_Det.Candidate_Id = dbo.Tbl_Candidate_ContactDetails.Candidate_Id
            INNER JOIN dbo.Tbl_Department 
                ON dbo.Tbl_Program_change_request.Department_id = dbo.Tbl_Department.Department_Id
            WHERE dbo.Tbl_Program_change_request.delete_status = 0
        END
    ')
END
