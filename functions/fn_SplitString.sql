
IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[fn_SplitString]') 
      AND type IN (N'FN', N'IF', N'TF') -- FN = Scalar, IF = Inline table, TF = Multi-statement table
)
BEGIN
    EXEC('
CREATE FUNCTION [dbo].[fn_SplitString]
(
    @InputString VARCHAR(MAX),
    @Delimiter CHAR(1)
)
RETURNS @OutputTable TABLE (Value VARCHAR(MAX))
AS
BEGIN
    DECLARE @StartIndex INT, @EndIndex INT, @Value VARCHAR(MAX)

    SET @StartIndex = 1
    SET @EndIndex = CHARINDEX(@Delimiter, @InputString)

    WHILE @EndIndex > 0
    BEGIN
        SET @Value = SUBSTRING(@InputString, @StartIndex, @EndIndex - @StartIndex)
        INSERT INTO @OutputTable (Value)
        VALUES (@Value)

        SET @StartIndex = @EndIndex + 1
        SET @EndIndex = CHARINDEX(@Delimiter, @InputString, @StartIndex)
    END

    -- Insert the last value
    SET @Value = SUBSTRING(@InputString, @StartIndex, LEN(@InputString) - @StartIndex + 1)
    INSERT INTO @OutputTable (Value)
    VALUES (@Value)

    RETURN
END
    ')
END
