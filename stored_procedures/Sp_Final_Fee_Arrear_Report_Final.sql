IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_Final_Fee_Arrear_Report_Final]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[Sp_Final_Fee_Arrear_Report_Final]
        AS
        BEGIN
            SELECT 
                FASR.Id,
                FASR.Arrear,
                FASR.Candidate_Id,
                FASR.Intake_id,
                FASR.Course_Code,
                FASR.Batch_Code,
                FASR.Candidate_Name,
                FASR.ICPassport,
                CCD.Candidate_TelePhone,
                CCD.Candidate_Email
            FROM dbo.Get_Fee_Arrear_Student_Report AS FASR
            INNER JOIN dbo.Tbl_Candidate_ContactDetails AS CCD
                ON CCD.ICPassport = FASR.ICPassport
            ORDER BY FASR.Course_Code ASC
        END
    ')
END
