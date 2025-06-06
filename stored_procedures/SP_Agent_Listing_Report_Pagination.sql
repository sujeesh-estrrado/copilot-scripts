IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_Agent_Listing_Report_Pagination]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[SP_Agent_Listing_Report_Pagination]
        (
            @flag bigint = 0,
            @category bigint = 0,
            @AgentId bigint = 0,
            @CurrentPage bigint = 0,
            @pagesize bigint = 0
        )
        AS
        BEGIN
            DECLARE @UpperBand INT
            DECLARE @LowerBand INT

            SET @LowerBand = (@CurrentPage - 1) * @PageSize
            SET @UpperBand = (@CurrentPage * @PageSize) + 1 

            IF(@flag = 0)
            BEGIN
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
                LEFT JOIN Tbl_Agent_Category C ON C.Category_Id = A.Agent_Category_Id
                LEFT JOIN Tbl_Country T ON T.Country_Id = A.Agent_Country_Id
                LEFT JOIN Tbl_Agent_User AU ON AU.Agent_Id = A.Agent_ID
                LEFT JOIN Tbl_State S ON A.Agent_Area = S.State_Id
                LEFT JOIN Tbl_City Y ON A.Agent_Location = Y.City_Id
                WHERE (Agent_Category_Id = @category OR @category = 0) 
                AND (A.Agent_Id = @AgentId OR @AgentId = 0)
                ORDER BY Agent_ID DESC
                OFFSET @pagesize * (@CurrentPage - 1) ROWS
                FETCH NEXT @pagesize ROWS ONLY
            END

            IF(@flag = 1)
            BEGIN
                SELECT DISTINCT COUNT(A.Agent_ID) AS totcount
                FROM [dbo].[Tbl_Agent] A
                LEFT JOIN Tbl_Agent_Category C ON C.Category_Id = A.Agent_Category_Id
                LEFT JOIN Tbl_Country T ON T.Country_Id = A.Agent_Country_Id
                LEFT JOIN Tbl_Agent_User AU ON AU.Agent_Id = A.Agent_ID
                LEFT JOIN Tbl_State S ON A.Agent_Area = S.State_Id
                LEFT JOIN Tbl_City Y ON A.Agent_Location = Y.City_Id
                WHERE (Agent_Category_Id = @category OR @category = 0) 
                AND (A.Agent_Id = @AgentId OR @AgentId = 0)
            END
        END
    ');
END
