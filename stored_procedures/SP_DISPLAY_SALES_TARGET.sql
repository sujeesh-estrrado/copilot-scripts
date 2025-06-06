IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_DISPLAY_SALES_TARGET]') 
    AND type = N'P'
)
BEGIN
    EXEC('
        
CREATE PROCEDURE [dbo].[SP_DISPLAY_SALES_TARGET]
(
    @fromdate DATETIME = NULL,
    @todate DATETIME = NULL,
    @Currentpage INT = NULL,
    @PageSize INT = NULL,
    @Targetid int=0
)
AS
BEGIN
    -- Set NOCOUNT to ON to prevent extra result sets for affected rows
    SET NOCOUNT ON;

    -- Declare a variable for the offset used in pagination
    DECLARE @Offset INT;

    -- Calculate offset for pagination if pagination parameters are provided
    IF @PageSize IS NOT NULL AND @Currentpage IS NOT NULL AND @PageSize > 0 AND @Currentpage > 0
    BEGIN
        SET @Offset = @PageSize * (@Currentpage - 1);
    END
    ELSE
    BEGIN
        SET @Offset = 0; -- Default offset when pagination parameters are not valid
    END

    -- Select query with pagination using a CTE
    ;WITH FollowUpDetails AS
    (
        SELECT 
            ROW_NUMBER() OVER (ORDER BY E.Employee_FName, E.Employee_LName) AS SlNo,
            CONCAT(E.Employee_FName, '' '', E.Employee_LName) AS Counselor_Employee,
            e.Employee_Id as Counselor_EmployeeId,
            F.Target_Id,
            F.Target_Year,
            F.Monthly_Target,
            F.Yearly_Target,
            F.Create_Date
        FROM 
            tbl_Sales_Target F
        INNER JOIN 
            Tbl_Employee E ON F.Councelor_Employee = E.Employee_Id
        WHERE 
            F.DelStatus = 0 -- Include only non-deleted records
            AND E.Employee_Status IN (1, 0) 
            and (Target_Id=@Targetid or @Targetid=0)-- Include active and inactive employees
            AND (
                (
                    (CONVERT(DATE, F.Create_Date) >= @fromdate AND CONVERT(DATE, F.Create_Date) < DATEADD(DAY, 1, @todate))
                )
                OR (@fromdate IS NULL AND @todate IS NULL) -- No date filter
                OR (@fromdate IS NULL AND CONVERT(DATE, F.Create_Date) < DATEADD(DAY, 1, @todate)) -- Only to-date
                OR (@todate IS NULL AND CONVERT(DATE, F.Create_Date) >= @fromdate) -- Only from-date
            )
    )
    SELECT *
    FROM FollowUpDetails
    WHERE 
        @PageSize IS NULL OR @Currentpage IS NULL OR @PageSize <= 0 OR @Currentpage <= 0
        OR (
            SlNo > @Offset AND SlNo <= (@Offset + @PageSize)
        );

    -- Set NOCOUNT OFF before returning the results
    SET NOCOUNT OFF;
END;
    ')
END
