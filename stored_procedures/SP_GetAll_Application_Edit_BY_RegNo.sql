IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_GetAll_Application_Edit_BY_RegNo]')
    AND type = N'P'
)
BEGIN
    EXEC('
    CREATE PROCEDURE [dbo].[SP_GetAll_Application_Edit_BY_RegNo]
    @Student_Reg_No VARCHAR(200)
    AS
    BEGIN
        SELECT 
            CPD.Candidate_Id AS ID,
            SR.Student_Reg_No,
            CPD.Candidate_Fname + '' '' + ISNULL(CPD.Candidate_Mname, '''') + '' '' + ISNULL(CPD.Candidate_Lname, '''') AS [Name],
            CPD.Candidate_Gender AS [Gender],
            CPD.Candidate_Dob AS [DOB],
            CPD.Candidate_PlaceOfBirth AS [PlaceOfBirth],
            CPD.Candidate_Nationality AS [Nationality],
            CPD.Candidate_State AS [State],
            CPD.Candidate_Img AS [Image],
            CCD.Candidate_FatherName AS [Fathername],
            CCD.Candidate_MotherName AS [Mothername],
            CCD.Candidate_FatherOcc AS [FatherOccupation],
            CCD.Candidate_MotherOcc AS [MotherOccupation],
            CCD.Candidate_PermAddress AS [Presentadress],
            CCD.Candidate_ContAddress AS [Permanentadress],
            CCD.Candidate_GuardianName AS [Gname],
            CCD.Candidate_Guardian_Telephone AS [Gtelephone],
            CCD.Candidate_Relationship AS [GRelationship],
            CCD.Candidate_Guardian_Address AS [Gadress],
            CCD.Candidate_FatherEmail AS [FEmail],
            CCD.Candidate_Guardian_Email AS [GEmail],

            -- SSLC Details
            SSLCD.Institution_Name AS [SSSLCInstitutnName],
            SSLCD.BoardofStudy AS [SSLCBoardofStudy],
            ISNULL(SSLCD.Candidate_MonthofPass, '''') + '' '' + ISNULL(SSLCD.Candidate_YearofPass, '''') AS [SSLSYearOfPass],
            SSLCD.Candidate_Percentage AS [SSLCPercetage],
            SSLCD.Candidate_Subj_Percentage_1 AS [SSSLSub1],
            SSLCD.Candidate_Subj_Percentage_2 AS [SSSLSub2],
            SSLCD.Candidate_Subj_Percentage_3 AS [SSSLSub3],

            -- HSE Details
            ISNULL(HSC.Candidate_MonthofPass, '''') + '' '' + ISNULL(HSC.Candidate_YearofPass, '''') AS [HSEYearOfPass],
            HSC.Candidate_Percentage AS [HSEPercentage],
            HSC.Candidate_Subj_Percentage_1 AS [HSESub1],
            HSC.Candidate_Subj_Percentage_2 AS [HSESub2],
            HSC.Candidate_Subj_Percentage_3 AS [HSESub3],

            -- UG Details
            UG.Institution_Name AS [UGInstitutionName],
            UG.BoardofStudy AS [UGBoardOfStudy],
            ISNULL(UG.Candidate_MonthofPass, '''') + '' '' + ISNULL(UG.Candidate_YearofPass, '''') AS [UGYearOfPass],
            UG.Candidate_Percentage AS [UGCandidatePer],
            UG.Candidate_Subj_Percentage_1 AS [UGSub1],
            UG.Candidate_Subj_Percentage_2 AS [UGSub2],
            UG.Candidate_Subj_Percentage_3 AS [UGSub3],

            -- PG Details
            PG.Institution_Name AS [PGInstitutionName],
            PG.BoardofStudy AS [PGBoardOfStudy],
            PG.Stream AS [PGStream],
            ISNULL(PG.Candidate_MonthofPass, '''') + '' '' + ISNULL(PG.Candidate_YearofPass, '''') AS [PGYearOfStudy],
            PG.Candidate_Percentage AS [PGPercentage],
            PG.Candidate_Subj_Percentage_1 AS [PGSub1],
            PG.Candidate_Subj_Percentage_2 AS [PGSub2],
            PG.Candidate_Subj_Percentage_3 AS [PGSub3],

            -- Admission details
            SR.Student_Reg_No AS [Regno],
            SS.Student_Semester_Current_Status AS newstatus,
            CDM.Course_Department_Id,
            CD.Course_Category_Id,
            CD.Department_Id,
            D.Department_Name AS new_dept,
            CC.Course_Category_Name,

            -- Course Level & Category
            (SELECT DISTINCT CL.Course_Level_Name 
             FROM dbo.Tbl_Course_Level CL
             LEFT JOIN dbo.Tbl_Candidate_CoursePriority CCP 
             ON CL.Course_Level_Id = CCP.Course_Level_Id 
             WHERE CCP.Candidate_Id = CPD.Candidate_Id) AS Course_LEVEL,

            (SELECT DISTINCT CC2.Course_Category_Name 
             FROM dbo.Tbl_Course_Category CC2
             LEFT JOIN dbo.Tbl_Candidate_CoursePriority CCP 
             ON CC2.Course_Category_Id = CCP.Course_Category_Id 
             WHERE CCP.Candidate_Id = CPD.Candidate_Id) AS Course_Category,

            (SELECT DISTINCT CL.Course_Level_Id 
             FROM dbo.Tbl_Course_Level CL
             LEFT JOIN dbo.Tbl_Candidate_CoursePriority CCP 
             ON CL.Course_Level_Id = CCP.Course_Level_Id 
             WHERE CCP.Candidate_Id = CPD.Candidate_Id) AS Course_LEVEL_Id,

            (SELECT DISTINCT CC2.Course_Category_Id 
             FROM dbo.Tbl_Course_Category CC2
             LEFT JOIN dbo.Tbl_Candidate_CoursePriority CCP 
             ON CC2.Course_Category_Id = CCP.Course_Category_Id 
             WHERE CCP.Candidate_Id = CPD.Candidate_Id) AS Course_Category_Id,

            SR.Department_Id,
            D.Department_Name AS [Department name],
            SS.Duration_Mapping_Id,
            CD.Department_Id,
            CD.Course_Category_Id,
            CPD.Religion,
            CPD.Caste,
            CCD.Candidate_Email AS Email,
            CCD.Candidate_Mob1 AS Mobile,
            CP.Application_Status AS [Status],
            CPD.New_Admission_Id
        FROM dbo.Tbl_Candidate_Personal_Det CPD
        LEFT JOIN Tbl_Candidate_ContactDetails CCD ON CPD.Candidate_Id = CCD.Candidate_Id
        LEFT JOIN Tbl_Candidate_PaymentDet CP ON CPD.Candidate_Id = CP.Candidate_Id
        LEFT JOIN Tbl_Candidate_HSCDet HSC ON CPD.Candidate_Id = HSC.Candidate_Id
        LEFT JOIN Tbl_Candidate_SSLC_Det SSLCD ON CPD.Candidate_Id = SSLCD.Candidate_Id
        LEFT JOIN Tbl_Candidate_UGDet UG ON CPD.Candidate_Id = UG.Candidate_Id
        LEFT JOIN Tbl_Candidate_PGDet PG ON CPD.Candidate_Id = PG.Candidate_Id
        LEFT JOIN Tbl_Student_Registration SR ON CPD.Candidate_Id = SR.Candidate_Id
        LEFT JOIN Tbl_Student_Semester SS ON SS.Candidate_Id = CPD.Candidate_Id
        LEFT JOIN Tbl_Course_Duration_Mapping CDM ON SS.Duration_Mapping_Id = CDM.Duration_Mapping_Id
        LEFT JOIN Tbl_Course_Department CD ON CDM.Course_Department_Id = CD.Course_Department_Id
        LEFT JOIN Tbl_Course_Category CC ON CD.Course_Category_Id = CC.Course_Category_Id
        LEFT JOIN Tbl_Course_Level CL ON CC.Course_level_Id = CL.Course_level_Id
        LEFT JOIN Tbl_Department D ON CD.Department_Id = D.Department_Id
        WHERE CPD.Candidate_DelStatus = 0 
        AND SR.Student_Reg_No = @Student_Reg_No
        AND SS.Student_Semester_Current_Status = 1
    END
    ')
END
GO
