IF NOT EXISTS (
    SELECT 1 
    FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[sp_Agent_SummaryBy_Country]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        CREATE PROCEDURE [dbo].[sp_Agent_SummaryBy_Country]
        @PageSize INT = NULL,
        @CurrentPage INT = NULL,
        @Country_Id BIGINT = NULL,
        @fromdate DATETIME = NULL,
        @todate DATETIME = NULL
        AS
        BEGIN
            DECLARE @SQLQuery NVARCHAR(MAX)

            SET @SQLQuery = '' 
            SELECT 
                ROW_NUMBER() OVER (ORDER BY COUNT(ag.Agent_ID) DESC) AS SlNo, 
                Tbl_Country.Country AS Country_Name, 
                COUNT(ag.Agent_ID) AS Agents
            FROM Tbl_Country
            LEFT JOIN Tbl_Agent ag ON Tbl_Country.Country_Id = ag.Agent_Country_Id
            WHERE ag.Agent_Status = ''''Active'''' AND ag.Delete_Status = 0
            AND (
                ((CONVERT(DATE, ag.Created_Date)) >= @fromdate 
                    AND (CONVERT(DATE, ag.Created_Date)) < DATEADD(DAY, 1, @todate))
                OR (@fromdate IS NULL AND @todate IS NULL)
                OR (@fromdate IS NULL AND (CONVERT(DATE, ag.Created_Date)) < DATEADD(DAY, 1, @todate))
                OR (@todate IS NULL AND (CONVERT(DATE, ag.Created_Date)) >= @fromdate)
            ) 
            ''

            -- Conditional for Country_Id filter
            IF @Country_Id IS NOT NULL AND @Country_Id > 0
            BEGIN
                SET @SQLQuery = @SQLQuery + '' AND Tbl_Country.Country_Id = @Country_Id''
            END

            SET @SQLQuery = @SQLQuery + ''
            GROUP BY Tbl_Country.Country
            ORDER BY Agents DESC
            ''

            -- Check if pagination parameters are provided
            IF @PageSize IS NOT NULL AND @PageSize > 0 AND @CurrentPage IS NOT NULL AND @CurrentPage > 0
            BEGIN
                -- Apply OFFSET and FETCH for pagination
                SET @SQLQuery = @SQLQuery + ''
                OFFSET (@PageSize * (@CurrentPage - 1)) ROWS
                FETCH NEXT @PageSize ROWS ONLY
                ''
            END

            -- Execute the dynamic SQL with parameters
            EXEC sp_executesql @SQLQuery, 
                N''@fromdate DATETIME, @todate DATETIME, @Country_Id BIGINT, @PageSize INT, @CurrentPage INT'', 
                @fromdate, @todate, @Country_Id, @PageSize, @CurrentPage
        END
    ')
END
