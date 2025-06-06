IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Agent_Perfomance_totcount]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Agent_Perfomance_totcount]
        (
            @fromdate DATETIME = NULL,
            @todate DATETIME = NULL,
            @PageSize BIGINT = 10,
            @CurrentPage BIGINT = 1
        )
        AS
        BEGIN
            -- Calculate the pagination limits

            -- Query to fetch data
            SELECT 
                SUM(Total_Agents) AS Total_Agents,
                SUM(Inprogress) AS Inprogress,
                SUM(Signed) AS Signed,
                SUM(agentlocal) AS agentlocal,
                SUM(agentinternational) AS agentinternational,
                SUM(inprogressinter) AS inprogressinter
            FROM (
                SELECT 
                    COUNT(ag.Agent_ID) AS Total_Agents,
                    0 AS Inprogress,
                    COUNT(CASE WHEN ag.Delete_Status = 0 THEN 1 END) AS Signed,
                    COUNT(CASE WHEN ag.Agent_Category_Id = 1 THEN 1 END) AS agentlocal,
                    COUNT(CASE WHEN ag.Agent_Category_Id = 2 THEN 1 END) AS agentinternational,
                    0 AS inprogressinter
                FROM 
                    Tbl_Agent ag
                JOIN 
                    Tbl_Employee em ON ag.Counsellor_Id = em.Employee_Id
                WHERE 
                    ag.Agent_Status = ''Active'' and ag.Delete_Status = 0 and 
                    (
                        (CONVERT(date, ag.Created_Date) >= @fromdate AND CONVERT(date, ag.Created_Date) < DATEADD(day, 1, @todate))
                        OR (@fromdate IS NULL AND @todate IS NULL)
                        OR (@fromdate IS NULL AND CONVERT(date, ag.Created_Date) < DATEADD(day, 1, @todate))
                        OR (@todate IS NULL AND CONVERT(date, ag.Created_Date) >= @fromdate)
                    )

                UNION ALL

                SELECT 
                    0 AS Total_Agents,
                    COUNT(CASE WHEN tta.Temp_Agent_Category_Id = 1 THEN 1 END) AS Inprogress,
                    0 AS Signed,
                    0 AS agentlocal,
                    0 AS agentinternational,
                    COUNT(CASE WHEN tta.Temp_Agent_Category_Id = 2 THEN 1 END) AS inprogressinter
                FROM 
                    Tbl_Temp_Agent tta
                JOIN 
                    Tbl_Employee em ON tta.Temp_Counsellor_Id = em.Employee_Id
                WHERE 
                    tta.Temp_Agent_Status = ''Active'' and tta.Delete_Status = 0 and 
                    (
                        (CONVERT(date, tta.Created_Date) >= @fromdate AND CONVERT(date, tta.Created_Date) < DATEADD(day, 1, @todate))
                        OR (@fromdate IS NULL AND @todate IS NULL)
                        OR (@fromdate IS NULL AND CONVERT(date, tta.Created_Date) < DATEADD(day, 1, @todate))
                        OR (@todate IS NULL AND CONVERT(date, tta.Created_Date) >= @fromdate)
                    )
            ) AS CombinedData
            ORDER BY Total_Agents
        END
    ')
END
