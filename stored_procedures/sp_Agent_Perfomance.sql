IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Agent_Perfomance]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Agent_Perfomance]
        (
            @fromdate DATETIME = NULL,
            @todate DATETIME = NULL,
            @PageSize BIGINT = NULL,
            @CurrentPage BIGINT = NULL
        )
        AS
        BEGIN
            -- If pagination parameters are not provided, set them to default values
            IF @PageSize IS NULL OR @CurrentPage IS NULL OR @PageSize <= 0 OR @CurrentPage <= 0
            BEGIN
                -- If PageSize or CurrentPage is NULL or invalid, don''t apply pagination
                SELECT 
                    ROW_NUMBER() OVER (ORDER BY Employee_Name) AS SlNo,  -- Add SlNo based on ordering
                    Employee_Name,
                    SUM(Total_Agents) AS Total_Agents,
                    SUM(Inprogress) AS Inprogress,
                    SUM(Signed) AS Signed,
                    SUM(agentlocal) AS agentlocal,
                    SUM(agentinternational) AS agentinternational,
                    SUM(inprogressinter) AS inprogressinter
                FROM (
                    -- Agent data
                    SELECT 
                        CONCAT(em.employee_fname, '' '', em.employee_lname) AS Employee_Name,
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
                        ag.Agent_Status = ''Active'' 
                        AND ag.Delete_Status = 0
                        AND (
                            (CONVERT(DATE, ag.Created_Date) >= @fromdate 
                             AND CONVERT(DATE, ag.Created_Date) < DATEADD(DAY, 1, @todate))
                            OR (@fromdate IS NULL AND @todate IS NULL)    
                            OR (@fromdate IS NULL AND CONVERT(DATE, ag.Created_Date) < DATEADD(DAY, 1, @todate))    
                            OR (@todate IS NULL AND CONVERT(DATE, ag.Created_Date) >= @fromdate)
                        )
                    GROUP BY 
                        em.Employee_FName, em.employee_lname

                    UNION ALL

                    -- Temp Agent data
                    SELECT 
                        CONCAT(em.employee_fname, '' '', em.employee_lname) AS Employee_Name,
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
                        tta.Temp_Agent_Status = ''Active'' 
                        AND tta.Delete_Status = 0
                        AND (
                            (CONVERT(DATE, tta.Created_Date) >= @fromdate 
                             AND CONVERT(DATE, tta.Created_Date) < DATEADD(DAY, 1, @todate))
                            OR (@fromdate IS NULL AND @todate IS NULL)    
                            OR (@fromdate IS NULL AND CONVERT(DATE, tta.Created_Date) < DATEADD(DAY, 1, @todate))    
                            OR (@todate IS NULL AND CONVERT(DATE, tta.Created_Date) >= @fromdate)
                        )
                    GROUP BY 
                        em.Employee_FName, em.employee_lname
                ) AS CombinedData
                GROUP BY 
                    Employee_Name
                ORDER BY 
                    Employee_Name;  -- Sorting is essential for the ROW_NUMBER() to work as expected
            END
            ELSE
            BEGIN
                -- Calculate the offset for pagination
                DECLARE @Offset INT;
                SET @Offset = @PageSize * (@CurrentPage - 1);

                -- Query to fetch data with pagination
                SELECT 
                    ROW_NUMBER() OVER (ORDER BY Employee_Name) AS SlNo,  -- Add SlNo based on ordering
                    Employee_Name,
                    SUM(Total_Agents) AS Total_Agents,
                    SUM(Inprogress) AS Inprogress,
                    SUM(Signed) AS Signed,
                    SUM(agentlocal) AS agentlocal,
                    SUM(agentinternational) AS agentinternational,
                    SUM(inprogressinter) AS inprogressinter
                FROM (
                    -- Agent data
                    SELECT 
                        CONCAT(em.employee_fname, '' '', em.employee_lname) AS Employee_Name,
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
                        ag.Agent_Status = ''Active'' 
                        AND ag.Delete_Status = 0
                        AND (
                            (CONVERT(DATE, ag.Created_Date) >= @fromdate 
                             AND CONVERT(DATE, ag.Created_Date) < DATEADD(DAY, 1, @todate))
                            OR (@fromdate IS NULL AND @todate IS NULL)    
                            OR (@fromdate IS NULL AND CONVERT(DATE, ag.Created_Date) < DATEADD(DAY, 1, @todate))    
                            OR (@todate IS NULL AND CONVERT(DATE, ag.Created_Date) >= @fromdate)
                        )
                    GROUP BY 
                        em.Employee_FName, em.employee_lname

                    UNION ALL

                    -- Temp Agent data
                    SELECT 
                        CONCAT(em.employee_fname, '' '', em.employee_lname) AS Employee_Name,
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
                        tta.Temp_Agent_Status = ''Active'' 
                        AND tta.Delete_Status = 0
                        AND (
                            (CONVERT(DATE, tta.Created_Date) >= @fromdate 
                             AND CONVERT(DATE, tta.Created_Date) < DATEADD(DAY, 1, @todate))
                            OR (@fromdate IS NULL AND @todate IS NULL)    
                            OR (@fromdate IS NULL AND CONVERT(DATE, tta.Created_Date) < DATEADD(DAY, 1, @todate))    
                            OR (@todate IS NULL AND CONVERT(DATE, tta.Created_Date) >= @fromdate)
                        )
                    GROUP BY 
                        em.Employee_FName, em.employee_lname
                ) AS CombinedData
                GROUP BY 
                    Employee_Name
                ORDER BY 
                    Employee_Name
                OFFSET @Offset ROWS
                FETCH NEXT @PageSize ROWS ONLY;
            END
        END
    ')
END
