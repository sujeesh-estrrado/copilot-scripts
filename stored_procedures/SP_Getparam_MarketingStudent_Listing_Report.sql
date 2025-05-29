IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Getparam_MarketingStudent_Listing_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_Getparam_MarketingStudent_Listing_Report]
(
    @Flag BIGINT = 0,
    @Status VARCHAR(MAX) = '''',
    @Staff BIGINT = 0,
    @ProgramType BIGINT = 0,
    @Program BIGINT = 0,
    @HighestEduLevel VARCHAR(MAX) = '''',
    @Source VARCHAR(MAX) = '''',
    @Eligibility VARCHAR(MAX) = '''',
    @fromdate VARCHAR(MAX) = '''',
    @todate VARCHAR(MAX) = ''''
)
AS
BEGIN
    IF (@Flag = 1)
    BEGIN
        SELECT DISTINCT 
            CASE WHEN @Status = '''' THEN ''All'' ELSE @Status END AS Status,
            CASE WHEN @Staff = 0 THEN ''All'' ELSE E.Employee_FName + '' '' + E.Employee_LName END AS CounselorName,
            CASE WHEN @ProgramType = 0 THEN ''All'' ELSE V.Course_Category_Name END AS Course_Category_Name,
            CASE WHEN @Program = 0 THEN ''All'' ELSE P.Department_Name END AS Department_Name,
            CASE WHEN @HighestEduLevel = '''' THEN ''All'' ELSE @HighestEduLevel END AS HighestEduLevel,
            CASE WHEN @Source = '''' THEN ''All'' ELSE @Source END AS Source,
            CASE WHEN @Eligibility = '''' THEN ''All'' ELSE @Eligibility END AS Eligibility,
            CASE WHEN @fromdate = '''' THEN ''All'' ELSE CONVERT(VARCHAR, D.RegDate, 103) END AS fromdate,
            CASE WHEN @todate = '''' THEN ''All'' ELSE CONVERT(VARCHAR, D.RegDate, 103) END AS todate
        FROM 
            Tbl_Candidate_Personal_Det D
            INNER JOIN Tbl_Candidate_ContactDetails C ON C.Candidate_Id = D.Candidate_Id
            LEFT JOIN tbl_New_Admission N ON N.New_Admission_Id = D.New_Admission_Id
            LEFT JOIN Tbl_Department P ON P.Department_Id = N.Department_Id
            LEFT JOIN Tbl_Course_Category V ON V.Course_Category_Id = N.Course_Category_Id
            LEFT JOIN Tbl_Agent A ON A.Agent_ID = D.Agent_ID 
            LEFT JOIN Tbl_Employee E ON E.Employee_Id = D.CounselorEmployee_id
            LEFT JOIN Tbl_Candidate_Additionalqualification AQ ON AQ.Candidate_Id = D.Candidate_Id
        WHERE 
            (@Status = '''' OR D.ApplicationStatus = @Status) 
            AND (@Staff = 0 OR D.CounselorEmployee_id = @Staff)
            AND (@ProgramType = 0 OR N.Course_Category_Id = @ProgramType) 
            AND (@Program = 0 OR N.Department_Id = @Program)
            AND (@HighestEduLevel = '''' OR AQ.QualificationLevel = @HighestEduLevel)
            AND (@Source = '''' OR D.Diocese = @Source OR D.Candidate_Hereaboutus = @Source)
            AND (@Eligibility = '''' OR D.Sponsorship = @Eligibility)
            AND (
                (@fromdate = '''' AND @todate = '''')
                OR (D.RegDate BETWEEN 
                    CASE WHEN @fromdate = '''' THEN ''1900-01-01'' ELSE @fromdate END 
                    AND 
                    CASE WHEN @todate = '''' THEN GETDATE() ELSE @todate END
                )
            )
    END
END
');
END;