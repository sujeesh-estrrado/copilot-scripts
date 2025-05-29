IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Get_Students_CompleteDetails_by_CandidateId]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Get_Students_CompleteDetails_by_CandidateId]
            @Candidate_Id BIGINT
        AS 
        BEGIN
            SELECT 
                CP.Candidate_Id AS ID,
                CP.Candidate_Fname + '' '' + CP.Candidate_Mname + '' '' + CP.Candidate_Lname AS [Name],
                CP.Candidate_Gender AS [Gender],
                CP.Candidate_Dob AS [DOB],
                CP.Candidate_PlaceOfBirth AS [PlaceOfBirth],
                CP.Candidate_Nationality AS [Nationality],
                CP.Candidate_State AS [State],
                CP.Candidate_Img AS [Image],
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

                /* SSLC Details */
                CSSLC.Institution_Name AS [SSSLCInstitutnName],
                CSSLC.BoardofStudy AS [SSLCBoardofStudy],
                CSSLC.Candidate_MonthofPass + '' '' + CSSLC.Candidate_YearofPass AS [SSLSYearOfPass],
                CSSLC.Candidate_Percentage AS [SSLCPercetage],
                CSSLC.Candidate_Subj_Percentage_1 AS [SSSLSub1],
                CSSLC.Candidate_Subj_Percentage_2 AS [SSSLSub2],
                CSSLC.Candidate_Subj_Percentage_3 AS [SSSLSub3],

                /* HSE Details */
                CHS.Candidate_MonthofPass + '' '' + CHS.Candidate_YearofPass AS [HSEYearOfPass],
                CHS.Candidate_Percentage AS [HSEPercentage],
                CHS.Candidate_Subj_Percentage_1 AS [HSESub1],
                CHS.Candidate_Subj_Percentage_2 AS [HSESub2],
                CHS.Candidate_Subj_Percentage_3 AS [HSESub3],

                /* UG Details */
                CUG.Institution_Name AS [UGInstitutionName],
                CUG.BoardofStudy AS [UGBoardOfStudy],
                CUG.Candidate_MonthofPass + '' '' + CUG.Candidate_YearofPass AS [UGYearOfPass],
                CUG.Candidate_Percentage AS [UGCandidatePer],
                CUG.Candidate_Subj_Percentage_1 AS [UGSub1],
                CUG.Candidate_Subj_Percentage_2 AS [UGSub2],
                CUG.Candidate_Subj_Percentage_3 AS [UGSub3],

                /* PG Details */
                CPG.Institution_Name AS [PGInstitutionName],
                CPG.BoardofStudy AS [PGBoardOfStudy],
                CPG.Stream AS [PGStream],
                CPG.Candidate_MonthofPass + '' '' + CPG.Candidate_YearofPass AS [PGYearOfStudy],
                CPG.Candidate_Percentage AS [PGPercentage],
                CPG.Candidate_Subj_Percentage_1 AS [PGSub1],
                CPG.Candidate_Subj_Percentage_2 AS [PGSub2],
                CPG.Candidate_Subj_Percentage_3 AS [PGSub3],

                SR.Student_Reg_No AS [Regno],
                CP.Religion AS [Religion],
                CP.Caste AS [Caste],
                CCD.Candidate_Email AS Email,
                CCD.Candidate_Mob1 AS Mobile,
                SS.Student_Semester_Current_Status AS newstatus,
                CDM.Course_Department_Id,
                CD.Course_Category_Id,
                CD.Department_Id,
                D.Department_Name AS new_dept,
                CC.Course_Category_Name,

                (SELECT DISTINCT a.Course_Level_Name 
                 FROM dbo.Tbl_Course_Level a 
                 LEFT JOIN dbo.Tbl_Candidate_CoursePriority b 
                     ON a.Course_Level_Id = b.Course_Level_Id 
                 WHERE b.Candidate_Id = CP.Candidate_Id) AS Course_LEVEL,

                (SELECT DISTINCT a.Course_Category_Name 
                 FROM dbo.Tbl_Course_Category a 
                 LEFT JOIN dbo.Tbl_Candidate_CoursePriority b 
                     ON a.Course_Category_Id = b.Course_Category_Id 
                 WHERE b.Candidate_Id = CP.Candidate_Id) AS Course_Category,

                (SELECT DISTINCT a.Course_Level_Id 
                 FROM dbo.Tbl_Course_Level a 
                 LEFT JOIN dbo.Tbl_Candidate_CoursePriority b 
                     ON a.Course_Level_Id = b.Course_Level_Id 
                 WHERE b.Candidate_Id = CP.Candidate_Id) AS Course_LEVEL_Id,

                (SELECT DISTINCT a.Course_Category_Id 
                 FROM dbo.Tbl_Course_Category a 
                 LEFT JOIN dbo.Tbl_Candidate_CoursePriority b 
                     ON a.Course_Category_Id = b.Course_Category_Id 
                 WHERE b.Candidate_Id = CP.Candidate_Id) AS Course_Category_Id,

                SR.Department_Id,
                D.Department_Name AS [Department name],
                SS.Duration_Mapping_Id,
                CD.Department_Id,
                CD.Course_Category_Id,
                SHD.*,
                SHV.*,
                SHB.*,
                SHA.*,
                STC.*
            FROM dbo.Tbl_Candidate_Personal_Det CP
            LEFT JOIN Tbl_Candidate_ContactDetails CCD ON CP.Candidate_Id = CCD.Candidate_Id
            LEFT JOIN Tbl_Candidate_PaymentDet CPD ON CP.Candidate_Id = CPD.Candidate_Id
            LEFT JOIN Tbl_Candidate_HSCDet CHS ON CP.Candidate_Id = CHS.Candidate_Id
            LEFT JOIN Tbl_Candidate_SSLC_Det CSSLC ON CP.Candidate_Id = CSSLC.Candidate_Id
            LEFT JOIN Tbl_Candidate_UGDet CUG ON CP.Candidate_Id = CUG.Candidate_Id
            LEFT JOIN Tbl_Candidate_PGDet CPG ON CP.Candidate_Id = CPG.Candidate_Id
            LEFT JOIN Tbl_Student_Registration SR ON CP.Candidate_Id = SR.Candidate_Id
            LEFT JOIN Tbl_Fee_Entry FE ON CP.Candidate_Id = FE.Candidate_Id
            LEFT JOIN Tbl_Student_Semester SS ON SS.Candidate_Id = CP.Candidate_Id
            LEFT JOIN Tbl_Course_Duration_Mapping CDM ON SS.Duration_Mapping_Id = CDM.Duration_Mapping_Id
            LEFT JOIN Tbl_Course_Department CD ON CDM.Course_Department_Id = CD.Course_Department_Id
            LEFT JOIN Tbl_Course_Category CC ON CD.Course_Category_Id = CC.Course_Category_Id
            LEFT JOIN Tbl_Course_Level CL ON CC.Course_level_Id = CL.Course_level_Id
            LEFT JOIN Tbl_Department D ON CD.Department_Id = D.Department_Id
            LEFT JOIN Tbl_Student_Health_General SHD ON SHD.StudentId = CP.Candidate_Id
            LEFT JOIN Tbl_Student_Health_Vaccination SHV ON SHV.StudentId = CP.Candidate_Id
            LEFT JOIN Tbl_Student_Health_BoosterDoses SHB ON SHB.StudentId = CP.Candidate_Id
            LEFT JOIN Tbl_Student_Health_Allergy SHA ON SHA.StudentId = CP.Candidate_Id
            LEFT JOIN Tbl_Student_TC_Details STC ON STC.Candidate_Id = CP.Candidate_Id
            WHERE 
                CP.Candidate_DelStatus = 0 
                AND CP.Candidate_Id = @Candidate_Id 
                AND SS.Student_Semester_Current_Status = 1
        END;
    ')
END
