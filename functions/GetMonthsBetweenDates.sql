IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetMonthsBetweenDates]') 
      AND type IN (N'FN', N'IF', N'TF') -- FN = Scalar, IF = Inline table, TF = Multi-statement table
)
BEGIN
    EXEC('
CREATE FUNCTION [dbo].[GetMonthsBetweenDates] 
(
    @DateA DATETIME,
    @DateB DATETIME
)
RETURNS @returnTable TABLE (Month varchar(200))
AS BEGIN
DECLARE @start  DATETIME,
        @end    DATETIME;

SELECT  
      @start = @DateA
    , @end = @DateB

;WITH cte AS 
(
    SELECT dt = DATEADD(DAY, -(DAY(@start) - 1), @start)

    UNION ALL

    SELECT DATEADD(MONTH, 1, dt)
    FROM cte
    WHERE dt < DATEADD(DAY, -(DAY(@end) - 1), @end)
)
INSERT INTO @returnTable
SELECT CONVERT(CHAR(4), dt, 100) + CONVERT(CHAR(4), dt, 120) 
FROM cte
RETURN
END

    ')
END
