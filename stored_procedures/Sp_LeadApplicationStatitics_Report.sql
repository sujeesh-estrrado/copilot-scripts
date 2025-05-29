IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[Sp_LeadApplicationStatitics_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('

CREATE PROCEDURE [dbo].[Sp_LeadApplicationStatitics_Report]
    @Year INT,
    @Month INT,
    @Duration VARCHAR(10),   -- ''Daily'' or ''Weekly''
    @Type VARCHAR(20),       -- ''Lead'' or ''Application''
    @IncludeSource BIT = 0,  -- 1 = Show SourceofInformation breakdown
    @Counsellors VARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @StartDate DATE = DATEFROMPARTS(@Year, @Month, 1)
    DECLARE @EndDate DATE = EOMONTH(@StartDate)

    IF @Duration = ''Daily''
    BEGIN
        IF @Type = ''Lead''
        BEGIN
            ;WITH CalendarDates AS (
                SELECT @StartDate AS RegDate
                UNION ALL
                SELECT DATEADD(DAY, 1, RegDate)
                FROM CalendarDates
                WHERE DATEADD(DAY, 1, RegDate) <= @EndDate
            ),
            Programmes AS (
                SELECT DISTINCT D.Department_Name
                FROM tbl_Department D
            ),
            SourceTypes AS (
                SELECT DISTINCT Enquiry_From as  SourceofInformation
                FROM Tbl_Lead_Personal_Det
                WHERE Enquiry_From IS NOT NULL
            ),
            RawData AS (
                SELECT 
                L.CounselorEmployee_id,
                    ISNULL(D.Department_Name,''Unallocated'') as Department_Name,
                    CAST(L.RegDate AS DATE) AS RegDate,
                    L.Enquiry_From AS SourceofInformation,
                    COUNT(*) AS TotalCount
                FROM Tbl_Lead_Personal_Det L
                LEFT JOIN tbl_New_Admission A ON L.New_Admission_Id = A.New_Admission_Id
                LEFT JOIN tbl_Department D ON A.Department_Id = D.Department_Id
               WHERE YEAR(L.RegDate) = @Year AND MONTH(L.RegDate) = @Month
                AND ((ISNULL(L.CounselorEmployee_id,0) in ( select Value from dbo.fn_SplitString( @Counsellors,'',''))))
                AND L.CounselorEmployee_id > 0
               GROUP BY ISNULL(D.Department_Name,''Unallocated''), CAST(L.RegDate AS DATE), L.Enquiry_From,L.CounselorEmployee_id
            )
            SELECT 
                 ISNULL(P.Department_Name,''Unallocated'') AS Programme,
                CASE(S.SourceofInformation)
                WHEN ''--Select--'' THEN ''N/A'' ELSE S.SourceofInformation END AS SourceofInformation,
                CONVERT(VARCHAR(10), C.RegDate, 103) AS RegDate,
                ISNULL(R.TotalCount, 0) AS TotalCount
            FROM CalendarDates C
            CROSS JOIN (SELECT * FROM Programmes UNION ALL SELECT ''Unallocated'') P
            LEFT JOIN (
                SELECT SourceofInformation FROM SourceTypes WHERE @IncludeSource = 1
                UNION ALL
                SELECT NULL WHERE @IncludeSource = 0
            ) S ON 1=1
            LEFT JOIN RawData R 
                ON R.RegDate = C.RegDate 
                AND R.Department_Name = P.Department_Name
                AND (
                    (@IncludeSource = 1 AND R.SourceofInformation = S.SourceofInformation)
                    OR 
                    (@IncludeSource = 0 AND R.SourceofInformation IS NOT NULL)
                )
                --WHERE ISNULL(R.CounselorEmployee_id,0) > 0
                
            ORDER BY R.Department_Name, 
                     S.SourceofInformation,
                     C.RegDate
            
            --OPTION (MAXRECURSION 1000)
        END
        ELSE IF @Type = ''Application''
        BEGIN
            ;WITH CalendarDates AS (
                SELECT @StartDate AS RegDate
                UNION ALL
                SELECT DATEADD(DAY, 1, RegDate)
                FROM CalendarDates
                WHERE DATEADD(DAY, 1, RegDate) <= @EndDate
            ),
            Programmes AS (
                SELECT DISTINCT D.Department_Name
                FROM tbl_Department D
            ),
            SourceTypes AS (
  --             SELECT DISTINCT CASE(SourceofInformation)
  --WHEN ''--Select--'' THEN ''N/A'' ELSE SourceofInformation END AS SourceofInformation
  --              FROM Tbl_Candidate_Personal_Det
  --              WHERE SourceofInformation IS NOT NULL

                     SELECT DISTINCT SourceofInformation
                FROM Tbl_Candidate_Personal_Det
                WHERE SourceofInformation IS NOT NULL

            ),
            RawData AS ( --77777777777777777777777777777777777777777777777
                SELECT 
                L.CounselorEmployee_id,
                    D.Department_Name,
                    CAST(L.RegDate AS DATE) AS RegDate,
                    L.SourceofInformation,
                    COUNT(*) AS TotalCount
                FROM Tbl_Candidate_Personal_Det L
                INNER JOIN tbl_New_Admission A ON L.New_Admission_Id = A.New_Admission_Id
                INNER JOIN tbl_Department D ON A.Department_Id = D.Department_Id
                WHERE YEAR(L.RegDate) = @Year AND MONTH(L.RegDate) = @Month
                AND ((ISNULL(L.CounselorEmployee_id,0) in ( select Value from dbo.fn_SplitString( @Counsellors,'',''))))
                AND L.CounselorEmployee_id > 0
                GROUP BY D.Department_Name, CAST(L.RegDate AS DATE), L.SourceofInformation,L.CounselorEmployee_id
            )
            SELECT 
                P.Department_Name AS Programme,
                 CASE(S.SourceofInformation) when ''--Select--''THEN ''N/A'' ELSE S.SourceofInformation END AS  SourceofInformation,
                CONVERT(VARCHAR(10), C.RegDate, 103) AS RegDate,
                ISNULL(R.TotalCount, 0) AS TotalCount
            FROM CalendarDates C
            CROSS JOIN Programmes P
            LEFT JOIN (
                SELECT SourceofInformation FROM SourceTypes WHERE @IncludeSource = 1
                UNION ALL
                SELECT NULL WHERE @IncludeSource = 0
            ) S ON 1=1
            LEFT JOIN RawData R 
                ON R.RegDate = C.RegDate 
                AND R.Department_Name = P.Department_Name
                AND (
                    (@IncludeSource = 1 AND R.SourceofInformation = S.SourceofInformation)
                    OR 
                    (@IncludeSource = 0 AND R.SourceofInformation IS NOT NULL)
                )
                
            ORDER BY P.Department_Name, 
                     S.SourceofInformation,
                     C.RegDate,r.CounselorEmployee_id
            OPTION (MAXRECURSION 1000)
        END
    END
    ELSE IF @Duration = ''Weekly''
    BEGIN
        IF @Type = ''Lead''
        BEGIN
            ;WITH WeekMapping AS (
                SELECT 1 AS WeekNo, ''Week 1'' AS WeekLabel, 1 AS StartDay, 7 AS EndDay
                UNION ALL
                SELECT 2, ''Week 2'', 8, 14
                UNION ALL
                SELECT 3, ''Week 3'', 15, 21
                UNION ALL
                SELECT 4, ''Week 4'', 22, 28
                UNION ALL
                SELECT 5, ''Week 5'', 29, 31
            ),
            Programmes AS (
                SELECT DISTINCT D.Department_Name
                FROM tbl_Department D
            ),
         


              SourceTypes AS (
                 SELECT DISTINCT Enquiry_From as  SourceofInformation
                FROM Tbl_Lead_Personal_Det
                WHERE Enquiry_From IS NOT NULL
            ),
            RawData AS (
                SELECT 
                L.CounselorEmployee_id,
                  ISNULL(D.Department_Name,''Unallocated'') as Department_Name,
                    CASE 
                        WHEN DAY(L.RegDate) BETWEEN 1 AND 7 THEN ''Week 1''
                        WHEN DAY(L.RegDate) BETWEEN 8 AND 14 THEN ''Week 2''
                        WHEN DAY(L.RegDate) BETWEEN 15 AND 21 THEN ''Week 3''
                        WHEN DAY(L.RegDate) BETWEEN 22 AND 28 THEN ''Week 4''
                        ELSE ''Week 5''
                    END AS WeekLabel,
                    L.Enquiry_From AS SourceofInformation,
                    COUNT(*) AS TotalCount
                FROM Tbl_Lead_Personal_Det L
                INNER JOIN tbl_New_Admission A ON L.New_Admission_Id = A.New_Admission_Id
                INNER JOIN tbl_Department D ON A.Department_Id = D.Department_Id
                WHERE YEAR(L.RegDate) = @Year AND MONTH(L.RegDate) = @Month
                AND ((ISNULL(L.CounselorEmployee_id,0) in ( select Value from dbo.fn_SplitString( @Counsellors,'',''))))
                AND L.CounselorEmployee_id > 0
                GROUP BY ISNULL(D.Department_Name,''Unallocated''),L.CounselorEmployee_id,
                    CASE 
                        WHEN DAY(L.RegDate) BETWEEN 1 AND 7 THEN ''Week 1''
                        WHEN DAY(L.RegDate) BETWEEN 8 AND 14 THEN ''Week 2''
                        WHEN DAY(L.RegDate) BETWEEN 15 AND 21 THEN ''Week 3''
                        WHEN DAY(L.RegDate) BETWEEN 22 AND 28 THEN ''Week 4''
                        ELSE ''Week 5''
                    END, L.Enquiry_From
            )
            SELECT 
                P.Department_Name AS Programme,
                CASE(S.SourceofInformation) when ''--Select--''THEN ''N/A'' ELSE S.SourceofInformation END AS  SourceofInformation,
                W.WeekLabel,
                ISNULL(R.TotalCount, 0) AS TotalCount
            FROM WeekMapping W
            CROSS JOIN (SELECT * FROM Programmes UNION ALL SELECT ''Unallocated'') P
            LEFT JOIN (
                SELECT SourceofInformation FROM SourceTypes WHERE @IncludeSource = 1
                UNION ALL
                SELECT NULL WHERE @IncludeSource = 0
            ) S ON 1=1
            LEFT JOIN RawData R 
                ON R.WeekLabel = W.WeekLabel 
                AND R.Department_Name = P.Department_Name
                AND (
                    (@IncludeSource = 1 AND R.SourceofInformation = S.SourceofInformation)
                    OR 
                    (@IncludeSource = 0 AND R.SourceofInformation IS NOT NULL)
                )
                --WHERE ISNULL(R.CounselorEmployee_id,0) > 0
            ORDER BY P.Department_Name, 
                     S.SourceofInformation, 
                     W.WeekNo
        END
        ELSE IF @Type = ''Application''
        BEGIN
            ;WITH WeekMapping AS (
                SELECT 1 AS WeekNo, ''Week 1'' AS WeekLabel, 1 AS StartDay, 7 AS EndDay
                UNION ALL
                SELECT 2, ''Week 2'', 8, 14
                UNION ALL
                SELECT 3, ''Week 3'', 15, 21
                UNION ALL
                SELECT 4, ''Week 4'', 22, 28
                UNION ALL
                SELECT 5, ''Week 5'', 29, 31
            ),
            Programmes AS (
                SELECT DISTINCT D.Department_Name
                FROM tbl_Department D
            ),
            SourceTypes AS (
             




                   SELECT DISTINCT SourceofInformation
                FROM Tbl_Candidate_Personal_Det
                WHERE SourceofInformation IS NOT NULL

            ),
            RawData AS (
                SELECT 
                    L.CounselorEmployee_id,
                    D.Department_Name,
                    CASE 
                        WHEN DAY(L.RegDate) BETWEEN 1 AND 7 THEN ''Week 1''
                        WHEN DAY(L.RegDate) BETWEEN 8 AND 14 THEN ''Week 2''
                        WHEN DAY(L.RegDate) BETWEEN 15 AND 21 THEN ''Week 3''
                        WHEN DAY(L.RegDate) BETWEEN 22 AND 28 THEN ''Week 4''
                        ELSE ''Week 5''
                    END AS WeekLabel,
                    L.SourceofInformation,
                    COUNT(*) AS TotalCount
                FROM Tbl_Candidate_Personal_Det L
                INNER JOIN tbl_New_Admission A ON L.New_Admission_Id = A.New_Admission_Id
                INNER JOIN tbl_Department D ON A.Department_Id = D.Department_Id
                WHERE YEAR(L.RegDate) = @Year AND MONTH(L.RegDate) = @Month
                AND ((ISNULL(L.CounselorEmployee_id,0) in ( select Value from dbo.fn_SplitString( @Counsellors,'',''))))
                AND L.CounselorEmployee_id > 0
                GROUP BY D.Department_Name,L.CounselorEmployee_id,
                    CASE 
                        WHEN DAY(L.RegDate) BETWEEN 1 AND 7 THEN ''Week 1''
                        WHEN DAY(L.RegDate) BETWEEN 8 AND 14 THEN ''Week 2''
                        WHEN DAY(L.RegDate) BETWEEN 15 AND 21 THEN ''Week 3''
                        WHEN DAY(L.RegDate) BETWEEN 22 AND 28 THEN ''Week 4''
                        ELSE ''Week 5''
                    END, L.SourceofInformation
            )
            SELECT 
                P.Department_Name AS Programme,
                CASE(S.SourceofInformation) when ''--Select--''THEN ''N/A'' ELSE S.SourceofInformation END AS  SourceofInformation,
                W.WeekLabel,
                ISNULL(R.TotalCount, 0) AS TotalCount
            FROM WeekMapping W
            CROSS JOIN Programmes P
            LEFT JOIN (
                SELECT SourceofInformation FROM SourceTypes WHERE @IncludeSource = 1
                UNION ALL
                SELECT NULL WHERE @IncludeSource = 0
            ) S ON 1=1
            LEFT JOIN RawData R 
                ON R.WeekLabel = W.WeekLabel 
                AND R.Department_Name = P.Department_Name
                AND (
                    (@IncludeSource = 1 AND R.SourceofInformation = S.SourceofInformation)
                    OR 
                    (@IncludeSource = 0 AND R.SourceofInformation IS NOT NULL)
                )
                    --WHERE ISNULL(R.CounselorEmployee_id,0) > 0
            ORDER BY P.Department_Name, 
                     CASE WHEN @IncludeSource = 1 THEN ISNULL(S.SourceofInformation, ''N/A'') ELSE ''All Sources'' END,
                     W.WeekNo
        END
    END
END
    ')
END;
