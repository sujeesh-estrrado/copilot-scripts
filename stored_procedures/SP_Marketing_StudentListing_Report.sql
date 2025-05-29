IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Marketing_StudentListing_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Marketing_StudentListing_Report] 
(
    @Status VARCHAR(MAX) = '''',
    @Staff BIGINT = 0,
    @ProgramType BIGINT = 0,
    @Program BIGINT = 0,
    @HighestEduLevel VARCHAR(MAX) = '''',
    @Source VARCHAR(MAX) = '''',
    @Eligibility VARCHAR(MAX) = '''',
    @fromdate DATETIME = NULL,
    @todate DATETIME = NULL,
    @CurrentPage BIGINT = 0,
    @pagesize BIGINT = 0,
    @IntakeId BIGINT = 0,
    @TypeOfStudent BIGINT = 0
)
AS
BEGIN
    DECLARE @UpperBand INT
    DECLARE @LowerBand INT

    SET @LowerBand = (@CurrentPage - 1) * @PageSize
    SET @UpperBand = (@CurrentPage * @PageSize) + 1

    IF(@Status = ''Pending'')
    BEGIN
        SELECT DISTINCT 
            D.Candidate_Id,
            ApplicationStatus,
            ApplicationStage,
            (CONCAT(UPPER(Candidate_Fname), '' '', UPPER(Candidate_Lname))) AS Candidatename,
            AdharNumber,
            Candidate_Gender,
            Candidate_Email,
            Candidate_Mob1,
            Candidate_Telephone,
            Candidate_Guardian_Mob,
            Candidate_PermAddress,
            Na.Nationality AS Candidate_Nationality,
            Department_Name,
            P.Course_Code,
            Diocese,
            E.Employee_FName + '' '' + Employee_LName AS CounselorName,
            EnrollBy,
            Sponsorship,
            A.Agent_Name,
            CONVERT(VARCHAR, RegDate, 103) AS RegDate, 
            '''' AS IntakeMasterID,    
            '''' AS SourceName,
            '''' AS intake_no,
            '''' AS Candidate_FamilyIncome,
            '''' AS Course_Level_Name,
            '''' AS Organization_Name,
            '''' AS ApprovedDate,
            '''' AS career,
            '''' AS TypeOfStudent
        FROM Tbl_Candidate_Personal_Det D
        INNER JOIN Tbl_Candidate_ContactDetails C ON C.Candidate_Id = D.Candidate_Id
        LEFT JOIN tbl_New_Admission N ON N.New_Admission_Id = D.New_Admission_Id
        LEFT JOIN Tbl_Department P ON P.Department_Id = N.Department_Id
        LEFT JOIN Tbl_Agent A ON A.Agent_ID = D.Agent_ID
        LEFT JOIN Tbl_Employee E ON E.Employee_Id = D.CounselorEmployee_id
        LEFT JOIN Tbl_Candidate_Additionalqualification AQ ON AQ.Candidate_Id = D.Candidate_Id
        LEFT JOIN Tbl_Candidate_EducationDetails ED ON ED.Candidate_Id = D.Candidate_Id
        LEFT JOIN Tbl_Nationality Na ON CONVERT(VARCHAR(10), NA.Nationality_Id) = CONVERT(VARCHAR(10), D.Candidate_Nationality)
        WHERE (@Staff = 0 OR CounselorEmployee_id = @Staff)
        AND (@ProgramType = 0 OR N.Course_Category_Id = @ProgramType) 
        AND (@Program = 0 OR N.Department_Id = @Program)
        AND (@HighestEduLevel = '''' OR Institution_Level = @HighestEduLevel OR QualificationLevel = @HighestEduLevel) 
        AND (@Source = '''' OR SourceofInformation = @Source OR Candidate_Hereaboutus = @Source)
        AND (@Eligibility = '''' OR Sponsorship = @Eligibility)
        AND active = 1
        AND (ApplicationStatus = ''pending'' OR ApplicationStatus = ''submited'')
        AND (
            (CONVERT(DATE, RegDate) >= @fromdate AND CONVERT(DATE, RegDate) < DATEADD(DAY, 1, @todate)) 
            OR (@fromdate IS NULL AND @todate IS NULL)
            OR (@fromdate IS NULL AND CONVERT(DATE, RegDate) < DATEADD(DAY, 1, @todate))
            OR (@todate IS NULL AND CONVERT(DATE, RegDate) >= @fromdate)
        )
        ORDER BY RegDate
        OFFSET @PageSize * (@CurrentPage - 1) ROWS
        FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
    END
    ELSE IF(@Status = ''FollowUp'')
    BEGIN
        SELECT DISTINCT 
            D.Candidate_Id,
            ApplicationStatus,
            ApplicationStage,
            (CONCAT(UPPER(Candidate_Fname), '' '', UPPER(Candidate_Lname))) AS Candidatename,
            AdharNumber,
            Candidate_Gender,
            Candidate_Email,
            Candidate_Mob1,
            Candidate_Telephone,
            Candidate_Guardian_Mob,
            Candidate_PermAddress,
            Na.Nationality AS Candidate_Nationality,
            Department_Name,
            P.Course_Code,
            Diocese,
            E.Employee_FName + '' '' + Employee_LName AS CounselorName,
            EnrollBy,
            Sponsorship,
            A.Agent_Name,
            CONVERT(VARCHAR, RegDate, 103) AS RegDate, 
            '''' AS IntakeMasterID,    
            '''' AS SourceName,
            '''' AS intake_no,
            '''' AS Candidate_FamilyIncome,
            '''' AS Course_Level_Name,
            '''' AS Organization_Name,
            '''' AS ApprovedDate,
            '''' AS career,
            '''' AS TypeOfStudent
        FROM Tbl_Candidate_Personal_Det D
        INNER JOIN Tbl_Candidate_ContactDetails C ON C.Candidate_Id = D.Candidate_Id
        LEFT JOIN tbl_New_Admission N ON N.New_Admission_Id = D.New_Admission_Id
        LEFT JOIN Tbl_Department P ON P.Department_Id = N.Department_Id
        LEFT JOIN Tbl_Agent A ON A.Agent_ID = D.Agent_ID
        LEFT JOIN Tbl_Employee E ON E.Employee_Id = D.CounselorEmployee_id
        LEFT JOIN Tbl_Candidate_Additionalqualification AQ ON AQ.Candidate_Id = D.Candidate_Id
        LEFT JOIN Tbl_Candidate_EducationDetails ED ON ED.Candidate_Id = D.Candidate_Id
        LEFT JOIN Tbl_Nationality Na ON CONVERT(VARCHAR(10), NA.Nationality_Id) = CONVERT(VARCHAR(10), D.Candidate_Nationality)
        LEFT JOIN Tbl_FollowUp_Detail F ON D.Candidate_Id = F.Candidate_Id
        WHERE D.Candidate_Id IN (SELECT Candidate_Id FROM Tbl_FollowUp_Detail) 
        AND ApplicationStatus != ''Completed'' 
        AND (@Staff = 0 OR CounselorEmployee_id = @Staff)
        AND (@ProgramType = 0 OR N.Course_Category_Id = @ProgramType)
        AND (@Program = 0 OR N.Department_Id = @Program)
        AND (@HighestEduLevel = '''' OR Institution_Level = @HighestEduLevel OR QualificationLevel = @HighestEduLevel) 
        AND (@Source = '''' OR SourceofInformation = @Source OR Candidate_Hereaboutus = @Source)
        AND (@Eligibility = '''' OR Sponsorship = @Eligibility)
        AND (
            (CONVERT(DATE, RegDate) >= @fromdate AND CONVERT(DATE, RegDate) < DATEADD(DAY, 1, @todate)) 
            OR (@fromdate IS NULL AND @todate IS NULL)
            OR (@fromdate IS NULL AND CONVERT(DATE, RegDate) < DATEADD(DAY, 1, @todate))
            OR (@todate IS NULL AND CONVERT(DATE, RegDate) >= @fromdate)
        )
        ORDER BY RegDate
        OFFSET @PageSize * (@CurrentPage - 1) ROWS
        FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
    END
    ELSE
    BEGIN
        SELECT DISTINCT 
            D.Candidate_Id,
            ApplicationStatus,
            ApplicationStage,
            (CONCAT(UPPER(Candidate_Fname), '' '', UPPER(Candidate_Lname))) AS Candidatename,
            AdharNumber,
            Candidate_Gender,
            Candidate_Email,
            Candidate_Mob1,
            Candidate_Telephone,
            Candidate_Guardian_Mob,
            Candidate_PermAddress,
            Na.Nationality AS Candidate_Nationality,
            Department_Name,
            P.Course_Code,
            Diocese,
            E.Employee_FName + '' '' + Employee_LName AS CounselorName,
            EnrollBy,
            Sponsorship,
            A.Agent_Name,
            CONVERT(VARCHAR, RegDate, 103) AS RegDate, 
            '''' AS IntakeMasterID,    
            '''' AS SourceName,
            '''' AS intake_no,
            '''' AS Candidate_FamilyIncome,
            '''' AS Course_Level_Name,
            '''' AS Organization_Name,
            '''' AS ApprovedDate,
            '''' AS career,
            '''' AS TypeOfStudent
        FROM Tbl_Candidate_Personal_Det D
        INNER JOIN Tbl_Candidate_ContactDetails C ON C.Candidate_Id = D.Candidate_Id
        LEFT JOIN tbl_New_Admission N ON N.New_Admission_Id = D.New_Admission_Id
        LEFT JOIN Tbl_Department P ON P.Department_Id = N.Department_Id
        LEFT JOIN Tbl_Agent A ON A.Agent_ID = D.Agent_ID
        LEFT JOIN Tbl_Employee E ON E.Employee_Id = D.CounselorEmployee_id
        LEFT JOIN Tbl_Candidate_Additionalqualification AQ ON AQ.Candidate_Id = D.Candidate_Id
        LEFT JOIN Tbl_Candidate_EducationDetails ED ON ED.Candidate_Id = D.Candidate_Id
        LEFT JOIN Tbl_Nationality Na ON CONVERT(VARCHAR(10), NA.Nationality_Id) = CONVERT(VARCHAR(10), D.Candidate_Nationality)
        WHERE (@Status = '''' OR ApplicationStatus = @Status) 
        AND ApplicationStatus != ''Completed'' 
        AND (@Staff = 0 OR CounselorEmployee_id = @Staff)
        AND (@ProgramType = 0 OR N.Course_Category_Id = @ProgramType) 
        AND (@Program = 0 OR N.Department_Id = @Program)
        AND (@HighestEduLevel = '''' OR Institution_Level = @HighestEduLevel OR QualificationLevel = @HighestEduLevel) 
        AND (@Source = '''' OR SourceofInformation = @Source OR Candidate_Hereaboutus = @Source)
        AND (@Eligibility = '''' OR Sponsorship = @Eligibility)
        AND (
            (CONVERT(DATE, RegDate) >= @fromdate AND CONVERT(DATE, RegDate) < DATEADD(DAY, 1, @todate)) 
            OR (@fromdate IS NULL AND @todate IS NULL)
            OR (@fromdate IS NULL AND CONVERT(DATE, RegDate) < DATEADD(DAY, 1, @todate))
            OR (@todate IS NULL AND CONVERT(DATE, RegDate) >= @fromdate)
        )
        ORDER BY RegDate
        OFFSET @PageSize * (@CurrentPage - 1) ROWS
        FETCH NEXT @PageSize ROWS ONLY OPTION (RECOMPILE);
    END
END
');
END