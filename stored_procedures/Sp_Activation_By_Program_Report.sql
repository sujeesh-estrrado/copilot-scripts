IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Activation_By_Program_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Activation_By_Program_Report]
        @flag BIGINT = 0, 
        @organitaion_id BIGINT = 0,
        @year BIGINT = 0, 
        @department BIGINT = 0,
        @Intake_year VARCHAR(50) = '''',
        @Intake_month VARCHAR(50) = ''''
        AS
        BEGIN
            IF (@flag = 1)
            BEGIN
                SELECT DISTINCT d.Department_Name, d.Department_Id 
                FROM Tbl_Department D
                LEFT JOIN Tbl_Organzations M ON M.Organization_Id = d.Org_Id 
                WHERE D.Org_Id = @organitaion_id;
            END

            IF (@flag = 2)
            BEGIN
                SELECT Organization_Name, Organization_Id 
                FROM Tbl_Organzations;
            END

            IF (@flag = 3)
            BEGIN
                SELECT DISTINCT CONCAT(YEAR(Batch_From), ''/'', MONTH(Batch_From)) AS INTAKE 
                FROM Tbl_Course_Batch_Duration 
                WHERE YEAR(Batch_From) = @year;
            END

            IF (@flag = 4)
            BEGIN
                SELECT DISTINCT YEAR(Batch_From) AS INTAKEYEAR 
                FROM Tbl_Course_Batch_Duration;
            END

            IF (@flag = 5)
            BEGIN
                SELECT COUNT(MM.ApplicationStatus) AS data 
                FROM Tbl_Candidate_Personal_Det MM
                LEFT JOIN tbl_New_Admission GG ON GG.New_Admission_Id = MM.New_Admission_Id 
                LEFT JOIN Tbl_Course_Batch_Duration BB ON BB.Batch_Id = GG.Batch_Id
                WHERE MM.ApplicationStatus != ''Completed'' 
                  AND BB.Duration_Id = @department 
                  AND YEAR(BB.Batch_From) = @Intake_year 
                  AND MONTH(BB.Batch_From) = @Intake_month;
            END
        END
    ');
END
