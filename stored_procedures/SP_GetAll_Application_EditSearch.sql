IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Application_EditSearch]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_GetAll_Application_EditSearch]
        @NewAdmission_Id BIGINT = NULL,    
        @Course_Level_Id BIGINT = NULL,    
        @Category_Id BIGINT = NULL,    
        @App_Satatus INT = NULL,    
        @Department_Id BIGINT = NULL,     
        @Batch_Id BIGINT = NULL       
    AS
    BEGIN
        SET NOCOUNT ON;

        SELECT  
            CPD.Candidate_Id AS ID,
            CPD.Candidate_Fname AS [Name],
            CPD.Candidate_Gender AS [Gender],
            CPD.Religion AS [Religion],
            CPD.Caste AS [Caste],
            CCD.Candidate_Email AS Email,
            CCD.Candidate_Mob1 AS Mobile,
            CPD_Payment.Application_Status AS [Status],
            NA.New_Admission_Id,
            HSC.Candidate_MonthofPass + '' '' + HSC.Candidate_YearofPass AS [HSEYearOfPass],
            CL.Course_Level_Name AS Course_LEVEL,
            CC.Course_Category_Name AS Course_Category,
            NA.Course_Level_Id AS Course_LEVEL_Id,
            NA.Course_Category_Id AS Course_Category_Id,
            CPD.Initial_Application_Id,
            CPD.New_Admission_Id,
            CBD.Batch_Id AS BatchID,
            CBD.Batch_Code AS Batch,
            NA.Department_Id,
            D.Department_Name AS Department
        FROM dbo.Tbl_Candidate_Personal_Det CPD
        LEFT JOIN Tbl_Candidate_ContactDetails CCD 
            ON CPD.Candidate_Id = CCD.Candidate_Id
        LEFT JOIN Tbl_Candidate_PaymentDet CPD_Payment 
            ON CPD.Candidate_Id = CPD_Payment.Candidate_Id
        LEFT JOIN Tbl_Candidate_HSCDet HSC 
            ON CPD.Candidate_Id = HSC.Candidate_Id
        INNER JOIN tbl_New_Admission NA 
            ON NA.New_Admission_Id = CPD.New_Admission_Id
        INNER JOIN Tbl_Course_Batch_Duration CBD 
            ON CBD.Batch_Id = NA.Batch_Id
        INNER JOIN Tbl_Course_Category CC 
            ON CC.Course_Category_Id = NA.Course_Category_Id
        INNER JOIN Tbl_Course_Level CL 
            ON CL.Course_Level_Id = NA.Course_Level_Id
        INNER JOIN Tbl_Department D 
            ON D.Department_Id = NA.Department_Id
        WHERE CPD.Candidate_DelStatus = 0
            AND NA.New_Admission_Id = ISNULL(@NewAdmission_Id, NA.New_Admission_Id)
            AND NA.Course_Level_Id = ISNULL(@Course_Level_Id, NA.Course_Level_Id)
            AND NA.Course_Category_Id = ISNULL(@Category_Id, NA.Course_Category_Id)
            AND CPD_Payment.Application_Status = ISNULL(@App_Satatus, CPD_Payment.Application_Status)
            AND NA.Department_Id = ISNULL(@Department_Id, NA.Department_Id)
            AND CBD.Batch_Id = ISNULL(@Batch_Id, CBD.Batch_Id)
    END
    ');
END
ELSE
BEGIN
    EXEC('
    ALTER PROCEDURE [dbo].[SP_GetAll_Application_EditSearch]
    (
        @NewAdmission_Id BIGINT = NULL,
        @Course_Level_Id BIGINT = NULL,
        @Category_Id BIGINT = NULL,
        @App_Status INT = NULL,
        @Department_Id BIGINT = NULL,
        @Batch_Id BIGINT = NULL
    )
    AS
    BEGIN
        SET NOCOUNT ON;
        
        SELECT  
            CP.Candidate_Id AS ID,
            CP.Candidate_Fname AS [Name],
            CP.Candidate_Gender AS [Gender],
            CP.Religion AS [Religion],
            CP.Caste AS [Caste],
            CC.Candidate_Email AS Email,
            CC.Candidate_Mob1 AS Mobile,
            CPD.Application_Status AS [Status],
            NA.New_Admission_Id,
            (CH.Candidate_MonthofPass + '' '' + CH.Candidate_YearofPass) AS [HSEYearOfPass],
            CL.Course_Level_Name AS Course_LEVEL,
            CCC.Course_Category_Name AS Course_Category,
            NA.Course_Level_Id AS Course_LEVEL_Id,
            NA.Course_Category_Id AS Course_Category_Id,
            CP.Initial_Application_Id,
            CP.New_Admission_Id,
            CBD.Batch_Id AS BatchID,
            CBD.Batch_Code AS Batch,
            NA.Department_Id,
            D.Department_Name AS Department
        FROM dbo.Tbl_Candidate_Personal_Det CP
        LEFT JOIN Tbl_Candidate_ContactDetails CC ON CP.Candidate_Id = CC.Candidate_Id
        LEFT JOIN Tbl_Candidate_PaymentDet CPD ON CP.Candidate_Id = CPD.Candidate_Id
        LEFT JOIN Tbl_Candidate_HSCDet CH ON CP.Candidate_Id = CH.Candidate_Id
        INNER JOIN tbl_New_Admission NA ON NA.New_Admission_Id = CP.New_Admission_Id
        INNER JOIN Tbl_Course_Batch_Duration CBD ON CBD.Batch_Id = NA.Batch_Id
        INNER JOIN Tbl_Course_Category CCC ON CCC.Course_Category_Id = NA.Course_Category_Id
        INNER JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = NA.Course_Level_Id
        INNER JOIN Tbl_Department D ON D.Department_Id = NA.Department_Id
        WHERE CP.Candidate_DelStatus = 0
            AND NA.New_Admission_Id = ISNULL(@NewAdmission_Id, NA.New_Admission_Id)
            AND NA.Course_Level_Id = ISNULL(@Course_Level_Id, NA.Course_Level_Id)
            AND NA.Course_Category_Id = ISNULL(@Category_Id, NA.Course_Category_Id)
            AND CPD.Application_Status = ISNULL(@App_Status, CPD.Application_Status)
            AND NA.Department_Id = ISNULL(@Department_Id, NA.Department_Id)
            AND CBD.Batch_Id = ISNULL(@Batch_Id, CBD.Batch_Id);
    END
    ');
END
GO