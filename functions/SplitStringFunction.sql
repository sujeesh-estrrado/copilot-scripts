IF NOT EXISTS (
    SELECT * FROM sys.objects 
    WHERE object_id = OBJECT_ID(N'[dbo].[SplitStringFunction]') 
      AND type IN (N'FN', N'IF', N'TF') -- FN = Scalar, IF = Inline table, TF = Multi-statement table
)
BEGIN
    EXEC('
 
CREATE FUNCTION [dbo].[SplitStringFunction]
(
    @String NVARCHAR(MAX),
    @Delimiter CHAR(1)
)
RETURNS @Result TABLE (Value NVARCHAR(MAX))
AS
BEGIN
    DECLARE @Start INT = 1, @End INT;

    WHILE CHARINDEX(@Delimiter, @String, @Start) > 0
    BEGIN
        SET @End = CHARINDEX(@Delimiter, @String, @Start);
        INSERT INTO @Result (Value)
        VALUES (SUBSTRING(@String, @Start, @End - @Start));
        SET @Start = @End + 1;
    END;

    INSERT INTO @Result (Value)
    VALUES (SUBSTRING(@String, @Start, LEN(@String) - @Start + 1));

    RETURN;
END;

    ')
END
