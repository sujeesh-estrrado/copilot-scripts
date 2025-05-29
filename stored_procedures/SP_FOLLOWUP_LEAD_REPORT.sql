IF NOT EXISTS (
    SELECT 1
    FROM sys.objects
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_FOLLOWUP_LEAD_REPORT]')
    AND type = N'P'
)
BEGIN
    EXEC('
    
CREATE PROCEDURE [dbo].[SP_FOLLOWUP_LEAD_REPORT]
(
  @PageSize INT = NULL,
  @CurrentPage INT = NULL,
  --@Country_Id BIGINT = NULL,
  @fromdate DATETIME = NULL,
  @todate DATETIME = NULL
)
AS
BEGIN
set nocount on
    DECLARE @sql NVARCHAR(MAX);
    DECLARE @columns NVARCHAR(MAX);
    DECLARE @Offset INT;


    -- Step 1: Generate the dynamic columns based on Respond_Type
    SELECT @columns = STRING_AGG(
        ''SUM(CASE WHEN UPPER(LTRIM(RTRIM(F.Respond_Type))) = '''''' + UPPER(LTRIM(RTRIM(Respond_Type))) + '''''' THEN 1 ELSE 0 END) AS ['' + UPPER(LEFT(LTRIM(RTRIM(Respond_Type)), 1)) + LOWER(SUBSTRING(LTRIM(RTRIM(Respond_Type)), 2, LEN(LTRIM(RTRIM(Respond_Type))))) + '']'', 
        '', ''
    )
    FROM (
        SELECT DISTINCT UPPER(LTRIM(RTRIM(Respond_Type))) AS Respond_Type 
        FROM Tbl_FollowUpLead_Detail
    ) AS Types;

    -- Step 2: Construct the dynamic SQL
    SET @sql = ''
    SELECT 
        ROW_NUMBER() OVER (ORDER BY E.Employee_FName) AS SlNo,
        CONCAT(E.Employee_FName, '''' '''', E.Employee_LName) AS Counsellor,
        COUNT(F.Respond_Type) AS Total_Leads_Followed_Up , 
        '' + @columns + ''
    FROM 
        Tbl_FollowUpLead_Detail F
    INNER JOIN 
        Tbl_Employee E ON F.Counselor_Employee = E.Employee_Id
    WHERE 
        E.Employee_Status IN (1, 0) '';

    -- Step 3: Add the date filter dynamically
    IF (@fromdate IS NOT NULL OR @todate IS NOT NULL)
    BEGIN
        SET @sql += ''
        AND (
            (CONVERT(DATE, F.Followup_Date) >= @fromdate AND CONVERT(DATE, F.Followup_Date) < DATEADD(DAY, 1, @todate))
            OR (@fromdate IS NULL AND CONVERT(DATE, F.Followup_Date) < DATEADD(DAY, 1, @todate))
            OR (@todate IS NULL AND CONVERT(DATE, F.Followup_Date) >= @fromdate)
        )'';
    END

    -- Step 4: Add grouping and ordering
    SET @sql += ''
    GROUP BY 
        E.Employee_FName, E.Employee_LName
    ORDER BY 
        E.Employee_FName'';
 -- Step 5: Add pagination if needed
    IF (@PageSize IS NOT NULL AND @Currentpage IS NOT NULL AND @PageSize > 0 AND @Currentpage > 0)
    BEGIN
        SET @Offset = @PageSize * (@Currentpage - 1);
        SET @sql += '' OFFSET '' + CAST(@Offset AS NVARCHAR) + '' ROWS FETCH NEXT '' + CAST(@PageSize AS NVARCHAR) + '' ROWS ONLY'';
    END;

    -- Execute the dynamic SQL
    EXEC sp_executesql @sql,
     N''@fromdate DATETIME, @todate DATETIME'', 
        @fromdate = @fromdate, 
        @todate = @todate;

    -- Set NOCOUNT OFF before returning the results
    SET NOCOUNT OFF;
END
    ')
END
