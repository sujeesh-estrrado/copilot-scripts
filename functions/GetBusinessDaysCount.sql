
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[GetBusinessDaysCount]') 
      AND type IN (N'FN', N'IF', N'TF') -- FN = Scalar, IF = Inline table, TF = Multi-statement table
)
BEGIN
    EXEC('
CREATE FUNCTION [dbo].[GetBusinessDaysCount]
(
    @StartDate DATETIME,
    @EndDate DATETIME
)
RETURNS INT
AS
BEGIN
    DECLARE @BusinessDays INT = 0;
    DECLARE @CurrentDate DATETIME = @StartDate;
    
    -- Convert to date to ignore time portions
    SET @StartDate = CONVERT(DATE, @StartDate);
    SET @EndDate = CONVERT(DATE, @EndDate);
    
    WHILE @CurrentDate <= @EndDate
    BEGIN
        -- Check if current day is a weekday (1=Sunday, 7=Saturday)
        IF DATEPART(WEEKDAY, @CurrentDate) NOT IN (1, 7)
        BEGIN
            SET @BusinessDays = @BusinessDays + 1;
        END
        
        SET @CurrentDate = DATEADD(DAY, 1, @CurrentDate);
    END
    
    RETURN @BusinessDays;
END
    ')
END
