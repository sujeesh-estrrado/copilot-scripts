IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Admission_AccademicBackground_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Admission_AccademicBackground_Report]
        @flag INT = 2,
        @Candidate_Id BIGINT = 0,
        @Faculty BIGINT = 0,
        @intake BIGINT = 0,
        @ProgramType BIGINT = 0,
        @Program BIGINT = 0,
        @Semester BIGINT = 0,
        @Qualification VARCHAR(MAX) = '''',
        @CurrentPage BIGINT = 0,
        @PageSize BIGINT = 0
        AS
        BEGIN
            DECLARE @UpperBand INT;
            DECLARE @LowerBand INT;

            SET @LowerBand = (@CurrentPage - 1) * @PageSize;
            SET @UpperBand = (@CurrentPage * @PageSize) + 1;

            IF (@flag = 1)
            BEGIN
                SELECT * INTO #TEMP1 
                FROM (
                    SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id DESC) AS slno, BK.*
                    FROM (
                        SELECT DISTINCT
                            D.Candidate_Id, Adharnumber, @Qualification AS Qualification,
                            COALESCE(Candidate_Fname, '''') + '' '' + COALESCE(Candidate_Lname, '''') AS Candidatename, IDMatrixNo,
                            Course_Level_Name, Department_Name, P.Course_Code, bd.Batch_Code AS Intake
                        FROM Tbl_Candidate_Personal_Det D
                        INNER JOIN Tbl_Candidate_ContactDetails C ON C.Candidate_Id = D.Candidate_Id
                        LEFT JOIN tbl_New_Admission N ON N.New_Admission_Id = D.New_Admission_Id
                        LEFT JOIN Tbl_Department P ON P.Department_Id = N.Department_Id
                        LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = N.Course_Level_Id
                        LEFT JOIN Tbl_Course_Batch_Duration bd ON N.Batch_Id = bd.Batch_Id
                        LEFT JOIN Tbl_Candidate_Additionalqualification Q ON D.Candidate_Id = Q.Candidate_Id
                        LEFT JOIN Tbl_Candidate_EducationDetails ED ON D.Candidate_Id = ED.Candidate_Id
                        WHERE ApplicationStatus = ''Completed''
                        AND (@Qualification = '''' OR Q.QualificationLevel = @Qualification OR Institution_Level = @Qualification)
                        AND (@ProgramType = 0 OR N.Course_Category_Id = @ProgramType)
                        AND (@Program = 0 OR N.Department_Id = @Program)
                        AND (@Faculty = 0 OR N.Course_Level_Id = @Faculty)
                        AND (N.Batch_Id = @intake OR @intake = 0)
                    ) BK
                ) B
                SELECT * FROM #TEMP1 WHERE slno > CONVERT(VARCHAR, @LowerBand) AND slno < CONVERT(VARCHAR, @UpperBand);
            END

            IF (@flag = 2)
            BEGIN
                SELECT * INTO #TEMP2 
                FROM (
                    SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id DESC) AS slno, BK.*
                    FROM (
                        SELECT DISTINCT
                            D.Candidate_Id, Adharnumber, @Qualification AS Qualification,
                            COALESCE(Candidate_Fname, '''') + '' '' + COALESCE(Candidate_Lname, '''') AS Candidatename, IDMatrixNo,
                            Course_Level_Name, Department_Name, P.Course_Code, bd.Batch_Code AS Intake
                        FROM Tbl_Candidate_Personal_Det D
                        INNER JOIN Tbl_Candidate_ContactDetails C ON C.Candidate_Id = D.Candidate_Id
                        LEFT JOIN tbl_New_Admission N ON N.New_Admission_Id = D.New_Admission_Id
                        LEFT JOIN Tbl_Department P ON P.Department_Id = N.Department_Id
                        LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = N.Course_Level_Id
                        LEFT JOIN Tbl_Course_Batch_Duration bd ON N.Batch_Id = bd.Batch_Id
                        LEFT JOIN Tbl_Candidate_Additionalqualification Q ON D.Candidate_Id = Q.Candidate_Id
                        LEFT JOIN Tbl_Candidate_EducationDetails ED ON D.Candidate_Id = ED.Candidate_Id
                        WHERE ApplicationStatus = ''Completed''
                        AND (@Qualification = '''' OR Q.QualificationLevel = @Qualification OR Institution_Level = @Qualification)
                        AND (@ProgramType = 0 OR N.Course_Category_Id = @ProgramType)
                        AND (@Program = 0 OR N.Department_Id = @Program)
                        AND (@Faculty = 0 OR N.Course_Level_Id = @Faculty)
                        AND (N.Batch_Id = @intake OR @intake = 0)
                    ) BK
                ) B
                SELECT COUNT(Candidate_Id) AS totcount FROM #TEMP2;
            END

            IF (@flag = 3)
            BEGIN
                SELECT * INTO #TEMP3 
                FROM (
                    SELECT ROW_NUMBER() OVER (ORDER BY Candidate_Id DESC) AS slno, BK.*
                    FROM (
                        SELECT DISTINCT
                            D.Candidate_Id, Adharnumber, YearofPass, InstitutionName, QualificationLevel,
                            ED.Qualification, Institution_Level, COALESCE(Candidate_Fname, '''') + '' '' + COALESCE(Candidate_Lname, '''') AS Candidatename,
                            IDMatrixNo, Course_Level_Name, Department_Name, P.Course_Code, bd.Batch_Code AS Intake
                        FROM Tbl_Candidate_Personal_Det D
                        INNER JOIN Tbl_Candidate_ContactDetails C ON C.Candidate_Id = D.Candidate_Id
                        LEFT JOIN tbl_New_Admission N ON N.New_Admission_Id = D.New_Admission_Id
                        LEFT JOIN Tbl_Department P ON P.Department_Id = N.Department_Id
                        LEFT JOIN Tbl_Course_Level CL ON CL.Course_Level_Id = N.Course_Level_Id
                        LEFT JOIN Tbl_Course_Batch_Duration bd ON N.Batch_Id = bd.Batch_Id
                        LEFT JOIN Tbl_Candidate_Additionalqualification Q ON D.Candidate_Id = Q.Candidate_Id
                        LEFT JOIN Tbl_Candidate_EducationDetails ED ON D.Candidate_Id = ED.Candidate_Id
                        WHERE ApplicationStatus = ''Completed''
                        AND D.Candidate_Id = @Candidate_Id
                        AND (@Qualification = '''' OR Q.QualificationLevel = @Qualification OR Institution_Level = @Qualification)
                    ) BK
                ) B
                SELECT * FROM #TEMP3;
            END
        END
    ');
END
