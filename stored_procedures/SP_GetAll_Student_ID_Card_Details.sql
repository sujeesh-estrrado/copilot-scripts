IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Student_ID_Card_Details]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_GetAll_Student_ID_Card_Details]
        AS
        BEGIN
            SELECT
                SR.Candidate_Id,
                CP.Candidate_Fname + '' '' + ISNULL(CP.Candidate_Mname, '''') + '' '' + CP.Candidate_Lname AS Candidate_Name,
                CP.Candidate_Gender AS Gender,
                CP.Candidate_Dob AS DOB,
                CC.Course_Category_Id,
                D.Department_Id,
                CC.Course_Category_Name + '' '' + D.Department_Name AS Class,
                SR.Student_Reg_No,
                CD.Candidate_Telephone AS Telephone
            FROM dbo.Tbl_Student_Registration SR
            LEFT JOIN dbo.Tbl_Candidate_Personal_Det CP ON CP.Candidate_Id = SR.Candidate_Id
            LEFT JOIN dbo.Tbl_Candidate_ContactDetails CD ON CD.Candidate_Id = CP.Candidate_Id
            LEFT JOIN dbo.Tbl_Course_Category CC ON CC.Course_Category_Id = SR.Course_Category_Id
            LEFT JOIN dbo.Tbl_Department D ON D.Department_Id = SR.Department_Id
        END
    ')
END
ELSE
BEGIN
    EXEC('
        ALTER PROCEDURE [dbo].[SP_GetAll_Student_ID_Card_Details]
        AS
        BEGIN
            SELECT
                SR.Candidate_Id,
                CP.Candidate_Fname + '' '' + ISNULL(CP.Candidate_Mname, '''') + '' '' + CP.Candidate_Lname AS Candidate_Name,
                CP.Candidate_Gender AS Gender,
                CP.Candidate_Dob AS DOB,
                CC.Course_Category_Id,
                D.Department_Id,
                CC.Course_Category_Name + '' '' + D.Department_Name AS Class,
                SR.Student_Reg_No,
                CD.Candidate_Telephone AS Telephone
            FROM dbo.Tbl_Student_Registration SR
            LEFT JOIN dbo.Tbl_Candidate_Personal_Det CP ON CP.Candidate_Id = SR.Candidate_Id
            LEFT JOIN dbo.Tbl_Candidate_ContactDetails CD ON CD.Candidate_Id = CP.Candidate_Id
            LEFT JOIN dbo.Tbl_Course_Category CC ON CC.Course_Category_Id = SR.Course_Category_Id
            LEFT JOIN dbo.Tbl_Department D ON D.Department_Id = SR.Department_Id
        END
    ')
END
