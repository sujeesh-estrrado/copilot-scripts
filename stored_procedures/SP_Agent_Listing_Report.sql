IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Agent_Listing_Report]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Agent_Listing_Report] 
        (
            @category bigint = 0,
            @AgentId bigint = 0
        )
        AS
        BEGIN
            SELECT * INTO #TEMP2
            FROM (
                SELECT 
                    ROW_NUMBER() OVER (ORDER BY Agent_ID ASC) AS slno,
                    BK.* 
                FROM (
                    SELECT DISTINCT 
                        A.Agent_ID,
                        A.Agent_Category_Id, 
                        C.Category_Name,
                        Agent_Name,
                        A.Agent_RegNo,
                        T.Country,
                        A.Agent_Mob,
                        A.Agent_Home,
                        S.State_Name AS Agent_Area,
                        Y.City_Name AS Agent_Location,
                        A.Agent_Email,
                        0.00 AS Commission,
                        A.Agent_Address,
                        A.Agent_Status,
                        AU.User_Id
                    FROM [dbo].[Tbl_Agent] A
                    INNER JOIN Tbl_Agent_Category C ON C.Category_Id = A.Agent_Category_Id
                    INNER JOIN Tbl_Country T ON T.Country_Id = A.Agent_Country_Id
                    INNER JOIN Tbl_Agent_User AU ON AU.Agent_Id = A.Agent_ID
                    LEFT JOIN Tbl_State S ON A.Agent_Area = S.State_Id
                    LEFT JOIN Tbl_City Y ON A.Agent_Location = Y.City_Id
                    WHERE (Agent_Category_Id = @category OR @category = 0) 
                    AND (A.Agent_Id = @AgentId OR @AgentId = 0)
                ) BK
            ) B

            SELECT * FROM #TEMP2
        END
    ');
END
