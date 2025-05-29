IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_reportsummary]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[sp_reportsummary]
(
    @fromdate DATETIME = NULL,
    @todate DATETIME = NULL,
    @CurrentPage INT = NULL,
    @PageSize INT = NULL
)
AS
BEGIN
    SELECT 
        Agent,
        ISNULL(SUM(Signed), 0) AS Signed,
        ISNULL(SUM(Inprogress), 0) AS Inprogress
    FROM (
        -- Local Signed Agents
        SELECT 
            ''Local'' AS Agent,
            COUNT(*) AS Signed,
            0 AS Inprogress
        FROM Tbl_Agent ag
        WHERE ag.Agent_Status = ''Active'' 
          AND ag.Delete_Status = 0
          AND ag.Agent_Category_Id = 1
          AND (@fromdate IS NULL OR CONVERT(DATE, ag.Created_Date) >= @fromdate)
          AND (@todate IS NULL OR CONVERT(DATE, ag.Created_Date) < DATEADD(DAY, 1, @todate))

        UNION ALL

        -- International Signed Agents
        SELECT 
            ''International'' AS Agent,
            COUNT(*) AS Signed,
            0 AS Inprogress
        FROM Tbl_Agent ag
        WHERE ag.Agent_Status = ''Active'' 
          AND ag.Delete_Status = 0
          AND ag.Agent_Category_Id = 2
          AND (@fromdate IS NULL OR CONVERT(DATE, ag.Created_Date) >= @fromdate)
          AND (@todate IS NULL OR CONVERT(DATE, ag.Created_Date) < DATEADD(DAY, 1, @todate))

        UNION ALL

        -- Local Inprogress Agents
        SELECT 
            ''Local'' AS Agent,
            0 AS Signed,
            COUNT(*) AS Inprogress
        FROM Tbl_Temp_Agent tta
        WHERE tta.Temp_Agent_Status = ''Active'' 
          AND tta.Delete_Status = 0
          AND tta.Temp_Agent_Category_Id = 1
          AND (@fromdate IS NULL OR CONVERT(DATE, tta.Created_Date) >= @fromdate)
          AND (@todate IS NULL OR CONVERT(DATE, tta.Created_Date) < DATEADD(DAY, 1, @todate))

        UNION ALL

        -- International Inprogress Agents
        SELECT 
            ''International'' AS Agent,
            0 AS Signed,
            COUNT(*) AS Inprogress
        FROM Tbl_Temp_Agent tta
        WHERE tta.Temp_Agent_Status = ''Active'' 
          AND tta.Delete_Status = 0
          AND tta.Temp_Agent_Category_Id = 2
          AND (@fromdate IS NULL OR CONVERT(DATE, tta.Created_Date) >= @fromdate)
          AND (@todate IS NULL OR CONVERT(DATE, tta.Created_Date) < DATEADD(DAY, 1, @todate))
    ) AS CombinedData
    GROUP BY Agent
END
');
END;