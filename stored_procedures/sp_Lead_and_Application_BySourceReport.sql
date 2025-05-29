IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Lead_and_Application_BySourceReport]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_Lead_and_Application_BySourceReport]
(
    @fromdate DATETIME = NULL,
    @todate DATETIME = NULL,
    @CurrentPage BIGINT = NULL,
    @PageSize BIGINT = NULL
)
AS
BEGIN
    SET NOCOUNT ON;

    -- Handle invalid pagination input
    IF @PageSize IS NULL OR @CurrentPage IS NULL OR @PageSize <= 0 OR @CurrentPage <= 0
    BEGIN
        -- Combine results using UNION
        WITH CombinedResults AS (
            -- Leads Query
            SELECT 
                si.SourceName AS SourceName,
                COUNT(CASE WHEN lpd.TypeofStudent = ''LOCAL'' AND lpd.ApplicationStatus = ''lead'' THEN 1 ELSE NULL END) AS LocalLeadsCount,
                COUNT(CASE WHEN lpd.TypeofStudent = ''INTERNATIONAL'' AND lpd.ApplicationStatus = ''lead'' AND lpd.Candidate_Nationality <> ''0'' THEN 1 ELSE NULL END) AS InternationalLeadsCount,
                COUNT(CASE WHEN lpd.Candidate_Nationality = ''0'' AND lpd.ApplicationStatus = ''lead'' THEN 1 ELSE NULL END) AS LeadsOthers, -- Count Candidate_Nationality = 0
                0 AS ApplicationLocal,
                0 AS ApplicationInternational
            FROM 
                Tbl_SourceInfo si
            LEFT JOIN 
                Tbl_Lead_Personal_Det lpd ON lpd.SourceofInformation = si.SourceName
            WHERE 
                si.SourceName IS NOT NULL 
                AND si.SourceName <> ''''
                AND (
                    (@fromdate IS NULL AND @todate IS NULL) OR
                    (lpd.RegDate >= @fromdate AND lpd.RegDate < DATEADD(DAY, 1, @todate)) OR
                    (@fromdate IS NULL AND lpd.RegDate < DATEADD(DAY, 1, @todate)) OR
                    (@todate IS NULL AND lpd.RegDate >= @fromdate)
                )
            GROUP BY 
                si.SourceName

            UNION ALL

            -- Application Query
            SELECT 
                si.SourceName AS SourceName,
                0 AS LocalLeadsCount,
                0 AS InternationalLeadsCount,
                0 AS LeadsOthers,
                COUNT(CASE WHEN cpd.TypeOfStudent = ''LOCAL'' AND cpd.ApplicationStatus IN (''pending'', ''submitted'',''Approved'',''Waiting for approval'',''Completed'') THEN 1 ELSE NULL END) AS ApplicationLocal,
                COUNT(CASE WHEN cpd.TypeOfStudent = ''INTERNATIONAL'' AND cpd.ApplicationStatus IN (''pending'', ''submitted'',''Approved'',''Waiting for approval'',''Completed'') THEN 1 ELSE NULL END) AS ApplicationInternational
            FROM 
                Tbl_SourceInfo si
            LEFT JOIN 
                Tbl_Candidate_Personal_Det cpd ON cpd.SourceofInformation = si.SourceName
            WHERE 
                si.SourceName IS NOT NULL 
                AND si.SourceName <> ''''
                AND (
                    (@fromdate IS NULL AND @todate IS NULL) OR
                    (cpd.RegDate >= @fromdate AND cpd.RegDate < DATEADD(DAY, 1, @todate)) OR
                    (@fromdate IS NULL AND cpd.RegDate < DATEADD(DAY, 1, @todate)) OR
                    (@todate IS NULL AND cpd.RegDate >= @fromdate)
                )
            GROUP BY 
                si.SourceName
        )

        -- Pagination and final result with total row
        SELECT 
            COALESCE(SourceName, ''Total'') AS SourceName,
            SUM(LocalLeadsCount) AS LocalLeadsCount,
            SUM(InternationalLeadsCount) AS InternationalLeadsCount,
            SUM(LeadsOthers) AS LeadsOthers, -- Include LeadsOthers in the final result
            SUM(ApplicationLocal) AS ApplicationLocal,
            SUM(ApplicationInternational) AS ApplicationInternational
        FROM 
            CombinedResults
        GROUP BY 
            ROLLUP(SourceName)
        ORDER BY 
            CASE WHEN SourceName IS NULL THEN 1 ELSE 0 END, 
            SourceName;
    END
    ELSE
    BEGIN
        -- Query with pagination
        DECLARE @Offset INT;
        SET @Offset = @PageSize * (@CurrentPage - 1);

        WITH CombinedResults AS (
            -- Leads Query
            SELECT 
                si.SourceName AS SourceName,
                COUNT(CASE WHEN lpd.TypeofStudent = ''LOCAL'' AND lpd.ApplicationStatus = ''lead'' THEN 1 ELSE NULL END) AS LocalLeadsCount,
                COUNT(CASE WHEN lpd.TypeofStudent = ''INTERNATIONAL'' AND lpd.ApplicationStatus = ''lead'' AND lpd.Candidate_Nationality <> ''0'' THEN 1 ELSE NULL END) AS InternationalLeadsCount,
                COUNT(CASE WHEN lpd.Candidate_Nationality = ''0'' AND lpd.ApplicationStatus = ''lead'' THEN 1 ELSE NULL END) AS LeadsOthers, -- Count Candidate_Nationality = 0
                0 AS ApplicationLocal,
                0 AS ApplicationInternational
            FROM 
                Tbl_SourceInfo si
            LEFT JOIN 
                Tbl_Lead_Personal_Det lpd ON lpd.SourceofInformation = si.SourceName
            WHERE 
                si.SourceName IS NOT NULL 
                AND si.SourceName <> ''''
                AND (
                    (@fromdate IS NULL AND @todate IS NULL) OR
                    (lpd.RegDate >= @fromdate AND lpd.RegDate < DATEADD(DAY, 1, @todate)) OR
                    (@fromdate IS NULL AND lpd.RegDate < DATEADD(DAY, 1, @todate)) OR
                    (@todate IS NULL AND lpd.RegDate >= @fromdate)
                )
            GROUP BY 
                si.SourceName

            UNION ALL

            -- Application Query
            SELECT 
                si.SourceName AS SourceName,
                0 AS LocalLeadsCount,
                0 AS InternationalLeadsCount,
                0 AS LeadsOthers,
                COUNT(CASE WHEN cpd.TypeOfStudent = ''LOCAL'' AND cpd.ApplicationStatus IN (''pending'', ''submitted'') THEN 1 ELSE NULL END) AS ApplicationLocal,
                COUNT(CASE WHEN cpd.TypeOfStudent = ''INTERNATIONAL'' AND cpd.ApplicationStatus IN (''pending'', ''submitted'') THEN 1 ELSE NULL END) AS ApplicationInternational
            FROM 
                Tbl_SourceInfo si
            LEFT JOIN 
                Tbl_Candidate_Personal_Det cpd ON cpd.SourceofInformation = si.SourceName
            WHERE 
                si.SourceName IS NOT NULL 
                AND si.SourceName <> ''''
                AND (
                    (@fromdate IS NULL AND @todate IS NULL) OR
                    (cpd.RegDate >= @fromdate AND cpd.RegDate < DATEADD(DAY, 1, @todate)) OR
                    (@fromdate IS NULL AND cpd.RegDate < DATEADD(DAY, 1, @todate)) OR
                    (@todate IS NULL AND cpd.RegDate >= @fromdate)
                )
            GROUP BY 
                si.SourceName
        )

        -- Pagination and final result with total row
        SELECT 
            COALESCE(SourceName, ''Total'') AS SourceName,
            SUM(LocalLeadsCount) AS LocalLeadsCount,
            SUM(InternationalLeadsCount) AS InternationalLeadsCount,
            SUM(LeadsOthers) AS LeadsOthers, -- Include LeadsOthers in the final result
            SUM(ApplicationLocal) AS ApplicationLocal,
            SUM(ApplicationInternational) AS ApplicationInternational
        FROM 
            CombinedResults
        GROUP BY 
            ROLLUP(SourceName)
        ORDER BY 
            CASE WHEN SourceName IS NULL THEN 1 ELSE 0 END, 
            SourceName
        OFFSET @Offset ROWS
        FETCH NEXT @PageSize ROWS ONLY;
    END
    SET NOCOUNT OFF;
END;
');
END;