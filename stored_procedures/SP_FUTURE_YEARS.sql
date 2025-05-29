IF NOT EXISTS (
    SELECT 1 FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SP_FUTURE_YEARS]') 
    AND type = N'P'
)
BEGIN
    EXEC('
CREATE PROCEDURE [dbo].[SP_FUTURE_YEARS]
AS
BEGIN
    WITH YearSequence AS (
        SELECT YEAR(GETDATE()) AS Year  -- Start from the current year
        UNION ALL
        SELECT Year + 1
        FROM YearSequence
        WHERE Year < YEAR(GETDATE()) + 10  -- Limit to the next 10 years
    )
    SELECT Year
    FROM YearSequence
    OPTION (MAXRECURSION 0);  -- Allow unlimited recursion
END
    ')
END;
